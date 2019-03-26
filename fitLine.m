function [l] = fitLine(im,n)
% n: number of points per line
% l: a 3x1 vector of line coefficients
if numel(im) > 0
    figure();
    imshow(im);
end
title(['Please click ' num2str(n) ' points to estimate line']);
data = ginput(n);
data = [data ones(n,1)];
[U D V] = svd(data);
l = V(:,3);
if numel(im) > 0
    close(gcf);
end