def individual_serial(user) -> dict:
    return {
        "id": str(user["_id"]),
        "name": user["user_name"],
        "email": user["email"],
        "password": user["password"],
        "role": user["role"]
    }

def list_serial(users) -> list:
    return [individual_serial(user) for user in users]