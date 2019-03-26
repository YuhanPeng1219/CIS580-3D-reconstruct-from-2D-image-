function [E, bestInliers] = estimateEmatrixRANSAC(X1,X2)
% Estimate E matrix given a set of 
% pairs of matching *calibrated* points
% X1,X2: Nx2 matrices of calibrated points
%   i^th row of X1 matches i^th row of X2
%
% E: robustly estimated E matrix
% bestInliers: indices of the rows of X1 (and X2) that where in the
% largest consensus set

nIterations = 500;
sampleSize = 8;

fractionInliers = 0.6;
nInliers = floor((size(X1,1) - sampleSize) * fractionInliers);
bestError = Inf;
eps = 10^(-4);
bestNInliers = 0;

for i=1:nIterations
    indices = randperm(size(X1,1));
    sampleInd = indices(1:sampleSize);
    testInd =  indices(sampleSize+1:length(indices));
    
    % Your code goes here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % compute sample E
    E1 = estimateEmatrix(X1(sampleInd, :), X2(sampleInd, :));
    E_sample = E1;
    
    % compute d12 and d21, d12 = d(x2, epi(x1))^2, d21 = d(x1, epi(x2))^2
    e_hat = [0,-1,0;
             1,0,0;
             0,0,0];
    R_X1 = [X1(testInd, :), ones(size(testInd,2),1)];
    R_X2 = [X2(testInd, :), ones(size(testInd,2),1)];
    
    e2 = (E_sample*R_X1')';          % N*3
    nomi12 = sum((R_X2 .* e2),2).^2; % sum(N*3) 
    denomi12 = (sum((e_hat*(e2)').^2, 1));
    d12 = nomi12'./denomi12;
    
    e1 = (R_X2*E_sample);            %N*3
    nomi21 = sum((R_X1 .* e1),2).^2; %sum(N*3)
    denomi21 = (sum((e_hat*(e1)').^2, 1));
    d21 = nomi21'./denomi21;    
    
    % compute residuals
    residuals = d12 + d21;  % Vector of residuals, same length as testInd.
                            % Can be vectorized code (extra-credit) 
                            % or a for loop on testInd
    lower_mat = residuals < eps;
    curInliers = [sampleInd, testInd(lower_mat)];    % don't forget to include the sampleInd
    
    % End of your code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    curNInliers = length(curInliers);

    if curNInliers > bestNInliers
        bestNInliers = curNInliers;
        bestInliers = curInliers;
        E = E_sample;
    end
end

disp(['Best number of inliers: ' num2str(bestNInliers) '/' num2str(size(X1,1))]); 
