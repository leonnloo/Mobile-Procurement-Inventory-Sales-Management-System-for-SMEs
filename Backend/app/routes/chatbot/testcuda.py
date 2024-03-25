import torch

cuda_available = torch.cuda.is_available()

if cuda_available:
    new_cuda = torch.cuda.device_count()
    print(f'Cuda is available with quantity: {new_cuda}')
else:
    print('Cuda is not available. Running on CPU')