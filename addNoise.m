function noisyImage = addNoise(inputImage, noiseType)
    % 输入参数说明：
    % inputImage - 输入的图像
    % noiseType  - 噪声类型，'gaussian' 或 'salt & pepper'
    % noiseLevel - 噪声强度
    %   对于高斯噪声，noiseLevel是噪声的标准差
    %   对于椒盐噪声，noiseLevel是噪声的比例

    % 判断噪声类型并加噪
    noiseLevel=0.2;
    switch noiseType
        case 'gaussian'
            % 对图像添加高斯噪声
            noisyImage = imnoise(inputImage, 'gaussian', 0, noiseLevel^2); % 高斯噪声（均值为0，方差为噪声强度的平方）
        
        case 'salt & pepper'
            % 对图像添加椒盐噪声
            noisyImage = imnoise(inputImage, 'salt & pepper', noiseLevel); % 椒盐噪声，噪声比例为noiseLevel
            
        otherwise
            error('Unsupported noise type. Use "gaussian" or "salt & pepper".');
    end
end
