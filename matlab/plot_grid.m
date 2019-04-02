function plot_grid(h, num_of_seg_z, num_of_seg_x, num_of_seg_leg, seg_point_z, seg_point_x, ...
    seg_point_leg, z_range, surfTop)
% This function plots the segmentation on a given figure

    % horizontal lines
    for z = 1:(num_of_seg_z+1)
        if(z == 3)
            x_plot = [seg_point_x(1):seg_point_x(2)]; 
            z_plot = z_range(seg_point_z(z)) .* ones(1,length(x_plot));
            hold on; plot3(x_plot, z_plot, surfTop*ones(1, length(x_plot)), 'g', 'LineWidth', 2);
            
            x_plot = [seg_point_x(3):seg_point_x(4)];
            z_plot = z_range(seg_point_z(z)) .* ones(1,length(x_plot));
            hold on; plot3(x_plot, z_plot, surfTop*ones(1, length(x_plot)), 'g', 'LineWidth', 2);
        elseif(z == num_of_seg_z+1)
            x_plot = [seg_point_x(2):seg_point_x(3)];
            z_plot = z_range(seg_point_z(z)) .* ones(1,length(x_plot));
            hold on; plot3(x_plot, z_plot, surfTop*ones(1, length(x_plot)), 'g', 'LineWidth', 2);
        else
            x_plot = [seg_point_x(1):seg_point_x(4)];
            z_plot = z_range(seg_point_z(z)) .* ones(1,length(x_plot));
            hold on; plot3(x_plot, z_plot, surfTop*ones(1, length(x_plot)), 'g', 'LineWidth', 2);
        end
    end
    
    % vertical lines
    for x = 2:num_of_seg_x
        z_plot = z_range(seg_point_z(2):seg_point_z(end));
        x_plot = seg_point_x(x) .* ones(1,length(z_plot));
        hold on; plot3(x_plot, z_plot, surfTop*ones(1, length(z_plot)), 'g', 'LineWidth', 2);
    end
        
    for x = 1:(num_of_seg_leg+1)
        z_plot = z_range(1:seg_point_z(2));
        x_plot = seg_point_leg(x) .* ones(1,length(z_plot));
        hold on; plot3(x_plot, z_plot, surfTop*ones(1, length(z_plot)), 'g', 'LineWidth', 2);
    end
    % for left/right most vertical lines
    z_plot = z_range(seg_point_z(2):seg_point_z(4));
    x_plot = seg_point_x(1) .* ones(1,length(z_plot));
    hold on; plot3(x_plot, z_plot, surfTop*ones(1, length(z_plot)), 'g', 'LineWidth', 2);
    
    z_plot = z_range(seg_point_z(2):seg_point_z(4));
    x_plot = seg_point_x(4) .* ones(1,length(z_plot));
    hold on; plot3(x_plot, z_plot, surfTop*ones(1, length(z_plot)), 'g', 'LineWidth', 2);    
    hold off
end