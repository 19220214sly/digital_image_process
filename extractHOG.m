% function [feature, image_hog] = extractHOG(Image)
%     % 输入参数:
%     %    Image - 输入的彩色或灰度图像
%     %    step - HOG计算时的cell大小（步长）
%     %    K - 梯度方向的数量（即直方图的分桶数）
%     %
%     % 输出参数:
%     %    feature - HOG特征向量的单元数组
%     %    image_hog_with_arrows - 带有HOG箭头的图像
%     step=8;
%     K=9;
%     % 如果是彩色图像，则转换为灰度图
%     if size(Image, 3) == 3
%         Image_gray = rgb2gray(Image);
%     else
%         Image_gray = Image;
%     end
% 
%     % 将图像转换为double类型
%     Image_gray = double(Image_gray);
% 
%     [N, M] = size(Image_gray);
%     Image_processed = sqrt(Image_gray);  % 对图像进行开根号操作
% 
%     % 计算梯度
%     Hy = [-1 0 1];
%     Hx = Hy';
%     Gy = imfilter(Image_processed, Hy, 'replicate');
%     Gx = imfilter(Image_processed, Hx, 'replicate');
%     Grad = sqrt(Gx.^2 + Gy.^2);  % 计算梯度幅值
%     Phase = atan2d(Gy, Gx);  % 计算梯度方向（度）
%     Phase(Phase < 0) = Phase(Phase < 0) + 180;  % 将角度转换到[0, 180]范围内
% 
%     % HOG计算参数
%     angle = 180 / K;  % 每个方向的角度大小
%     numCellsX = floor(M / step);
%     numCellsY = floor(N / step);
%     Cell = cell(numCellsY, numCellsX);  % 预分配单元格数组
% 
%     % 计算HOG特征
%     for i = 1:numCellsX
%         for j = 1:numCellsY
%             col_start = (i-1)*step + 1;
%             col_end = i*step;
%             row_start = (j-1)*step + 1;
%             row_end = j*step;
%             Gtmp = Grad(row_start:row_end, col_start:col_end);
%             sumGrad = sum(Gtmp(:));
%             if sumGrad == 0
%                 Gtmp_norm = Gtmp;
%             else
%                 Gtmp_norm = Gtmp / sumGrad;  % 对每个cell的梯度进行归一化
%             end
%             Hist = zeros(1, K);  % 初始化梯度直方图
%             for x = 1:step
%                 for y = 1:step
%                     ang = Phase(row_start + y -1, col_start + x -1); 
%                     if ang <= 180
%                         bin = floor(ang / angle) + 1;
%                         if bin > K  % 处理角度为180度的情况
%                             bin = K;
%                         end
%                         Hist(bin) = Hist(bin) + Gtmp_norm(y, x);   
%                     end
%                 end
%             end
%             Cell{j, i} = Hist;  % 存储每个cell的HOG特征
%         end
%     end
% 
%     % 特征提取
%     feature = cell(1, (numCellsX-1)*(numCellsY-1));  % 初始化HOG特征向量的单元数组
%     idx = 1;
%     for i = 1:numCellsX-1
%         for j = 1:numCellsY-1           
%             f = [Cell{j, i} Cell{j, i+1} Cell{j+1, i} Cell{j+1, i+1}];
%             f = f / sum(f);  % 归一化特征向量
%             feature{idx} = f;  % 存储特征向量
%             idx = idx + 1;
%         end
%     end
% 
%     % 准备输出图像，将原始图像转换为RGB格式
%     if size(Image, 3) == 1
%         image_hog = cat(3, uint8(Image), uint8(Image), uint8(Image));  % 灰度图像转换为RGB
%     else
%         image_hog = Image;
%     end
% 
%     % 初始化箭头线段列表
%     lines = [];  % 每行是 [x1 y1 x2 y2]
% 
%     % 计算箭头的起点和方向
%     for i = 1:numCellsX
%         for j = 1:numCellsY
%             Hist = Cell{j, i};
% 
%             % 将梯度直方图转换为HOG方向图
%             for k = 1:K
%                 angle_start = (k - 1) * angle;  % 每个方向的起始角度
%                 angle_end = k * angle;          % 每个方向的结束角度
%                 intensity_k = Hist(k);         % 每个方向的强度
%                 if intensity_k == 0
%                     continue;  % 跳过强度为0的方向
%                 end
%                 length = intensity_k * 50;      % 可以调节条的长度
% 
%                 % 计算方向条的极坐标
%                 angle_center = (angle_start + angle_end) / 2;
%                 [dx, dy] = pol2cart(deg2rad(angle_center), length);  % 转换为笛卡尔坐标
% 
%                 % 计算箭头的起点
%                 startX = (i - 0.5) * step;  % cell中心的x坐标
%                 startY = (j - 0.5) * step;  % cell中心的y坐标
% 
%                 % 计算箭头的终点
%                 endX = startX + dx;
%                 endY = startY + dy;
% 
%                 % 将箭头的起点和终点加入lines列表
%                 lines = [lines; startX, startY, endX, endY];
%             end
%         end
%     end
% 
%     % 检查是否有箭头需要绘制
%     if isempty(lines)
%         disp('No arrows generated. Returning original image.');
%         return;
%     end
% 
% 
%     image_hog = insertShape(image_hog, 'Line', lines, 'Color', 'black', 'LineWidth', 1);
% 
% end

function [hogFeatures, visualizedImage] = extractHOG(inputImage)
    cellSize = 8;
    numBins = 9;

    if size(inputImage, 3) == 3
        grayImage = rgb2gray(inputImage);
    else
        grayImage = inputImage;
    end

    grayImage = double(grayImage);
    [height, width] = size(grayImage);
    processedImage = sqrt(grayImage);

    gradientY = [-1 0 1];
    gradientX = gradientY';
    gradY = imfilter(processedImage, gradientY, 'replicate');
    gradX = imfilter(processedImage, gradientX, 'replicate');
    magnitude = sqrt(gradX.^2 + gradY.^2);
    direction = atan2d(gradY, gradX);
    direction(direction < 0) = direction(direction < 0) + 180;

    angleStep = 180 / numBins;
    numCellsX = floor(width / cellSize);
    numCellsY = floor(height / cellSize);
    hogCells = cell(numCellsY, numCellsX);

    for x = 1:numCellsX
        for y = 1:numCellsY
            colRange = (x - 1) * cellSize + 1:x * cellSize;
            rowRange = (y - 1) * cellSize + 1:y * cellSize;
            gradCell = magnitude(rowRange, colRange);
            normFactor = sum(gradCell(:));
            if normFactor == 0
                normalizedGrad = gradCell;
            else
                normalizedGrad = gradCell / normFactor;
            end
            histValues = zeros(1, numBins);
            for i = 1:cellSize
                for j = 1:cellSize
                    binIdx = floor(direction(rowRange(j), colRange(i)) / angleStep) + 1;
                    binIdx = min(binIdx, numBins);
                    histValues(binIdx) = histValues(binIdx) + normalizedGrad(j, i);
                end
            end
            hogCells{y, x} = histValues;
        end
    end

    hogFeatures = cell(1, (numCellsX - 1) * (numCellsY - 1));
    idx = 1;
    for x = 1:numCellsX - 1
        for y = 1:numCellsY - 1
            blockFeature = [hogCells{y, x}, hogCells{y, x + 1}, hogCells{y + 1, x}, hogCells{y + 1, x + 1}];
            hogFeatures{idx} = blockFeature / sum(blockFeature);
            idx = idx + 1;
        end
    end

    if size(inputImage, 3) == 1
        visualizedImage = cat(3, uint8(inputImage), uint8(inputImage), uint8(inputImage));
    else
        visualizedImage = inputImage;
    end

    lines = [];
    for x = 1:numCellsX
        for y = 1:numCellsY
            cellHist = hogCells{y, x};
            for bin = 1:numBins
                binAngle = (bin - 1) * angleStep + angleStep / 2;
                intensity = cellHist(bin);
                if intensity == 0
                    continue;
                end
                length = intensity * 20;
                [dx, dy] = pol2cart(deg2rad(binAngle), length);
                startX = (x - 0.5) * cellSize;
                startY = (y - 0.5) * cellSize;
                endX = startX + dx;
                endY = startY + dy;
                lines = [lines; startX, startY, endX, endY];
            end
        end
    end

    if ~isempty(lines)
        visualizedImage = insertShape(visualizedImage, 'Line', lines, 'Color', 'black', 'LineWidth', 1);
    end
end
