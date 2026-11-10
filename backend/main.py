from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
import uuid
import json
import hashlib
import datetime
import models, schemas, auth_service
from database import SessionLocal, engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="Loan Recovery API")

# Enable CORS for all origins (Required for Flutter/Web/Mobile connectivity)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Loan Recovery API is running"}

# ==========================================
# Authentication & Identity Endpoints
# ==========================================

@app.post("/auth/google-login", response_model=schemas.TokenResponse)
def google_login(payload: schemas.GoogleLoginRequest, db: Session = Depends(get_db)):
    # 1. Verify Google ID Token
    google_profile = auth_service.verify_google_id_token(payload.id_token)
    email = google_profile.get("email", "").lower().strip()

    if not email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Google account did not return a valid email address.",
        )

    # 2. Check Employee Whitelist
    employee = db.query(models.AuthorizedEmployee).filter(
        models.AuthorizedEmployee.email == email
    ).first()

    if not employee or not employee.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Access denied. Employee email '{email}' is not authorized by the Co-operative Society.",
        )

    # 3. Check / Register Device Session
    session = db.query(models.DeviceSession).filter(
        models.DeviceSession.employee_id == employee.id,
        models.DeviceSession.device_id == payload.device_id,
    ).first()

    if session and session.is_revoked:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Access denied. This device has been remotely revoked by system administration.",
        )

    # 4. Generate JWT Pair
    token_claims = {
        "sub": employee.id,
        "email": employee.email,
        "role": employee.role,
        "device_id": payload.device_id,
    }
    access_token = auth_service.create_access_token(token_claims)
    refresh_token = auth_service.create_refresh_token(token_claims)

    refresh_token_hash = hashlib.sha256(refresh_token.encode()).hexdigest()

    if not session:
        session = models.DeviceSession(
            id=str(uuid.uuid4()),
            employee_id=employee.id,
            device_id=payload.device_id,
            device_name=payload.device_name or "Mobile Client",
            refresh_token=refresh_token_hash,
            is_revoked=False,
            last_seen_at=datetime.datetime.utcnow(),
        )
        db.add(session)
    else:
        session.refresh_token = refresh_token_hash
        session.last_seen_at = datetime.datetime.utcnow()

    db.commit()

    assigned_branches = []
    try:
        assigned_branches = json.loads(employee.assigned_branches)
    except Exception:
        pass

    return schemas.TokenResponse(
        access_token=access_token,
        refresh_token=refresh_token,
        token_type="bearer",
        employee=schemas.EmployeeResponse(
            id=employee.id,
            email=employee.email,
            name=employee.name,
            role=employee.role,
            assigned_branches=assigned_branches,
            is_active=employee.is_active,
        ),
    )

@app.post("/auth/refresh", response_model=schemas.TokenResponse)
def refresh_token(payload: schemas.RefreshTokenRequest, db: Session = Depends(get_db)):
    token_data = auth_service.decode_token(payload.refresh_token)

    if token_data.get("type") != "refresh":
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token type.")

    employee_id = token_data.get("sub")
    device_id = payload.device_id

    # Verify session and non-revocation
    session = db.query(models.DeviceSession).filter(
        models.DeviceSession.employee_id == employee_id,
        models.DeviceSession.device_id == device_id,
    ).first()

    if not session or session.is_revoked:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Device session has been revoked.")

    employee = db.query(models.AuthorizedEmployee).filter(
        models.AuthorizedEmployee.id == employee_id,
        models.AuthorizedEmployee.is_active == True,
    ).first()

    if not employee:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Employee has been deactivated.")

    # Re-issue rotated tokens
    claims = {
        "sub": employee.id,
        "email": employee.email,
        "role": employee.role,
        "device_id": device_id,
    }
    new_access = auth_service.create_access_token(claims)
    new_refresh = auth_service.create_refresh_token(claims)

    session.refresh_token = hashlib.sha256(new_refresh.encode()).hexdigest()
    session.last_seen_at = datetime.datetime.utcnow()
    db.commit()

    assigned_branches = []
    try:
        assigned_branches = json.loads(employee.assigned_branches)
    except Exception:
        pass

    return schemas.TokenResponse(
        access_token=new_access,
        refresh_token=new_refresh,
        token_type="bearer",
        employee=schemas.EmployeeResponse(
            id=employee.id,
            email=employee.email,
            name=employee.name,
            role=employee.role,
            assigned_branches=assigned_branches,
            is_active=employee.is_active,
        ),
    )

@app.post("/auth/revoke-device")
def revoke_device(payload: schemas.RevokeDeviceRequest, db: Session = Depends(get_db)):
    query = db.query(models.DeviceSession).filter(models.DeviceSession.device_id == payload.device_id)
    if payload.employee_id:
        query = query.filter(models.DeviceSession.employee_id == payload.employee_id)

    sessions = query.all()
    if not sessions:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No matching device session found.")

    for s in sessions:
        s.is_revoked = True

    db.commit()
    return {"message": f"Successfully revoked {len(sessions)} device session(s)."}

@app.get("/auth/status")
def auth_status(auth_context: dict = Depends(auth_service.get_current_employee_and_session)):
    employee = auth_context["employee"]
    return {
        "status": "authenticated",
        "employee_id": employee.id,
        "email": employee.email,
        "name": employee.name,
        "role": employee.role,
        "assigned_branches": auth_context["assigned_branches"],
    }

@app.get("/auth/employees", response_model=List[schemas.EmployeeResponse])
def list_authorized_employees(db: Session = Depends(get_db)):
    employees = db.query(models.AuthorizedEmployee).all()
    results = []
    for emp in employees:
        branches = []
        try:
            branches = json.loads(emp.assigned_branches)
        except Exception:
            pass
        results.append(schemas.EmployeeResponse(
            id=emp.id,
            email=emp.email,
            name=emp.name,
            role=emp.role,
            assigned_branches=branches,
            is_active=emp.is_active,
        ))
    return results

@app.post("/auth/employees", response_model=schemas.EmployeeResponse)
def add_authorized_employee(payload: schemas.EmployeeCreate, db: Session = Depends(get_db)):
    clean_email = payload.email.lower().strip()
    existing = db.query(models.AuthorizedEmployee).filter(
        models.AuthorizedEmployee.email == clean_email
    ).first()

    if existing:
        raise HTTPException(status_code=400, detail="Employee with this email already exists.")

    emp_id = str(uuid.uuid4())
    new_emp = models.AuthorizedEmployee(
        id=emp_id,
        email=clean_email,
        name=payload.name,
        role=payload.role or "officer",
        assigned_branches=json.dumps(payload.assigned_branches or []),
        is_active=True,
    )
    db.add(new_emp)
    db.commit()
    db.refresh(new_emp)

    return schemas.EmployeeResponse(
        id=new_emp.id,
        email=new_emp.email,
        name=new_emp.name,
        role=new_emp.role,
        assigned_branches=payload.assigned_branches or [],
        is_active=new_emp.is_active,
    )

# --- Branch/Office Endpoints ---
@app.get("/offices/", response_model=List[schemas.Office])
def read_offices(db: Session = Depends(get_db)):
    return db.query(models.Office).all()

@app.post("/offices/", response_model=schemas.Office)
def create_office(office: schemas.OfficeBase, db: Session = Depends(get_db)):
    db_office = models.Office(**office.model_dump())
    db.add(db_office)
    db.commit()
    db.refresh(db_office)
    return db_office

@app.delete("/offices/{office_id}", status_code=204)
def delete_office(office_id: str, db: Session = Depends(get_db)):
    db_office = db.query(models.Office).filter(models.Office.id == office_id).first()
    if not db_office:
        raise HTTPException(status_code=404, detail="Office not found")
    db.delete(db_office)
    db.commit()
    return None

# --- Customer Endpoints ---
@app.get("/customers/", response_model=List[schemas.Customer])
def read_customers(office_id: str = None, db: Session = Depends(get_db)):
    query = db.query(models.Customer)
    if office_id:
        query = query.filter(models.Customer.office_id == office_id)
    return query.all()

@app.post("/customers/", response_model=schemas.Customer)
def create_customer(customer: schemas.CustomerBase, db: Session = Depends(get_db)):
    db_customer = models.Customer(**customer.model_dump())
    db.add(db_customer)
    db.commit()
    db.refresh(db_customer)
    return db_customer

@app.delete("/customers/{customer_id}", status_code=204)
def delete_customer(customer_id: str, db: Session = Depends(get_db)):
    db_customer = db.query(models.Customer).filter(models.Customer.id == customer_id).first()
    if not db_customer:
        raise HTTPException(status_code=404, detail="Customer not found")
    db.delete(db_customer)
    db.commit()
    return None

# --- Loan Endpoints ---
@app.get("/loans/", response_model=List[schemas.Loan])
def read_loans(customer_id: str = None, db: Session = Depends(get_db)):
    query = db.query(models.Loan)
    if customer_id:
        query = query.filter(models.Loan.customer_id == customer_id)
    return query.all()

@app.post("/loans/", response_model=schemas.Loan)
def create_loan(loan: schemas.LoanBase, db: Session = Depends(get_db)):
    db_loan = models.Loan(**loan.model_dump())
    db.add(db_loan)
    db.commit()
    db.refresh(db_loan)
    return db_loan

@app.delete("/loans/{loan_id}", status_code=204)
def delete_loan(loan_id: str, db: Session = Depends(get_db)):
    db_loan = db.query(models.Loan).filter(models.Loan.id == loan_id).first()
    if not db_loan:
        raise HTTPException(status_code=404, detail="Loan not found")
    db.delete(db_loan)
    db.commit()
    return None

# --- Recovery Endpoints ---
@app.get("/recoveries/", response_model=List[schemas.MonthlyRecovery])
def read_recoveries(month: int = None, year: int = None, db: Session = Depends(get_db)):
    query = db.query(models.MonthlyRecovery)
    if month:
        query = query.filter(models.MonthlyRecovery.month == month)
    if year:
        query = query.filter(models.MonthlyRecovery.year == year)
    return query.all()

@app.post("/recoveries/", response_model=schemas.MonthlyRecovery)
def create_recovery(recovery: schemas.MonthlyRecoveryBase, db: Session = Depends(get_db)):
    db_recovery = models.MonthlyRecovery(**recovery.model_dump())
    db.add(db_recovery)
    db.commit()
    db.refresh(db_recovery)
    return db_recovery

@app.post("/recoveries/generate")
def generate_drafts(month: int, year: int, office_id: str = None, db: Session = Depends(get_db)):
    query = db.query(models.Loan).filter(models.Loan.status.in_(['Active', 'ACTIVE']))
    
    if office_id:
        query = query.join(models.Customer).filter(models.Customer.office_id == office_id)
        
    loans = query.all()
    created_drafts = []
    
    for loan in loans:
        # Check if draft exists
        existing = db.query(models.MonthlyRecovery).filter(
            models.MonthlyRecovery.loan_id == loan.id,
            models.MonthlyRecovery.month == month,
            models.MonthlyRecovery.year == year
        ).first()
        
        if not existing:
            # Calculation logic:
            # 1. Principal due is fixed constant installment, capped at remaining balance
            principal_due = min(loan.base_emi_amount, loan.principal_outstanding)
            
            # 2. Reduce principal due from outstanding balance to determine new balance
            reduced_outstanding = loan.principal_outstanding - principal_due
            
            # 3. Calculate 12% p.a. interest (1% monthly) on the reduced balance
            interest = round(reduced_outstanding * 0.01, 2)

            new_draft = models.MonthlyRecovery(
                id=str(uuid.uuid4()),
                loan_id=loan.id,
                month=month,
                year=year,
                principal_due=principal_due,
                interest=interest,
                penal_interest=0.0,
                other_charges=0.0,
            )
            db.add(new_draft)
            created_drafts.append(new_draft)
    
    db.commit()
    return {"message": f"{len(created_drafts)} drafts generated for the selected unit."}

@app.patch("/recoveries/{recovery_id}", response_model=schemas.MonthlyRecovery)
def update_recovery(
    recovery_id: str, 
    principal_due: float = None,
    interest: float = None,
    penal_interest: float = None, 
    other_charges: float = None, 
    db: Session = Depends(get_db)
):
    db_recovery = db.query(models.MonthlyRecovery).filter(models.MonthlyRecovery.id == recovery_id).first()
    if not db_recovery:
        raise HTTPException(status_code=404, detail="Recovery not found")
    
    if principal_due is not None:
        db_recovery.principal_due = principal_due
    if interest is not None:
        db_recovery.interest = interest
    if penal_interest is not None:
        db_recovery.penal_interest = penal_interest
    if other_charges is not None:
        db_recovery.other_charges = other_charges
        
    db.commit()
    db.refresh(db_recovery)
    return db_recovery
