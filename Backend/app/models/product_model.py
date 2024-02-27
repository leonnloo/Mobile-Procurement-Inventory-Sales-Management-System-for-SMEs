from pydantic import BaseModel

class ProductItem(BaseModel):
    product_id: str
    product_name: str
    unit_price: int
    selling_price: int
    quantity: int
    markup: int
    margin: int
    status: str