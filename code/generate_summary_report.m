function generate_summary_report(segmentationMethods, lesionImages, accuracyResults, resultsTables, orders)
    % Initialize arrays for table generation
    numMethods = length(segmentationMethods);
    methodsArray = segmentationMethods(:); % ensure it's a column vector
    numImagesArray = repmat(size(lesionImages, 2), numMethods, 1);
    accuracies = zeros(numMethods, 1);
    precisions = zeros(numMethods, 1);
    recalls = zeros(numMethods, 1);
    f1s = zeros(numMethods, 1);
    specificities = zeros(numMethods, 1);
    classOrder = cell(numMethods, 1);
    misClassified = zeros(numMethods,1);
    
    % Extract values for each segmentation method
    for i = 1:numMethods
        accuracies(i) = accuracyResults(i) * 100; % Convert to percentage
        precisions(i) = resultsTables{i}.Precision * 100; % Convert to percentage
        recalls(i) = resultsTables{i}.Recall * 100; % Convert to percentage
        f1s(i) = resultsTables{i}.F1_Score * 100; % Convert to percentage
        specificities(i) = resultsTables{i}.Specificity * 100; % Convert to percentage
        classOrder{i} = strjoin(orders{i}, ', ');
        misClassified(i) = resultsTables{i}.Num_Misclassified;
        
       

    end
    
    % Create a summary table
    summaryTable = table(methodsArray, numImagesArray, accuracies, precisions, recalls, f1s, specificities, classOrder, misClassified);
    
    % Display the table
    disp(summaryTable);
    
    % Highlight the best model based on highest accuracy
    [~, bestIndex] = max(accuracies);
    disp(['The best model is: ', segmentationMethods{bestIndex}, ' with an accuracy of ', num2str(accuracies(bestIndex)), '%']);
    
  

end
