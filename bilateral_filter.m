function filtered_image = bilateral_filter(I)
    % 输入参数：
    % I：输入的彩色图像（需要是double类型）
    % sigma_spatial：空间域的标准差
    % sigma_intensity：强度域的标准差
    % window_width：滤波的窗口宽度（也可以理解为滤波的半径范围）
    
    % 确保图像是double类型
    I = im2double(I);
    %默认设置(根据作业效果设置)
    sigma_spatial=10;
    sigma_intensity=0.3;
    window_width=7;
    % 对每个颜色通道分别进行双边滤波
    filtered_R = imbilatfilt(I(:,:,1), sigma_intensity, sigma_spatial, 'NeighborhoodSize', window_width);
    filtered_G = imbilatfilt(I(:,:,2), sigma_intensity, sigma_spatial, 'NeighborhoodSize', window_width);
    filtered_B = imbilatfilt(I(:,:,3), sigma_intensity, sigma_spatial, 'NeighborhoodSize', window_width);

    % 合并滤波后的颜色通道
    filtered_image = cat(3, filtered_R, filtered_G, filtered_B);
end
