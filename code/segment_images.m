function [segmentedImages] = segment_images(maskedImages, segmentationMethod)
    numImages = length(maskedImages);
    
    % Preallocate for speed
    segmentedImages = cell(1, numImages);
    
    for i = 1:numImages
        % Get the masked image and convert to grayscale once
        maskedImage = maskedImages{i};
        if size(maskedImage, 3) == 3
            I_gray = rgb2gray(maskedImage);
        else
            I_gray = maskedImage;
        end
        
        switch segmentationMethod
            case 'none'
                segmentedImages{i} = maskedImage; % No segmentation, just return the original image
                
            case 'threshold'
                BW = segment_threshold(I_gray);
                segmentedImages{i} = apply_segmentation(maskedImage, BW);
                
            case 'edge'
                BW = segment_edge(I_gray);
                segmentedImages{i} = apply_segmentation(maskedImage, BW);
                
            case 'watershed'
                BW = segment_watershed(I_gray);
                segmentedImages{i} = apply_segmentation(maskedImage, BW);
                
            otherwise
                error('Unknown segmentation method: %s', segmentationMethod);
        end
    end
end

function segmented = apply_segmentation(maskedImage, BW)
    % Remove small noise regions
    BW = bwareaopen(BW, 50);  % Remove regions smaller than 50 pixels
    % Multiply the masked image by the segmentation result to retain regions of interest
    segmented = bsxfun(@times, maskedImage, cast(BW, 'like', maskedImage));
end

function BW = segment_threshold(image)
    % Using adaptive binarization
    BW = imbinarize(image, 'adaptive', 'Sensitivity', 0.6);  % Experiment with Sensitivity value
end

function BW = segment_edge(image)
    BW = edge(image, 'Canny');
    % Add additional post-processing to close small gaps and smooth edges if needed
    BW = imclose(BW, strel('disk', 2));
end

function BW = segment_watershed(image)
    % Smoothing
    I_smooth = imgaussfilt(image, 2.5);  % Adjusting Gaussian filter's standard deviation

    % Edge detection
    [~, threshold] = edge(I_smooth, 'sobel');
    fudgeFactor = 0.4;  % Adjusting fudge factor
    BW_sobel = edge(I_smooth, 'sobel', threshold * fudgeFactor);

    % Distance transform
    D = bwdist(~BW_sobel);
    D = -D;  % Negate the distance map

    % Watershed
    mask = imextendedmin(D, 3);  % Adjusting value
    D2 = imimposemin(D, mask);
    L = watershed(D2);
    BW = L > 1;  % Extract segmentation
end
