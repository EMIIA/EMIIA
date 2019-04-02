function score = calc_body_score(patch_curr, noise_floor)

%     score = mean(patch_curr(:));

%     score = mean(patch_curr(patch_curr > 0));
    
    score = mean(patch_curr(patch_curr > noise_floor));



