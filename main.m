% main.m

% Ensure the entire project is in the MATLAB path
addpath(genpath(pwd));

% Parameters
numBins = 256; % Number of bins for histogram

% Paths
lesionDir = fullfile(pwd, 'data', 'lesionimages');
maskDir = fullfile(pwd, 'data', 'masks');
groundTruthFile = fullfile(pwd, 'data', 'groundtruth.txt');

% Step 1: Read Data
disp('### STEP 1: Reading Data ###');

[lesionImages, maskImages, groundTruthLabels] = read_data(lesionDir, maskDir, groundTruthFile);
disp(['Number of lesion Images loaded: ', num2str(length(lesionImages))]);
disp(['Number of mask Images loaded: ', num2str(length(maskImages))]);
disp(['Number of ground truth labels loaded: ', num2str(length(groundTruthLabels))]);

disp('--- Step 1 Completed ---');

% Step 2: Preprocess Images for segmentation
disp('### STEP 2: Preprocessing Images for segmentation ###');

disp('### ---- Please wait. This process will take up to 120 seconds! ---- ###');
[maskedImages, standardSize] = preprocess_images_for_segmentation(lesionImages, maskImages);
disp(['Number of masked images: ', num2str(length(maskedImages))]);

disp('--- Step 2 Completed ---');

% Define segmentation methods for evaluation
segmentationMethods = {'none', 'threshold', 'edge', 'watershed'};
accuracyResults = zeros(1, length(segmentationMethods));
confusionMatrices = cell(1, length(segmentationMethods));
orders = cell(1, length(segmentationMethods));
resultsTables = cell(1, length(segmentationMethods));

% Storage for SVMs and features
bestSVMs = cell(1, length(segmentationMethods));
featureSets = cell(1, length(segmentationMethods));
misclassifiedInfoStore = cell(1, length(segmentationMethods));

% Iterate through each segmentation method and evaluate
for idx = 1:length(segmentationMethods)
    currentMethod = segmentationMethods{idx};
    disp(['### EVALUATION FOR: ', currentMethod, ' ###']);
    
    % Step 3: Segmenting Images
    disp(['### STEP 3: Segmenting Images FOR: ', currentMethod, ' ###']);

    if strcmp(currentMethod, 'none')
        segmentedImages = maskedImages;
    else
        segmentedImages = segment_images(maskedImages, currentMethod);
    end
    disp(['Number of segmented images: ', num2str(length(segmentedImages))]);

    disp('--- Step 3 Completed ---');
    
    % Step 4: Extract Features
    disp(['### STEP 4: Extracting Features FOR: ', currentMethod, ' ###']);

    features = extract_all_features(segmentedImages, numBins);
    disp(size(features));
    assert(size(features, 2) == length(groundTruthLabels), 'Mismatch between features and ground truth labels');
    
    disp(['Number of feature vectors: ', num2str(size(features, 1))]);
    disp(['Number of ground truth labels: ', num2str(length(groundTruthLabels))]);

    disp('--- Step 4 Completed ---');

    % Store the features for each method
    featureSets{idx} = features';
    
    % Step 5: Hyperparameter tuning for SVM
    disp(['### STEP 5: Hyperparameter tuning for SVM: ', currentMethod, ' ###']);

    [bestSVM, bestC, ~] = svm_hyperparameter_tuning(features, groundTruthLabels(:));
    disp(['Best C Value: ', num2str(bestC)]);

    disp('--- Step 5 Completed ---');

    % Store the SVM for each method
    bestSVMs{idx} = bestSVM;
    
    % Step 6: Cross-validate SVM
    disp(['### STEP 6: Evaluating SVM using Cross-validation FOR: ', currentMethod, ' ###']);

    [cm, order] = train_support_vector(bestSVM, groundTruthLabels);
    disp('Confusion Matrix:');
    disp(cm);
    disp('Order of Classes:');
    disp(order);

    disp('--- Step 6 Completed ---');
    
    % Step 7: Evaluate SVM
    disp(['### STEP 7: SVM Evaluation FOR: ', currentMethod, ' ###']);

    [accuracy, precision, recall, f1, specificity, misclassifiedInfo] = svm_evaluation(bestSVM, features, groundTruthLabels, maskedImages, currentMethod);
    misclassified = length(misclassifiedInfo);
    resultsTable = table(accuracy, precision, recall, f1, specificity, misclassified, 'VariableNames', {'Accuracy', 'Precision', 'Recall', 'F1_Score', 'Specificity', 'Num_Misclassified'});

    disp(resultsTable);
 
    disp(['Shape of groundTruthLabels: ', num2str(size(groundTruthLabels))]);

    disp('--- Step 7 Completed ---');
    
    % Store results
    accuracyResults(idx) = accuracy;
    confusionMatrices{idx} = cm;
    orders{idx} = order;
    resultsTables{idx} = resultsTable;
    misclassifiedInfoStore{idx} = misclassifiedInfo; 
  
 
    disp(['### END OF EVALUATION FOR: ', currentMethod, ' ###']);
    disp('------------------------------------------------------');
    sizeOfFeatureSet = size(featureSets{idx});
    disp(['Size of Feature Set for ', segmentationMethods{idx}, ': ', num2str(sizeOfFeatureSet)]);

end

% Step 8: Generate Summary Report
disp('### STEP 8: Generating Summary Report ###');

generate_summary_report(segmentationMethods, lesionImages, accuracyResults, resultsTables, orders);

disp('--- Step 8 Completed ---');

disp('### STEP 9: Visualization ###');
% Visualize Confusion Matrices

for idx = 1:length(segmentationMethods)
    visualize_confusion_matrices(confusionMatrices{idx}, orders{idx}, segmentationMethods{idx}, accuracyResults(idx), resultsTables{idx}.Precision, resultsTables{idx}.Recall, resultsTables{idx}.F1_Score, resultsTables{idx}.Specificity, idx);
end


% Display Misclassified Images for each segmentation method
for idx = 1:length(segmentationMethods)
    display_misclassified_images(misclassifiedInfoStore{idx}, segmentationMethods{idx});
end

% visualizing the colour histogram for about 10 images
visualize_color_histogram(lesionImages);

% visualizing accuracies
display_accuracy_barchart(accuracyResults, segmentationMethods);

disp('--- Step 9 Completed ---');

disp('### STEP 10: Saving model ###');
% Save results
modelPath = fullfile(pwd, 'results', 'trained_model.mat');
save(modelPath, 'bestSVMs', 'accuracyResults', 'confusionMatrices', 'orders', 'resultsTables', 'featureSets');
disp('--- Step 10 Completed ---');
