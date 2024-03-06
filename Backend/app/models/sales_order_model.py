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


class Refunds(BaseModel):
    refund_id: str
    order_no: str
    date: str
    customer_id: str
    product_id: str
    product_name: str
    quantity: int
    total_price: float
    refund_amount: float
    status: str 
# status: completed, delivering, pending, refunded