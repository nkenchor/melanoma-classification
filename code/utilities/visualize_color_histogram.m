function visualize_color_histogram(lesionImages)
    % Create a new figure for color histograms
    figure('Name', 'Color Histograms', 'NumberTitle', 'off', 'Position', [100, 100, 2000, 800]);
    sgtitle('Color Histograms for Lesion Images');

    % Color histograms for up to 10 lesion images
    for idx = 1:min(10, length(lesionImages))
        subplot(2, 5, idx); % Updated positioning for up to 10 images
        visualize_small_color_histogram(lesionImages{idx}, idx);
        title(['Hist for Lesion Image ', num2str(idx)]);
    end
end
