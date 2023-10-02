function display_accuracy_barchart(accuracies, segmentationMethods)
    % Create a figure for visualization of accuracies
    figure('Name', 'Segmentation Accuracy Barchart', 'NumberTitle', 'off');
    bar(accuracies);
    xlabel('Segmentation Methods');
    ylabel('Accuracy');
    title('Accuracy of Different Segmentation Methods');
    xticklabels(segmentationMethods);
    xtickangle(45); % angle the labels for better visualization
    grid on;
end
