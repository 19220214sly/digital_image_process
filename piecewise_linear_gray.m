function output_img = piecewise_linear_gray(input_img)
    % 输入参数：
    % input_img: 输入图像，可以是灰度图像
    % a=30, b=100, c=75, d=200  设定的四个阈值，范围是0-255
    
    % 确保输入图像是灰度图像
    if size(input_img, 3) == 3
        input_img = rgb2gray(input_img);  % 如果是彩色图像，转换为灰度图像
    end

    % 参数设定，范围应在0-255之间
    a = 30;  % 对应原图中的灰度值
    b = 100;
    c = 75;
    d = 200;

    % 将输入图像转化为 double 类型以便处理
    input_img = double(input_img);

    % 获取图像的大小
    [rows, cols] = size(input_img);

    % 初始化输出图像
    output_img = zeros(rows, cols);

    % 遍历图像中的每个像素，应用三段线性变换
    for i = 1:rows
        for j = 1:cols
            pixel_value = input_img(i, j);

            if pixel_value < a
                % 第一段：线性变换公式：s = (c/a) * r
                output_img(i, j) = (c / a) * pixel_value;
            elseif pixel_value >= a && pixel_value < b
                % 第二段：线性变换公式：s = ((d - c)/(b - a)) * (r - a) + c
                output_img(i, j) = ((d - c) / (b - a)) * (pixel_value - a) + c;
            else
                % 第三段：线性变换公式：s = ((255 - d)/(255 - b)) * (r - b) + d
                output_img(i, j) = ((255 - d) / (255 - b)) * (pixel_value - b) + d;
            end
        end
    end

    % 限制输出图像像素值的范围，确保在0到255之间
    output_img = uint8(min(max(output_img, 0), 255));
end
