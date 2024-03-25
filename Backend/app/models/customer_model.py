from typing import List
from pydantic import BaseModel
from models.sales_order_model import SaleOrder

class CustomerInfo(BaseModel):
    customer_id: str
    business_name: str
    contact_person: str
    email: str
    phone_number: str
    billing_address: str
    shipping_address: str 
    notes: str | None

class NewCustomer(BaseModel):
    business_name: str
    contact_person: str
    email: str
    phone_number: str
    billing_address: str
    shipping_address: str