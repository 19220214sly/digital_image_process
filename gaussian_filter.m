function output_img = gaussian_filter(input_img)
    % GAUSSIAN_FILTER 对彩色或灰度图像进行5x5高斯滤波
    % 输入:
    %   input_img: 待处理的图像（灰度或彩色）
    %   sigma: 高斯模板的标准差
    % 输出:
    %   output_img: 高斯滤波后的图像

    % 参数初始化
    sigma=1;
    N_size = 5; % 高斯模板大小为5x5
    center_N = (N_size + 1) / 2; % 模板中心
    [x, y] = meshgrid(1:N_size, 1:N_size); % 创建网格

    % 计算高斯模板
    G_ry = exp(-((x - center_N).^2 + (y - center_N).^2) / (2 * sigma^2));
    G_ry = G_ry / sum(G_ry(:)); % 归一化

    % 判断输入图像的维度
    if size(input_img, 3) == 3
        % 彩色图像
        output_img = zeros(size(input_img), 'like', input_img); % 初始化输出图像
        for c = 1:3 % 分别处理 R、G、B 通道
            output_img(:, :, c) = imfilter(double(input_img(:, :, c)), G_ry, 'same', 'replicate');
        end
    else
        % 灰度图像
        output_img = imfilter(double(input_img), G_ry, 'same', 'replicate');
    end

    % 转换为 uint8 类型
    output_img = uint8(output_img);
end
