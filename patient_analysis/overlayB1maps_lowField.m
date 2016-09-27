clear allROI allb1;
load results_plot_b1_3;
load warped_b1_low.mat

allROI = zeros(128,128);
allb1 = allROI;
for n=patIndex
    try
        allROI(:,:,end+1) = imresize(b1(n).res.lowSlow.roi,128/size(b1(n).res.lowSlow.roi,1));
        allb1(:,:,end+1) = imresize(b1(n).res.lowSlow.im,128/size(b1(n).res.lowSlow.roi,1));
    catch
        fprintf('failed %i',n);
    end
end
allROI = allROI(:,:,2:end);
allb1 = allb1(:,:,2:end);

allb1 = allb1.*allROI;

allROI = reshape(allROI,[128*128,9]);
allb1 = reshape(allb1,[128*128,9]);

b1out = sum(allb1,2)./sum(allROI,2);

b1out = reshape(b1out,[128 128]);

imagesc(b1out(39:90, 27:90));
caxis([30 120]);
colormap parula;
colorbar;
set(gca,'XTick',[]);
set(gca,'YTick',[]);

h = ylabel('B1+ scale (% flip angle achieved)');
set(h,'Position',[76.5785   26.7281    1.0001]);
title('Average regional B1+ scale in 9 patients, 3T Dual TR');
p = get(gcf,'Position');
set(gcf,'PaperSize',p(3:4));
set(gcf,'PaperUnits','points');
set(gcf,'PaperPosition',[0 0 p(3:4)]);
%saveas( gcf, 'b1_mean_liver_regional','pdf');
%%
load('mean_liver_rois.mat');
ll_mean = mean(b1out(find(left_lobe_mean_roi)));
rl_mean = mean(b1out(find(right_lobe_mean_roi)));

fprintf( 'left lobe mean is %2.2f\nright lobe mean is %2.2f\n',ll_mean,rl_mean)

disp('mean');
mean(allb1(allROI==1))
disp('stdev')
std(allb1(allROI==1))