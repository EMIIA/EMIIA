% parameters for mask (alpha) blending
weight_mask_leg_coef = 2;

% grid points for alpha masks
grid_x = [c_width/2 - (0.5/0.8)*chest_x_width,  c_width/2, c_width/2 + (0.5/0.8)*chest_x_width];
grid_x = repmat([1 grid_x c_width], num_of_seg_z + 2, 1);
grid_x_q = repmat(1:c_width, c_height, 1);
grid_z = ((seg_point_z(1:end-1) + seg_point_z(2:end))/2);
grid_z = repmat([1 grid_z c_height]', 1, num_of_seg_x + 2);
grid_z_q = repmat((1:c_height)', 1, c_width);

grid_x_leg = [c_width/2 - leg_sep/2,  c_width/2 + leg_sep/2];
grid_x_leg = repmat([1 grid_x_leg c_width], num_of_seg_z + 2, 1);
grid_z_leg = ((seg_point_z(1:end-1) + seg_point_z(2:end))/2);
grid_z_leg = repmat([1 grid_z_leg c_height]', 1, num_of_seg_leg + 2);
