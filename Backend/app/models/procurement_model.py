from pydantic import BaseModel

class Procurement(BaseModel):
    purchase_id: str | None
    item_type: str
    item_name: str
    item_id: str
    supplier_name: str
    order_date: str
    delivery_date: str
    unit_price: float
    total_price: float
    quantity: int
    status: str

class NewProcurement(BaseModel):
    item_type: str
    item_name: str
    item_id: str
    supplier_name: str
    order_date: str
    delivery_date: str
    unit_price: float
    total_price: float
    quantity: int
    status: str
