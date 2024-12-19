function segmentedImage = regionGrowingSegmentation(inputImage, seedPoint, threshold)
    % 基于区域生长的图像分割
    % 输入参数:
    %   inputImage: 输入图像（灰度图像）
    %   seedPoint: 种子点坐标 [row, col]
    %   threshold: 灰度值阈值，用于控制生长条件
    % 输出:
    %   segmentedImage: 分割后的二值图像

    % 检查输入图像的维度，确保为灰度图像
    if size(inputImage, 3) == 3
        inputImage = rgb2gray(inputImage); % 将彩色图像转换为灰度图像
    end
    inputImage = double(inputImage); % 将图像转换为 double 类型

    % 检查种子点是否有效
    [rows, cols] = size(inputImage);
    if seedPoint(1) < 1 || seedPoint(1) > rows || seedPoint(2) < 1 || seedPoint(2) > cols
        error('种子点越界');
    end

    % 初始化输出图像和访问标记
    segmentedImage = false(rows, cols); % 输出二值图像
    visited = false(rows, cols); % 记录访问过的像素
    seedValue = inputImage(seedPoint(1), seedPoint(2)); % 种子点灰度值

    % 初始化队列并添加种子点
    queue = seedPoint; % 使用种子点初始化队列
    visited(seedPoint(1), seedPoint(2)) = true;

    % 区域生长
    while ~isempty(queue)
        % 取出队列中的第一个点
        currentPoint = queue(1, :);
        queue(1, :) = []; % 出队

        r = currentPoint(1);
        c = currentPoint(2);

        % 标记当前点为分割区域
        segmentedImage(r, c) = true;

        % 遍历当前点的8邻域
        for i = -1:1
            for j = -1:1
                if i == 0 && j == 0
                    continue; % 跳过中心点
                end

                newRow = r + i;
                newCol = c + j;

                % 检查是否越界
                if newRow >= 1 && newRow <= rows && newCol >= 1 && newCol <= cols
                    % 检查是否已访问过
                    if ~visited(newRow, newCol)
                        % 判断当前点和相邻点灰度值差异
                        if abs(inputImage(newRow, newCol) - inputImage(r, c)) <= threshold
                            % 添加到队列
                            queue = [queue; newRow, newCol];
                            visited(newRow, newCol) = true;
                        end
                    end
                end
            end
        end
    end
end
