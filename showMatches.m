function showMatches(im1,im2,f1,f2,matches,horiz_flag)
%Create display containing both images
horiz = false;
if nargin > 5
    horiz = horiz_flag;
end

h1 = size(im1,1); w1 = size(im1,2);
h2 = size(im2,1); w2 = size(im2,2);
nChannels = size(im1,3);
if horiz
    display = uint8(zeros(max(h1,h2), w1 + w2, nChannels));
    display(1:h1,1:w1,:) = im1;
    display(1:h2,w1+1:w1+w2,:) = im2;
    %Modify f2 positions to plot at the right position in the display
    f2(1,:) = f2(1,:) + w1;
else
    display = uint8(zeros(h1 + h2, max(w1, w2), nChannels));
    display(1:h1,1:w1,:) = im1;
    display(h1+1:h1+h2,1:w2,:) = im2;
    %Modify f2 positions to plot at the right position in the display
    f2(2,:) = f2(2,:) + h1;
end            

figure()
imshow(display);
hold on;
h1 = vl_plotframe(f1(:,matches(1,:)));
h2 = vl_plotframe(f1(:,matches(1,:)));
set(h1,'color','k','linewidth',3);
set(h2,'color','y','linewidth',2);
h1 = vl_plotframe(f2(:,matches(2,:)));
h2 = vl_plotframe(f2(:,matches(2,:)));
set(h1,'color','k','linewidth',3);
set(h2,'color','y','linewidth',2);

cmap = hsv(size(matches,2));
for i=1:size(matches,2)
    plot([f1(1,matches(1,i)) f2(1,matches(2,i))], ...
         [f1(2,matches(1,i)) f2(2,matches(2,i))], ...
         'Color', cmap(i,:));
end



