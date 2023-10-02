function [red_hist, green_hist, blue_hist] = extract_color_histograms(image, numBins)
    
    % Check if the image has at least 3 channels (assumed RGB)
    if size(image, 3) < 3
        % The image isn't a 3-channel image, so we'll return empty histograms for the missing channels
        red_hist = zeros(numBins, 1);
        green_hist = zeros(numBins, 1);
        blue_hist = zeros(numBins, 1);
        return;
    end

    % Extract the RGB channels
    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);

    % Calculate histograms
    red_hist = histcounts(R, numBins, 'Normalization', 'probability');
    green_hist = histcounts(G, numBins, 'Normalization', 'probability');
    blue_hist = histcounts(B, numBins, 'Normalization', 'probability');
end
