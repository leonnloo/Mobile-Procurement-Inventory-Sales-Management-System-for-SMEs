from typing import List
from pydantic import BaseModel
from models.sales_order_model import SaleOrder


class NotesInfo(BaseModel):
    date: str
    memo: str

class SupplierInfo(BaseModel):
    supplier_id: str
    business_name: str
    contact_person: str
    email: str
    phone_number: str
    address: str
    past_order: List[SaleOrder] | None
    notes: NotesInfo | None

class NewSupplier(BaseModel):
    business_name: str
    contact_person: str
    email: str
    phone_number: str
    address: str