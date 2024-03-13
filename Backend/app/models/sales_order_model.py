from pydantic import BaseModel

class SaleOrder(BaseModel):
    order_id: str
    order_date: str
    customer_id: str
    customer_name: str
    product_id: str
    product_name: str
    quantity: int
    unit_price: float
    total_price: float
    status: str
    employee: str
    employee_id: str

class NewSaleOrder(BaseModel):
    order_date: str
    customer_id: str
    customer_name: str
    product_id: str
    product_name: str
    quantity: int
    unit_price: float
    total_price: float
    status: str
    employee: str
    employee_id: str


class Refunds(BaseModel):
    refund_id: str
    order_id: str
    date: str
    customer_id: str
    customer_name: str
    product_id: str
    product_name: str
    quantity: int
    order_price: float
    refund_amount: float
# status: completed, delivering, pending, refunded