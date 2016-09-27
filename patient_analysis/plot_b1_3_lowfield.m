%%
%[b1 patIndex] = recon_b1_2();
load results_plot_b1_3.mat;
counter = 0;
figure(150);
colormap('parula');

%set(gcf,'Position',[0 0 600 600]);
set(gcf,'Position',[1225         327 600 600]);
for n=patIndex
    counter = counter +1;
    res = b1(n).res
    subplot(3,3,counter);
    im = res.lowFast.roi .* abs(res.lowFast.im);
    %if mean(im(find(res.highFast.roi)))>1
        im=im./100;
    %end
    size(im)
    if size(im,1) ==112
        imagesc(im(20:95,10:85).*100);
    elseif size(im,1) ==96
        imagesc(im(11:85,10:85).*100);
    else
        imagesc(im(35:90,20:100).*100);
    end
    %title(sprintf('R2* = %3.2f',b1(n).patInfo.r2s));
    caxis([30 120]);
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    set(gca,'XColor',[0.2081    0.1663    0.5292]);
    set(gca,'YColor',[0.2081    0.1663    0.5292]);
    p = get(gca,'Position');
    set(gca,'Position', p + [-.1 -.05 .09 .09]);
end

temp = get(gca,'Position');
ha = gca;
h = colorbar;
set(h,'FontSize',14);
set(ha,'Position',temp);
p = get(h,'Position');
set(h,'Position',[ .85 .06 .05 0.905]);

%axes(h);
h = text(100,-45, 'Achieved B1+ Amplitude (%)')
set(h,'Rotation',-90)
set(h,'FontSize',14);


set(gcf,'PaperUnits','points');
p = get(gcf,'Position');
set(gcf,'PaperSize',p(3:4));
set(gcf,'PaperPosition', [0 0 p(3:4)]);
saveas(gcf,'plot_b1_3_different_scale_grodins2016.pdf');
