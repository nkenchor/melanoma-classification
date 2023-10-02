function texture_features = extract_texture_features(img)
    fprintf('Extracting texture features...\n');
    
    % Convert the image to grayscale if it's not already
    gray_img = rgb2gray(img);
    
    % Compute texture features using Haralick features
    glcm = graycomatrix(gray_img, 'Offset', [0 1], 'Symmetric', true);
    stats = graycoprops(glcm, {'Contrast', 'Energy', 'Homogeneity'});
    
    % Concatenate texture features into a vector
    texture_features = [cat(1, stats.Contrast); cat(1, stats.Energy); cat(1, stats.Homogeneity)];
end