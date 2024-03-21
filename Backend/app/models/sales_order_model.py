from pydantic import BaseModel
from enum import Enum
class orderStatus(Enum):
    completed = 'Completed'
    pending = 'Pending'
    refunded = 'Refunded'

class completionMode(Enum):
    package = 'To be packaged'
    ship = 'To be shipped'
    complete = 'To be completed'


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
    completion_status: str
    order_status: str
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
    order_status: str
    employee: str
    employee_id: str


class Refunds(BaseModel):
    refund_id: str
    order_id: str
    refund_date: str
    customer_id: str
    customer_name: str
    product_id: str
    product_name: str
    refund_quantity: int
    order_price: float
    refund_amount: float
    reason: str
# status: completed, delivering, pending, refunded