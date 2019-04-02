function img_final = combine_snapshots(img_shifted_norm, weight, ...
    weight_leg, patches, data, chest_z_avg, debug_flag)
% Combine snapshots with alpha masks generated from patch scores
%
% Inputs:
%   img_shifted_norm    - images after swaying compensation with normalization
%   weight              - scores for body image patches
%   weight_leg          - scores for leg image patches
%   patches             - segmented image patches
%   chest_z_avg         - estimated chest location in z
%   debug_flag          - show debug figures
%
% Outputs:
%   img_final           - combined figure
%
disp('combining snapshots')

%% choose patches with highest score
[~, max_patch] = max(weight,[],3);
[~, max_patch_leg] = max(weight_leg,[],2);

%% parameters
run('segmentation_parameters.m') % this script uses chest_z_avg
run('mask_parameters.m')

%% combine using mask
img_final = zeros(c_height, c_width);
if debug_flag
    figure('Position', [100, 500, [c_width*3, length(data.z_range)]*4]);
end

% replace chest part w/ chest_patch
max_patch(2:3,2) = 0;
max_patch_body = max_patch(2:end,:);
max_patch_body = max_patch_body(max_patch_body > 0 );

chosen_frames = unique(cat(1, max_patch_leg, max_patch_body(:)))';

weight_mask_sample = zeros(num_of_seg_z+2, num_of_seg_x+2);
weight_mask_sample_leg = zeros(num_of_seg_z+2, num_of_seg_leg+2);

% for each frame, scan through each image segment, if the frame has the
% patch with highest SNR, create non-zero weight mask for it
for f = chosen_frames
    img = img_shifted_norm(:,:,f);
    
    for seg_cnt_z = 1:num_of_seg_z
        
        if(seg_cnt_z == 1)
            for seg_cnt_leg = 1:num_of_seg_leg

                weight_mask_sample_leg(seg_cnt_z + 1, seg_cnt_leg + 1) = ...
                    (max_patch_leg(seg_cnt_leg) == f);
            end            
        elseif( sum(seg_cnt_z == chest_seg_cnt_z) ) % chest part
            
            for seg_cnt_x = 1:num_of_seg_x                
                weight_mask_sample(seg_cnt_z + 1, seg_cnt_x + 1) = ...
                    (max_patch(seg_cnt_z, seg_cnt_x) == f);
            end
            
        else
            for seg_cnt_x = 2 % head                
                weight_mask_sample(seg_cnt_z + 1, seg_cnt_x + 1) = ...
                    (max_patch(seg_cnt_z, seg_cnt_x) == f);
            end
        end
    end
    
    weight_mask = interp2(grid_x, grid_z, weight_mask_sample, grid_x_q, grid_z_q);
    weight_mask_leg = interp2(grid_x_leg, grid_z_leg, weight_mask_sample_leg, grid_x_q, grid_z_q);
    
    if debug_flag
        subplot(1,4,1); surf(1:size(img_final,2), data.z_range,  img, 'edgecolor','none');
        view(0,90); axis tight; colormap('jet'); title(num2str(f))
        surfTop = 1;
        plot_grid(gcf, num_of_seg_z, num_of_seg_x, num_of_seg_leg, seg_point_z, seg_point_x, ...
            seg_point_leg, data.z_range, surfTop)
    end
    
    img_final = img_final + img .* weight_mask; %.* bound_mask;
    img_final = img_final + img .* weight_mask_leg .* weight_mask_leg_coef; % .* bound_mask;
    
    if debug_flag
        subplot(1,4, 2); surf(1:size(weight_mask,2), data.z_range, weight_mask, 'edgecolor','none');
        view(0,90); axis tight; colormap('jet'); title('mask for body')
        subplot(1,4, 3); surf(1:size(weight_mask_leg,2), data.z_range, weight_mask_leg, 'edgecolor','none');
        view(0,90); axis tight; colormap('jet'); title('mask for legs')
        subplot(1,4, 4); surf(1:size(img_final,2), data.z_range, img_final, 'edgecolor','none');
        view(0,90); axis tight; colormap('jet'); title('final figure')
        xlabel('x'); ylabel('z'); 
        pause
    end
end

%% replace chest part with patches summed across time
chest1 = cat(3, patches{:, 4});
chest2 = cat(3, patches{:, 7});
chest_patch = cat(1, chest1, chest2);

cp_sum = sum(chest_patch,3); %%% XXX using patches from walking for chest
cp_sum = cp_sum ./ max(cp_sum(:));
chest_img = zeros(size(img_final));
chest_img(seg_point_z(2):seg_point_z(4)-1, seg_point_x(2):seg_point_x(3)-1) = cp_sum;

weight_mask_c_sample = zeros(num_of_seg_z+2, num_of_seg_x+2);
weight_mask_c_sample(3,3) = 1;
weight_mask_c_sample(4,3) = 1;

grid_z_chest = grid_z;
grid_z_chest(2,:) = seg_point_z(2);
grid_z_chest(5,:) = seg_point_z(4);
weight_mask_chest = interp2(grid_x, grid_z_chest, weight_mask_c_sample, grid_x_q, grid_z_q);

img_final = img_final + chest_img .* weight_mask_chest;

%% crop the final image
img_center = length(data.x_range);
img_w = (img_center-1)/2;

img_final = img_final(:,img_center-img_w:img_center+img_w);
