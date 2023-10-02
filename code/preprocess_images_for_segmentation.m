function [maskedImages, edgeImages, standardSize] = preprocess_images_for_segmentation(imagePaths, maskPaths)
    numImages = length(imagePaths);
    % numGaborFilters = 1;
    % Define the size to which all images should be resized.
    standardSize = [256, 256];
    
    % Preallocate for speed
    maskedImages = cell(1, numImages);
    edgeImages = cell(1, numImages);
    
    for i = 1:numImages
        % Read the image and mask
        image = imread(imagePaths{i});
        mask = imread(maskPaths{i});
        mask = mask > 128;

        % Image Enhancement using CLAHE on each channel
        if size(image, 3) == 3
            for channel = 1:3
                image(:,:,channel) = adapthisteq(image(:,:,channel), 'ClipLimit', 0.02);
                image(:,:,channel) = medfilt2(image(:,:,channel));
            end
        else
            image = adapthisteq(image, 'ClipLimit', 0.02);
            image = medfilt2(image);
        end

        % Gaussian Filtering to smooth out noise
        image = imgaussfilt(image, 2);

        % Normalize image data
        image = double(image) / 255;

        % Morphological Operations
        se = strel('disk', 3);
        image = imopen(image, se);

        % Apply the mask to the image
        maskedImage = bsxfun(@times, image, cast(mask, 'like', image));

        % Convert the image to grayscale if it's RGB
        if size(image, 3) == 3
            grayImage = rgb2gray(image);
        else
            grayImage = image;
        end

        % Gabor filtering
        % gaborFeatures = gabor_features(grayImage, numGaborFilters);
        
        % Reshape Gabor features to a vector and concatenate to feature matrix
        % gaborFeatures = reshape(gaborFeatures, [size(grayImage, 1) * size(grayImage, 2), numGaborFilters]);
        
        % Adaptive thresholding
        thresholded = adaptive_threshold(grayImage);
        
        % Resize the masked image and thresholded image to the standard size
        resizedMaskedImage = imresize(maskedImage, standardSize);
        resizedThresholdedImage = imresize(thresholded, standardSize);
        
        % Store the masked and thresholded images for segmentation
        maskedImages{i} = resizedMaskedImage;
        edgeImages{i} = resizedThresholdedImage;
    end
end


% function gaborFeatures = gabor_features(image, numFilters)
%     gaborFeatures = [];
%     [rows, cols] = size(image);
% 
%     % Create Gabor filter bank
%     gaborBank = cell(1, numFilters);
%     for i = 1:numFilters
%         wavelength = 4 + i * 2; % Adjust wavelength for each filter
%         orientation = i * pi / numFilters; % Equally spaced orientations
%         gaborBank{i} = gabor(wavelength, orientation);
%     end
% 
%     for i = 1:numFilters
%         % Apply Gabor filter
%         filteredImage = imfilter(image, gaborBank{i}.SpatialKernel);
% 
%         % Reshape filtered image to a vector and concatenate to feature matrix
%         gaborFeatures = [gaborFeatures, reshape(filteredImage, rows * cols, 1)];
%     end
% end
% 


function thresholdedImage = adaptive_threshold(image)
    thresholdedImage = adaptthresh(image, 0.4); % You can adjust the threshold value
    thresholdedImage = imbinarize(image, thresholdedImage);
end
