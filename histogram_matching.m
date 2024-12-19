function matched_img = histogram_matching(source, reference)
    % 如果是彩色图像，分别处理每个通道
    if size(source, 3) == 3
        matched_img = source;
        for channel = 1:3
            matched_img(:,:,channel) = match_histogram_single_channel(source(:,:,channel), reference(:,:,channel));
        end
    else
        % 如果是灰度图像，直接进行匹配
        matched_img = match_histogram_single_channel(source, reference);
    end
end