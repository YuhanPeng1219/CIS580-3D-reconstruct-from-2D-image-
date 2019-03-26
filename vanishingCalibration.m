function [K] = vanishingCalibration(im)
% Calibrate camera from three vanishing points
% Assumption: no pixel distortion, just: 
% - focal length f
% - camera center projection: 3x1 homogeneous vector c = [u0;v0;1]

% Click on points and intersect lines to locate vanishing points
nPoints = 1; % number of points to estimate a line
nLines = 1;  % numer of lines to estimate a vanishing point

v = zeros(3,3); % three vanishing points vi = v(:,i)

L = {};
for v_num = 1:3               % loop through vanishing pts to estimate
    L{v_num} = zeros(3,nLines);
    for line_num = 1:nLines   % loop through lines intersecting at
                              % a given vanishing point
        disp(['Line ' num2str(line_num) ' going through v' num2str(v_num)]);
        L{v_num}(:,line_num) = fitLine(im,nPoints);
    end
    v(:,v_num) = findIntersection(L{v_num});
end


% Focal length estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We want to solve a linear system for s = 1/f^2
v = 1e3*[    -0.4384    1.2019    0.2105
   -0.5377   -0.2077    0.7743
    0.0010    0.0010    0.0010];
% Your code goes here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[h1, l1_base] = compute_height(v(:,1), v(:,2), v(:,3));
[h2, l2_base] = compute_height(v(:,2), v(:,3), v(:,1));
[h3, l3_base] = compute_height(v(:,3), v(:,1), v(:,2));
intersect = cross(h2, h3);
intersect = intersect/intersect(3);
d = compute_d(l2_base, h2, intersect, v(:,2), v(:,3));
f = sqrt(d(1)*d(2)-d(3)^2);
% f = 1 / sqrt(s);
% End of your code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Projection center estimation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute [u0;v0;1] as the  orthocenter of v1,v2,v3
% Use orthogonality equations to define a least-square problem and
% solve it

% Your code goes here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A = [h1';h2';h3'];
% [~,~,V]=svd(A);
% image_center = V(:,end);
% c = image_center/image_center(3); % Vector [u0;v0;1]
c=intersect;
% End of your code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = [f 0 c(1); 
     0 f c(2); 
     0 0 1];
end
%% ****************** Function to compute height **************************
function [height, l_base] = compute_height(p1, p2, v3)
l_base = cross(p1, p2);
l_base = l_base/l_base(3);
k = l_base(2)/l_base(1);
h = [k;-1;-k*v3(1)+v3(2)];
height = h/h(3);
end

%% ****************** Function to compute d1, d2, d3 **********************
function d = compute_d(l_base, h, intersect, p1, p2)
d = zeros(1,3);
D = cross(h, l_base);
D = D/D(3);
d(1) = norm(D-p1);
d(2) = norm(D-p2);
d(3) = norm(D-intersect); 
end