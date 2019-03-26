function drawLines(L,h,w)
% L: 3xN matrix of line parameters for N lines
% h,w: height and width of figure

hold on;
for i=1:size(L,2)
    %ezplot([num2str(L(1,i)) '*x+' num2str(L(2,i)) '*y+' num2str(L(3,i)) '=0'],...
    %       [0 w 0 h]);
    if abs(L(1,i)/L(2,i)) < 1
        y0 = -L(3,i) / L(2,i);
        yw = y0 - w * L(1,i) / L(2,i);
        plot([0 w],[y0 yw]);
    else
        x0 = -L(3,i) / L(1,i);
        xh = x0 - h * L(2,i) / L(1,i);
        plot([x0 xh],[0 h]);
    end
end
