%% get the stats
[b1 patIndex] = recon_b1(patientList);

%% plot the stats
b1 = patientList;
close all;
subplotPanes = 8;
spRows = 2;
spCols = 4;
b1lim = [0 140];
m = zeros(1,6)

xTitle = 'R2* Hz'
for ni=1:length(b1)
    
    csInd = b1{ni}.useIndex;
    
    m(ni,1) = max(b1{ni}.patInfo.r2s);
    m(ni,2) = max(b1{ni}.patInfo.r2(end));
    m(ni,3) = b1{ni}.res.lowSlow.mean;
    m(ni,4) = b1{ni}.res.highSlow.mean;
    m(ni,5) = b1{ni}.res.lowFast.mean;
    m(ni,6) = b1{ni}.res.highFast.mean;    
    
    n = ni;%patIndex(ni);
    c = 0;
    c=c+1
    subplot(spRows,spCols,c);
    ni
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.lowSlow.mean,'*');
    title('Low slow mean');
    xlabel(xTitle);ylabel('Mean')
    ylim(b1lim);
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.highSlow.mean,'*');
    title('High slow mean');
    xlabel(xTitle);ylabel('Mean')
    ylim(b1lim);
    hold on;    
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.lowFast.mean,'*');
    title('Low Fast Mean');
    xlabel(xTitle);ylabel('5th %ile B1')
    ylim(b1lim);
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.highFast.mean,'*');
    title('High Fast Mean');
    xlabel(xTitle);ylabel('95th %ile B1')
    ylim(b1lim);
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.res.lowSlow.per5,b1{n}.res.lowSlow.per95,'*');
    title('Low slow 95% vs 5%');
    xlabel('5th %ile B1');ylabel('95th %ile B1');
    ylim(b1lim);
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.res.highSlow.per5,b1{n}.res.highSlow.per95,'*');
    title('High Slow 95% vs 5%');
    xlabel('5th %ile B1');ylabel('95th %ile B1')
    ylim(b1lim);
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.res.lowFast.per5,b1{n}.res.lowFast.per95,'*');
    title('Low fast 95% vs 5%');
    xlabel('5th %ile B1');ylabel('95th %ile B1')
    ylim(b1lim);
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.res.highFast.per5,b1{n}.res.highFast.per95,'*');
    title('High fast 95% vs 5%');
    xlabel('5th %ile B1');ylabel('95th %ile B1')
    ylim(b1lim);
    hold on;
    
end
figure;

for ni=1:length(b1)
    n = ni;%patIndex(ni);
    c = 0;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.highSlow.per5,'*');
    xlabel(xTitle);ylabel('B1 %*10')
    title('High slow 5%ile');
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.highSlow.per95,'*');
    xlabel(xTitle);ylabel('B1 %*10')
    title('High slow 95%ile');
    hold on;    
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.lowSlow.per5,'*');
    xlabel(xTitle);ylabel('B1 %*10')
    title('Low slow 5th%ile');
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.lowSlow.per95,'*');
    hold on;
    xlabel(xTitle);ylabel('B1 %*10')
    title('Low slow 95th%ile');
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.highFast.per5,'*');
    title('High fast 5%');
    xlabel(xTitle);ylabel('5th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.highFast.per95,'*');
    title('High fast 5%');
    xlabel(xTitle);ylabel('95th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.lowFast.per5,'*');
    title('low fast 5%');
    xlabel(xTitle);ylabel('5th %ile B1')
    hold on;
    c=c+1
    subplot(spRows,spCols,c);
    plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.lowFast.per95,'*');
    title('low fast 5%');
    xlabel(xTitle);ylabel('95th %ile B1')
    hold on;
    
end

figure;
for ni=1:length(b1)
    n = ni;%patIndex(ni);
    plot(max(b1{n}.patInfo.r2(end)),max(b1{n}.patInfo.r2s(end)),'*');
    xlabel('R2 Hz');
    ylabel('R2* Hz');
    hold on;
end



%%

% m(ni,1) = b1{ni}.patInfo.r2s(end);
% m(ni,2) = b1{ni}.patInfo.r2(end);
% m(ni,3) = b1{ni}.res.lowSlow.mean;
% m(ni,4) = b1{ni}.res.highSlow.mean;
% m(ni,5) = b1{ni}.res.lowFast.mean;
% m(ni,6) = b1{ni}.res.highFast.mean;    
mylims = [40 120];
figure(4);
subplot(2,2,1)

figure(5);h = plotregression(m(:,1)',m(:,3)');
[R M B] = regression(m(:,1)',m(:,3)');
h = get(h,'Children'); h = h(2);

figure(4);
ha = subplot(2,2,1)
copyobj(get(h,'Children'),ha);
ylim(mylims);
ylabel('slow');
title('low');
text( 100,45,sprintf('R = %0.4f',R));

figure(5);h = plotregression(m(:,1)',m(:,4)');
[R M B] = regression(m(:,1)',m(:,4)');
h = get(h,'Children'); h = h(2);

figure(4);
ha = subplot(2,2,2)
copyobj(get(h,'Children'),ha);
ylim(mylims);
title('high');
text( 100,45,sprintf('R = %0.4f',R));

figure(5);h = plotregression(m(:,1)',m(:,5)');
[R M B] = regression(m(:,1)',m(:,5)');
h = get(h,'Children'); h = h(2);

figure(4);
ha = subplot(2,2,3)
copyobj(get(h,'Children'),ha);
ylim(mylims);
ylabel('fast');
xlabel(xTitle);
text( 100,45,sprintf('R = %0.4f',R));

figure(5);h = plotregression(m(:,1)',m(:,6)');
[R M B] = regression(m(:,1)',m(:,6)');
h = get(h,'Children'); h = h(2);

figure(4);
ha = subplot(2,2,4)
copyobj(get(h,'Children'),ha);
ylim(mylims);
xlabel(xTitle);
text( 100,45,sprintf('R = %0.4f',R));

suptitle('B1 regression with iron');

close(5);


%%

figure(5);
for n=1:length(b1);
    
    
mylims = ([0 80]);

subplot(2,2,1)

ha = subplot(2,2,1)
plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.lowSlow.std,'*r');
hold on;
ylim(mylims);
ylabel('slow');
title('low');

ha = subplot(2,2,2)
plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.highSlow.std,'*r');
hold on;
ylim(mylims);
title('high');

ha = subplot(2,2,3)
plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.lowFast.std,'*r');
hold on;
ylim(mylims);
ylabel('fast');

ha = subplot(2,2,4)
plot(b1{n}.patInfo.r2s(csInd),b1{n}.res.highFast.std,'*r');
hold on;
ylim(mylims);


end
suptitle('B1 standard devation');

