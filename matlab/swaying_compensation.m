function [img_shifted, img_shifted_norm] = swaying_compensation(data, body_x, chest_z_avg, debug_flag)

% Center all images to compensate for body swaying
%
% Inputs:
%   data.images     - snapshots from emonocle after beam compensation
%   body_x          - estimated chest location in x
%   chest_z_avg     - estimated chest location in z
%   debug_flag      - show debug figures
%
% Outputs:
%   img_shifted - images after swaying compensation
%   img_shifted_norm - images after swaying compensation with normalization
%
%   Vladimir Starostin (vstarostin@emiia.ru)
%   Last update: 08/08/2016
%

images = data.images_decv;
num_frames = size(images,3);

disp('swaying compensation...')
img_shifted = zeros(size(images, 1), size(images, 2) * 2 - 1, num_frames);
fs_cnt = 1;
for f = 1:num_frames
    x_start = round(size(images, 2) - body_x(f));
    x_end = x_start + size(images, 2) - 1;
    img_shifted(:, x_start:x_end, fs_cnt) = images(:,:,f);
    fs_cnt = fs_cnt + 1;
end

% normalized the images to 0 ~ 1
img_shifted_norm = zeros(size(img_shifted));
for f = 1:size(img_shifted,3)
    img_shifted_norm(:, :, f) = img_shifted(:, :,f)./max(max(img_shifted(:, :, f)));
end

%%
if (debug_flag)
    run('segmentation_parameters.m')  % this script uses chest_z_avg
    scale = 4;
    h = figure('Position', [100, 500, [c_width, length(data.z_range)]*scale]);

    for f = 1:num_frames
        figure(h); surf(1:c_width, data.z_range, img_shifted(:,:,f),'edgecolor','none');

        surfTop = max(max(img_shifted(:,:,f)));
        colorbar
        axis tight; view(0,90); colormap('jet');
        xlabel('x'); ylabel('z'); title(['frame ' num2str(f)])
        
        plot_grid(gcf, num_of_seg_z, num_of_seg_x, num_of_seg_leg, seg_point_z, seg_point_x, ...
            seg_point_leg, data.z_range, surfTop)
        
        pause
    end
end