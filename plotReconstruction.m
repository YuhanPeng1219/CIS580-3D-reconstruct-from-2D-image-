function plotReconstruction(P1,P2,T,R)
% Plot the two point clouds and the two camera centers, 
% all in frame 2

P1trans = bsxfun(@plus,R*P1',T)';
figure()
hold on 

%Plot centers
plot3(0,0,0,'bs','MarkerFaceColor','k');
C1 = T;
plot3(C1(1),C1(3),C1(2),'ro','MarkerFaceColor','k');

%Plot rays
nPoints = size(P1,1);
for i=1:nPoints
    plot3([0 P2(i,1)],...
          [0 P2(i,3)],...
          [0 P2(i,2)],'bs-'); 

    plot3([C1(1) P1trans(i,1)],...
          [C1(3) P1trans(i,3)],...
          [C1(2) P1trans(i,2)],'ro-'); 
end
axis tight