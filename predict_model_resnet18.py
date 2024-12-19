import torch
import torchvision
from torchvision import datasets, transforms
from torch import nn
from PIL import Image


def get_classes(data_dir):
    # 返回图像数据和对应标签的数据对象
    all_data = datasets.ImageFolder(data_dir)
    return all_data.classes

def MyModel(classes):
    model = torchvision.models.resnet18(pretrained=False)
    n_inputs = model.fc.in_features
    model.fc = nn.Sequential(
        nn.Linear(n_inputs, 1024),  # Increase the size of the first fully connected layer
        nn.SiLU(),
        nn.Dropout(0.3),
        nn.Linear(1024, 2048),  # Add another fully connected layer
        nn.SiLU(),
        nn.Dropout(0.3),
        nn.Linear(2048, 2048),  # Add another fully connected layer
        nn.SiLU(),
        nn.Dropout(0.3),
        nn.Linear(2048, len(classes))  # Adjust the output size to match the number of classes
    )
    return model

def apply_test_transforms():
    # 使用 Compose 统一处理
    return transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

def predict_with_checkpoint(checkpoint_path, image_path, device='cuda'):
    # 获取类
    dataset_path = "C:/Users/sun/CUB_200_2011/images"
    classes = get_classes(dataset_path)
    
    # 加载模型和检查点
    checkpoint = torch.load(checkpoint_path, map_location=device)
    model = MyModel(classes)
    model.load_state_dict(checkpoint['model_state_dict'])  # 加载模型权重
    model.to(device)
    model.eval()  # 设置为评估模式

    # 图像预处理
    transform = apply_test_transforms()
    im = Image.open(image_path)
    image_tensor = transform(im).to(device)

    # 推理
    with torch.no_grad():
        minibatch = torch.stack([image_tensor])
        outputs = model(minibatch)
        _, predicted_class = torch.max(outputs, 1)  # 获取预测类别索引
    
    # 返回类别名称
    return classes[predicted_class.item()]
