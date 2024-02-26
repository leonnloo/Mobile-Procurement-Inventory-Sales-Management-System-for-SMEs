from typing import List
from pydantic import BaseModel
from bson import ObjectId

from models.sales_management_model import EmployeeMonthlySales

class User(BaseModel):
    employee_name: str
    employee_id: int
    email: str
    password: str
    role: str
    sales_record: List[EmployeeMonthlySales]
    # company: str