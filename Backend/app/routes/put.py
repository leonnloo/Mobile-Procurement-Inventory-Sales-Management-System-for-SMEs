from fastapi import APIRouter, Depends, HTTPException, status
from config.database import *
from models.customer_model import *
from models.sales_order_model import *
from models.supplier_model import *
from models.procurement_model import * 
from models.product_model import * 
from models.inventory_model import *  
from models.sales_management_model import *
from schema.schemas import *
from fastapi.security import OAuth2PasswordBearer
from routes.func import *

put_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")

# ----------------------------------------- Customer Update ----------------------------------------------
@put_router.put("/update_customer/{customerID}")
def update_customer(customer: NewCustomer, customerID: str, token: str = Depends(oauth_scheme)):
    old_customer = customers_db.find_one({"customer_id": customerID})
    if old_customer:
        updated_customer = CustomerInfo(
            customer_id = old_customer["customer_id"],
            business_name = customer.business_name,
            contact_person = customer.contact_person,
            email = customer.email,
            phone_number = customer.phone_number,
            billing_address = customer.billing_address,
            shipping_address = customer.shipping_address,
            notes = old_customer["notes"],
        )
        customers_db.update_one({"customer_id": customerID}, {"$set": dict(updated_customer)})
        return customer_dict_serial(customers_db.find_one({"customer_id": customerID}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Customer not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
# ----------------------------------------- Supplier Update ----------------------------------------------
@put_router.put("/update_supplier/{supplierID}")
def update_supplier(supplier: NewSupplier, supplierID: str, token: str = Depends(oauth_scheme)):
    old_supplier = suppliers_db.find_one({"supplier_id": supplierID})
    if old_supplier:
        updated_supplier = SupplierInfo(
            supplier_id = old_supplier["supplier_id"],
            business_name = supplier.business_name,
            contact_person = supplier.contact_person,
            email = supplier.email,
            phone_number = supplier.phone_number,
            address = supplier.address,
            notes = old_supplier["notes"],
        )
        suppliers_db.update_one({"supplier_id": supplierID}, {"$set": dict(updated_supplier)})
        return supplier_dict_serial(suppliers_db.find_one({"supplier_id": supplierID}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Supplier not found",
            headers={"WWW-Authenticate": "Bearer"},
        )




# ----------------------------------------- Sales Order Update ----------------------------------------------
@put_router.put("/update_sale_order/{order_id}")
def update_sale_order(order: SaleOrder, order_id, token: str = Depends(oauth_scheme)):
    old_order = sales_order_db.find_one({"order_id": order_id})
    product = product_db.find_one({"product_id": order.product_id})
    left_product = product["quantity"] - (order.quantity - old_order["quantity"])
    if (left_product >= 0):
        if old_order:
            if order.order_status == 'Completed':
                priceDifference = order.total_price - old_order['total_price']
                product_difference = order.quantity - old_order["quantity"]
                year, month, day = extract_year_month_day(order.order_date)
                monthly_sale = monthly_sales_db.find_one({"year": year, "month": month})
                # Update monthly sales
                if monthly_sale:
                    monthly_sale['actual_sales'] += priceDifference
                    monthly_sales_db.update_one({"year": year, "month": month}, {"$set": monthly_sale})
                # if order is placed in a advanced month
                else:
                    new_monthly_sales = MonthlySalesTarget(
                        year = year,
                        month = month,
                        actual_sales = order.total_price,
                        target_sales = 0
                    )
                    monthly_sales_db.insert_one(dict(new_monthly_sales))


                # Update employee
                employee = users_db.find_one({"employee_id": order.employee_id})
                if employee:
                    if 'sales_record' in employee and isinstance(employee['sales_record'], list):
                        # Check if there is a sales record for the given year and month
                        sales_record_found = False
                        for record in employee['sales_record']:
                            if record['year'] == year and record['month'] == month:
                                record['sales'] += priceDifference
                                sales_record_found = True
                                break

                        # If no sales record found for the given year and month, create a new one
                        if not sales_record_found:
                            new_monthly_sales = {
                                'year': year,
                                'month': month,
                                'sales': order.total_price
                            }
                            employee['sales_record'].append(new_monthly_sales)
                    else:
                        # If sales_record doesn't exist or is not a list, create a new list with the new sales record
                        employee['sales_record'] = [{
                            'year': year,
                            'month': month,
                            'sales': order.total_price
                        }]
                    
                    # Update the employee document in the database
                    users_db.update_one({"employee_id": order.employee_id}, {"$set": employee})
                if not employee:
                    raise HTTPException(
                        status_code = status.HTTP_403_FORBIDDEN,
                        detail = "Couldn't register employee sale",
                        headers={"WWW-Authenticate": "Bearer"},
                    )
                
                # Update product monthly sales
                if 'monthly_sales' in product and isinstance(product['monthly_sales'], list):
                    monthlyProduct = False
                    for record in product['monthly_sales']:
                        if record['year'] == year and record['month'] == month:
                            record['total_price'] += priceDifference
                            record['quantity_sold'] += product_difference
                            monthlyProduct = True
                            break

                    # If no sales record found for the given year and month, create a new one
                    if not monthlyProduct:
                        new_monthly_sales = {
                            'year': year,
                            'month': month,
                            'quantity_sold': order.quantity,
                            'total_price': order.total_price
                        }
                        product['monthly_sales'].append(new_monthly_sales)
                else:
                    # If monthly_sales doesn't exist or is not a list, create a new list with the new sales record
                    product['monthly_sales'] = [{
                        'year': year,
                        'month': month,
                        'quantity_sold': order.quantity,
                        'total_price': order.total_price
                    }]

                # Update completion status of order
                order.completion_status = 'Delivered'

            # Update product status
            product['quantity'] = left_product
            if product['quantity'] > 0 and product['quantity'] >= product['critical_level']:
                new_status = 'In Stock'
            elif product['quantity'] > 0 and product['quantity'] < product['critical_level']:
                new_status = 'Low Stock'
            else:
                new_status = 'Out of Stock'
            product['status'] = new_status
            product_db.update_one({"product_id": order.product_id}, {"$set": product})


            updated_order = SaleOrder(
                order_id = order_id,
                order_date = order.order_date,
                customer_id = order.customer_id,
                customer_name = order.customer_name,
                product_id = order.product_id,
                product_name = order.product_name,
                quantity = order.quantity,
                unit_price = order.unit_price,
                total_price = order.total_price,
                completion_status = order.completion_status,
                order_status = order.order_status,
                employee = order.employee,
                employee_id = order.employee_id
            )

            sales_order_db.update_one({"order_id": order_id}, {"$set": dict(updated_order)})
            return sale_order_dict_serial(sales_order_db.find_one({"order_id": order_id}))
        else:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Sale order not found",
                headers={"WWW-Authenticate": "Bearer"},
            )
    else:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Product ran out of stock",
        )
# ----------------------------------------- Procurement Update ----------------------------------------------
@put_router.put("/update_procurement/{procurement_id}")
def update_procurement(purchase: NewProcurement, procurement_id: str, token: str = Depends(oauth_scheme)):
    old_purchase = procurement_db.find_one({"purchase_id": procurement_id})
    if old_purchase:
        if purchase.status == "Completed":
            if purchase.item_type == "Product":
                product = product_db.find_one({"product_id": purchase.item_id})
                left_product = product["quantity"] - purchase.quantity
                if left_product >= 0:
                    product['quantity'] = left_product
                    if product['quantity'] > 0 and product['quantity'] >= product['critical_level']:
                        new_status = 'In Stock'
                    elif product['quantity'] > 0 and product['quantity'] < product['critical_level']:
                        new_status = 'Low Stock'
                    else:
                        new_status = 'Out of Stock'
                    
                    product['status'] = new_status
                    product_db.update_one({"product_id": purchase.item_id}, {"$set": product})
                else:
                    raise HTTPException(
                    status_code = status.HTTP_403_FORBIDDEN,
                    detail = "Product ran out of stock",
                    )
            elif purchase.item_type == "Inventory":
                item = inventory_db.find_one({"item_id": purchase.item_id})
                left_item = item["quantity"] - purchase.quantity
                if left_item >= 0:
                    item['quantity'] = left_item
                    if item['quantity'] > 0 and item['quantity'] >= item['critical_level']:
                        new_status = 'In Stock'
                    elif item['quantity'] > 0 and item['quantity'] < item['critical_level']:
                        new_status = 'Low Stock'
                    else:
                        new_status = 'Out of Stock'
                    
                    item['status'] = new_status
                    inventory_db.update_one({"item_id": purchase.item_id}, {"$set": item})
                else:
                    raise HTTPException(
                    status_code = status.HTTP_403_FORBIDDEN,
                    detail = "Inventory item ran out of stock",
                    )
                
        procurement_db.update_one({"purchase_id": procurement_id}, {"$set": dict(purchase)})
        return procurement_dict_serial(procurement_db.find_one({"purchase_id": procurement_id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Purchase not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
# ----------------------------------------- Product Update ----------------------------------------------
@put_router.put("/update_product/{productID}")
def update_product(product: EditProduct, productID: str, token: str = Depends(oauth_scheme)):
    old_product = product_db.find_one({"product_id": productID})

    if old_product:
        if product.quantity > 0 and product.quantity >= product.critical_level:
            new_status = 'In Stock'
        elif product.quantity > 0 and product.quantity < product.critical_level:
            new_status = 'Low Stock'
        else:
            new_status = 'Out of Stock'

        if product.quantity < 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Quantity cannot be negative",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        updated_product = ProductItem(
            product_id = old_product["product_id"],
            product_name = product.product_name,
            unit_price = product.unit_price,
            selling_price = product.selling_price,
            markup = product.markup,
            margin = product.margin,
            quantity = product.quantity,
            critical_level = product.critical_level,
            status = new_status,
            monthly_sales = old_product['monthly_sales']
        )

        old_product['product_name'] = product.product_name
        old_product['unit_price'] = product.unit_price
        old_product['selling_price'] = product.selling_price
        old_product['markup'] = product.markup
        old_product['margin'] = product.margin
        old_product['quantity'] = product.quantity
        old_product['critical_level'] = product.critical_level
        old_product['status'] = new_status
        product_db.update_one({"product_id": productID}, {"$set": old_product})
        return product_dict_serial(product_db.find_one({"product_id": productID}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
@put_router.put("/stock_in_product")
def stock_in_product(item: StockInOutProduct, token: str = Depends(oauth_scheme)):
    old_item = product_db.find_one({"product_name": item.product_name})
    if old_item:
        new_quantity = old_item["quantity"] + item.quantity
        
        if new_quantity > 0 and new_quantity >= old_item["critical_level"]:
            old_item['status'] = 'In Stock'
        elif new_quantity > 0 and new_quantity < old_item["critical_level"]:
            old_item['status'] = 'Low Stock'
        else:
            old_item['status'] = 'Out of Stock'
        old_item['quantity'] = new_quantity

        product_db.update_one({"product_name": item.product_name}, {"$set": old_item})
        return product_dict_serial(product_db.find_one({"product_name": item.product_name}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

@put_router.put("/stock_out_product")
def stock_out_product(item: StockInOutProduct, token: str = Depends(oauth_scheme)):
    old_item = product_db.find_one({"product_name": item.product_name})
    if old_item:
        new_quantity = old_item["quantity"] - item.quantity
        if new_quantity < 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Quantity cannot be negative",
                headers={"WWW-Authenticate": "Bearer"},
            )

        if new_quantity > 0 and new_quantity >= old_item["critical_level"]:
            old_item['status'] = 'In Stock'
        elif new_quantity > 0 and new_quantity < old_item["critical_level"]:
            old_item['status'] = 'Low Stock'
        else:
            old_item['status'] = 'Out of Stock'
        old_item['quantity'] = new_quantity

        product_db.update_one({"product_name": item.product_name}, {"$set": old_item})
        return product_dict_serial(product_db.find_one({"product_name": item.product_name}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Product not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
# ----------------------------------------- Inventory Update ----------------------------------------------
@put_router.put("/update_inventory/{item_id}")
def update_inventory(item: EditInventoryItem, item_id: str, token: str = Depends(oauth_scheme)):
    old_item = inventory_db.find_one({"item_id": item_id})

    if old_item:
        if item.quantity > 0 and item.quantity >= item.critical_level:
            new_status = 'In Stock'
        elif item.quantity > 0 and item.quantity < item.critical_level:
            new_status = 'Low Stock'
        else:
            new_status = 'Out of Stock'

        if item.quantity < 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Quantity cannot be negative",
                headers={"WWW-Authenticate": "Bearer"},
            )

        updated_item = InventoryItem(
            item_id = item_id,
            item_name = item.item_name,
            category = item.category,
            quantity = item.quantity,
            unit_price = item.unit_price,
            total_price = item.unit_price * item.quantity,
            critical_level = item.critical_level,
            status = new_status,
        )

        inventory_db.update_one({"item_id": item_id}, {"$set": dict(updated_item)})
        return inventory_dict_serial(inventory_db.find_one({"item_id": item_id}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Inventory item not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

@put_router.put("/stock_in_inventory")
def stock_in_inventory(item: StockInOutInventoryItem, token: str = Depends(oauth_scheme)):
    old_item = inventory_db.find_one({"item_name": item.item_name})
    if old_item:
        new_quantity = old_item["quantity"] + item.quantity
        
        if new_quantity > 0 and new_quantity >= old_item["critical_level"]:
            new_status = 'In Stock'
        elif new_quantity > 0 and new_quantity < old_item["critical_level"]:
            new_status = 'Low Stock'
        else:
            new_status = 'Out of Stock'

        updated_item = InventoryItem(
            item_id = old_item["item_id"],
            item_name = item.item_name,
            category = old_item["category"],
            quantity = new_quantity,
            unit_price = old_item["unit_price"],
            total_price = old_item["unit_price"] * new_quantity,
            critical_level = old_item["critical_level"], 
            status = new_status,
        )

        inventory_db.update_one({"item_name": item.item_name}, {"$set": dict(updated_item)})
        return inventory_dict_serial(inventory_db.find_one({"item_name": item.item_name}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Inventory item not found",
            headers={"WWW-Authenticate": "Bearer"},
        )

@put_router.put("/stock_out_inventory")
def stock_out_inventory(item: StockInOutInventoryItem, token: str = Depends(oauth_scheme)):
    old_item = inventory_db.find_one({"item_name": item.item_name})
    if old_item:
        new_quantity = old_item["quantity"] - item.quantity
        if new_quantity < 0:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Quantity cannot be negative",
                headers={"WWW-Authenticate": "Bearer"},
            )

        if new_quantity > 0 and new_quantity >= old_item["critical_level"]:
            new_status = 'In Stock'
        elif new_quantity > 0 and new_quantity < old_item["critical_level"]:
            new_status = 'Low Stock'
        else:
            new_status = 'Out of Stock'
        
        updated_item = InventoryItem(
            item_id = old_item["item_id"],
            item_name = old_item["item_name"],
            category = old_item["category"],
            quantity = new_quantity,
            unit_price = old_item["unit_price"],
            total_price = old_item["unit_price"] * new_quantity,
            status = new_status,
        )

        inventory_db.update_one({"item_name": item.item_name}, {"$set": dict(updated_item)})
        return inventory_dict_serial(inventory_db.find_one({"item_name": item.item_name}))
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Inventory item not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
