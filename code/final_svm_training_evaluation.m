function results = final_svm_training_evaluation(model, testFeatures, testLabels)
    
    % Validate input dimensions
    if size(model.SupportVectors, 2) ~= size(testFeatures, 2)
      error('Number of features mismatch!'); 
    end
    
    % Predict labels 
    predictedLabels = predict(model, testFeatures);
    
    % Get confusion matrix
    cm = confusionmat(testLabels, predictedLabels);
    
    % Compute accuracy
    accuracy = sum(diag(cm)) / sum(cm(:));
    
    % Compute precision, recall, F1 for each class
    numClasses = size(cm, 1);
    classMetrics = zeros(numClasses, 3);
    
    for i = 1:numClasses
        TP = cm(i,i);
        FP = sum(cm(:,i)) - TP;
        FN = sum(cm(i,:)) - TP;
        
        % Calculate precision
        if TP + FP == 0
            precision = 0;
        else
            precision = TP / (TP + FP);
        end
        
        % Calculate recall
        if TP + FN == 0
            recall = 0;
        else
            recall = TP / (TP + FN);
        end
        
        % Calculate F1 score
        if precision + recall == 0
            F1 = 0;
        else
            F1 = 2 * precision * recall / (precision + recall);
        end
        
        classMetrics(i,:) = [precision, recall, F1]; 
    end
    
    % Get average metrics
    avgPrecision = mean(classMetrics(:,1));
    avgRecall = mean(classMetrics(:,2)); 
    avgF1 = mean(classMetrics(:,3));
    
    % Create results struct
    results.Accuracy = accuracy; 
    results.ConfusionMatrix = cm;
    results.Precision = avgPrecision;
    results.Recall = avgRecall; 
    results.F1 = avgF1;

end
