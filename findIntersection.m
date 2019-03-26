function [p] = findIntersection(L)
% L: a 3xN matrix of line coefficients
% p: a 3x1 vector of (homogenous) point coefficients
[U D V] = svd(L');
% vanishing point is the eigenvector
% corresponding to the minimum eigenvalue.
p = V(:,3)/V(3,3);
end
