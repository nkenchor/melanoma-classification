function features = extract_all_features(image_data, numBins)

    num_images = length(image_data);
    
    % Preallocate features matrix 
    features = zeros(numBins*3, num_images); 
    
    for i = 1:num_images
    
        img = image_data{i};
        
        % Extract RGB histograms  
        [red_hist, green_hist, blue_hist] = extract_color_histograms(img, numBins);
        
        % Make sure histograms are column vectors
        red_hist = red_hist(:);
        green_hist = green_hist(:);
        blue_hist = blue_hist(:);
    
        % Concatenate features for the image
        img_features = [red_hist; green_hist; blue_hist];
    
        % Store features for this image in columns 
        features(:,i) = img_features;
    
    end

end

