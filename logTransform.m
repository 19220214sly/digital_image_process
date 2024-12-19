function output = logTransform(inputImage)
    % 对数变换函数
    % inputImage: 输入图像（灰度图或单通道图像）
    % c: 常数系数，用于调整输出图像的强度
    
    % 如果是彩色图像，转换为灰度图像
    if size(inputImage, 3) == 3
        inputImage = rgb2gray(inputImage);  % 将RGB图像转换为灰度图像
    end
    
    % 转换为双精度浮点数
    inputImage = double(inputImage);
   
    % 对数变换公式：output = c * log(1 + inputImage)
    output =  log(1 + inputImage);
    % 归一化到 [0, 1] 区间
    output = mat2gray(output);  % 将输出规范化到 [0, 1] 范围
    
    % 映射到 [0, 255] 并转换为 uint8 类型
    output = uint8(output * 255);
    
end
