function transformed_image = linear_gray_transform(image, alpha)
    % 检查输入图像是否是彩色图像，如果是，则转换为灰度图像
    if size(image, 3) == 3
        image = rgb2gray(image);  % 使用 rgb2gray 转换彩色图像为灰度图像
    end

    % 将图像转换为 double 类型，以便进行数值计算
    image = double(image);

    % 计算 tan(alpha)，需要将角度转换为弧度
    alpha_rad = deg2rad(alpha);  % 将角度转换为弧度
    
    tan_alpha = tan(alpha_rad);  % 计算 tan(alpha)，它是一个标量

    % 应用线性灰度级变换，按元素乘以 tan_alpha
    transformed_image = image .* tan_alpha;  % 按元素相乘

    % 对变换后的图像进行裁剪，确保像素值在 0 到 255 之间
    transformed_image = uint8(max(min(transformed_image, 255), 0));  % 裁剪并转换回 uint8 类型
end
