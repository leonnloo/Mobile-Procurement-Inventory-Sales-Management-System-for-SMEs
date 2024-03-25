import spacy

# Load the English language model
nlp = spacy.load("updated_ner_model")

def extract_entities(text):
    # Process the text with spaCy
    doc = nlp(text)
    entities = {}
    for ent in doc.ents:
        print(ent.label_)
        print(ent.text)
        if ent.label_ == "customID": 
            entities["customID"] = ent.text
        elif ent.label_ == "PERSON":  # Extract person names
            entities["contact_person"] = ent.text
        elif ent.label_ == "ORG" or ent.label == "BUSINESS-NAME":  # Extract organization or company names
            entities["business_name"] = ent.text
        elif ent.label_ == "EMAIL":  # Extract email addresses
            entities["email"] = ent.text
        elif ent.label_ == "PHONE-NUMBER":  # Extract phone numbers
            entities["phone_number"] = ent.text
        elif ent.label_ == "DATE":  # Extract dates
            entities["date"] = ent.text
        elif ent.label_ == "ITEM-QUANTITY":  
            entities["quantity"] = ent.text
        elif ent.label_ == "PRICE":  
            entities["price"] = ent.text
        elif ent.label_ == "STATUS":  
            entities["status"] = ent.text
        elif ent.label_ == "ADDRESS":
            entities["address"] = ent.text
        elif ent.label_ == "ITEM-NAME":  
            entities["item_name"] = ent.text
            
    return entities