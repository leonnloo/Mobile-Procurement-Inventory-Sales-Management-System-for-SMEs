from pydantic import BaseModel

class Procurement(BaseModel):
    purchase_no: str | None
    item_name: str
    supplier_name: str
    order_date: str
    delivery_date: str
    unit_price: float
    total_price: float
    quantity: int
    status: str

class NewProcurement(BaseModel):
    item_name: str
    supplier_name: str
    order_date: str
    delivery_date: str
    unit_price: float
    total_price: float
    quantity: int
    status: str
