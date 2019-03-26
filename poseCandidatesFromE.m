function [transfoCandidates] = poseCandidatesFromE(E)
% Return the 4 possible transformations for an input matrix E
% transfoCandidates(i).T is the 3x1 translation
% transfoCandidates(i).R is the 3x3 rotation

transfoCandidates = repmat(struct('T',[],'R',[]),[4 1]);
% Fill in the twisted pair for E and the twisted pair for -E
% The order does not matter.
[U,S,V]=svd(E);
% [u,s,v]=svd(-E);
Rz = [0,-1,0;1,0,0;0,0,1];
T_hat1 = U*Rz*S*U';
T_hat2 = U*(Rz')*S*U';
T_hat3 = U*Rz*S*U';
T_hat4 = U*(Rz')*S*U';

R1 = U*Rz*V';
R2 = U*Rz'*V';
R3 = U*Rz'*V';
R4 = U*Rz*V';

T1 = solve_hat(T_hat1);
T2 = solve_hat(T_hat2);
T3 = solve_hat(T_hat3);
T4 = solve_hat(T_hat4);

if det(R1) < 0 
    T1 = -T1; R1 = -R1;
end
if det(R2) < 0 
    T2 = -T2; R2 = -R2;
end
if det(R3) < 0 
    T3 = -T3; R3 = -R3;
end
if det(R4) < 0 
    T4 = -T4; R4 = -R4;
end

transfoCandidates(1).T = T1;
transfoCandidates(2).T = T2;
transfoCandidates(3).T = T3;
transfoCandidates(4).T = T4;

% transfoCandidates(1).T = U(:,3);
% transfoCandidates(2).T = -U(:,3);
% transfoCandidates(3).T = u(:,3);
% transfoCandidates(4).T = -u(:,3);

transfoCandidates(1).R = R1;
transfoCandidates(2).R = R2;
transfoCandidates(3).R = R3;
transfoCandidates(4).R = R4;
% Your code goes here %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



end
function t=solve_hat(t_hat)
    t=[t_hat(3,2); t_hat(1,3); t_hat(2,1)];
end
% End of your code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%