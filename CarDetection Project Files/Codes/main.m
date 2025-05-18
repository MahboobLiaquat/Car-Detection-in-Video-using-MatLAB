clc;
clear all;
close all;
 warning off;
 % Read in video file
 vid = VideoReader('visiontraffic.avi');
 v = VideoWriter('smallSizeVideo.avi');
 open(v)
 while hasFrame(vid)
     frame = readFrame(vid);
     frame = imresize(frame, 1/2);
     writeVideo(v, frame);
 end
 close(v)
 
 % Read in video file
 vid = VideoReader('smallSizeVideo.avi');
 N = 150;
 n = 1;
 frame = readFrame(vid);
 [r, c, d] = size(frame);
 allNFrames = zeros(N, r, c);% initialize array for storing pixel
                               %intensities
 while hasFrame(vid) && n <= N
     % Read in the current frame
     frame = readFrame(vid);
        % Convert the frame to grayscale
     grayFrame = rgb2gray(frame);
     allNFrames(n, :, :) = grayFrame; %stores the pixel intensities of
                                       %each frame
     n = n + 1;
 end
 
 allHistograms = zeros(256, r, c);
 for i = 1 : r
     for j = 1 : c
         hist = myhist(allNFrames(:,i, j)); %hist is 1D array that stores
                                            %histogram of each pixel
         allHistograms(:, i, j) = double(hist);%convert to double-prec'n (64-bit) 
     end
 end
 delete hist;
 
 
 % Fit 3 Gaussian components to each histogram
 K = 3;
 gmmMU = zeros(K, r, c);
 gmmSigma = zeros(K, r, c);
 gmmMC = zeros(K, r, c);
 %vec1 = zeros(1, N);
 maxIter = 150;% max# of GMM fitting iterations
 for i = 1 : r
     i %useful for tracking the progress of the loop.
     for j = 1 : c
         % Fit Gaussian mixture model to histogram data
         vec = allHistograms(:, i, j);
         y = expandHist(vec);
         gmmModel = myfitgmdist(y', K, maxIter);% the histogram data is
         % passed on to myfitgmdist inorder to fit the GMM with K gaussians
         gmmMU(:, i, j)=gmmModel.mu;
         gmmSigma(:, i, j)=gmmModel.Sigma;
         gmmMC(:, i, j)=gmmModel.ComponentProportion;
           %the above stores the mean,sigma&mc of the fitted GMM
     end
 end

% Process each frame
save all;
load all;
warning off;
se = strel('square', 2);
[foreground, gmmMU, gmmSigma, gmmMC, allHistograms] = foregroundDetector(grayFrame, allHistograms, gmmMU, gmmSigma, gmmMC, K);

filteredForeground = imopen(foreground, se);
figure; imshow(filteredForeground); title('Clean Foreground');
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
'AreaOutputPort', false, 'CentroidOutputPort', false, ...
'MinimumBlobArea', 500);
bbox = step(blobAnalysis, filteredForeground);
result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
numCars = size(bbox, 1);
result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
'FontSize', 14);
figure; imshow(result); title('Detected Cars');

videoPlayer = vision.VideoPlayer('Name', 'Detected Cars');
videoPlayer.Position(3:4) = [650,400];  % window size: [width, height]
se = strel('square', 3); % morphological filter for noise removal

v = VideoWriter('newfile.avi');
open(v)
while hasFrame(vid) % Read in the current frame
    frame = readFrame(vid);
    grayFrame = rgb2gray(frame);
    [foreground, gmmMU, gmmSigma, gmmMC, allHistograms] = foregroundDetector(grayFrame, allHistograms, gmmMU, gmmSigma, gmmMC, K);
        imshow(uint8(foreground));
    filteredForeground = imopen(foreground, se);
     
     % Detect the connected components with the specified minimum area, and
     % compute their bounding boxes
     bbox = step(blobAnalysis, filteredForeground);
     
     % Draw bounding boxes around the detected cars
     result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green');
     
     % Display the number of cars found in the video frame
     numCars = size(bbox, 1);
     result = insertText(result, [10 10], numCars, 'BoxOpacity', 1, ...
         'FontSize', 14);
     
     step(videoPlayer, result);  % display the results
     writeVideo(v, result)
end
close(v)


