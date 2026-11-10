from sqlalchemy import Column, Integer, String, Float, ForeignKey, Date, Boolean, DateTime
from sqlalchemy.orm import relationship
import datetime
from database import Base

class AuthorizedEmployee(Base):
    __tablename__ = "authorized_employees"
    id = Column(String, primary_key=True)
    email = Column(String, unique=True, index=True, nullable=False)
    name = Column(String, nullable=False)
    role = Column(String, default="officer")  # officer, auditor, admin
    assigned_branches = Column(String, default="[]")  # JSON string of branch slugs
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    sessions = relationship("DeviceSession", back_populates="employee")

class DeviceSession(Base):
    __tablename__ = "device_sessions"
    id = Column(String, primary_key=True)
    employee_id = Column(String, ForeignKey("authorized_employees.id"), nullable=False)
    device_id = Column(String, index=True, nullable=False)
    device_name = Column(String, default="Unknown Device")
    refresh_token = Column(String, nullable=True)
    is_revoked = Column(Boolean, default=False)
    last_seen_at = Column(DateTime, default=datetime.datetime.utcnow)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    employee = relationship("AuthorizedEmployee", back_populates="sessions")

class Office(Base):
    __tablename__ = "offices"
    id = Column(String, primary_key=True)
    branch_id = Column(String)  # internal mapping
    name = Column(String, nullable=False)

    customers = relationship("Customer", back_populates="office")

class Customer(Base):
    __tablename__ = "customers"
    id = Column(String, primary_key=True)
    office_id = Column(String, ForeignKey("offices.id"))
    member_no = Column(String, nullable=False)
    name = Column(String, nullable=False)

    office = relationship("Office", back_populates="customers")
    loans = relationship("Loan", back_populates="customer")

class Loan(Base):
    __tablename__ = "loans"
    id = Column(String, primary_key=True)
    customer_id = Column(String, ForeignKey("customers.id"))
    account_no = Column(String, nullable=False)
    principal_outstanding = Column(Float, default=0.0)
    base_emi_amount = Column(Float, default=0.0)
    status = Column(String, default="Active")

    customer = relationship("Customer", back_populates="loans")
    recoveries = relationship("MonthlyRecovery", back_populates="loan")

class MonthlyRecovery(Base):
    __tablename__ = "monthly_recoveries"
    id = Column(String, primary_key=True)
    loan_id = Column(String, ForeignKey("loans.id"))
    month = Column(Integer, nullable=False)
    year = Column(Integer, nullable=False)
    principal_due = Column(Float, default=0.0)
    interest = Column(Float, default=0.0)
    penal_interest = Column(Float, default=0.0)
    other_charges = Column(Float, default=0.0)

    loan = relationship("Loan", back_populates="recoveries")
