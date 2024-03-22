from pydantic import BaseModel

class Refund(BaseModel):
    refund_id: str
    order_id: str
    order_status: str
    refund_date: str
    customer_id: str
    customer_name: str
    product_id: str
    product_name: str
    refund_quantity: int
    order_price: float
    refund_amount: float
    reason: str

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




# status: completed, pending, refunded