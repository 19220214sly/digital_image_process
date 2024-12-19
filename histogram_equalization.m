function [NewImage] = histogram_equalization(input_img)
    
    % 读取图像并转换为灰度图像
    if size(input_img, 3) == 3
        Image = rgb2gray(input_img);  % 将彩色图像转换为灰度图像
    else
        Image = input_img;  % 如果已经是灰度图像，直接使用
    end
    
    % 计算原始灰度图像的直方图
    histgram = imhist(Image);  % 统计图像直方图
    [h, w] = size(Image);
    
    % 初始化均衡化后的图像矩阵
    NewImage = zeros(h, w);
    
    % 计算累积直方图
    s = zeros(256, 1);
    s(1) = histgram(1);
    for t = 2:256
        s(t) = s(t-1) + histgram(t);  % 计算新的灰度值
    end
    
    % 生成均衡化后的图像
    for x = 1:w
        for y = 1:h
            NewImage(y, x) = s(Image(y, x) + 1) / (w * h);  % 生成新图像
        end
    end
    
    % 返回处理后的图像
end
