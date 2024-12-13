function new_img = bilinear_resize(f, kx, ky)
    % 函数功能: 使用双线性插值对图像进行缩放
    % 输入参数:
    %   f  - 输入图像 (可以是灰度图像或彩色图像)
    %   kx - 水平方向缩放因子
    %   ky - 垂直方向缩放因子
    % 输出:
    %   new_img - 缩放后的图像

    % 获取原图像的大小
    [h, w, c] = size(f);  % c为通道数（如果是灰度图，c=1）

    % 缩放后的图像大小
    new_h = ceil(h * ky);
    new_w = ceil(w * kx);

    % 初始化放大后的图像
    new_img = zeros(new_h, new_w, c);

    % 对每个颜色通道分别进行双线性插值操作
    for ch = 1:c
        for y_new = 1:new_h
            for x_new = 1:new_w
                % 计算在原图像中的位置
                x_orig = (x_new - 1) / kx;
                y_orig = (y_new - 1) / ky;

                % 如果该点在原图像范围内，则进行插值，否则设置为背景色0
                if x_orig >= 0 && x_orig < w && y_orig >= 0 && y_orig < h
                    % 找到原图像中的四个邻近像素的坐标
                    x = floor(x_orig) + 1;
                    y = floor(y_orig) + 1;

                    % 计算插值的权重
                    a = x_orig - (x - 1);  % 水平方向的权重
                    b = y_orig - (y - 1);  % 垂直方向的权重

                    % 如果在图像范围内，使用四个像素进行插值
                    if x < w && y < h
                        % 获取四个邻近像素的值
                        f11 = f(y, x, ch);         % 左上角
                        f12 = f(y + 1, x, ch);     % 左下角
                        f21 = f(y, x + 1, ch);     % 右上角
                        f22 = f(y + 1, x + 1, ch); % 右下角
                        % 计算插值后的像素值
                        new_img(y_new, x_new, ch) = (1 - a) * (1 - b) * f11 + ...
                                                   a * (1 - b) * f21 + ...
                                                   (1 - a) * b * f12 + ...
                                                   a * b * f22;
                    % 如果超出图像宽度范围，则在垂直方向进行插值
                    elseif x >= w && y < h
                        new_img(y_new, x_new, ch) = f(y, w, ch) + ...
                                                   b * (f(y + 1, w, ch) - f(y, w, ch));
                    % 如果超出图像高度范围，则在水平方向进行插值
                    elseif x < w && y >= h
                        new_img(y_new, x_new, ch) = f(h, x, ch) + ...
                                                   a * (f(h, x + 1, ch) - f(h, x, ch));
                    % 如果x和y都超出图像范围，则直接使用右下角的像素值
                    else
                        new_img(y_new, x_new, ch) = f(h, w, ch);
                    end
                else
                    % 超出原图像范围时，设置背景色
                    new_img(y_new, x_new, ch) = 0;
                end
            end
        end
    end

    % 将结果转换为8位图像
    new_img = uint8(new_img);
end
