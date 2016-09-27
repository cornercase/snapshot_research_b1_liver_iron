load fits_CPMG_regular.mat;
figName = 'find percent error CPMG';
figSize = [500 718];
eFig(figName,'size',figSize);
yl = [0 100];
angleToB1p = 100/90;
%angleToB1p = 1;
xl = [47 115].*angleToB1p;
fixdumbx = [-.001,.001]; %part of a dirty axis rerender fix
fixdumby = [-1,.001]; %part of a dirty axis rerender fix
pickFEV = 1:(length(FE)-2);
surfPlot = 0;
for n=1:2
    [a mainIndex] = find(B1==90);
    centerDecay = repmat(brCon(n).R2(1:end,mainIndex),1,12);
    perc = 100*((brCon(n).R2-centerDecay)./centerDecay);
    h = subplot(2,1,n); 
    if n==1
        h_a1 = h;
    end
    area(xl,yl);
    myMap = goodColors(length(FE));
    [~,b1center] = find(B1==90);
    for pickFE=pickFEV
        plot(B1.*angleToB1p, perc(pickFE,:),'Color',myMap(pickFE,:), 'LineWidth',3);
        names{pickFE} = mat2str(FE(pickFE));
        hold on;
    end
    if(surfPlot);
        hold off;
        surf(B1,FE(1:9),perc(1:9,:));
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
    ylabel('Percent R2 Error');
    xlabel( 'Achieved B_{1}^{+} (% specified flip angle)');
    ylim(yl+fixdumby);
    xlim(xl+fixdumbx);
    title(sprintf('%0.1fT',1.5*n));
    %plot([xl(1) xl(1)],yl,'k');% the rest of the dirty axis rendering fix
    %plot(xl,[yl(1) yl(1)],'k');
end

load fits_TEshortening.mat;

figName = 'find percent error SE';
figSize = [500 718];
eFig(figName,'size',figSize);
yl = [0 100];
angleToB1p = 100/90;
for n=1:2
    [a mainIndex] = find(B1==90);
    centerDecay = repmat(brUnc(n).R2(:,mainIndex),1,12);
    perc = 100*((brUnc(n).R2 - centerDecay)./centerDecay);
    h = subplot(2,1,n); 
    if n==1
        h_a1 = h;
    end
    area(xl,yl);
    myMap = goodColors(length(FE));
    [~,b1center] = find(B1==90);
    for pickFE=pickFEV
        plot(B1.*angleToB1p, perc(pickFE,:),'Color',myMap(pickFE,:), 'LineWidth',3);
        names{pickFE} = mat2str(FE(pickFE));
        hold on;
    end
    if surfPlot
        hold off;
        surf(B1,FE(1:9),perc(1:9,:));
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
    ylabel('Percent R2 Error');
    xlabel( 'Achieved B_{1}^{+} (% specified flip angle)');
    ylim(yl+fixdumby);
    xlim(xl+fixdumbx);
    title(sprintf('%0.1fT',1.5*n));
    %plot([xl(1) xl(1)],yl,'k');% the rest of the dirty axis rendering fix
    %plot(xl,[yl(1) yl(1)],'k');
end