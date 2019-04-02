function joints = read_joint_from_emonocle(folder_path)

% This script read in 3D coordinates of skeleton joints recorded by emonocle
%
% INPUT: file location
%
% OUTPUT: joints - each cell component contains the 3D location of a joint
%   

% path_name = './'; %'~/fmcw_matlab/RFS/big_t_multiTx/cy_walk_kinect_2/';
% folder_path = [path_name 'joints/'];
joints = cell(1,25);

z_offset = 1.4;

for jnt = 0:24
    data = read_float([folder_path 'joint_' num2str(jnt) '.bin']);
    x = data([1:3:end]);
    y = data([2:3:end]);
    z = data([3:3:end]);
    
    % transform the coordinate system (x_n, y_n, z_n) = (-x, z, y)
    % for easiser visualization in MATLAB and comparison with our results

    x_n = -x;
    y_n = z;
    z_n = y + z_offset;    
    
    joint = struct('x', x_n, 'y', y_n, 'z', z_n);
    joints{jnt+1} = joint;
end

return
%%
figure; plot(joints{1}.x); title('x')
figure; plot(joints{1}.y); title('y')
figure; plot(joints{1}.z); title('z')