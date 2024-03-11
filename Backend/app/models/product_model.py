from pydantic import BaseModel

class ProductItem(BaseModel):
    product_id: str
    product_name: str
    unit_price: float
    selling_price: float
    quantity: int
    markup: str
    margin: str
    status: str

class NewProduct(BaseModel):
    product_name: str
    quantity: int
    unit_price: float
    selling_price: float
    markup: str
    margin: str
