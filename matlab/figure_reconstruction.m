% This script takes the 2D snapshots from emonocle as input and generate
% the reconstructed figure
%
% INPUT: experiment ID
%
% OUTPUT: reconstructed figure
%
% IMPORTANT NOTE: 
%   After you open MATLAB, navigate to the 'codes' folder before you run 
%   this script.
%
%   Vladimir Starostin (vstarostin@emiia.ru)
%   Last update: 08/08/2016
%

debug_flag = false; % turn this on for debugging

%% load data
exp_name  = 'cy_walk_emonocle_4';
% To change the experiment, replace 'cy_walk_emonocle_4' by any of the file
% names in the data folder

data_path = ['../data/' exp_name];
data = load(data_path);

%% compenste for swaying
[body_x, chest_z_avg] = estimate_swaying(data, debug_flag);

[img_shifted, img_shifted_norm] = swaying_compensation(data, body_x, chest_z_avg, debug_flag);

%% calculate the score for each image patch
[scores, patches, weight, weight_leg] = calculate_patch_scores(img_shifted, chest_z_avg, data);

%% combine snapshots with alpha masks
img_final = combine_snapshots(img_shifted_norm, weight, weight_leg, patches, data, chest_z_avg, debug_flag);

%% plot the figure
figure('Position', [100, 500, [length(data.x_range), length(data.z_range)]*4]);
surf(data.x_range, data.z_range, img_final, 'edgecolor','none'); 
view(0,90); axis tight; colormap('jet');
