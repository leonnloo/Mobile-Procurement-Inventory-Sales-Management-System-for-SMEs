from fastapi.security import OAuth2PasswordBearer
from fastapi import APIRouter, Depends, HTTPException, status
from schema.schemas import *
from config.database import *
from routes.func import *
from models.sales_management_model import *
from models.sales_order_model import *

sales_management_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")


# ! FLutter if [] then return text that shows empty list
@sales_management_router.get("/sales-management/get_monthly_sales")
def get_sales_by_month(token: str = Depends(oauth_scheme)):
    sales = monthly_sales_target_serial(monthly_sales_db.find())
    return sales

@sales_management_router.get("/sales-management/get_monthly_sales_by_year/{year}")
def get_sales_by_month_by_year(year: int, token: str = Depends(oauth_scheme)):
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
@sales_management_router.put("/sales-management/update_monthly_target_sales")
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
        year, month, day = extract_year_month_day(order['order_date'])
        monthly_sale = monthly_sales_db.find_one({"year": year, "month": month})

        # Update monthly sales
        if monthly_sale:
            monthly_sale['actual_sales'] += order['total_price']
            monthly_sales_db.update_one({"year": year, "month": month}, {"$set": monthly_sale})
        # if order is placed in a advanced month
        else:
            new_monthly_sales = MonthlySalesTarget(
                year = year,
                month = month,
                actual_sales = order['total_price'],
                target_sales = 0
            )
            monthly_sales_db.insert_one(dict(new_monthly_sales))

        # Update employee
        employee = users_db.find_one({"employee_id": order['employee_id']})
        if employee:
            if 'sales_record' in employee and isinstance(employee['sales_record'], list):
                # Check if there is a sales record for the given year and month
                sales_record_found = False
                for record in employee['sales_record']:
                    if record['year'] == year and record['month'] == month:
                        record['sales'] += order['total_price']
                        sales_record_found = True
                        break

                # If no sales record found for the given year and month, create a new one
                if not sales_record_found:
                    new_monthly_sales = {
                        'year': year,
                        'month': month,
                        'sales': order['total_price']
                    }
                    employee['sales_record'].append(new_monthly_sales)
            else:
                # If sales_record doesn't exist or is not a list, create a new list with the new sales record
                employee['sales_record'] = [{
                    'year': year,
                    'month': month,
                    'sales': order['total_price']
                }]
            
            # Update the employee document in the database
            users_db.update_one({"employee_id": order['employee_id']}, {"$set": employee})
        if not employee:
            raise HTTPException(
                status_code = status.HTTP_403_FORBIDDEN,
                detail = "Couldn't register employee sale",
                headers={"WWW-Authenticate": "Bearer"},
            )

        # Add product monthly sales
        product = product_db.find_one({"product_id": order['product_id']})
        if 'monthly_sales' in product and isinstance(product['monthly_sales'], list):
            monthlyProduct = False
            for record in product['monthly_sales']:
                if record['year'] == year and record['month'] == month:
                    record['total_price'] += order['total_price']
                    record['quantity_sold'] += order['quantity']
                    monthlyProduct = True
                    break

            # If no sales record found for the given year and month, create a new one
            if not monthlyProduct:
                new_monthly_sales = {
                    'year': year,
                    'month': month,
                    'quantity_sold': order['quantity'],
                    'total_price': order['total_price']
                }
                product['monthly_sales'].append(new_monthly_sales)
        else:
            # If monthly_sales doesn't exist or is not a list, create a new list with the new sales record
            product['monthly_sales'] = [{
                'year': year,
                'month': month,
                'quantity_sold': order['quantity'],
                'total_price': order['total_price']
            }]
        if not product:
            raise HTTPException(
                status_code = status.HTTP_403_FORBIDDEN,
                detail = "Couldn't register product sale",
                headers={"WWW-Authenticate": "Bearer"},
            )
        product_db.update_one({"product_id": order['product_id']}, {"$set": product})


    sales_order_db.update_one({"order_id": orderID}, {"$set": order})
    return {"message": "Dispatch updated successfully",}

# Refunds
@sales_management_router.get("/sales-management/get_refunds")
def get_refunds(token: str = Depends(oauth_scheme)):
    refunds = refunds_serial(refunds_db.find())
    return refunds


@sales_management_router.post("/sales-management/new_refund")
def new_refund(refund: Refund, token: str = Depends(oauth_scheme)):
    latest_id_document = refunds_db.find_one(sort=[("refund_id", -1)])

    if latest_id_document:
        query_id = latest_id_document.get("refund_id", "-1")
        next_refund_id = processNextID(query_id)
    else:
        next_refund_id = "RF1"

    # Update order status
    order = sales_order_db.find_one({"order_id": refund.order_id})
    old_order_status = order['order_status']
    if not order:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    order['order_status'] = 'Refunded';
    sales_order_db.update_one({"order_id": refund.order_id}, {"$set": order})
    
    if old_order_status == "Completed":
        # Update monthly sales
        year, month, day = extract_year_month_day(order["order_date"])
        monthly_sale = monthly_sales_db.find_one({"year": year, "month": month})
        if not monthly_sale:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Monthly sales not found",
                headers={"WWW-Authenticate": "Bearer"},
            )
        monthly_sale['target_sales'] -= refund.refund_amount
        monthly_sales_db.update_one({"year": year, "month": month}, {"$set": monthly_sale})

        # Update employee sales
        employee = employee_db.find_one({"employee_id": order.employee_id})
        if not employee:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Employee not found",
                headers={"WWW-Authenticate": "Bearer"},
            )
        for record in employee['sales_record']:
            if record['year'] == year and record['month'] == month:
                record['sales'] -= refund.refund_amount
                break
        employee_db.update_one({"employee_id": order.employee_id}, {"$set": employee})
            
        # Update product sales
        product = product_db.find_one({"product_id": order.product_id})
        if not product:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Product not found",
                headers={"WWW-Authenticate": "Bearer"},
            )
        for record in product['monthly_sales']:
                if record['year'] == year and record['month'] == month:
                    product['total_price'] -= refund.refund_amount
                    break
        product_db.update_one({"product_id": order.product_id}, {"$set": product})

    new_refund = Refund(
        refund_id = next_refund_id,
        order_id = refund.order_id,
        order_status = old_order_status,
        refund_date = refund.refund_date,
        customer_id = refund.customer_id,
        customer_name = refund.customer_name,
        product_id = refund.product_id,
        product_name = refund.product_name,
        refund_quantity = refund.refund_quantity,
        order_price = refund.order_price,
        refund_amount = refund.refund_amount,
        reason = refund.reason
    )

    refunds_db.insert_one(dict(new_refund))
    return {"Message": "Refund successfully registered"}


@sales_management_router.delete("/sales-management/delete_refund/{refundID}")
def delete_refunds(refundID: str, token: str = Depends(oauth_scheme)):
    refund = refunds_db.find_one({"refund_id": refundID})
    refunded_order = sales_order_db.find_one({'order_id': refund['order_id']})
    if not refunded_order:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Order not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    product = product_db.find_one({"product_id": refund['product_id']})
    if not product:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # Update monthly sales, product sales, and employee sales if refund was deleted reverting back to the original order
    if refund['order_status'] == 'Completed':
        year, month, day = extract_year_month_day(refunded_order['order_date'])
        monthly_sale = monthly_sales_db.find_one({"year": year, "month": month})
        if monthly_sale:
            monthly_sale['actual_sales'] += refund['refund_amount']
            monthly_sales_db.update_one({"year": year, "month": month}, {"$set": monthly_sale})

        # update employee sales
        employee = users_db.find_one({"employee_id": refunded_order['employee_id']})
        if employee:
            for record in employee['sales_record']:
                if record['year'] == year and record['month'] == month:
                    record['sales'] += refund['refund_amount']
            users_db.update_one({"employee_id": refunded_order['employee_id']}, {"$set": employee})

        # update product monthly sales
        if product:
            for record in product['monthly_sales']:
                if record['year'] == year and record['month'] == month:
                    record['total_price'] += refund['refund_amount']
                    break
            product_db.update_one({'product_id': refund['product_id']}, {'$set': product})

    refunded_order['order_status'] = refund['order_status']
    sales_order_db.update_one({'order_id': refund['order_id']}, {'$set': refunded_order})
    result = refunds_db.delete_one({'refund_id': refundID})
    if result.deleted_count > 0:
        return {"message": f"Refund with id {refundID} deleted successfully"}
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Refund with refundID {refundID} not found",
        )
