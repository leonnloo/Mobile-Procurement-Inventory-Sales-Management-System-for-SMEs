from typing import List
from pydantic import BaseModel
from bson import ObjectId

from models.sales_management_model import EmployeeMonthlySales

class User(BaseModel):
    employee_name: str
    employee_id: int | None
    email: str 
    password: str
    phone_number: str
    role: str | None
    sales_record: List[EmployeeMonthlySales] | None
    # company: str