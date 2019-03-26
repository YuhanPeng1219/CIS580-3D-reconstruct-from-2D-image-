% CIS580 Final exam
% 3D point cloud reconstruction from two 2D views


% IMPORTANT: you first need to initialized VLFeat
% This can be done once at the beginning of your Matlab session
% (You can add the command to your startup.m file)
%
% run('[path-to-vlfeat]/toolbox/vl_setup.m');

close all;
clear
load images
nImages = length(images);

%% Compute the SIFT features
% 
gray = {}; f = {}; d = {};
for i=1:nImages
    % vl_sift only takes gray single inputs
    gray{i} = single(rgb2gray(images{i}));
    [f{i},d{i}] = vl_sift(gray{i});
end

%% Match features across the two images
nInitialMatches = 400;
[matches,scores] = vl_ubcmatch(d{1},d{2});
% Sort matches by decreasing score and keep nInitialMatches
[foo indices] = sort(scores,'descend');
scores = scores(indices);
matches = matches(:,indices);
matches = matches(:,1:min(nInitialMatches,size(matches,2)));

% Small function to display the matches
% Play a bit with this and try to display only 
% some of the matches, say half of them
showMatches(images{1},images{2},...
            f{1},f{2},...
            matches);


%% Calibration       (part 2.1)
% You can comment out the calibration function call
% Once you are done with this part

load calib_images
% K = vanishingCalibration(calib_images{1}); % or 2,3...

% The output of your calibration should be 
% close to the following matrix:
K = [552 0  307.5;...
     0  552 205;...
     0   0   1 ];
%
% In the following parts, you can use this K matrix
% even if your calibration seems too different


%% Estimation of E  (part 2.2)
U1 = f{1}(1:2,matches(1,:))';
U2 = f{2}(1:2,matches(2,:))';

% Compute calibrated coordinates
% Your code goes here %%%%%%%%%%%%%%%%%%%%%
U11 = [U1, ones(size(U1,1),1)];
U22 = [U2, ones(size(U2,1),1)]; % Change into P2
X1 = (K \ U11')';   % as a function of U1 and K
X2 = (K \ U22')';   % as a function of U2 and K
X1 = (X1(:, 1:2));
X2 = (X2(:, 1:2));
% End of your code %%%%%%%%%%%%%%%%%%%%%%%%

% Flip this flag to true in the RANSAC part
useRANSAC = 1;
if useRANSAC==false
    % First method: just SVD
    E = estimateEmatrix(X1,X2);
else
    % RANSAC
    [E, inliers] = estimateEmatrixRANSAC(X1,X2);
end

% Show the epipolar lines based on E
if useRANSAC==false
    drawEpipolarLines(images{1},images{2},...
                      U1,U2, ...
                      E,K);
else
    % Show only inliers!
    drawEpipolarLines(images{1},images{2},...
                      U1(inliers,:),U2(inliers,:), ...
                      E,K);
    % Show the selected matches: many spurious matches 
    % should be eliminated
    % (Compare to the call to showMatches at the beginning
    % of the script)
    showMatches(images{1},images{2},...
                f{1},f{2},...
                matches(:,inliers));
end


%% Pose recovery and 3D reconstruction  (part 2.3)

transfoCandidates = poseCandidatesFromE(E);
[P1,P2,T,R] = reconstruct3D(transfoCandidates,X1,X2);

% Show point cloud and camera centers in camera frame 2
plotReconstruction(P1,P2,T,R);

% Show the projections of P2 points in image 1 
% and P1 points in image 2
showReprojections(images{1}, ...
                 images{2},...
                 U1,U2,P1,P2,K,T,R); 
