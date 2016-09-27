function [] = temp_fit_v2(dpath)


for pickSE = 1:2
    yla = {[0 400],[0 250]};
    c_res = {};
    xlab = 'LIC (mg/g Fe/tissue)';
    ylab = 'R2 (Hz)';
    eFig(['R2 vs LIC for different B1 Values'],xlab,ylab,'Size',[848 297]);
    clf;
    for n=1:3
        axH(n) = subplot(1,3,n);
        %get(axH(n),'Position')
    end
    c1 = 0.0800;
    c2 = 0.51;
    c3 = .9;
    wid = .36;
    set(axH(1),'Position', [c1    0.1100    wid       0.8150]);
    set(axH(2),'Position', [c2    0.1100    wid       0.8150]);
    set(axH(3),'Position', [c3    0.1100    .08       0.8150],'XTick',[],'YTick',[]);
    
    for pickField = 1:2
        %subplot(1,3,pickField);
        axes(axH(pickField));
        fname = [];
        if pickSE==2
            uncFits = [dpath '/fits_CPMG_2_no_const.mat'];
            load(uncFits);
            yl = [0 300 25];
            xl = [0 50 5];
            verStr = 'CPMG';
        else
            uncFits =  [dpath '/fits_SE_TEshortening_2.mat'];
            load(uncFits);
            r = brUnc;
            yl = [0 450 25];
            xl = [0 50 0];
            verStr = 'SE';
        end

        for B1idx=1:length(B1)

            R2_temp = r(pickField).R2(:,B1idx);

            [curve, goodness] = fit( log(FE'), log(R2_temp), 'poly3' );
            c_res{B1idx,1} = curve;
            c_res{B1idx,2} = goodness;

        end


        colors = goodColors(length(B1));
        %FE_new = 
        for whichIdx= 1:1
            for B1idx=1:length(B1)
                if whichIdx==1
                    %h = plot(c_res{B1idx,1});%,'Color',colors(B1idx,:));
                    x = log(1:.1:50);
                    tf = c_res{B1idx,1};
                    c = tf.p1.*x.^3 + tf.p2.*x.^2 + tf.p3.*x + tf.p4;
                    h = plot(exp(x),exp(c));
                else
                    %h = plot(FE',r(pickField).R2(:,B1idx)','*');%,'*','Color',colors(B1idx,:));
                end
                set(h,'Color',colors(B1idx,:));
                if(B1(B1idx) == 90)
                    set(h,'LineWidth',5);
                else
                    set(h,'LineWidth',2);
                end
                hold on;
            end
            if whichIdx==1 && pickField == 1
                convertString = @(x) sprintf(' %1.2f',x);
                %entries = cellfun(@num2str,num2cell(B1./90)','UniformOutput',false);
                entries = cellfun(convertString,num2cell(B1./90)','UniformOutput',false);
                for n=1:11;
                    entries{n} = [entries{n}];
                end
                %h = legend(entries,'Location','NorthWest');
                %goodLegend(gca,colors,xl,yl);
                %get(h,'Position')
                %set(h,'Position',get(h,'Position')+[0 0 -.1 -.2])
                %get(h,'Position')
                %legend('off');
            end
        end
        title(sprintf('%s, Field Strength: %s',verStr,r(pickField).field));
        xlabel(xlab);
        ylabel(ylab);
        ylim(yla{pickSE});
        
        fname = sprintf('%s',verStr,r(pickField).field);
        %pause;
    end
    legendUp(axH(3), colors,entries);
    saveas(gcf,['temp_figs/temp3_' fname '.fig']);
    figSize = get(gcf,'Position');
    figSize = figSize(3:4);
    set(gcf, 'PaperUnits','points','PaperSize',figSize,'PaperPosition',[0 0 figSize]);
    
    saveas(gcf,['dpath/' fname],'pdf');
    saveas(gcf,['dpath/' fname],'png');
    saveas(gcf,['dpath/' fname],'fig');
    %saveas(gcf,['paperfig_v2/' fname],'pdf');
    %saveas(gcf,['paperfig_v2/' fname],'png');
    %saveas(gcf,['paperfig_v2/' fname],'fig');
end


function [] = legendUp(axisHandle, myMap,entries)
%xDims = [maxL maxR startL]
axes(axisHandle);
xlim([0 10]);
ylim([0 10]);
y=1:length(entries);
xinit = [6 12];
%FEcell = {'40','35','30','25','20','15','10','5','1'};
for n=1:length(entries)
pH=plot(xinit,[y(n) y(n)],'Color',myMap(n,:),'LineWidth',2); hold on;
tH=text(xinit(1)-.5,y(n)-.25,entries{n});
set(tH,'HorizontalAlignment','right');
if n==8
    set(pH,'LineWidth',5);
end
end
xlim([0 13]);
ylim([-4 15]);
set(gca,'XTick',[],'YTick',[]);

title('B1 Fraction');

%tH = text(.75,max(y)+3.7,'$\displaystyle\frac{\mbox{\textsf{  mg Fe  }}}{\mbox{\textsf{g dry tissue}}}$');
%set(tH,'Interpreter','latex');
%text(xinit(1)-5,max(y)+1,'g dry tissue]');
ylim([-4 15]);
xlim([0 13]);

