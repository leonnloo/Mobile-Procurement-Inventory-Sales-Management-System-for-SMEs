from enum import Enum
from pydantic import BaseModel


# Used in user data
class EmployeeMonthlySales(BaseModel):
    year: int
    month: int
    sales: float
    
class CompanyMonthlySales(BaseModel):
    year: int
    month: int
    sales: int







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
