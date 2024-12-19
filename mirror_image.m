function new_img = mirror_image(f, mode)
    % 函数功能: 对图像进行镜像变换
    % 输入参数:
    %   f    - 输入图像
    %   mode - 选择镜像模式, 'horizontal' 水平镜像，'vertical' 垂直镜像, 'diagonal' 对角镜像
    % 输出:
    %   new_img - 变换后的图像

    [h, w, c] = size(f);  % 获取原图像大小

    % 初始化新图像
    new_img = zeros(h, w, c);

    switch mode
        case 'horizontal'
            % 水平镜像（沿着垂直轴翻转）
            for y = 1:h
                for x = 1:w
                    new_img(y, x, :) = f(y, w - x + 1, :);
                end
            end
            
        case 'vertical'
            % 垂直镜像（沿着水平轴翻转）
            for y = 1:h
                for x = 1:w
                    new_img(y, x, :) = f(h - y + 1, x, :);
                end
            end
            
        case 'diagonal'
            % 对角镜像（沿着对角线翻转）
            % 假设输入是方阵，若不是，则以左上角矩阵为主
            for y = 1:min(h, w)
                for x = 1:min(h, w)
                    new_img(x, y, :) = f(y, x, :);  % 交换行列位置
                end
            end
            
        otherwise
            error('未知的镜像模式. 请选择 horizontal, vertical 或 diagonal.');
    end

    % 将新图像转换为uint8类型
    new_img = uint8(new_img);
end
