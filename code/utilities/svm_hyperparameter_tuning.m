function [bestSVM, bestC, numFeatures] = svm_hyperparameter_tuning(features, labels)
    % Define possible hyperparameters to search
    C_vals = logspace(-3,3,7);
    bestAccuracy = 0;
    % Get number of features 
    numFeatures = size(features, 2);
    assert(size(features, 2) == length(labels), 'Mismatch between features and labels');

    for i = 1:length(C_vals)
        C = C_vals(i);
        svmModel = fitcsvm(features', labels, 'KernelFunction', 'linear', 'BoxConstraint', C);
        
        % Cross-validate and get the accuracy
        CVSVM = crossval(svmModel);
        accuracy = 1 - kfoldLoss(CVSVM);

        if accuracy > bestAccuracy
            bestAccuracy = accuracy;
            bestSVM = svmModel;
            bestC = C;
        end
    end
end
