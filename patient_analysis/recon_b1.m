
function [b1 patIndex] = recon_b1(b1)
    

% Compare 1.5 and 3T maps

sIndex = [];
fIndex = [];

sliceNum = 1;
% 
% for n=1:length(b1)
%     if ~isempty(b1{n}.l.slow) && ~isempty(b1{n}.h.slow)
%         sIndex(end+1) = n;
%     end
%     if ~isempty(b1{n}.l.fast) && ~isempty(b1{n}.h.fast)
%         fIndex(end+1) = n;
%     end
% end

myStatsLow = [0 0];
myStatsHigh = [0 0];
for n=1:length(b1)
    ni=n;
    [im m s per5 per95 roi myMap useIndex] = getStatsSlice(b1,ni,'low','fast',sliceNum);
    b1{ni}.res.lowFast.im = im;
    b1{ni}.res.lowFast.mean = m;
    b1{ni}.res.lowFast.std = s;
    b1{ni}.res.lowFast.per5 = per5;
    b1{ni}.res.lowFast.per95 = per95;
    b1{ni}.res.lowFast.roi = roi;
    b1{ni}.res.lowFast.myMap = myMap;
    b1{ni}.useIndex = useIndex;
    [im m s per5 per95 roi myMap useIndex] = getStatsSlice(b1,ni,'high','fast',sliceNum);
    b1{ni}.res.highFast.im = im;
    b1{ni}.res.highFast.mean = m;
    b1{ni}.res.highFast.std = s;
    b1{ni}.res.highFast.per5 = per5;
    b1{ni}.res.highFast.per95 = per95;
    b1{ni}.res.highFast.roi = roi;
    b1{ni}.res.highFast.myMap = myMap;
end

myStatsLow = [0 0];
myStatsHigh = [0 0];
for n=1:length(b1)
    ni=n;
    [im m s per5 per95 roi myMap useIndex] = getStatsSlice(b1,ni,'low','slow',sliceNum);
    b1{ni}.res.lowSlow.im = im;
    b1{ni}.res.lowSlow.mean = m;
    b1{ni}.res.lowSlow.std = s;
    b1{ni}.res.lowSlow.per5 = per5;
    b1{ni}.res.lowSlow.per95 = per95;
    b1{ni}.res.lowSlow.roi = roi;
    b1{ni}.res.lowSlow.myMap = myMap;
    [im m s per5 per95 roi myMap useIndex] = getStatsSlice(b1,ni,'high','slow',sliceNum);
    b1{ni}.res.highSlow.im = im;
    b1{ni}.res.highSlow.mean = m;
    b1{ni}.res.highSlow.std = s;
    b1{ni}.res.highSlow.per5 = per5;
    b1{ni}.res.highSlow.per95 = per95;
    b1{ni}.res.highSlow.roi = roi;
    b1{ni}.res.highSlow.myMap = myMap;
end

patIndex = fIndex;

end   


function [im, m, s, per5, per95, roi, myMap, useIndex] = getStatsSlice(b1,ind,field,speed,slice)

if strcmp(field,'low')
    temp = b1{ind}.l;
else
    temp = b1{ind}.h;
end

if strcmp(speed,'fast')
    path = temp.fast;
    a = dir(path);
    sNum = a(6).name;
    sNum = strsplit(sNum,'-');
    sNum = sNum{2};
    sNum = str2num(sNum);
else
    path = temp.slow;
    a = dir(path)
    sNum = a(6).name;
    sNum = strsplit(sNum,'-');
    sNum = sNum{2};
    sNum = str2num(sNum);
end

mapNum = 12+slice %since all the scans are 3 slices -> 2 images, 2
                   %phase, 1 calc per slice, interleaved
%assignin('base','sNum','sNum');

scanPrefix = sprintf('IM-%04d-%04d.dcm',sNum,mapNum);
im1Prefix = sprintf('IM-%04d-%04d.dcm',sNum,slice);
im2Prefix = sprintf('IM-%04d-%04d.dcm',sNum,slice+7);
roiPrefix = sprintf('liver-IM-%04i-%04i.dcm.mat',sNum,slice);
fullpath = fullfile(path,scanPrefix);
roiPath = fullfile(path,'ROI',roiPrefix);
info = dicominfo(fullpath);

indArray = [];
for findDateItr = 1:length(b1{ind}.patInfo.examdate)
    d = str2num(b1{ind}.patInfo.examdate{findDateItr});
    indArray(end+1) = abs(str2num(info.AcquisitionDate) - d);
end
[notUsed useIndex] = min(indArray);
clear notUsed;



im = readDicomSeries(fullpath,'adjustScale',1,'rescaleFieldName','realWorld'); %this is actually ROI

im1 = readDicomSeries(fullfile(path,im1Prefix));%,'adjustScale',0);
im2 = readDicomSeries(fullfile(path,im2Prefix));%,'adjustScale',0);
im1(:,:,2) = im2;
myMap = dualTRb1map(im1,30,20,120);
im=im;
%im = readDicomSeries(fullpath);
%assignin('base','im',im);
load(roiPath);

liverInd = find(roi);

m = mean(im(liverInd));
s = std(im(liverInd));
per5 = prctile(im(liverInd),5);
per95 = prctile(im(liverInd),95);

end