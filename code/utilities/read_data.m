function [lesionImagePaths, maskImagePaths, groundTruthLabels] = read_data(lesionDir, maskDir, groundTruthFile)
    % Get lesion image paths
    lesionFiles = dir(fullfile(lesionDir, '*.jpg'));
    lesionImagePaths = fullfile(lesionDir, {lesionFiles.name});

    % Get mask image paths
    maskFiles = dir(fullfile(maskDir, '*.png'));
    maskImagePaths = fullfile(maskDir, {maskFiles.name});

    % Load ground truth labels
    groundTruthData = readtable(groundTruthFile, 'Delimiter', ',', 'ReadVariableNames', false);
    groundTruthLabels = groundTruthData.Var2;
end
