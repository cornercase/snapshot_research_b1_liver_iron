figName = 'Compare Constrained V. Unconstrained MonoExpC Fit B1+ Inhomo 1';
%saveFileName = 'compareConstrains.pdf';

eFig(figName,'size',[1074 718]);
titles(1).t = '\bf \fontsize{12}Non-negative';
titles(2).t = '\bf \fontsize{12}Bounded';
yl = [0 800];
fontspec = '\fontsize{12} ';
pickFEV = 1:(length(FE));
for n=1:2
    h = subplot(2,2,n); 
    myMap = goodColors(length(FE));
    [~,b1center] = find(B1==90);
    for pickFE=pickFEV
        plot(B1*100/90, brUnc(n).R2(pickFE,:),'Color',myMap(pickFE,:), 'LineWidth',3);
        names{pickFE} = mat2str(FE(pickFE));
        hold on;
    end
    xlabel([fontspec 'Achieved B1 (%)']);
    if n==1
        %h = legend(names);
        %set(h,'Position',[ 0.3134   0.6908    0.0475    0.2270])
        %set(h,'EdgeColor',[.999999 .99999 .99999]);
        %textH = findobj(h,'Type','text');
        %for ind=1:length(textH)
        %    set(textH(ind),'HorizontalAlignment', 'right');
        %    set(textH(ind),'Position',get(textH(ind),'Position')+[.2 0 0]);
        %end
        axes(h);
        w = 4;
        yo = 60;
        l1 = 698;
        l2 = l1-yo;
        l3 = l1-2*yo;
        xinit = [90 90+w]*100/90;
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
    end
    if n==1; ylabel([fontspec 'unconstrained']); end
    ylim(yl);
    title(sprintf('%0.1fT',1.5*n));
%end
%for n=1:2
    subplot(2,2,n+2); 
    myMap = goodColors(length(FE));
    [~,b1center] = find(B1==90);
    for pickFE=pickFEV
        plot(B1*100/90, brCon(n).R2(pickFE,:),'Color',myMap(pickFE,:), 'LineWidth',3);
        names{n} = mat2str(FE(n));
        hold on;
    end
    ylim(yl);
    xlabel([fontspec 'Achieved B1 (%)']);
    if n==1; ylabel([fontspec 'contrained']);end

end
