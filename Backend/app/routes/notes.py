from fastapi import APIRouter, Depends, HTTPException, status
from config.database import *
from models.supplier_model import NotesInfo
from models import *
from schema.schemas import *
from fastapi.security import OAuth2PasswordBearer

note_router = APIRouter()
oauth_scheme = OAuth2PasswordBearer(tokenUrl="token")

@note_router.get("/get_supplier_note")
def get_supplier_note(id: str):
    exist_note = suppliers_db.find_one({"supplier_id": id})
    if exist_note:
        return exist_note["notes"]
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Note with id {id} not found",
        )

@note_router.get("/get_customer_note")
def get_customer_note(id: str):
    exist_note = customers_db.find_one({"customer_id": id})
    if exist_note:
        return exist_note["notes"]
    else:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Note with id {id} not found",
        )


@note_router.put("/update_note/{id}")
def update_note(note: NotesInfo, id: str):
    supType = suppliers_db.find_one({"supplier_id": id})
    if supType:
        suppliers_db.update_one({"supplier_id": id}, {"$set": {"notes": dict(note)}})
        return {"Message": f"Successfully updated supplier with id {id}."}

    cusType = customers_db.find_one({"customer_id": id})
    if cusType:
        customers_db.update_one({"customer_id": id}, {"$set": {"notes": dict(note)}})
        return {"Message": f"Successfully updated customer with id {id}."}

    raise (HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
         detail=f"Note with id {id} not found")
        )

@note_router.delete("/delete_note/{id}")
def delete_note(id: str):
    supType = suppliers_db.find_one({"supplier_id": id})
    if supType:
        suppliers_db.update_one({"supplier_id": id}, {"$set": {"notes": None}})
        return {"Message": f"Successfully deleted supplier with id {id}."}
    
    cusType = customers_db.find_one({"customer_id": id})
    if cusType:
        customers_db.update_one({"customer_id": id}, {"$set": {"notes": None}})
        return {"Message": f"Successfully deleted customer with id {id}."}
    
    raise (HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
         detail=f"Note with id {id} not found")
        )