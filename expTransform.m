function output = expTransform(inputImage)
    % 幂指数变换函数
    % inputImage: 输入图像（灰度图或单通道图像）
    
    % 如果是彩色图像，转换为灰度图像
    if size(inputImage, 3) == 3
        inputImage = rgb2gray(inputImage);  % 将RGB图像转换为灰度图像
    end
    
    % 转换为双精度浮点数
    inputImage = double(inputImage);

    % 幂指数变换公式：output = exp(c * (inputImage - a)) + 1
    output = exp(0.325 * (inputImage - 225) / 30) + 1;
    
    % 归一化到 [0, 1] 范围
    output = mat2gray(output);  % 将输出规范化到 [0, 1] 范围
    
    % 映射到 [0, 255] 并转换为 uint8 类型
    output = uint8(output * 255);  % 映射并转换为 uint8
end
