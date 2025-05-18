function [foreground, gmmMU, gmmSigma, gmmMC, allHistograms] = foregroundDetector(grayFrame, allHistograms, gmmMU, gmmSigma, gmmMC, K)
[r, c] = size(grayFrame);
background  = uint8(zeros(r, c));
for i = 1 : r
    for j = 1 : c  % Compute the distance between pixel intensity
                    %value X and the means of the GMM for pixel location
                    %(i,j),double precision floating point number.
        X = double(grayFrame(i, j));
        
        mu = gmmMU(:, i, j);
        
        sigma = gmmSigma(:, i, j);
        %calculates the Euclidean distance between the pixel value and each mean.
        dist = sqrt((X - mu).*(X - mu));
                        
        % Find the Gaussian component with the minimum distance
        
        [minDist, idx] = min(dist);
        %idx: index of the corresponding Gaussian component that has the 
        %minimum distance from the current pixel value X, determined by i,j
        s = gmmSigma(idx, i, j);

        % Check if the pixel value belongs to the selected Gaussian component
                
        if minDist < 2.5*s
            mc = gmmMC(idx, i, j); 
            if mc/s > .001
                background(i, j) = 1;   
                % lowest intensity is black and highest is white
            end
        end
        % histogram of the pixel values in the previous frame at location (i,j)
        vec1 = allHistograms(:, i, j);
        vec2 = vec1; 
        vec2(X + 1) = vec2(X + 1) + 1;
        %below the histograms are normalized (vec1/sum(vec1)
        if sqrt(sum((vec1/sum(vec1) - vec2/sum(vec2)) .^ 2)) > .009 %The Euclidean distance between the normalized histogram vectors
            % if .009 is taken as a threshold, a new GMM is fitted using
            % myfitgmdist function and the respective mean, sigma and mc
            % values are stored.
            y = expandHist(vec2);
            gmmModel = myfitgmdist(y', K, 4);
%             gmmMU(:, i, j)=gmmModel.mu;
%             gmmSigma(:, i, j)=sqrt(gmmModel.Sigma);
%             gmmMC(:, i, j)=gmmModel.ComponentProportion;
        end          
    end
end
foreground = 1 - background;
foreground = logical(foreground);
%"logical" converts image to logical data, where 0 is false and 1 is true
% so if foreground = 1 - 1, then it will be false =  black, otherwise,
% true/white.
