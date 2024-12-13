function new_img = rotate_image(f, theta)
    % 函数功能: 使用双线性插值法对图像进行逆时针旋转
    % 输入参数:
    %   f      - 输入图像
    %   theta  - 旋转角度（弧度制）
    % 输出:
    %   new_img - 旋转后的图像
    
    % 获取原图像的大小
    [h, w, c] = size(f);
    
    % 步骤一：先确定旋转后的图像大小
    x = [0 w-1 w-1 0];
    y = [0 0 h-1 h-1];
    x_new = x*cos(theta) + y*sin(theta);
    y_new = -x*sin(theta) + y*cos(theta);
    
    % 找新图像的大小
    minx = min(x_new);
    miny = min(y_new);
    maxx = max(x_new);
    maxy = max(y_new);
    H = ceil(maxy - miny + 1);
    W = ceil(maxx - minx + 1);
    
    % 初始化新图像
    new_img = zeros(H, W, c);
    
    % 对每个通道分别进行处理
    for ch = 1:c
        for newx = 1:W
            for newy = 1:H
                % 平移变换
                x_temp = newx - 1 + minx;
                y_temp = newy - 1 + miny;
                
                % 反变换
                oldx = x_temp*cos(theta) - y_temp*sin(theta);
                oldy = x_temp*sin(theta) + y_temp*cos(theta);
                
                % 判断是否在原图像范围内
                if oldx < 0 || oldy < 0 || oldx >= w || oldy >= h
                    new_img(newy, newx, ch) = 0;
                else
                    x = floor(oldx) + 1;
                    y = floor(oldy) + 1;
                    a = oldx - floor(oldx);
                    b = oldy - floor(oldy);
                    
                    % 双线性插值
                    if x < w && y < h
                        f11 = f(y, x, ch);        % 左上角
                        f12 = f(y + 1, x, ch);    % 左下角
                        f21 = f(y, x + 1, ch);    % 右上角
                        f22 = f(y + 1, x + 1, ch);% 右下角
                        new_img(newy, newx, ch) = (1 - a) * (1 - b) * f11 + ...
                                                  a * (1 - b) * f21 + ...
                                                  (1 - a) * b * f12 + ...
                                                  a * b * f22;
                    elseif x >= w && y < h
                        new_img(newy, newx, ch) = f(y, w, ch) + b * (f(y + 1, w, ch) - f(y, w, ch));
                    elseif x < w && y >= h
                        new_img(newy, newx, ch) = f(h, x, ch) + a * (f(h, x + 1, ch) - f(h, x, ch));
                    else
                        new_img(newy, newx, ch) = f(h, w, ch);
                    end
                end
            end
        end
    end
    % 将结果转换为uint8格式
    new_img = uint8(new_img);
end
