function result = blurFilter(Image)
    % Image: 输入的图像
    % n: 模板的半径，决定邻域大小 (2*n+1) x (2*n+1) n=1
    n=1;
    
    % 转换为 double 类型，方便进行计算
    NoiseI = im2double(Image);

    % 图像尺寸获取
    [height, width, channels] = size(NoiseI);

    % 邻域模板半径
    result = zeros(height, width, channels);

    % 对每个通道进行模糊滤波处理
    for c = 1:channels
        % 扩展边缘
        hh = height + 2 * n;
        ww = width + 2 * n;
        ff = zeros(hh, ww);
        ff(n+1:hh-n, n+1:ww-n) = NoiseI(:, :, c);
        
        % 滤波操作
        for i = n+1:hh-n
            for j = n+1:ww-n
                % 当前窗口
                dd = zeros(n*2+1, n*2+1);
                % 求 d(m,n)
                for s = i-n:i+n
                    for t = j-n:j+n
                        dd(s+n-i+1, t+n-j+1) = ((ff(i, j) - ff(s, t)))^2;
                    end
                end
                % 求 β(x,y)
                bb = (sum(dd(:))) / ((n*2+1)^2 - 1);
                % 求 μ(m,n)/β(x,y)
                dd = (exp((-dd / bb))) / bb;
                sumd = sum(dd(:)) - 1 / bb;
                gg = 0;
                for s = i-n:i+n
                    for t = j-n:j+n
                        gg = gg + dd(s+n-i+1, t+n-j+1) * ff(s, t);
                    end
                end
                gg = gg - (1 / bb) * ff(i, j);
                result(i-n, j-n, c) = gg / sumd;
            end
        end
    end

    % 转换为 uint8 并返回结果
    result = uint8(result * 255);
end
