function misclassifiedInfo = capture_misclassified_images(bestSVM, featureSet, groundTruthLabels, lesionImages, segmentationMethod)
    expectedFeatures = 768;
    misclassifiedInfo = struct('Image', {}, 'TrueLabel', {}, 'PredictedLabel', {}, 'SegmentationMethod', {});

    % Check for feature mismatch
    if size(featureSet, 2) ~= expectedFeatures
        disp(['Feature mismatch for method ', segmentationMethod, '. Expected ', num2str(expectedFeatures), ' features but got ', num2str(size(featureSet, 2)), '. Exiting...']);
        return;
    end
        
    [numSamples, numFeatures] = size(featureSet);
    disp(['Number of Samples: ', num2str(numSamples), ', Number of Features: ', num2str(numFeatures)]);

    % Predict labels using the SVM
    predictedLabels = predict(bestSVM, featureSet);

    % Convert to numeric array if they are cell arrays
    if iscell(predictedLabels) && isnumeric(predictedLabels{1})
        predictedLabels = cell2mat(predictedLabels);
    end
    if iscell(groundTruthLabels) && isnumeric(groundTruthLabels{1})
        groundTruthLabels = cell2mat(groundTruthLabels);
    end

    disp(['Format of predicted labels after conversion: ', class(predictedLabels)]);
    disp(['Format of ground truth labels after conversion: ', class(groundTruthLabels)]);

    % Safe comparison of labels
    if iscell(predictedLabels) && iscell(groundTruthLabels)
        mismatches = cellfun(@(x,y) ~(isequal(x, y)), predictedLabels, groundTruthLabels, 'UniformOutput', false);
        misclassifiedIndices = find(cell2mat(mismatches));
    else
        misclassifiedIndices = find(predictedLabels ~= groundTruthLabels);
    end

    % Store misclassified images and details
    for misIdx = misclassifiedIndices'
        misInfo.Image = lesionImages{misIdx};
        misInfo.TrueLabel = groundTruthLabels(misIdx);
        misInfo.PredictedLabel = predictedLabels(misIdx);
        misInfo.SegmentationMethod = segmentationMethod;
        misclassifiedInfo(end+1) = misInfo;
    end

    if isempty(misclassifiedInfo)
        disp('No misclassified images found.');
    end
end
