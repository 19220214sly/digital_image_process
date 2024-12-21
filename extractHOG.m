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
