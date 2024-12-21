function target_img = kmeans_target_extraction(input_img, k)
    % 将输入图像转换为灰度图像，如果是彩色图像
    if size(input_img, 3) == 3
        gray_img = rgb2gray(input_img);  % 将彩色图像转换为灰度图像
    else
        gray_img = input_img;  % 如果已经是灰度图像，直接使用
    end

    % 将图像转化为一个N x 1的列向量，其中每行是一个像素值
    [rows, cols] = size(gray_img);
    data = double(reshape(gray_img, [], 1));  % 将灰度图像转为列向量

    % K-means聚类
    [cluster_idx, ~] = kmeans(data, k, 'Replicates', 5, 'MaxIter', 1000);  % 聚类
    
    % 将聚类结果映射回图像尺寸
    segmented_img = reshape(cluster_idx, rows, cols);

    target_img = (segmented_img == k);  % 提取聚类编号为k的目标区域

    % 将目标区域从原图中提取出来
    target_img = uint8(target_img) .* input_img;  % 只保留目标区域

end
