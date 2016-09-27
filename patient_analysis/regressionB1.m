clear allROI allb1;
allROI = zeros(128,128);
allb1 = allROI;

if ~exist('b1')
    [b1 patIndex] = recon_b1_2;
end


m = [];
s=[];
for n=1:length(patIndex)
    try
        m(end+1,1) = b1(n).patInfo.r2s;
        s(end+1,1) = b1(n).patInfo.r2s;
        m(end,2) = b1(n).patInfo.r2;
        m(end,3) = b1(n).res.lowSlow.mean;
        m(end,4) = b1(n).res.highSlow.mean;
        m(end,5) = b1(n).res.lowFast.mean;
        m(end,6) = b1(n).res.highFast.mean;
        
        s(end,2) = b1(n).patInfo.r2;
        s(end,3) = b1(n).res.lowSlow.std;
        s(end,4) = b1(n).res.highSlow.std;
        s(end,5) = b1(n).res.lowFast.std;
        s(end,6) = b1(n).res.highFast.std;  
    catch 
        
    end
end

%plot(m(find(m(:,3)),2),m(find(m(:,4)),4));
plot(m(:,2),s(:,5));
%ylim([0 110]);

% imagesc(b1out(39:90, 27:90));
% caxis([30 100]);
% colormap parula;
% colorbar;
% set(gca,'XTick',[]);
% set(gca,'YTick',[]);

% h = ylabel('B1+ scale (% flip angle achieved)');
% set(h,'Position',[76.5785   26.7281    1.0001]);
% title('Average regional B1+ scale in 9 patients, 3T Dual TR Slow');
% p = get(gcf,'Position');
% set(gcf,'PaperSize',p(3:4));
% set(gcf,'PaperUnits','points');
% set(gcf,'PaperPosition',[0 0 p(3:4)]);
% saveas( gcf, 'b1_mean_liver_regional','pdf');