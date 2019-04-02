function plot_emonocle_skeleton(h, t, joints)
% This script plot the skeleton capture by emonocle
%
% INPUTs:
%   h       - MATLAB graphic handler
%   t       - frame number
%   joints  - cell[1x25], each cell contains the coordinates of a joint
%   ex:
%       joints{1}.x - the x location of SpineMid across time
%
% OUTPUT:
%   plot of all the joints with limb connections at time t
%
%   Vladimir Starostin (vstarostin@emiia.ru)
%   Last update: 08/08/2016
%

run('emonocle_joint_mapping.m');

num_jnts = length(joints);
num_limbs = size(joint_connections,1);

x_min = -1;
x_max = 1;
y_min = 0;
y_max = 4.5;
z_min = 0;
z_max = 2;

figure(h);
%%
joint = zeros(num_jnts,3);
for jnt = 1:num_jnts
    joint(jnt,1) = joints{jnt}.x(t);
    joint(jnt,2) = joints{jnt}.y(t);
    joint(jnt,3) = joints{jnt}.z(t);
end
scatter3(joint(:,1), joint(:,2), joint(:,3))

%%
p1 = zeros(num_limbs, 3);
p2 = zeros(num_limbs, 3);

for l = 1:num_limbs
    % the indexes of two joints for a connection
    joint_pair = joint_connections(l,:) + 1;
    
    p1(l,1) = joints{joint_pair(1)}.x(t);
    p1(l,2) = joints{joint_pair(1)}.y(t);
    p1(l,3) = joints{joint_pair(1)}.z(t);
    
    p2(l,1) = joints{joint_pair(2)}.x(t);
    p2(l,2) = joints{joint_pair(2)}.y(t);
    p2(l,3) = joints{joint_pair(2)}.z(t); 
end
hold on; 
plot3([p1(:,1)'; p2(:,1)'], [p1(:,2)'; p2(:,2)'], [p1(:,3)'; p2(:,3)']);
hold off;

axis([x_min x_max y_min y_max z_min z_max]);
view(-30,20)

