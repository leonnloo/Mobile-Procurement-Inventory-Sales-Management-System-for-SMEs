from enum import Enum
from pydantic import BaseModel


# Used in user data
class EmployeeMonthlySales(BaseModel):
    year: str
    month: str
    sales: float
    
class CompanyMonthlySales(BaseModel):
    year: str
    month: str
    sales: float







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
