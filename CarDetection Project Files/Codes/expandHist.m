function out = expandHist(hist)
%takes a histogram as input and expands it into a vector that contains the pixel intensity values. 

[x, id] = find(hist ~= 0); %finds all non-zero indices of pixel intensities and stores them in 'x'
out = [];%initialize empty vector to store the expanded histogram
for i = 1 : length(x)
    out = [out, repmat((x(i)-1), 1, hist(x(i)))]; % "1" means only one row
    % adds the pixel intensity value x(i)-1 to the out vector hist(x(i)) times. 
    %The repmat function repeats the pixel intensity value "x(i)-1"  "hist(x(i))" times to create 
    %a vector of length hist(x(i)). 
    %This vector is then concatenated with the out vector to create the expanded histogram.
end
%loop continues until all non-zero values in hist have been processed.
