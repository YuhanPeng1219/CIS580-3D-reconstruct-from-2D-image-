function showReprojections(im1,im2,U1,U2,P1,P2,K,T,R)
% Show the projections of P1 points in camera 2
% and the projections of P2 points in camera 1
%
% Since rows of P1 are expressed in camera frame 1
% (and rows of P2 in camera frame 2), you first need to 
% apply the 3D transformation (R,T) in the right direction,
% then apply K, then normalize by the third coordinate (this
% last step is taken care of in the call to 'plot' as you can
% see).

figure()

subplot(1,2,1)
imshow(im1);
hold on; 
% Your code goes here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P2proj = (K*((R)'*(P2'-T)))';

% End of your code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(P2proj(:,1)./P2proj(:,3),P2proj(:,2)./P2proj(:,3),'bs');
% Plot 'local' image points for comparison: ideally each blue
% square should be right on top of a red circle.
% The distance between a point and its reprojection from the other
% camera point is called the reprojection error (duh!)
plot(U1(:,1),U1(:,2),'ro');



subplot(1,2,2)
imshow(im2);
hold on; 
% Your code goes here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P1proj = (K*(R*P1'+T))';

% End of your code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(P1proj(:,1)./P1proj(:,3),P1proj(:,2)./P1proj(:,3),'bs');
plot(U2(:,1),U2(:,2),'ro');
