import pytest
import os
import json
import uuid
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Setup SQLite test DB for backend tests
os.environ["DATABASE_URL"] = "sqlite:///./test_auth.db"

import models
from database import Base, get_db
from main import app

SQLALCHEMY_DATABASE_URL = "sqlite:///./test_auth.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

@pytest.fixture(scope="module", autouse=True)
def setup_database():
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    # Add an authorized employee
    emp = models.AuthorizedEmployee(
        id="emp_test_1",
        email="officer@kollampost.org",
        name="Officer Radhakrishnan",
        role="officer",
        assigned_branches=json.dumps(["punalur", "kollam"]),
        is_active=True,
    )
    db.merge(emp)
    db.commit()
    db.close()
    yield
    Base.metadata.drop_all(bind=engine)
    if os.path.exists("./test_auth.db"):
        os.remove("./test_auth.db")

client = TestClient(app)

def test_unauthorized_google_email_rejected():
    response = client.post("/auth/google-login", json={
        "id_token": "mock_id_token:stranger@gmail.com:Stranger",
        "device_id": "device_123",
        "device_name": "Pixel 8"
    })
    assert response.status_code == 403
    assert "not authorized" in response.json()["detail"]

def test_authorized_employee_google_login_success():
    response = client.post("/auth/google-login", json={
        "id_token": "mock_id_token:officer@kollampost.org:Officer Radhakrishnan",
        "device_id": "device_123",
        "device_name": "Pixel 8"
    })
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert "refresh_token" in data
    assert data["employee"]["email"] == "officer@kollampost.org"
    assert "punalur" in data["employee"]["assigned_branches"]

def test_auth_status_with_valid_jwt():
    # Login first
    login_resp = client.post("/auth/google-login", json={
        "id_token": "mock_id_token:officer@kollampost.org:Officer Radhakrishnan",
        "device_id": "device_123"
    })
    token = login_resp.json()["access_token"]

    # Verify status
    status_resp = client.get("/auth/status", headers={
        "Authorization": f"Bearer {token}"
    })
    assert status_resp.status_code == 200
    assert status_resp.json()["status"] == "authenticated"
    assert status_resp.json()["email"] == "officer@kollampost.org"

def test_remote_device_revocation_blocks_access():
    login_resp = client.post("/auth/google-login", json={
        "id_token": "mock_id_token:officer@kollampost.org:Officer Radhakrishnan",
        "device_id": "stolen_device_456"
    })
    token = login_resp.json()["access_token"]
    refresh = login_resp.json()["refresh_token"]

    # Verify access works initially
    res = client.get("/auth/status", headers={"Authorization": f"Bearer {token}"})
    assert res.status_code == 200

    # Admin revokes the stolen device
    revoke_resp = client.post("/auth/revoke-device", json={
        "device_id": "stolen_device_456"
    })
    assert revoke_resp.status_code == 200

    # Subsequent access attempt with token must be forbidden (403)
    blocked_resp = client.get("/auth/status", headers={"Authorization": f"Bearer {token}"})
    assert blocked_resp.status_code == 403
    assert "revoked" in blocked_resp.json()["detail"]

    # Refresh attempt must also fail
    refresh_resp = client.post("/auth/refresh", json={
        "refresh_token": refresh,
        "device_id": "stolen_device_456"
    })
    assert refresh_resp.status_code == 403

