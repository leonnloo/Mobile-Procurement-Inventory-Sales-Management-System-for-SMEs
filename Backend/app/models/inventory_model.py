from pydantic import BaseModel

class InventoryItem(BaseModel):
    item_id: int
    item_name: str
    category: str
    quantity: int
    unit_price: int
    total_price: int
    supplier: str
    status: str