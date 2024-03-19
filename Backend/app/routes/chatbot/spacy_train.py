# import random
# import spacy
# from spacy.training.example import Example

# # Load a pre-trained spaCy model
# nlp = spacy.load("en_core_web_sm")

# # Add your custom labels to the existing NER component
# labels = ["CUSTOM_LABEL_1", "CUSTOM_LABEL_2", ...]
# ner = nlp.get_pipe("ner")
# for label in labels:
#     ner.add_label(label)

# # Prepare your annotated training data
# train_data = [
#     ("Your annotated text here", {"entities": [(start, end, "CUSTOM_LABEL_1"), ...]}),
#     # Add more annotated examples
# ]

# # Fine-tune the NER model
# optimizer = nlp.resume_training()
# for iteration in range(100):  # Adjust the number of iterations
#     random.shuffle(train_data)
#     for text, annotations in train_data:
#         doc = nlp.make_doc(text)
#         example = Example.from_dict(doc, annotations)
#         nlp.update([example], sgd=optimizer)

# # Save the updated model
# nlp.to_disk("updated_ner_model")
