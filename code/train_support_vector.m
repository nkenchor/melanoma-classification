function [cm, order] = train_support_vector(svm, groundtruth)
    % Perform classification using 10-fold cross validation
    rng(1); % Let's all use the same seed for the random number generator
    
    % Directly cross-validate the provided SVM model
    cvsvm = crossval(svm);
    pred = kfoldPredict(cvsvm);

    [cm, order] = confusionmat(groundtruth, pred);


    % Display results
    disp('10-Fold Cross-Validation Results:');
    disp('----------------------------------');
    
    % Confusion Matrix
    disp('Confusion Matrix:');
    disp(cm);
    disp('Order of Classes:');
    disp(order);
    
    % Evaluation Metrics
    accuracy = sum(diag(cm)) / sum(cm(:));
    disp(['Accuracy: ', num2str(accuracy * 100), '%']);
    
    % Assuming binary classification, calculate additional metrics
    if length(unique(groundtruth)) == 2
        TP = cm(1,1); 
        FP = cm(1,2);
        FN = cm(2,1);
        TN = cm(2,2);
    
        precision = TP / (TP + FP);
        recall = TP / (TP + FN);
        specificity = TN / (TN + FP);
        f1Score = 2 * (precision * recall) / (precision + recall);
    
        disp(['Precision: ', num2str(precision * 100), '%']);
        disp(['Recall: ', num2str(recall * 100), '%']);
        disp(['Specificity: ', num2str(specificity * 100), '%']);
        disp(['F1 Score: ', num2str(f1Score * 100), '%']);
    end
end
