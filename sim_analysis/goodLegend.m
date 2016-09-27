function [] = goodLegend(axisHandle, cMap,xDims,yDims)
%xDims = [maxL maxR startL]

myMap = cMap;

axes(axisHandle);
w = 4;
%yl = [0 300];
yl = yDims;
%xl = [0 50];
xl = xDims;
%yo = 0.064*(yl(2)-yl(1));
yo = yl(3);
l1 = yl(3);%yl(2) - .1*(yl(2)-yl(1));
l2 = l1-.1*(yl(2)-yl(1));
l3 = l1-.2*(yl(2)-yl(1));
xinit = [xl(3) xl(3)*1.7];
xo = xl(3);
xo2 = 2*xo
tyo = 4.5;

plot(xinit,[l1 l1],'Color',myMap(1,:),'LineWidth',3); hold on;
plot(xinit,[l2 l2],'Color',myMap(2,:),'LineWidth',3);
plot(xinit,[l3 l3],'Color',myMap(3,:),'LineWidth',3);

plot(xo+xinit,[l1 l1],'Color',myMap(4,:),'LineWidth',3); hold on;
plot(xo+xinit,[l2 l2],'Color',myMap(5,:),'LineWidth',3);
plot(xo+xinit,[l3 l3],'Color',myMap(6,:),'LineWidth',3);

plot(xo2+xinit,[l1 l1],'Color',myMap(7,:),'LineWidth',3); hold on;
plot(xo2+xinit,[l2 l2],'Color',myMap(8,:),'LineWidth',3);
plot(xo2+xinit,[l3 l3],'Color',myMap(9,:),'LineWidth',3);

text(xinit(1)-5,l1,'Iron Load');
text(xinit(1)-5,l1-7,'[mg Fe/g dry tissue]');

text(xinit(1)-1,l1-tyo,'1');
text(xinit(1)-1,l2-tyo,'5');
text(xinit(1)-1,l3-tyo,'10');

text(xinit(1)+xo-1,l1-tyo,'15');
text(xinit(1)+xo-1,l2-tyo,'20');
text(xinit(1)+xo-1,l3-tyo,'25');

text(xinit(1)+xo2-1,l1-tyo,'30');
text(xinit(1)+xo2-1,l2-tyo,'35');
text(xinit(1)+xo2-1,l3-tyo,'40');