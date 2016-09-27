%%
%[b1 patIndex] = recon_b1_2();
loadFiles{1} = 'results_plot_b1_3.mat';
loadFiles{2} = 'warped_b1_low.mat';
saveFiles{1} = 'b1_3T_joined';
saveFiles{2} = 'b1_1p5T_joined';
save = 0;
for fieldN=1:2
    
    load(loadFiles{fieldN});

    counter = 0;
    figure(150+fieldN); clf;
    colormap('parula');

    %set(gcf,'Position',[0 0 600 600]);
    set(gcf,'Position',[2200 327 1200 600]);

    width = .15;
    height = .3;
    offY = 0.05;
    offX = 0.025;

    axes1pos = [0.000 0.33 0.15 0.33];
    for n=patIndex
        counter = counter +1;
        res = b1(n).res
        row = mod(counter+2,3);
        col = floor((counter+2)/3)-1;

        axesPos = [offX+width*col offY+height*row width height]       

        axes('Position',axesPos)
        if fieldN == 1
            im = res.highFast.roi .* abs(res.highFast.im);
        else
            im = res.lowSlow.roi .* abs(res.lowSlow.im);
        end
        im=im./100;
        if size(im,1) ==112
            imagesc(im(20:95,10:85).*100);
        elseif size(im,1) ==96
            imagesc(im(11:85,10:85).*100);
        else
            imagesc(im(35:90,20:100).*100);
        end
        %if mean(im(find(res.highFast.roi)))>1

        %end
%        imagesc(im(35:90,20:100).*100);
        caxis([30 120]);
        set(gca,'XTick',[]);
        set(gca,'YTick',[]);
        set(gca,'XColor',[0.2081    0.1663    0.5292]);
        set(gca,'YColor',[0.2081    0.1663    0.5292]);
        %p = get(gca,'Position');
        %if counter == 1
        %    set(gca,'Position',axes1pos);
        %else
        %    set(gca,'Position', p + [-.1 -.05 .09 .09]);
        %end
    end


    h = axes('Position',[.5 offY .45 height*3]);


    
    allROI = zeros(128,128);
    allb1 = allROI;

    if fieldN==1
    
        for n=1:13
            try
                allROI(:,:,end+1) = imresize(b1(n).res.highSlow.roi,128/size(b1(n).res.highSlow.roi,1));
                allb1(:,:,end+1) = imresize(b1(n).res.highSlow.im,128/size(b1(n).res.highSlow.roi,1));
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
    else
        allROI = allROIwarp;
        allb1 = allb1warp;
        allROI = reshape(allROI,[128*128,7]);
        allb1 = reshape(allb1,[128*128,7]).*allROI;
        b1out = sum(allb1,2)./sum(allROI,2);

        b1out = reshape(b1out,[128 128]);

        imagesc(b1out(29:99, 17:90));
    end
    
    set(h,'YTick',[],'XTick',[]);
    caxis([30 120]);
    ha = colorbar('WestOutside');
    set(ha,'FontSize',14);
    colormap parula;

    axes(ha);
    h = text(-6,65, 'Achieved B1+ (% specified flip angle)')
    set(h,'Rotation',90)
    set(h,'FontSize',14);
    axes(ha);
    h = text(-59,122,'9 Patient B1 Maps');
    set(h,'FontSize',16,'FontWeight','bold');
    h = text(30,122,'Mean B1 Map');
    set(h,'FontSize',16);
    set(h,'FontWeight','bold');

    set(gcf,'PaperUnits','points');
    p = get(gcf,'Position');
    set(gcf,'PaperSize',p(3:4));
    set(gcf,'PaperPosition', [0 0 p(3:4)]);
    if save
        saveas(gcf,saveFiles{fieldN},'png');
    end

end
