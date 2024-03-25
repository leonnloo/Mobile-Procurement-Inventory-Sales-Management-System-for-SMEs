from spacy_llm.util import assemble
import torch
import argparse
cuda_available = torch.cuda.is_available()

if cuda_available:
    new_cuda = torch.cuda.device_count()
    print(f'Cuda is available with quantity: {new_cuda}')
else:
    print('Cuda is not available. Running on CPU')
    
torch.cuda.empty_cache()
print('hey')
nlp = assemble("routes/chatbot/config.cfg")
print('hey')
doc = nlp("Jack and Jill rode up the hill in Les Deux Alpes")
print('hey')
print([(ent.text, ent.label_) for ent in doc.ents])




# D:\NOTTINGHAM STUDIES\CSAI Y2 CHINA\SOFTWARE ENGINEERING\GRP\GIT\Mobile-Procurement-Inventory-Sales-Management-System-for-SMEs\Backend\venv\Lib\site-packages\huggingface_hub\file_download.py:149: UserWarning: `huggingface_hub` cache-system uses symlinks by default to efficiently store duplicated files but your machine does not support them in C:\Users\looya\.cache\huggingface\hub\models--databricks--dolly-v2-12b. Caching files will still work but in a degraded version that might require more space on your disk. This warning can be disabled by setting the `HF_HUB_DISABLE_SYMLINKS_WARNING` environment variable. For more details, see https://huggingface.co/docs/huggingface_hub/how-to-cache#limitations.
# To support symlinks on Windows, you either need to activate Developer Mode or to run Python as an administrator. In order to see activate developer mode, see this article: https://docs.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development
#   warnings.warn(message)