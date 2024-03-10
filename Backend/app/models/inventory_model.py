from pydantic import BaseModel

class InventoryItem(BaseModel):
    item_id: str
    item_name: str
    category: str
    quantity: int
    unit_price: float
    total_price: float
    status: str

class NewInventoryItem(BaseModel):
    item_name: str
    category: str
    unit_price: float

class StockInOutInventoryItem(BaseModel):
    item_name: str
    quantity: int

class EditInventoryItem(BaseModel):
    item_name: str
    category: str
    unit_price: float
    quantity: int
