function h = myhist(x)
h = zeros(1, 256);
for i=1:length(x)
    %x is a one-dimensional array of pixel intensities, and
    %length(x) returns the total number of pixels in the array.
    h(x(i)+1) = h(x(i)+1) + 1;
end