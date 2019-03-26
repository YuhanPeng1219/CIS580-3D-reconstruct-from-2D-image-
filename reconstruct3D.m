function [P1,P2,T,R] = reconstruct3D(transfoCandidates,X1,X2)
% This functions selects (T,R) among the 4 candidates transfoCandidates
% such that all triangulated points are in front of both cameras.
% X1,X2: two Nx2 matrices of matching calibrated points
% transfoCandidates: output of poseCandidatesFromE.m
%
% T,R: optimal estimated transformation between cameras 1 and 2
% P1,P2: Nx3 matrices pf 3D coordinates of the triangualated points 
% for camera 1 and 2 (a row of P2 should be very close to a row 
% of P1 to which we apply R and T)


% We need to solve the system (triangulation) for each pair of points 
% lambda_2 [x2;1] = lambda_1 R * [x1;1] + T
% and we want lambda_1,lambda_2 > 0

nPoints = size(X1,1);
lambdas = {};
errors = zeros(length(transfoCandidates),1);
nFrontPts = zeros(length(transfoCandidates),1);

for i=1:length(transfoCandidates)
    R = transfoCandidates(i).R;
    T = transfoCandidates(i).T;
    lambdas{i} = zeros(2,nPoints);
    for pt=1:nPoints
        % Your code goes here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        lambdas{i}(:,pt) = pinv([[X2(pt,:),1]',-R*[X1(pt,:),1]'])*(T/norm(T));  % fill in least-squares optimal
                                                                        % [lambda_1; lambda_2] 
                                                                        % for a given pair
        if any(lambdas{i}(:,pt)<0)
           lambdas{i}(:,pt) = [0;0]; 
        end
        % End of your code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

    nFrontPts(i) = sum(lambdas{i}(1,:)>0 & lambdas{i}(2,:)>0);

    debug_mode = 0;
    % You can use this debug mode to see plot all four 
    % 3D reconstructed point clouds and display the 
    % corresponding R and T.
    % Can you guestimate the real R and T in our case?
    if debug_mode
        P1 = bsxfun(@times,[X1 ones(size(X1,1),1)],lambdas{i}(2,:)');
        P2 = bsxfun(@times,[X2 ones(size(X2,1),1)],lambdas{i}(1,:)');
        plotReconstruction(P1,P2,T,R);
        T
        R
        fractionsFrontPts = nFrontPts(i) ./ nPoints
        ginput(1);
    end
end

% Keep transformation with most front points
[best_n best_i]  = max(nFrontPts);
lambdas = lambdas{best_i};
P1 = bsxfun(@times,[X1 ones(size(X1,1),1)],lambdas(2,:)');
P2 = bsxfun(@times,[X2 ones(size(X2,1),1)],lambdas(1,:)');
R = transfoCandidates(best_i).R;
T = transfoCandidates(best_i).T;
end
