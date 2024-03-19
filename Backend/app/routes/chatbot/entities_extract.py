import spacy

# Load the English language model
nlp = spacy.load("en_core_web_sm")

def extract_entities(text):
    # Process the text with spaCy
    doc = nlp(text)
    entities = {}
    for ent in doc.ents:
        if ent.label_ == "PERSON":  # Extract person names
            entities["name"] = ent.text
        # elif ent.label_ == "ID":
        #     entities["ID"] = ent.text
        elif ent.label_ == "EMAIL":  # Extract email addresses
            entities["email"] = ent.text
        elif ent.label_ == "ORG":  # Extract organization or company names
            entities["business_name"] = ent.text
        elif ent.label_ == "PHONE":  # Extract phone numbers
            entities["phone_number"] = ent.text
        elif ent.label_ == "DATE":  # Extract dates
            entities["date"] = ent.text
        elif ent.label_ == "MONEY":  # Extract monetary values
            entities["money"] = ent.text
        elif ent.label_ == "INVENTORY":  
            entities["product"] = ent.text
        elif ent.label_ == "PRODUCT":  # Extract product names
            entities["product"] = ent.text
        # elif ent.label_ == "ADDRESS":  # Extract product names
        #     entities["product"] = ent.text
        # elif ent.label_ == "CRITICAL_LEVEL":  
        #     entities["product"] = ent.text
            
    return entities