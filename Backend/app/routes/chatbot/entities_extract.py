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
        elif ent.label_ == "EMAIL":  # Extract email addresses
            entities["email"] = ent.text
        # You can add more conditions to extract other types of entities like dates, phone numbers, etc.
    return entities