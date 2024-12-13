function outputImage=ideal_lowpass_filter_color(Image, D0)
    
    if size(Image, 3) == 3
        % 如果是彩色图像，分离RGB通道
        R = Image(:,:,1);
        G = Image(:,:,2);
        B = Image(:,:,3);
    else
        % 如果是灰度图像，直接处理
        R = Image;
        G = Image;
        B = Image;
    end
    
    % 执行滤波
        % 创建空的输出图像
        output_R = ideal_lowpass_filter_single(R, D0);
        output_G = ideal_lowpass_filter_single(G, D0);
        output_B = ideal_lowpass_filter_single(B, D0);
        
        % 合并三个通道
        outputImage = cat(3, uint8(output_R), uint8(output_G), uint8(output_B));