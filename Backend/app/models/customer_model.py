from typing import List
from pydantic import BaseModel
from models.sales_order_model import SaleOrder
from models.supplier_model import NotesInfo

class CustomerInfo(BaseModel):
    customer_id: str
    business_name: str
    contact_person: str
    email: str
    phone_number: str
    billing_address: str
    shipping_address: str 
    past_order: List[SaleOrder] | None
    refunds: List[SaleOrder] | None
    notes: NotesInfo | None