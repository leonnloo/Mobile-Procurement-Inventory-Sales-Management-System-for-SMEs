from fastapi import APIRouter, Depends, HTTPException, status
from models.customer_model import *
from models.sales_order_model import *
from models.supplier_model import *
from models.procurement_model import *
from models.product_model import *
from models.inventory_model import *
from config.database import *
from fastapi.security import OAuth2PasswordBearer

form_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")


def processNextID(query: str) -> str:
    # Extract integers from the string
    extracted_numbers = ''.join(char for char in query if char.isdigit())

    # Convert the extracted numbers to an integer
    result = int(extracted_numbers) if extracted_numbers else None
    if result:
        result += 1
        # Extract the first two characters from the original query
        first_two_characters = query[:2]
        # Append them to the result
        result_with_prefix = f"{first_two_characters}{result}"
        return result_with_prefix
    else:
        return None

# ----------------------------------------- Customer Form ----------------------------------------------
@form_router.post("/customer_form")
def customer_form(customer: NewCustomer, token: str = Depends(oauth_scheme)):
    existing_customer = customers_db.find_one({"business_name": customer.business_name})
    if existing_customer:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Customer business registered",
    )

    # Find the document with the largest customer_id
    latest_id_document = customers_db.find_one(sort=[("customer_id", -1)])

    # Determine the next customer_id
    if latest_id_document:
        query_id = latest_id_document.get("customer_id", "-1")
        next_customer_id = processNextID(query_id)
    else:
        next_customer_id = "CO1"


    updated_customer = CustomerInfo(
        customer_id = next_customer_id,
        business_name = customer.business_name,
        contact_person = customer.contact_person,
        email = customer.email,
        phone_number = customer.phone_number,
        billing_address = customer.billing_address,
        shipping_address = customer.shipping_address,
        past_order = None,
        notes = None,
    )

    customers_db.insert_one(dict(updated_customer))
    return {"Message": "Customer successfully registered"}

# ----------------------------------------- Supplier Form ----------------------------------------------
@form_router.post("/supplier_form")
def supplier_form(supplier: NewSupplier, token: str = Depends(oauth_scheme)):
    existing_supplier = suppliers_db.find_one({"business_name": supplier.business_name})
    if existing_supplier:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Supplier business registered",
    )

    # Find the document with the largest supplier_id
    latest_id_document = suppliers_db.find_one(sort=[("supplier_id", -1)])

    # Determine the next supplier_id
    if latest_id_document:
        query_id = latest_id_document.get("supplier_id", "-1")
        next_supplier_id = processNextID(query_id)
    else:
        next_supplier_id = "SP1"

    updated_supplier = SupplierInfo(
        supplier_id = next_supplier_id,
        business_name = supplier.business_name,
        contact_person = supplier.contact_person,
        email = supplier.email,
        phone_number = supplier.phone_number,
        address = supplier.address,
        notes = None,
    )

    suppliers_db.insert_one(dict(updated_supplier))
    return {"Message": "Supplier successfully registered"}

# ! Update monthly sales when inputting a new order
# ----------------------------------------- Sales Form ----------------------------------------- 
@form_router.post("/sales_order_form")
def sales_order_form(order: NewSaleOrder, token: str = Depends(oauth_scheme)):
    product = product_db.find_one({"product_id": order.product_id})
    left_product = product["quantity"] - order.quantity
    if (left_product >= 0):
        latest_id_document = sales_order_db.find_one(sort=[("order_id", -1)])
        
        if latest_id_document:
            query_id = latest_id_document.get("order_id", "-1")
            next_order_id = processNextID(query_id)
        else:
            next_order_id = "SO1"

        updated_order = SaleOrder(
            order_id = next_order_id,
            order_date = order.order_date,
            customer_id = order.customer_id,
            customer_name = order.customer_name,
            product_id = order.product_id,
            product_name = order.product_name,
            quantity = order.quantity,
            unit_price = order.unit_price,
            total_price = order.total_price,
            status = order.status,
            employee = order.employee,
            employee_id = order.employee_id
        )
        
        product['quantity'] = left_product
        if product['quantity'] > 0 and product['quantity'] >= product['critical_level']:
            new_status = 'In Stock'
        elif product['quantity'] > 0 and product['quantity'] < product['critical_level']:
            new_status = 'Low Stock'
        else:
            new_status = 'Out of Stock'
        product['status'] = new_status
        product_db.update_one({"product_id": order.product_id}, {"$set": product})
        
        sales_order_db.insert_one(dict(updated_order))
        return {"Message": "Sales order successfully registered"}
    else:
        raise HTTPException(
        status_code = status.HTTP_403_FORBIDDEN,
        detail = "Product ran out of stock",
        )

# ----------------------------------------- Procurement Form ----------------------------------------------
@form_router.post("/procurement_form")
def procurement_form(procurement: NewProcurement, token: str = Depends(oauth_scheme)):
    latest_id_document = procurement_db.find_one(sort=[("purchase_id", -1)])

    if latest_id_document:
        query_id = latest_id_document.get("purchase_id", "-1")
        next_purchase_id = processNextID(query_id)
    else:
        next_purchase_id = "PR1"

    if procurement.status == "Completed":
        if procurement.item_type == "Product":
            product = product_db.find_one({"product_id": procurement.item_id})
            left_product = product["quantity"] - procurement.quantity
            if left_product >= 0:
                product['quantity'] = left_product
                if product['quantity'] > 0 and product['quantity'] >= product['critical_level']:
                    new_status = 'In Stock'
                elif product['quantity'] > 0 and product['quantity'] < product['critical_level']:
                    new_status = 'Low Stock'
                else:
                    new_status = 'Out of Stock'
                
                product['status'] = new_status
                product_db.update_one({"product_id": procurement.item_id}, {"$set": product})
            else:
                raise HTTPException(
                status_code = status.HTTP_403_FORBIDDEN,
                detail = "Product ran out of stock",
                )
        elif procurement.item_type == "Inventory":
            item = inventory_db.find_one({"item_id": procurement.item_id})
            left_item = item["quantity"] - procurement.quantity
            if left_item >= 0:
                item['quantity'] = left_item
                if item['quantity'] > 0 and item['quantity'] >= item['critical_level']:
                    new_status = 'In Stock'
                elif item['quantity'] > 0 and item['quantity'] < item['critical_level']:
                    new_status = 'Low Stock'
                else:
                    new_status = 'Out of Stock'
                
                item['status'] = new_status
                inventory_db.update_one({"item_id": procurement.item_id}, {"$set": item})
            else:
                raise HTTPException(
                status_code = status.HTTP_403_FORBIDDEN,
                detail = "Inventory item ran out of stock",
                )



    updated_procurement = Procurement(
        purchase_id = next_purchase_id,
        item_type = procurement.item_type,
        item_id = procurement.item_id,
        item_name = procurement.item_name,
        supplier_name = procurement.supplier_name,
        order_date = procurement.order_date,
        delivery_date = procurement.delivery_date,
        unit_price = procurement.unit_price,
        total_price = procurement.total_price,
        quantity = procurement.quantity,
        status = procurement.status,
    )

    procurement_db.insert_one(dict(updated_procurement))
    return {"Message": "Procurement successfully registered"}

# ----------------------------------------- Product Form ----------------------------------------------
@form_router.post("/product_form")
def product_form(product: NewProduct, token: str = Depends(oauth_scheme)):
    if product_db.find_one({"product_name": product.product_name}):
        raise HTTPException(
            status_code = status.HTTP_403_FORBIDDEN,
            detail = "Product name already registered",
        )

    latest_id_document = product_db.find_one(sort=[("product_id", -1)])

    if latest_id_document:
        query_id = latest_id_document.get("product_id", "-1")
        next_product_id = processNextID(query_id)
    else:           
        next_product_id = "PD1"

    updated_product = ProductItem(
        product_id = next_product_id,
        product_name = product.product_name,
        unit_price = product.unit_price,
        selling_price = product.selling_price,
        markup = product.markup,
        margin = product.margin,
        quantity = 0,
        critical_level = product.critical_level,
        status = "Out of Stock",
    )

    product_db.insert_one(dict(updated_product))
    return {"Message": "Product successfully registered"}

# ----------------------------------------- Inventory Form ----------------------------------------------
@form_router.post("/inventory_form")
def inventory_form(inventory: NewInventoryItem, token: str = Depends(oauth_scheme)):
    if inventory_db.find_one({"item_name": inventory.item_name}):
        raise HTTPException(
            status_code = status.HTTP_403_FORBIDDEN,
            detail = "Inventory name already registered",
        )

    latest_id_document = inventory_db.find_one(sort=[("item_id", -1)])

    if latest_id_document:
        query_id = latest_id_document.get("item_id", "-1")
        next_inventory_id = processNextID(query_id)
    else:
        next_inventory_id = "IV1"

    updated_inventory = InventoryItem(
        item_id = next_inventory_id,
        item_name = inventory.item_name,
        category = inventory.category,
        quantity = 0,
        unit_price = inventory.unit_price,
        total_price = 0,
        critical_level = inventory.critical_level,
        status = "Out of Stock",
    )

    inventory_db.insert_one(dict(updated_inventory))
    return {"Message": "Inventory successfully registered"}