function visualize_confusion_matrices(cm, order, segmentationMethod, accuracy, precision, recall, f1, specificity, idx)
    % Create a new figure only if it's the first segmentation method
    if idx == 1
        figure('Name', 'Confusion Matrices', 'NumberTitle', 'off', 'Position', [100, 100, 2000, 800]);
        sgtitle('Results for SVM Classification using different segmentation methods');
    end

    % Confusion Matrix for each method
    subplot(1, 4, idx);
    confusionchart(cm, order);
    title(['Confusion Matrix for ', segmentationMethod]);
    metricsStr = sprintf('Accuracy: %.2f%%\nPrecision: %.2f%%\nRecall: %.2f%%\nF1: %.2f%%\nSpecificity: %.2f%%', ...
        accuracy*100, precision*100, recall*100, f1*100, specificity*100);
    xlabel(metricsStr);
end
