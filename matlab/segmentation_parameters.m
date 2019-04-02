% segment points here are for calculating scors/weight only
% the real blending is done by the masks

assert(logical(exist('data', 'var')), 'load data first!')

num_of_seg_z = 4;
num_of_seg_x = 3;
num_of_seg_leg = 2;

% all parameter setting should be in meters
chest_x_width = 0.30; %0.32; 
chest_upper_z_width = 0.4; 
chest_lower_z_width = 0.6;
head_z_width = 0.5;
head_z_top  = chest_z_avg + head_z_width; %1.8;
chest_hand_dist_z = chest_lower_z_width + 0.5 * chest_upper_z_width; %0.8;
leg_sep = 0.5;
ground_z = 0;

chest_seg_cnt_z = [2 3];

ds = data.z_range(2) - data.z_range(1);
    
% meters to index
chest_z_avg = find( abs(data.z_range - chest_z_avg) < ds/2);
head_z_top = find( abs(data.z_range - head_z_top) < ds/2);
chest_x_width = round(chest_x_width / ds);
chest_upper_z_width = round(chest_upper_z_width / ds);
chest_hand_dist_z = round(chest_hand_dist_z / ds);
leg_sep = round(leg_sep/ds);
ground_z = find( abs(data.z_range - ground_z) < (ds/2 + eps));

c_width  = size(data.images, 2) * 2 - 1;
c_height = size(data.images, 1);

clear seg_point_z seg_point_x seg_point_leg;
% unit in z index
seg_point_z(1) = 1;
seg_point_z(2) = round(chest_z_avg - 1*chest_hand_dist_z);  % hand below
seg_point_z(3) = round(chest_z_avg - 0.5*chest_upper_z_width);  % chest bottom
seg_point_z(4) = round(chest_z_avg + 0.5*chest_upper_z_width); % chest top
seg_point_z(5) = head_z_top;

% unit in x index
seg_point_x(1) = 1;
seg_point_x(2) = round(c_width/2 - 0.5*chest_x_width);  % chest left
seg_point_x(3) = round(c_width/2 + 0.5*chest_x_width);  % chest right
seg_point_x(4) = c_width;

seg_point_leg(1) = round(c_width/2) - leg_sep;
seg_point_leg(2) = round(c_width/2);
seg_point_leg(3) = round(c_width/2) + leg_sep;