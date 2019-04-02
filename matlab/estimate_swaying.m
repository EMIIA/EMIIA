function [body_x, chest_z_avg] = estimate_swaying(data, debug_flag)
% Estimate chest's location across frames for swaying compensation
%
% Inputs:
%   data.images     - snapshots from emonocle
%   data.x_range    - range of snapshots in x dimension (in meters)
%   data.z_range    - range of snapshots in z dimension (in meters)
%   data.walk_start - the frame when the person started walking
%   data.walk_end   - the frame when the person stopped walking
%   debug_flag      - show debug figures
%
% Output:
%   body_x          - estimated chest location in x
%   chest_z_avg     - estimated chest location in z
%
%   Vladimir Starostin (vstarostin@emiia.ru)
%   Last update: 08/08/2016
%

images      = data.images_decv;
x_range     = data.x_range;
z_range     = data.z_range;
walk_start  = data.walk_start;
walk_end    = data.walk_end;

ds = x_range(2) - x_range(1);
num_frames = size(images,3);

%% raw estimation
% use the maximum reflection point as raw estimations

check_above = 0.49; % meter
check_above = find(abs(z_range - check_above) < (ds/2 + eps), 1);
max_val = zeros(1, num_frames);
max_col = zeros(1, num_frames);
max_row = zeros(1, num_frames);
for f = 1:num_frames
    img = images(check_above:end,:,f);
    [max_val(f), max_idx] = max(img(:));
    [max_row(f), max_col(f)] = ind2sub(size(img), max_idx);
end
traj_x = (x_range(max_col))';
traj_z = (z_range(max_row+check_above))';

%% outlier rejection
% interpolate the chest locations for frames in which the strongest 
% reflection point is not chest

body_center = mean(traj_x(walk_start:walk_end));
hand_left_bound  = body_center - 0.12; 
hand_right_bound = body_center + 0.12; 
hand_reg = (traj_x < hand_left_bound) + (traj_x > hand_right_bound);
hand_reg_mf = medfilt1(hand_reg*1, 5);
hand_reg = logical(hand_reg + hand_reg_mf);

% if get hand strongest before walk_start -> replace traj_x with mean(traj_x)
if (abs(mean(traj_x(1:walk_start)) - body_center) > 0.1)
    traj_x(1:walk_start) = body_center;
    hand_reg(1:walk_start) = 0;
end
traj_x(1) = body_center; % in case first pos is bad
hand_reg(1) = 0;

body_x = interp_badRegion(traj_x, hand_reg, 3, 'pchip', debug_flag);
body_x = medfilt1(body_x,10); % apply median filter

if debug_flag
    title('swaying estimation')
    len = length(hand_reg);
    hold on; plot(1:len, hand_left_bound*ones(1,len));
    hold on; plot(1:len, hand_right_bound*ones(1,len));
    xlabel('frames')
    ylabel('x (meters)')
end
% estimated chest x location
body_x = round((body_x - min(x_range))/ds);

% estimated chest hight
chest_z_avg = mode(traj_z);
