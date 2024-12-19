%单通道滤波
function outputImage = ideal_lowpass_filter_single(inputImage, D0)
    % 单通道的理想低通滤波器
    % 输入：inputImage - 输入的单通道图像（灰度图）
    %        D0 - 截止频率
    % 输出：outputImage - 经过低通滤波后的图像
    
    % 执行傅里叶变换并进行频谱搬移
    FImage = fftshift(fft2(double(inputImage)));  % 傅里叶变换及频谱搬移
    
    % 获取图像大小
    [N, M] = size(FImage);
    
    % 计算图像的中心坐标
    r1 = floor(M / 2);
    r2 = floor(N / 2);
    
    % 创建空的频率响应矩阵
    g = zeros(N, M);
    
    % 生成理想低通滤波器
    for x = 1:M
        for y = 1:N
            d = sqrt((x - r1)^2 + (y - r2)^2);  % 计算当前点到频域中心的距离
            if d <= D0
                h = 1;  % 保留低频
            else
                h = 0;  % 阻断高频
            end
            g(y, x) = h * FImage(y, x);  % 应用低通滤波器
        end
    end
    
    % 执行逆傅里叶变换，得到滤波后的图像
    g = real(ifft2(ifftshift(g)));  % 逆变换并去除频谱搬移
    
    % 归一化输出图像，确保值在0-255之间
    outputImage = uint8(mat2gray(g) * 255);
end