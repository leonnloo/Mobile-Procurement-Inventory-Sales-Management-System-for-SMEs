from typing import List
from pydantic import BaseModel

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
    notes: List[NotesInfo]

