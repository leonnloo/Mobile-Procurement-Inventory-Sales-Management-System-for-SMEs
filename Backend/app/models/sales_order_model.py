from pydantic import BaseModel

class SaleOrder(BaseModel):
    order_no: str
    date: str
    customer_id: int
    product_id: int
    product_name: str
    quantity: int
    total_price: int
    status: str

# status: completed, delivering, pending, refunded