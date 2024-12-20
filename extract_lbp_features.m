function [lbp_image1, lbp_image2] = extract_lbp_features(image1, image2)
    % 输入两张彩色图像，输出它们的LBP特征图

    % 将彩色图像转换为灰度图像
    gray_image1 = rgb2gray(image1);
    gray_image2 = rgb2gray(image2);
    
    % 获取灰度图像的尺寸
    [N, M] = size(gray_image1);
    
    % 初始化LBP特征图
    lbp_image1 = zeros(N, M);
    lbp_image2 = zeros(N, M);
    
    % 对灰度图像进行LBP特征提取
    for j = 2:N-1
        for i = 2:M-1
            % 获取当前像素周围的8个邻域像素
            neighbor = [j-1 i-1; j-1 i; j-1 i+1; j i+1; j+1 i+1; j+1 i; j+1 i-1; j i-1];
            
            % 初始化计数
            count1 = 0;
            count2 = 0;
            
            % 对邻域像素进行比较
            for k = 1:8
                if gray_image1(neighbor(k, 1), neighbor(k, 2)) > gray_image1(j, i)
                    count1 = count1 + 2^(8-k);
                end
                if gray_image2(neighbor(k, 1), neighbor(k, 2)) > gray_image2(j, i)
                    count2 = count2 + 2^(8-k);
                end
            end
            
            % 保存结果到LBP图像中
            lbp_image1(j, i) = count1;
            lbp_image2(j, i) = count2;
        end
    end
    
    % 将LBP特征图转换为uint8类型
    lbp_image1 = uint8(lbp_image1);
    lbp_image2 = uint8(lbp_image2);
    
    figure;
    % 显示两张图像的LBP特征图
    subplot(2,2,1);
    imshow(lbp_image1);
    title('原图 LBP 特征图');
    
    subplot(2,2,2);
    imshow(lbp_image2);
    title('目标提取图像 LBP 特征图');
    
    % 计算并显示直方图
    subplot(2,2,3);
    imhist(lbp_image1);
    title('原图 LBP 直方图');
    
    subplot(2,2,4);
    imhist(lbp_image2);
    title('目标提取图像 LBP 直方图');
end
