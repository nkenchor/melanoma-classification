function geometric_features = extract_geometric_features(img)
    fprintf('Extracting geometric features...\n');
    
    % Convert the image to binary
    binary_img = imbinarize(rgb2gray(img));
    
    % Get region properties of the binary image
    stats = regionprops(binary_img, 'Area', 'Perimeter', 'Circularity', 'Eccentricity');
    
    % Calculate aspect ratio
    [rows, cols, ~] = size(img);
    aspect_ratio = cols / rows;
    
    % Concatenate geometric features into a vector
    geometric_features = [cat(1, [stats.Area]); cat(1, [stats.Perimeter]); cat(1, aspect_ratio); cat(1, [stats.Circularity]); cat(1, [stats.Eccentricity])];
end
