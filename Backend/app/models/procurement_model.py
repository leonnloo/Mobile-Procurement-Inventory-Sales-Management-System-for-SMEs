from pydantic import BaseModel

class Procurement(BaseModel):
    purchase_no: str
    item_name: str
    supplier: str
    order_date: str
    delivery_date: str
    cost: int
    quantity: int
    status: str