function Yi = interp_badRegion(Y, bad_region, mf_win, method, debug)
    % input Y should be a column vector, Y is the signal to be interpolate, 
    % bad_region is the region to be replaced
    if( size(Y,1) == 1 || size(Y,2) ~= 1)
        fprintf('ERROR: Y should be a column vector!')
        Yi = 0;
        return
    end
    
    index = (1:size(Y,1))';
    if mf_win ~= 0
        Y_mf = medfilt1(Y,mf_win);
    else
        Y_mf = Y;
    end
    X = index(~bad_region(1:length(index)));
    Y_t = Y_mf(~bad_region(1:length(index)));
    Yi = interp1(X,Y_t, index, method);
    
    if (debug)
       figure; plot(Y)
       hold on; plot(Y_mf,'g')
       hold on; plot(Yi, 'r')
       hold on; plot(bad_region)
       title('interp bad region')
    end
end