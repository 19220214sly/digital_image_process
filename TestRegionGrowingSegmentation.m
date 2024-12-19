function segmentedImage=TestRegionGrowingSegmentation(imagePath, threshold)
    % 读取图像
    inputImage = imread(imagePath);  % 读取图像

    % 将图像转换为灰度图像（如果是彩色图像的话）
    if size(inputImage, 3) == 3
        inputImage = rgb2gray(inputImage);  % 将彩色图像转换为灰度图像
    end

    % 显示图像并让用户选择种子点
    figure;
    imshow(inputImage, []);
    title('点击选择种子点');
    [col, row] = ginput(1);  % 让用户点击图像选择种子点
    seedPoint = [round(row), round(col)];  % 获取种子点坐标并四舍五入到整数

    % 输出选择的种子点
    disp(['选中的种子点：(', num2str(seedPoint(1)), ',', num2str(seedPoint(2)), ')']);

    % 调用区域生长分割函数
    segmentedImage = regionGrowingSegmentation(inputImage, seedPoint, threshold);
end
