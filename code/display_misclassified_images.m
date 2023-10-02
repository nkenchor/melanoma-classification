function display_misclassified_images(misclassifiedInfo, methodName)
    if isempty(misclassifiedInfo)
        return; % No misclassified images to display
    end
    
    numMisclassified = length(misclassifiedInfo);
    
    % Calculate rows and columns for subplot
    numRows = ceil(sqrt(numMisclassified));
    numCols = ceil(numMisclassified / numRows);

    fig = figure('Name', ['Misclassified Images for ', methodName], 'NumberTitle', 'off');

    for j = 1:numMisclassified
        subplot(numRows, numCols, j);
        imshow(misclassifiedInfo(j).Image);
        
        % Check if the labels are numeric or strings, then handle accordingly
        if isnumeric(misclassifiedInfo(j).TrueLabel)
            trueLabelStr = num2str(misclassifiedInfo(j).TrueLabel);
        elseif iscell(misclassifiedInfo(j).TrueLabel)
            trueLabelStr = misclassifiedInfo(j).TrueLabel{1}; % Extracting content from cell
        else
            trueLabelStr = misclassifiedInfo(j).TrueLabel;
        end

        if isnumeric(misclassifiedInfo(j).PredictedLabel)
            predictedLabelStr = num2str(misclassifiedInfo(j).PredictedLabel);
        elseif iscell(misclassifiedInfo(j).PredictedLabel)
            predictedLabelStr = misclassifiedInfo(j).PredictedLabel{1}; % Extracting content from cell
        else
            predictedLabelStr = misclassifiedInfo(j).PredictedLabel;
        end

        titleTxt = sprintf('True: %s\nPredicted: %s', trueLabelStr, predictedLabelStr);
        title(titleTxt);
    end
    
    % Add heading
    sgtitle(['Misclassified Images using ', methodName], 'FontSize', 16, 'FontWeight', 'bold');
    
    % Add summary below the images
    summaryText = sprintf('Total Misclassified Images: %d', numMisclassified);
    annotation(fig, 'textbox', [0, 0.01, 1, 0.03], 'String', summaryText, 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', 'EdgeColor', 'none', 'FontSize', 12, 'FontWeight', 'bold');
end
