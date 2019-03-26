function E = estimateEmatrix(X1,X2)
% Estimate E matrix given a set of 
% pairs of matching *calibrated* points
% X1,X2: Nx2 matrices of calibrated points
%   i^th row of X1 matches i^th row of X2

% Kronecker products
% Your code goes here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = [X1, ones(size(X1,1),1)];
X2 = [X2, ones(size(X2,1),1)];
A = [X1(:, 1).* X2, X1(:,2).* X2, X1(:,3).*X2]; % Kronecker products

[~,~,V] = svd(A);
E_temp = V(:, end);
E = reshape(E_temp, 3,3);                       % Compute essential matrix

[U,~,V] = svd(E);
Diag = eye(3);
Diag(3,3)=0;
E = (U*Diag*V');                                % project E by redecomposing
% Project E on the space of essential matrices

% End of your code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end