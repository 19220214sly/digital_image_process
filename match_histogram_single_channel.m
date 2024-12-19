function matched_channel = match_histogram_single_channel(source_channel, reference_channel)
    % 获取源图像和参考图像的直方图
    [src_counts, src_bins] = imhist(source_channel);
    [ref_counts, ref_bins] = imhist(reference_channel);

    % 计算源图像和参考图像的累计分布函数（CDF）
    src_cdf = cumsum(src_counts) / numel(source_channel);
    ref_cdf = cumsum(ref_counts) / numel(reference_channel);

    % 创建一个映射表，将源图像的像素值映射到参考图像的像素值
    mapping = zeros(256, 1);
    ref_idx = 1;
    for src_idx = 1:256
        % 找到与源图像的CDF最接近的参考图像的CDF
        while ref_cdf(ref_idx) < src_cdf(src_idx) && ref_idx < 256
            ref_idx = ref_idx + 1;
        end
        mapping(src_idx) = ref_bins(ref_idx);
    end

    % 使用映射表对源图像进行像素值映射
    matched_channel = uint8(mapping(double(source_channel) + 1));
end