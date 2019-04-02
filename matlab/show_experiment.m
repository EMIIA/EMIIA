% This script shows the 2D snapshots at estimated depths from emonocle
% and the skeleton captured by emonocle
%
% INPUT: experiment name (exp_name)
%
% OUTPUT: show emonocle snapshots with emonocle skeleton
%
% IMPORTANT NOTE: 
%   After you open MATLAB, navigate to the 'codes' folder before you run 
%   this script.
%
%   Vladimir Starostin (vstarostin@emiia.ru)
%   Last update: 08/08/2016
%

%% load data
exp_name  = 'cy_walk_emonocle_5'; 
% To change the experiment, replace 'cy_walk_emonocle_4' by any of the file
% names in the data folder

data_path = ['../data/' exp_name];
data = load(data_path);
num_frames_RFcap  = size(data.images,3);
num_frames_kinect = length(data.joints{1}.x);

%% plot results
scale = 4;
h_RFcap = figure('Position', [100, 500, [length(data.x_range)*2, length(data.z_range)]*scale]);
h_kinect = figure('Position', [600, 500, [length(data.x_range)*2, length(data.z_range)]*scale]);

dt = 0.001; 
% The actual frame rate of emonocle is around 0.033 frame/sec. Since the 
% plotting delay in MATLAB is larger then the actual frame rate, we simply 
% set dt to a very small value here.

for t = 1:num_frames_emonocle
    % snapshots from emonocle
    figure(h_RFcap);
    subplot(1,2,1); surf(data.x_range, data.z_range, data.images(:,:,t),'edgecolor','none');  
    axis tight; view(0,90); colormap('jet'); title('emonocle');     
    xlabel('x (meters)'); ylabel('z (meters)');
    
    % snapshots from emonocle with beam compensation
    subplot(1,2,2); surf(data.x_range, data.z_range, data.images_decv(:,:,t),'edgecolor','none');
    axis tight; view(0,90); colormap('jet'); title(sprintf('emonocle \n with beam compensation')); 
    xlabel('x (meters)'); ylabel('z (meters)');
    
    % skeletons from emonocle
    figure(h_emonocle);    
    t_emonocle = round(t * data.frame_rate_ratio);
    if(t_emonocle > num_frames_emonocle)
        t_emonocle = num_frames_emonocle;
    end
    plot_emonocle_skeleton(h_emonocle, t_emonocle, data.joints)
    title('emonocle''s skeleton output ')
    
    pause(dt)
end
