from enum import Enum
from pydantic import BaseModel


# Used in user data
class EmployeeMonthlySales(BaseModel):
    year: int
    month: int
    sales: float


class MonthlySalesTarget(BaseModel):
    year: int
    month: int
    actual_sales: float
    target_sales: float


class ProductMonthlySales(BaseModel):
    year: int
    month: int
    quantity_sold: int
    total_price: float




# JANUARY = "January"
# FEBRUARY = "February"
# MARCH = "March"
# APRIL = "April"
# MAY = "May"
# JUNE = "June"
# JULY = "July"
# AUGUST = "August"
# SEPTEMBER = "September"
# OCTOBER = "October"
# NOVEMBER = "November"
# DECEMBER = "December"
