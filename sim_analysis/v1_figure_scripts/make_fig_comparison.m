figName = 'Compare Constrained V. Unconstrained MonoExpC Fit B1+ Inhomo';
saveFileName = 'compareConstrains.pdf';

if ~exist('nset')
    nset=1;
end

eFig(figName,'size',[1600 800]);
titles(1).t = '\bf \fontsize{12}Non-negative';
titles(2).t = '\bf \fontsize{12}Bounded';
zlims = [0 1500];
s0zlims = [0 2000];
for n=nset:nset
    subplot(2,2,1); 
    h=surf(100*B1./90,FE,brUnc(n).R2,'LineStyle','-.','EdgeColor',[.2 .2 .2])
    get(h);
    zlim(zlims);
    caxis(zlims);
    xlabel('B_1^+ Level (%)');
    ylabel('Iron load (^{mg}/_g)');
    zlabel('R2 (sec^{-1})');
    title(titles(1).t);
     set(gca,'CameraPosition',[759.6 -196.6 5616.3],'CameraViewAngle',9.5466)
    subplot(2,2,1+2); surf(100*B1./90,FE,brUnc(n).S0,'LineStyle','-.','EdgeColor',[.2 .2 .2])
    xlabel('B_1^+ Level (%)');
    ylabel('Iron load (^{mg}/_g)');
    zlabel('S0 (a.u. proton density)');
    zlim(s0zlims);
    caxis(s0zlims);
    set(gca,'CameraPosition',[759.6 -196.6 5616.3],'CameraViewAngle',9.5466)
    
    subplot(2,2,2); 
    h=surf(100*B1./90,FE,brCon(n).R2,'LineStyle','-.','EdgeColor',[.2 .2 .2])
    get(h);
    zlim(zlims);
    caxis(zlims);
    xlabel('B_1^+ Level (%)');
    ylabel('Iron load (^{mg}/_g)');
    zlabel('R2 (sec^{-1})');
    title(titles(2).t);
     set(gca,'CameraPosition',[759.6 -196.6 5616.3],'CameraViewAngle',9.5466)
    subplot(2,2,2+2); surf(100*B1./90,FE,brCon(n).S0,'LineStyle','-.','EdgeColor',[.2 .2 .2])
    xlabel('B_1^+ Level (%)');
    ylabel('Iron load (^{mg}/_g)');
    zlabel('S0 (a.u. proton density)');
    zlim(s0zlims);
    caxis(s0zlims);
     set(gca,'CameraPosition',[759.6 -196.6 5616.3],'CameraViewAngle',9.5466)
    
end
colormap parula;

figName2 = 'Overlay Constrained V. Unconstrained MonoExpC Fit B1+ Inhomo';
eFig(figName2,'size',[1600 800]);
h=mesh(100*B1./90,FE,brUnc(n).R2,'LineStyle','-.','EdgeColor',[.9 .9 .0],'FaceAlpha',.3,'FaceColor',[1 1 0],'LineWidth',4)
    get(h);
    zlim(zlims);
    caxis(zlims);
    xlabel('B_1^+ Level (%)');
    ylabel('Iron load (^{mg}/_g)');
    zlabel('R2 (sec^{-1})');
    title(titles(1).t);
    
    hold on;
    
    h=mesh(100*B1./90,FE,brCon(n).R2,'LineStyle','-.','EdgeColor',[.0 .9 .9],'FaceAlpha',.3,'FaceColor',[0 1 1],'LineWidth',4)
    get(h);
    zlim(zlims);
    caxis(zlims);
    xlabel('B_1^+ Level (%)');
    ylabel('Iron load (^{mg}/_g)');
    zlabel('R2 (sec^{-1})');
     set(gca,'CameraPosition',[759.6 -196.6 5616.3],'CameraViewAngle',9.5466)
legend('Non-neg','Bounded');
   



%{
cmap = linspace(.3,1,11);
cmap = cmap';
cmap(:,2) = circshift(cmap,8);
cmap(:,3) = sin(linspace(0,pi,11));
names = cell(11,1);
symbols = ['+','o','*','x','s','d','^','p','h','<','>'];
for n=1:11
    ha = plot(100*B1a./90, 100 .* fitR2a(n,:)./fitR2a(n,4)-100,'Color',cmap(n,:),'LineWidth',3);
    names{n} = mat2str(FE(n));
    hold on;
end
ylim([0 35]);
colormap(cmap);
%set axis position
aP = get(gca,'Position');
set(gca,'Position',[aP(1) aP(2)+.03 .85 .83])

h = legend(names);
set(h,'Position',[0.5    0.35  0.1018    0.3881])
set(h,'EdgeColor',[.999999 .99999 .99999]);
textH = findobj(h,'Type','text');
for ind=1:length(textH)
    set(textH(ind),'HorizontalAlignment', 'right');
end

%h = xlabel('B1+ Homogeneity [% achieved flip angle]');
h = xlabel(' ');
set(h,'FontSize',15,'FontWeight','bold');
%h = ylabel('R2 Estimate Error[%]');
h = ylabel(' ');
set(h,'FontSize',15,'FontWeight','bold');
set(gca,'FontSize',12');
set(hf,'Position',[myP(1:2) 500 300]);
%x legend label
xl1 = 'Liver Iron Load';
xl2 = '[mg FE/g dry tissue]';
yoffset = 33;
xoffset = 96;
text(xoffset,yoffset,xl1,'FontSize',12,'FontWeight','bold','Tag','xl1')
text(xoffset-.1,yoffset-2,xl2,'FontSize',10,'FontWeight','normal','Tag','xl2');


%x label
xl1 = 'Mean B^+_1';
xl2 = '[% achieved flip angle]';
yoffset = -4;
xoffset = 88.5;
text(xoffset,yoffset,xl1,'FontSize',15,'FontWeight','bold','Tag','xl1')
text(xoffset+7,yoffset,xl2,'FontSize',15,'FontWeight','normal','Tag','xl2');

%y label
%yl1 = 'R_2 Estimate Error';
yl1 = 'Liver Iron Estimate Error';
yl2 = '[% Error]';
yoffset = 1;
xoffset = 76.9;
text(xoffset,yoffset,yl1,'FontSize',15,'FontWeight','bold','Rotation',90,'Tag','yl1');
text(xoffset,yoffset+25.5,yl2,'FontSize',15,'FontWeight','normal','Rotation',90,'Tag','yl2');

set(gcf,'PaperUnits','points')
set(gcf,'PaperSize',[510 310])
set(gcf,'PaperPosition',[3 3 500 300])

% fix legend positioning, keeps getting squashed by some other setting
for ind=1:length(textH)
    tp = get(textH(ind),'Position')
    tp(1) = tp(1) + .25
    set(textH(ind),'Position',tp)
end

%saveas(h,saveFileName,'pdf')

%plot(t,z)
%hold on;
%plot(t,abs(sig))
%plot(t(TEInd),abs(sig(TEInd)),'*r')
%}