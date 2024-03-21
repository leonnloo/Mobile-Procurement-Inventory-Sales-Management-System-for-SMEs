from pydantic import BaseModel
from models.sales_management_model import ProductMonthlySales
from typing import List

class ProductItem(BaseModel):
    product_id: str
    product_name: str
    unit_price: float
    selling_price: float
    quantity: int
    markup: str
    margin: str
    critical_level: int
    status: str
    monthly_sales: List[ProductMonthlySales] | None

class NewProduct(BaseModel):
    product_name: str
    unit_price: float
    selling_price: float
    markup: str
    margin: str
    critical_level: int

class EditProduct(BaseModel):
    product_name: str
    unit_price: float
    selling_price: float
    quantity: int
    markup: str
    margin: str
    critical_level: int

class StockInOutProduct(BaseModel):
    product_name: str
    quantity: int