function visualize_small_color_histogram(img, idx)
    % Ensure the image is in uint8 format and in RGB mode
    if ischar(img)
        img = imread(img); % If a path is provided, read the image
    end
    
    if size(img, 3) ~= 3
        error('Image must be an RGB image for color histogram visualization.');
    end

    % Extract individual channels
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);

    % Histogram for Red Channel
    hr = histogram(R, 256, 'FaceColor', 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    hold on; % Allows overlapping of the histograms

    % Histogram for Green Channel
    hg = histogram(G, 256, 'FaceColor', 'g', 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    % Histogram for Blue Channel
    hb = histogram(B, 256, 'FaceColor', 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    hold off;

    % Setting the legend
    legend([hr, hg, hb], {'Red', 'Green', 'Blue'});
    xlabel('Pixel Intensity (0-255)');
    ylabel('Frequency');
end
