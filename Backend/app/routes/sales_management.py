from fastapi.security import OAuth2PasswordBearer
from fastapi import APIRouter, Depends, HTTPException, status
from schema.schemas import *
from config.database import *
from models.sales_management_model import *

sales_management_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")


# ! FLutter if [] then return text that shows empty list
@sales_management_router.get("/sales-management/get_monthly_sales")
def get_sales_by_month(token: str = Depends(oauth_scheme)):
    sales = monthly_sales_target_serial(monthly_sales_db.find())
    return sales

@sales_management_router.get("/sales-management/get_monthly_sales_by_year/{year}")
def get_sales_by_month(year: int, token: str = Depends(oauth_scheme)):
    sales = monthly_sales_target_serial(monthly_sales_db.find())
    return sales

@sales_management_router.get("/sales-management/get_specific_monthly_sales/{year}/{month}")
def get_sales_by_month(year: int, month: int, token: str = Depends(oauth_scheme)):
    if month > 12 or month < 1:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Invalid Month",
            headers={"WWW-Authenticate": "Bearer"},
        )
    monthlySale = monthly_sales_db.find_one({"year": year, "month": month})
    
    if not monthlySales:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, 
            detail="Monthly Sales not found", 
            headers={"WWW-Authenticate": "Bearer"}
        )
    return monthlySale

# POSTING new sales target
@sales_management_router.post("/sales-management/new_monthly_sales_target")
def update_company_monthly_sales(sales_by_month: MonthlySalesTarget, token: str = Depends(oauth_scheme)):
    old_sales = monthly_sales_db.find_one({"year": sales_by_month.year, "month": sales_by_month.month})
    if old_sales:
        if old_sales['target_sales'] == 0 or not old_sales['target_sales']:
            old_sales['target_sales'] = sales_by_month.target_sales
            monthly_sales_db.update_one({"year": sales_by_month.year, "month": sales_by_month.month}, {"$set": old_sales})
            return {"message": "Monthly Sales added successfully",}
        else:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Monthly sales added previously",
                headers={"WWW-Authenticate": "Bearer"},
            )
    if not old_sales:
        monthly_sales_db.insert_one(dict(sales_by_month))
        return {"message": "Monthly Sales added successfully",}
        

# Updating existing sales target
@sales_management_router.put("/sales-management/update_monthly_sales_target")
def update_company_monthly_sales(sales_by_month: MonthlySalesTarget, token: str = Depends(oauth_scheme)):
    old_sales = monthly_sales_db.find_one({"year": sales_by_month.year, "month": sales_by_month.month})
    if old_sales:
        monthly_sales_db.update_one({"year": sales_by_month.year, "month": sales_by_month.month}, {"$set": dict(sales_by_month)})
        return {"message": "Monthly Sales updated successfully",}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Previous monthly sales not found",
            headers={"WWW-Authenticate": "Bearer"},
        )


# Updating dispatch information
@sales_management_router.put("/sales-management/update_dispatch/{orderID}/{completionStatus}")
def update_dispatch(orderID: str, completionStatus: str, token: str = Depends(oauth_scheme)):
    order = sales_order_db.find_one({"order_id": orderID})
    if not order:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    if order['order_status'] == "Completed":
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order already completed",
            headers={"WWW-Authenticate": "Bearer"},
        )
    order['completion_status'] = completionStatus
    if completionStatus == 'Delivered':
        order['order_status'] = 'Completed'
    sales_order_db.update_one({"order_id": orderID}, {"$set": order})
    return {"message": "Dispatch updated successfully",}