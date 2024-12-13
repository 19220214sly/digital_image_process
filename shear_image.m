function new_img = shear_image(f, shear_factor_xy, shear_factor_yx)
    % 函数功能: 对图像同时进行水平和垂直方向的错切变换
    % 输入参数:
    %   f               - 输入图像
    %   shear_factor_xy - 水平方向错切因子
    %   shear_factor_yx - 垂直方向错切因子
    % 输出:
    %   new_img         - 变换后的图像

    % 获取原图像的大小
    [h, w, c] = size(f);

    % 水平和垂直方向的错切变换矩阵
    T = [1 shear_factor_xy; shear_factor_yx 1];

    % 计算变换后图像的范围
    corners = [1, 1, w, w; 1, h, 1, h];  % 原图像四个角的坐标
    new_corners = T * corners;           % 变换后的四个角坐标

    minx = min(new_corners(1, :));
    maxx = max(new_corners(1, :));
    miny = min(new_corners(2, :));
    maxy = max(new_corners(2, :));

    % 计算新图像的大小
    new_w = ceil(maxx - minx);
    new_h = ceil(maxy - miny);

    % 初始化新图像
    new_img = zeros(new_h, new_w, c);

    % 对每个通道分别处理
    for ch = 1:c
        for newx = 1:new_w
            for newy = 1:new_h
                % 反向变换到原图坐标
                pos = inv(T) * [(newx + minx - 1); (newy + miny - 1)];
                oldx = pos(1);
                oldy = pos(2);

                % 判断是否在原图像范围内
                if oldx >= 1 && oldx <= w && oldy >= 1 && oldy <= h
                    % 双线性插值
                    x1 = floor(oldx);
                    x2 = ceil(oldx);
                    y1 = floor(oldy);
                    y2 = ceil(oldy);

                    % 计算插值权重
                    a = oldx - x1;
                    b = oldy - y1;

                    % 获取邻近像素的值
                    if x1 < 1, x1 = 1; end
                    if y1 < 1, y1 = 1; end
                    if x2 > w, x2 = w; end
                    if y2 > h, y2 = h; end

                    f11 = double(f(y1, x1, ch));  % 左上角
                    f12 = double(f(y2, x1, ch));  % 左下角
                    f21 = double(f(y1, x2, ch));  % 右上角
                    f22 = double(f(y2, x2, ch));  % 右下角

                    % 插值计算
                    new_img(newy, newx, ch) = (1 - a) * (1 - b) * f11 + ...
                                              a * (1 - b) * f21 + ...
                                              (1 - a) * b * f12 + ...
                                              a * b * f22;
                else
                    % 超出原图范围设为背景色0
                    new_img(newy, newx, ch) = 0;
                end
            end
        end
    end

    % 将结果转换为uint8格式
    new_img = uint8(new_img);
end
