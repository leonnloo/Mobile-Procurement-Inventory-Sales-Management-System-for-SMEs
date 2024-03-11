# ---------------------------------------- User ----------------------------------------
def user_dict_serial(user) -> dict:
    return {
        # "Object id": str(user["_id"]),
        "employee_name": user["employee_name"],
        "employee_id": user["employee_id"],
        "email": user["email"],
        "phone_number": user["phone_number"],
        "password": user["password"],
        "role": user["role"],
        "sales_record": user["sales_record"],
    }

def user_serial(users) -> list:
    return [user_dict_serial(user) for user in users]
 
# ---------------------------------------- Supplier ----------------------------------------
def supplier_dict_serial(supplier) -> dict:
    return {
        "supplier_id": supplier["supplier_id"],
        "business_name": supplier["business_name"],
        "contact_person": supplier["contact_person"],
        "email": supplier["email"],
        "phone_number": supplier["phone_number"],
        "address": supplier["address"],
        "past_order": supplier["past_order"],
        "notes": supplier["notes"]
    }

def supplier_serial(suppliers) -> list:
    return [supplier_dict_serial(supplier) for supplier in suppliers]

def supplier_dict_name(supplier) -> str:
    if isinstance(supplier, dict):
        return supplier.get("business_name", "")
    return str(supplier)

def supplier_name_serial(suppliers) -> list:
    return [supplier_dict_name(supplier) for supplier in suppliers]


# ---------------------------------------- Customer ----------------------------------------
def customer_dict_serial(customer) -> dict:
    return {
        "customer_id": customer["customer_id"],
        "business_name": customer["business_name"],
        "contact_person": customer["contact_person"],
        "email": customer["email"],
        "phone_number": customer["phone_number"],
        "billing_address": customer["billing_address"],
        "shipping_address": customer["shipping_address"],
        "past_order": customer["past_order"],
        "notes": customer["notes"]
    }

def customer_serial(customers) -> list:
    return [customer_dict_serial(customer) for customer in customers]

def customer_dict_name(customer) -> str:
    if isinstance(customer, dict):
        return customer.get("business_name", "")
    return str(customer)

def customer_name_serial(customers) -> list:
    return [customer_dict_name(customer) for customer in customers]

# ---------------------------------------- Product ----------------------------------------
def product_dict_serial(product) -> dict:
    return {
        "product_id": product["product_id"],
        "product_name": product["product_name"],
        "unit_price": product["unit_price"],
        "selling_price": product["selling_price"],
        "quantity": product["quantity"],
        "markup": product["markup"],
        "margin": product["margin"],
        "status": product["status"]
    } 

def product_serial(products) -> list:
    return [product_dict_serial(product) for product in products]

def product_dict_name(product) -> str:
    if isinstance(product, dict):
        return product.get("product_name", "")
    return str(product)

def product_name_serial(products) -> list:
    return [supplier_dict_name(product) for product in products]

# ---------------------------------------- Procurement ----------------------------------------
def procurement_dict_serial(purchase) -> dict:
    return {
        "purchase_no": purchase["purchase_no"],
        "item_name": purchase["item_name"],
        "supplier_name": purchase["supplier_name"],
        "order_date": purchase["order_date"],
        "delivery_date": purchase["delivery_date"],
        "unit_price": purchase["unit_price"],
        "total_price": purchase["total_price"],
        "quantity": purchase["quantity"],
        "status": purchase["status"]
    }

def procurement_serial(purchases) -> list:
    return [procurement_dict_serial(purchase) for purchase in purchases]


# ---------------------------------------- Inventory ----------------------------------------
def inventory_dict_serial(inventory) -> dict:
    return {
        "item_id": str(inventory["item_id"]),
        "item_name": inventory["item_name"],
        "category": inventory["category"],
        "quantity": inventory["quantity"],
        "unit_price": inventory["unit_price"],
        "total_price": inventory["total_price"],
        "status": inventory["status"]
    }

def inventory_serial(inventories) -> list:
    return [inventory_dict_serial(inventory) for inventory in inventories]

def inventory_dict_name(item) -> str:
    if isinstance(item, dict):
        return item.get("item_name", "")
    return str(item)

def inventory_name_serial(items) -> list:
    return [inventory_dict_name(item) for item in items]

# ---------------------------------------- Sales Order ----------------------------------------
def sale_order_dict_serial(sale_order) -> dict:
    return {
        "order_id": sale_order["order_id"],
        "order_date": sale_order["order_date"],
        "customer_id": sale_order["customer_id"],
        "customer_name": sale_order["customer_name"],
        "product_id": sale_order["product_id"],
        "product_name": sale_order["product_name"],
        "quantity": sale_order["quantity"],
        "unit_price": sale_order["unit_price"],
        "total_price": sale_order["total_price"],
        "status": sale_order["status"],
        "employee": sale_order["employee"],
        "employee_id": sale_order["employee_id"]
    }

def sale_order_serial(sale_orders) -> list:
    return [sale_order_dict_serial(sale_order) for sale_order in sale_orders]

# ---------------------------------------- Sales Management ----------------------------------------
def company_monthly_sales_dict_serial(sale) -> dict:
    return {
        "year": sale["year"],
        "month": sale["month"],
        "sales": sale["sales"]
    }

def company_monthly_sales_serial(sales) -> list:
    return [company_monthly_sales_dict_serial(sale) for sale in sales]


# ---------------------------------------- Notes ----------------------------------------
def note_dict_serial(note) -> dict:
    return {
        "note_id": str(note["note_id"]),
        "date": note["date"],
        "memo": note["memo"]
    }