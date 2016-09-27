if ~exist('brCon90_1');
    recon1;
end
%%
%surf(fitR2a ./repmat(fitR2a(:,4),1,7));
figName = 'SimulationB1';
if isempty(findobj('type','figure','name',figName))
    hf = figure('name',figName);
    myP = [20 20 500 300];
else
    hf =  findobj('type','figure','name',figName);
    myP = get(hf,'Position');
    clf(hf);
end

R2b = brCon(1).R2_perc;

cmap = linspace(.3,1,11);
cmap = cmap';
cmap(:,2) = circshift(cmap,8);
cmap(:,3) = sin(linspace(0,pi,11));
names = cell(11,1);
symbols = ['+','o','*','x','s','d','^','p','h','<','>'];
for n=1:11
    ha = plot(100*B1./90, 100 .* R2b(n,:) ,'Color',cmap(n,:),'LineWidth',3);
    names{n} = mat2str(FE(n));
    hold on;
end
ylim([-20 +135]);
xlim([53 126]);
colormap(cmap);

%set axis position
aP = get(gca,'Position');
set(gca,'Position',[aP(1) aP(2)+.03 .85 .83])



h = legend(names);
set(h,'Position',[0.5  0.55  0.2818    0.2881])
set(h,'EdgeColor',[.999999 .99999 .99999]);
textH = findobj(h,'Type','text');
for ind=1:length(textH)
    set(textH(ind),'HorizontalAlignment', 'right');
    set(textH(ind),'Position',get(textH(ind),'Position')+[.11 0 0])
end

%h = xlabel('B1+ Homogeneity [% achieved flip angle]');
h = xlabel(' ');
set(h,'FontSize',15,'FontWeight','bold');
%h = ylabel('R2 Estimate Error[%]');
h = ylabel(' ');
set(h,'FontSize',15,'FontWeight','bold');
set(gca,'FontSize',12');
set(hf,'Position',[myP(1:2) 550 350]);
%x legend label
xl1 = 'Liver Iron Load';
xl2 = '[mg FE/g dry tissue]';
yoffset = 30;
xoffset = 90;
text(xoffset,yoffset,xl1,'FontSize',12,'FontWeight','bold','Tag','xl1')
text(xoffset-.5,yoffset-7,xl2,'FontSize',10,'FontWeight','normal','Tag','xl2');
%}

%x label
xl1 = 'Mean B^+_1';
xl2 = '[% achieved flip angle]';
yoffset = -35;
xoffset = 72;
text(xoffset,yoffset,xl1,'FontSize',15,'FontWeight','bold','Tag','xl1')
text(xoffset+10,yoffset,xl2,'FontSize',15,'FontWeight','normal','Tag','xl2');

%y label
%yl1 = 'R_2 Estimate Error';
yl1 = 'Liver Iron Estimate Error';
yl2 = '[% Error]';
yoffset = -5;
xoffset = 47.5 ;
text(xoffset,yoffset,yl1,'FontSize',15,'FontWeight','bold','Rotation',90,'Tag','yl1');
text(xoffset,yoffset+98.5,yl2,'FontSize',15,'FontWeight','normal','Rotation',90,'Tag','yl2');

set(gcf,'PaperUnits','points')
set(gcf,'PaperSize',[510 310])
set(gcf,'PaperPosition',[3 3 500 300])

% fix legend positioning, keeps getting squashed by some other setting
for ind=1:length(textH)
    tp = get(textH(ind),'Position')
    tp(1) = tp(1) + .25
    set(textH(ind),'Position',tp)
end

%saveas(h,'simulation_b1_onerun.pdf','pdf')

%plot(t,z)
%hold on;
%plot(t,abs(sig))
%plot(t(TEInd),abs(sig(TEInd)),'*r')


%}