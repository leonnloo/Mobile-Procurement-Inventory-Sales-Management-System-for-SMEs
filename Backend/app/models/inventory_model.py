from pydantic import BaseModel

class InventoryItem(BaseModel):
    item_id: str
    item_name: str
    category: str
    quantity: int
    unit_price: int
    total_price: int
    supplier: str
    status: str