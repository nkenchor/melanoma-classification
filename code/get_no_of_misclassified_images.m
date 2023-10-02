function numMisclassified = get_no_of_misclassified_images(bestSVM, featureSet, groundTruthLabels)
    expectedFeatures = 768;
    
    % Check for feature mismatch
    if size(featureSet, 2) ~= expectedFeatures
        disp(['Feature mismatch. Expected ', num2str(expectedFeatures), ' features but got ', num2str(size(featureSet, 2)), '. Skipping...']);
        numMisclassified = NaN;  % Not a number, indicating an error
        return;
    end
        
    % Predict labels using the SVM
    predictedLabels = predict(bestSVM, featureSet);
    
    % Convert to numeric array if they are cell arrays
    if iscell(predictedLabels)
        predictedLabels = cell2mat(predictedLabels);
    end
    if iscell(groundTruthLabels)
        groundTruthLabels = cell2mat(groundTruthLabels);
    end

    % Find misclassified indices
    misclassifiedIndices = find(predictedLabels ~= groundTruthLabels);

    % Return the number of misclassified images
    numMisclassified = length(misclassifiedIndices);
end
