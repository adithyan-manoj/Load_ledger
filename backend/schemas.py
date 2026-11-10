from pydantic import BaseModel
from typing import List, Optional

class OfficeBase(BaseModel):
    id: str
    branch_id: str
    name: str

class Office(OfficeBase):
    class Config:
        from_attributes = True

class CustomerBase(BaseModel):
    id: str
    office_id: str
    member_no: str
    name: str

class Customer(CustomerBase):
    class Config:
        from_attributes = True

class LoanBase(BaseModel):
    id: str
    customer_id: str
    account_no: str
    principal_outstanding: float
    base_emi_amount: float
    status: str

class Loan(LoanBase):
    class Config:
        from_attributes = True

class MonthlyRecoveryBase(BaseModel):
    id: str
    loan_id: str
    month: int
    year: int
    principal_due: float
    interest: float
    penal_interest: float
    other_charges: float

class MonthlyRecovery(MonthlyRecoveryBase):
    @property
    def total_recovered(self) -> float:
        return self.principal_due + self.interest + self.penal_interest + self.other_charges

    class Config:
        from_attributes = True

# --- Authentication & Identity Schemas ---
class GoogleLoginRequest(BaseModel):
    id_token: str
    device_id: str
    device_name: Optional[str] = "Mobile Client"

class EmployeeResponse(BaseModel):
    id: str
    email: str
    name: str
    role: str
    assigned_branches: List[str]
    is_active: bool

    class Config:
        from_attributes = True

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    employee: EmployeeResponse

class RefreshTokenRequest(BaseModel):
    refresh_token: str
    device_id: str

class RevokeDeviceRequest(BaseModel):
    device_id: str
    employee_id: Optional[str] = None

class EmployeeCreate(BaseModel):
    email: str
    name: str
    role: Optional[str] = "officer"
    assigned_branches: Optional[List[str]] = []
