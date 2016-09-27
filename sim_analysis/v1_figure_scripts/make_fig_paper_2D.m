load fits_TEshortening.mat;

figName = 'Compare Constrained V. Unconstrained MonoExpC Fit B1+ Inhomo';
%saveFileName = 'compareConstrains.pdf';
figSize = [500 718];
eFig(figName,'size',figSize);

yl = [0 800];
xl = [47 115]./90.*100;
fixdumbx = [-.001,.001]; %part of a dirty axis rerender fix
fixdumby = [-1,.001]; %part of a dirty axis rerender fix
pickFEV = 1:(length(FE)-2);
for n=1:2
    h = subplot(2,1,n); 
    if n==1
        h_a1 = h;
    end
    area(xl,yl);
    myMap = goodColors(length(FE));
    [~,b1center] = find(B1==90);
    for pickFE=pickFEV
        plot(B1./90.*100, brCon(n).R2(pickFE,:),'Color',myMap(pickFE,:), 'LineWidth',3);
        names{pickFE} = mat2str(FE(pickFE));
        hold on;
    end
    if n==1 + 5
        h = legend(names);
        set(h,'Position',[ 0.3134   0.6908    0.0475    0.2270])
        set(h,'EdgeColor',[.999999 .99999 .99999]);
        textH = findobj(h,'Type','text');
        for ind=1:length(textH)
            set(textH(ind),'HorizontalAlignment', 'right');
            set(textH(ind),'Position',get(textH(ind),'Position')+[.2 0 0]);
        end
    end
    ylabel('R_{2} Estimate (Hz)');
    xlabel( 'Achieved B_{1}^{+} (% specified flip angle)');
    ylim(yl+fixdumby);
    xlim(xl+fixdumbx);
    title(sprintf('%0.1fT',1.5*n));
    plot([xl(1) xl(1)],yl,'k');% the rest of the dirty axis rendering fix
    plot(xl,[yl(1) yl(1)],'k');
end

%set(h,'Position',[.7106 .6908 0.0531 0.2270]);

axes(h_a1);
w = 4;
yo = 60;
l1 = 698;
l2 = l1-yo;
l3 = l1-2*yo;
xinit = [90 90+w];
xo = 10;
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

text(xinit(1)-18.5,l1-floor(yo*2/3),'Iron Load');
text(xinit(1)-23,l1-floor(yo*4/3),'[mg Fe/g dry tissue]');

text(xinit(1)-2,l1-tyo,'1');
text(xinit(1)-2,l2-tyo,'5');
text(xinit(1)-3.2,l3-tyo,'10');

text(xinit(1)+xo-3.2,l1-tyo,'15');
text(xinit(1)+xo-3.2,l2-tyo,'20');
text(xinit(1)+xo-3.2,l3-tyo,'25');

text(xinit(1)+xo2-3.2,l1-tyo,'30');
text(xinit(1)+xo2-3.2,l2-tyo,'35');
text(xinit(1)+xo2-3.2,l3-tyo,'40');
%}




set(gcf, 'PaperUnits','points','PaperSize',figSize,'PaperPosition',[0 0 figSize]);

saveas(gcf,'paperfigs/3Tvs1p5T_SE','pdf');
saveas(gcf,'paperfigs/3Tvs1p5T_SE','png');


