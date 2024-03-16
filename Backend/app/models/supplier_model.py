from typing import List
from pydantic import BaseModel
from models.sales_order_model import SaleOrder

class SupplierInfo(BaseModel):
    supplier_id: str
    business_name: str
    contact_person: str
    email: str
    phone_number: str
    address: str
    notes: str | None

class NewSupplier(BaseModel):
    business_name: str
    contact_person: str
    email: str
    phone_number: str
    address: str