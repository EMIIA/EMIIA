function [scores, patches, weight, weight_leg] = calculate_patch_scores(img_shifted, chest_z_avg, data)
% Based on the segmentation, calculate the score for each image patch
%
% Inputs:
%   img_shifted     - images after swaying compensation
%   chest_z_avg     - estimated chest location in z
%   data.walk_start - the frame when the person started walking
%   data.walk_end   - the frame when the person stopped walking
%
% Outputs:
%   scores          - scores for each image patch
%   patches         - segmented image patches
%   weight          - scores for body image patches
%   weight_leg      - scores for leg image patches
%
%   Vladimir Starostin (vstarostin@emiia.ru)
%   Last update: 08/08/2016
%

disp('calculating scores...')

%% get parameters
run('segmentation_parameters.m')  % this script uses chest_z_avg
frame_used = data.walk_start:(data.walk_end-12);
num_frame_used = length(frame_used);

%% calculate the score for each image patch
% store each frame into patches
scores  = cell(num_frame_used,9);
patches = cell(num_frame_used,9);

weight = zeros(num_of_seg_z, num_of_seg_x, num_frame_used);
weight_leg = zeros(num_of_seg_leg, num_frame_used);

cnt = 1;
for fs_cnt = frame_used
    img = img_shifted(:,:,fs_cnt);
    
    noise_floor = 10; %max(max(img)) .* 0.25;   %    % TODO: how to set noise floor
    for seg_cnt_z = 1:num_of_seg_z
        
        seg_start_z = seg_point_z(seg_cnt_z);
        seg_end_z   = seg_point_z(seg_cnt_z+1) - 1;
        
        if (seg_cnt_z == 1) % use leg segment points
            
            for seg_cnt_leg = 1:num_of_seg_leg
                seg_start_x = seg_point_leg(seg_cnt_leg);
                seg_end_x   = seg_point_leg(seg_cnt_leg+1) - 1;
                
                % calculate weigh for patches above ground
                seg_start_z = ground_z;
                seg_end_z   = seg_point_z(seg_cnt_z+1) - 1;
                
                patch_curr = img(seg_start_z:seg_end_z,seg_start_x:seg_end_x);
                
                weight_leg(seg_cnt_leg, fs_cnt) = calc_body_score(patch_curr, noise_floor);
                scores{cnt, seg_cnt_leg} = calc_body_score(patch_curr, noise_floor);
                patches{cnt, seg_cnt_leg} = patch_curr;
            end
            
        elseif ( sum(seg_cnt_z == chest_seg_cnt_z) ) % chest part
            
            for seg_cnt_x = 1:num_of_seg_x
                seg_start_x = seg_point_x(seg_cnt_x);
                seg_end_x   = seg_point_x(seg_cnt_x+1) - 1;
                
                seg_start_z = seg_point_z(seg_cnt_z);
                seg_end_z   = seg_point_z(seg_cnt_z+1) - 1;
                patch_curr = img(seg_start_z:seg_end_z,seg_start_x:seg_end_x);
                
                weight(seg_cnt_z, seg_cnt_x, fs_cnt) = calc_body_score(patch_curr, noise_floor);
                
                bp_idx = num_of_seg_leg + num_of_seg_x*(seg_cnt_z-2) + seg_cnt_x;
                scores{cnt, bp_idx} = calc_body_score(patch_curr, noise_floor);
                patches{cnt, bp_idx} = patch_curr;
            end
        else
            
            for seg_cnt_x = 2; %only consider head.
                seg_start_x = seg_point_x(seg_cnt_x);
                seg_end_x   = seg_point_x(seg_cnt_x+1) - 1;
                
                patch_curr = img(seg_start_z:seg_end_z,seg_start_x:seg_end_x);
                weight(seg_cnt_z, seg_cnt_x, fs_cnt) = calc_body_score(patch_curr, noise_floor);
                
                scores{cnt, 9} = calc_body_score(patch_curr, noise_floor);
                patches{cnt, 9} = patch_curr;
            end
        end
    end
    cnt = cnt + 1;
end
