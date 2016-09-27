%% get the stats
[b1 patIndex] = recon_b1_2;

%% plot the stats

close all;
subplotPanes = 8;
spRows = 2;
spCols = 4;
for ni=1:length(patIndex)
    n = patIndex(ni);
    c = 0;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2s,b1(n).res.lowSlow.mean,'*');
    title('Low slow mean');
    xlabel('R2 Hz');ylabel('Mean')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2s,b1(n).res.highSlow.mean,'*');
    title('High slow mean');
    xlabel('R2 Hz');ylabel('Mean')
    hold on;    
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2s,b1(n).res.lowSlow.per5,'*');
    title('Low slow 5th');
    xlabel('R2 Hz');ylabel('5th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2s,b1(n).res.lowSlow.per95,'*');
    title('Low slow 95%ile');
    xlabel('R2');ylabel('95th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).res.lowSlow.per5,b1(n).res.lowSlow.per95,'*');
    title('Low slow 95% vs 5%');
    xlabel('5th %ile B1');ylabel('95th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).res.highSlow.per5,b1(n).res.highSlow.per95,'*');
    title('High Slow 95% vs 5%');
    xlabel('5th %ile B1');ylabel('95th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).res.lowFast.per5,b1(n).res.lowFast.per95,'*');
    title('Low fast 95% vs 5%');
    xlabel('5th %ile B1');ylabel('95th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).res.highFast.per5,b1(n).res.highFast.per95,'*');
    title('High fast 95% vs 5%');
    xlabel('5th %ile B1');ylabel('95th %ile B1')
    hold on;
    
end
figure;

for ni=1:length(patIndex)
    n = patIndex(ni);
    c = 0;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2,b1(n).res.highSlow.per5,'*');
    xlabel('R2 Hz');ylabel('B1 %*10')
    title('High slow 5%ile');
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2,b1(n).res.highSlow.per95,'*');
    xlabel('R2 Hz');ylabel('B1 %*10')
    title('High slow 95%ile');
    hold on;    
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2,b1(n).res.lowSlow.per5,'*');
    xlabel('R2 Hz');ylabel('B1 %*10')
    title('Low slow 5th%ile');
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2,b1(n).res.lowSlow.per95,'*');
    hold on;
    xlabel('R2 Hz');ylabel('B1 %*10')
    title('Low slow 95th%ile');
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2,b1(n).res.highFast.per5,'*');
    title('High fast 5%');
    xlabel('R2');ylabel('5th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2,b1(n).res.highFast.per95,'*');
    title('High fast 5%');
    xlabel('R2');ylabel('95th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2,b1(n).res.lowFast.per5,'*');
    title('low fast 5%');
    xlabel('R2');ylabel('5th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1(n).patInfo.r2,b1(n).res.lowFast.per95,'*');
    title('low fast 5%');
    xlabel('R2');ylabel('95th %ile B1')
    hold on;
    
end

figure;
for ni=1:length(patIndex)
    n = patIndex(ni);
    plot(b1(n).patInfo.r2,b1(n).patInfo.r2s,'*');
    hold on;
end