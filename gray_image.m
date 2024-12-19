function new_img = gray_image(image_path)
    % 读取图像
    ori_img = imread(image_path);
    
    % 灰度化
    new_img = 0.229 * ori_img(:,:,1) + 0.587 * ori_img(:,:,2) + 0.114 * ori_img(:,:,3);
    
end
