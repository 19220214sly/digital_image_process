function edgeI = edgeDetection(Image, operator)
    % 输入：Image - 彩色图像 (double 类型)
    %        operator - 边缘检测算子名称 (字符串, 'sobel', 'prewitt', 'robert', 'laplacian')
    % 输出：edgeI - 彩色图像的边缘检测结果

    threshold=0.4;
    Image=im2double(Image);
    % 获取图像的大小
    [rows, cols, channels] = size(Image);
    
    % 初始化边缘检测结果
    edgeI = zeros(rows, cols, channels); 

    % 根据输入的算子选择对应的滤波器
    switch operator
        case 'sobel'
            % Sobel 算子
            H1 = [-1 0 1; -2 0 2; -1 0 1]; % 水平方向
            H2 = [-1 -2 -1; 0 0 0; 1 2 1]; % 垂直方向

        case 'prewitt'
            % Prewitt 算子
            H1 = [-1 0 1; -1 0 1; -1 0 1]; % 水平方向
            H2 = [-1 -1 -1; 0 0 0; 1 1 1]; % 垂直方向

        case 'robert'
            % Robert 算子 (通常是 2x2 的小滤波器)
            H1 = [1 0; 0 -1]; % 水平方向
            H2 = [0 1; -1 0]; % 垂直方向

        case 'laplacian'
            % 拉普拉斯算子
            H1 = [0 1 0; 1 -4 1; 0 1 0]; % 拉普拉斯算子

        otherwise
            error('Unsupported operator. Choose from "sobel", "prewitt", "robert", or "laplacian".');
    end
    
    % 分别处理 RGB 三个通道
    for c = 1:channels
        % 提取当前通道
        channel = Image(:, :, c);
        
        % 计算梯度幅值
        if strcmp(operator, 'laplacian')
            % 对于拉普拉斯算子，只有一个方向
            R1 = imfilter(channel, H1); % 水平方向梯度
            gradI = abs(R1);
        else
            % 其他算子，使用欧几里得距离计算梯度幅值
            R1 = imfilter(channel, H1); % 水平方向梯度
            R2 = imfilter(channel, H2); % 垂直方向梯度
            gradI = abs(R1) + abs(R2);
        end
        
        % 阈值处理生成二值边缘
        edgeI(:, :, c) = gradI > threshold;
    end
end
