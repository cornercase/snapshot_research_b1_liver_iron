%%
allb1warp = zeros(128,128,7);
allROIwarp = allb1warp;

for n=1:7
    cpselect(allb1(:,:,n),canonical_liver);
    pause;
end

%%
fixedpoints = cell(0);
movingpoints = cell(0);
for n=1:7
    eval(sprintf('fixedpoints{end+1} = fixedPoints%i;',n));
    eval(sprintf('movingpoints{end+1} = movingPoints%i;',n));
end
%%
for n=1:7
    tform = fitgeotrans(movingpoints{n},fixedpoints{n},'nonreflectivesimilarity');
    Roriginal = imref2d(size(canonical_liver));
    recovered = imwarp(allb1(:,:,n),tform,'OutputView',Roriginal);
    recoveredROI = imwarp(allROI(:,:,n),tform,'OutputView',Roriginal);
    allb1warp(:,:,n) = recovered;
    allROIwarp(:,:,n) = recoveredROI;
    clear movingPoints fixedPoints;
    
end

%%
for n=1:7
    imshowpair(canonical_liver,allb1warp(:,:,n),'montage');
    pause;
end

%%
allROIwarp = allROIwarp==1;
save('warped_b1_low','fixedpoints','movingpoints','allb1warp','allROIwarp')