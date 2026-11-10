import os
import json
import uuid
import datetime
from typing import Optional, Dict, Any
import jwt
from fastapi import HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from google.oauth2 import id_token as google_id_token
from google.auth.transport import requests as google_requests

import models
from database import get_db

JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "coop-loan-recovery-jwt-secret-key-2026-production")
JWT_ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "15"))
REFRESH_TOKEN_EXPIRE_DAYS = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", "30"))
GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID", None)

security = HTTPBearer()

def verify_google_id_token(token_str: str) -> Dict[str, Any]:
    """
    Verifies a Google Sign-In ID Token.
    Returns the token payload containing email, name, sub (google_id).
    Supports simulation/mock tokens prefixed with 'mock_id_token:' for automated tests.
    """
    if token_str.startswith("mock_id_token:"):
        # Format: mock_id_token:<email>:<name>
        parts = token_str.split(":")
        email = parts[1] if len(parts) > 1 else "officer@kollampost.org"
        name = parts[2] if len(parts) > 2 else "Test Postal Officer"
        return {
            "email": email,
            "name": name,
            "sub": f"google_sub_{email}",
            "email_verified": True,
        }

    try:
        request = google_requests.Request()
        # If client ID is configured, verify against it; otherwise verify signature with Google certs
        if GOOGLE_CLIENT_ID:
            payload = google_id_token.verify_oauth2_token(token_str, request, GOOGLE_CLIENT_ID)
        else:
            payload = google_id_token.verify_oauth2_token(token_str, request)

        if not payload.get("email_verified", False):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Google account email is not verified.",
            )

        return payload
    except ValueError as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Invalid Google ID Token: {str(e)}",
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Google authentication failed: {str(e)}",
        )

def create_access_token(data: dict, expires_delta: Optional[datetime.timedelta] = None) -> str:
    to_encode = data.copy()
    now = datetime.datetime.utcnow()
    expire = now + (expires_delta or datetime.timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire, "iat": now, "type": "access"})
    return jwt.encode(to_encode, JWT_SECRET_KEY, algorithm=JWT_ALGORITHM)

def create_refresh_token(data: dict) -> str:
    to_encode = data.copy()
    now = datetime.datetime.utcnow()
    expire = now + datetime.timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    to_encode.update({"exp": expire, "iat": now, "type": "refresh", "jti": str(uuid.uuid4())})
    return jwt.encode(to_encode, JWT_SECRET_KEY, algorithm=JWT_ALGORITHM)

def decode_token(token: str) -> dict:
    try:
        payload = jwt.decode(token, JWT_SECRET_KEY, algorithms=[JWT_ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token has expired. Please authenticate again.",
        )
    except jwt.PyJWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials.",
        )

def get_current_employee_and_session(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db),
) -> Dict[str, Any]:
    token = credentials.credentials
    payload = decode_token(token)

    if payload.get("type") != "access":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token type.",
        )

    employee_id = payload.get("sub")
    device_id = payload.get("device_id")

    if not employee_id or not device_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Malformed token claims.",
        )

    # Check employee
    employee = db.query(models.AuthorizedEmployee).filter(
        models.AuthorizedEmployee.id == employee_id,
        models.AuthorizedEmployee.is_active == True,
    ).first()

    if not employee:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Employee access has been revoked or deactivated.",
        )

    # Check device session revocation
    session = db.query(models.DeviceSession).filter(
        models.DeviceSession.employee_id == employee_id,
        models.DeviceSession.device_id == device_id,
    ).first()

    if session and session.is_revoked:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This device's access has been remotely revoked.",
        )

    # Update last seen
    if session:
        session.last_seen_at = datetime.datetime.utcnow()
        db.commit()

    assigned_branches = []
    try:
        assigned_branches = json.loads(employee.assigned_branches)
    except Exception:
        pass

    return {
        "employee": employee,
        "session": session,
        "device_id": device_id,
        "assigned_branches": assigned_branches,
    }

