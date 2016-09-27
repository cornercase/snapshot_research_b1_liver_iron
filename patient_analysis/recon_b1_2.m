
function [b1 patIndex] = recon_b1()
% root %server%/data/3T

root = '/Volumes/hellinabucket/3T';
b1 = struct('patRoot',{},'fLow',struct('root',{},'fast',{},'slow',{}),'fHigh',struct('root',{},'fast',{},'slow',{}));
sliceNum = 1;


% Patient 1
patient.num     = 1;
patient.r2      = 27;
patient.r2s     =113;
patient.r2s = 58.8;
patient.disease ='B-thal';
patient.examdate='3/31/2014';
patient.dob     ='6/28/1994';
patient.sex     ='m';

b1(1).patInfo = patient;
b1(1).patRoot = '3T_001/2014_03_31';
b1(1).l.root='1.5T_LH';
b1(1).l.slow = 'B1_cal_long_TE_1801';
b1(1).l.fast = 'B1_cal_short_TE_1901';
b1(1).h.root = '3T_LH';
b1(1).h.slow = 'B1_cal_long_TE_1801';
b1(1).h.fast = 'B1_cal_short_TE_1901';

% Patient 2
patient.num     = 2;
patient.r2      = 281.5;
patient.r2s     = 1796;

patient.disease ='B-thal';
patient.examdate='4/1/2014';
patient.dob     ='5/4/1991';
patient.sex     ='f';

b1(end+1).patInfo = patient;
b1(end).patRoot = '3T_002/04_01_2014';
b1(end).l.root = '';
b1(end).l.slow = '';
b1(end).l.fast = '';
b1(end).h.root = '3.0T_LH';
b1(end).h.slow = 'B1_cal_long_TE_2101';
b1(end).h.fast = 'B1_cal_short_TE_2201 ';

% Patient 3
patient.num     = 3;
patient.r2      = 193.65;
patient.r2s     = 804.9;
patient.disease ='SCD';
patient.examdate='4/9/2014';
patient.dob     ='3/2/2003';
patient.sex     ='f';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_003/04_09_2014';
b1(end).l.root = '1.5T_L';
b1(end).l.slow = 'WIP_B1_std_901';
b1(end).l.fast = 'WIP_B1_fast_1001';
b1(end).h.root = '3.0T_L';
b1(end).h.slow = 'B1_cal_long_TE_501';
b1(end).h.fast = 'B1_cal_short_TE_601';

% Patient 5
patient.num     = 5;
patient.r2      = 15.2;
patient.r2s     = 49.7;
patient.disease = 'B-thal';
patient.examdate= '4/18/2014';
patient.dob     ='10/6/1996';
patient.sex     ='m';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_005NM';
b1(end).l.root = '1.5T_LH';
b1(end).l.slow = 'WIP_B1_std_2701';
b1(end).l.fast = 'WIP_B1_fast_2801';
b1(end).h.root = '3T_LHP';
b1(end).h.fast = 'B1_cal_short_TE_2101';
b1(end).h.slow = 'B1_cal_long_TE_2001';

% Patient 6
patient.num     = 6;
patient.r2      = 35.75;
patient.r2s     = 47.05;
patient.disease ='B-thal';
patient.examdate='5/2/2014';
patient.dob     ='4/13/2002';
patient.sex     ='m';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_006RN';
b1(end).l.root = '';
b1(end).l.slow = '';
b1(end).l.fast = '';
b1(end).h.root = '3T_L';
b1(end).h.slow = 'B1_cal_short_TE_601';
b1(end).h.fast = 'B1_cal_long_TE_501';

% Patient 7
patient.num     = 7;
patient.r2      = 139.9;
patient.r2s     = 528.4;
patient.disease = 'B-thal';
patient.examdate='5/16/2014';
patient.dob     ='4/25/1989';
patient.sex     ='m';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_007DL';
b1(end).l.root = '1.5T_LH';
b1(end).l.slow = 'Scan2/WIP_B1_std_2001';
b1(end).l.fast = 'Scan2/WIP_B1_fast_2101';
b1(end).h.root = '3T_LH';
b1(end).h.slow = 'B1_cal_long_TE_2601';
b1(end).h.fast = 'B1_cal_short_TE_2501';

% Patient 8
patient.num     = 8;
patient.r2      = 10.4;
patient.r2s     =53.9;
patient.r2s = 40.7
patient.disease ='B-thal';
patient.examdate='5/30/2014';
patient.dob     ='8/17/2002';
patient.sex     ='m';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_008WN';
b1(end).l.root = '1.5T_L';
b1(end).l.slow = 'WIP_B1_std_2501';
b1(end).l.fast = 'WIP_B1_fast_2601';
b1(end).h.root = '3T_L';
b1(end).h.slow = 'B1_cal_short_TE_601';
b1(end).h.fast = 'B1_cal_long_TE_501';

%Patient 9
patient.num     = 9;
patient.r2      = 84;
patient.r2s     =837.95;
patient.disease ='other';
patient.examdate='5/9/2014';
patient.dob     ='7/3/1991';
patient.sex     ='f';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_009ML';
b1(end).l.root = '1.5T_L';
b1(end).l.slow = 'WIP_B1_std_601';
b1(end).l.fast = 'WIP_B1_fast_701';
b1(end).h.root = '3T_L';
b1(end).h.slow = 'B1_cal_long_TE_601';
b1(end).h.fast = 'B1_cal_short_TE_701';
%extra 3T fast maps
%B1_cal_short_TE_701
%B1_cal_short_TE_801

%Patient 10
patient.num     = 10;
patient.r2      = 178.5;
patient.r2s     =602.5;
patient.disease ='B-thal';
patient.examdate='6/2/2014';
patient.dob     ='2/26/1992';
patient.sex     ='f';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_010JR';
b1(end).l.root = '1.5T_LH';
b1(end).l.slow = 'WIP_B1_std_2301';
b1(end).l.fast = 'WIP_B1_fast_2401';
b1(end).h.root = '3T_LH';
b1(end).h.slow = 'B1_cal_long_TE_2101';
b1(end).h.fast = 'B1_cal_short_TE_2201';

%Patient 11
patient.num     = 11;
patient.r2      = 122.2;
patient.r2s     =544;
patient.disease ='B-thel';
patient.examdate='7/11/2014';
patient.dob     ='1/21/1983';
patient.sex     ='m';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_011ES/07_11_14';
b1(end).l.root = '';
b1(end).l.slow = '';
b1(end).l.fast = '';
b1(end).h.root = '3T';
b1(end).h.slow = 'B1_cal_long_TE_2201';
b1(end).h.fast = 'B1_cal_short_TE_2301';

%Patient 12
patient.num     = 12;
patient.r2      = 37.9;
patient.r2s     = 90.4;
patient.disease ='B-thal';
patient.examdate='7/18/2014';
patient.dob     ='7/19/1985';
patient.sex     ='f';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_012CL/07_18_2014';
b1(end).l.root = '1.5T';
b1(end).l.slow = 'WIP_B1_std_2501';
b1(end).l.fast = 'WIP_B1_fast_2801';
b1(end).h.root = '3T';
b1(end).h.slow = 'B1_cal_long_TE_2301';
b1(end).h.fast = 'B1_cal_short_TE_2401';

%Patient 13
patient.num     = 13;
patient.r2      = 17.35;
patient.r2s     = 51.95;
patient.disease = 'SCD';
patient.examdate= '6/25/2014';
patient.dob     = '2/4/1994';
patient.sex     = 'm';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_013KM/07_24_14';
b1(end).l.root = '1.5T';
b1(end).l.slow = 'WIP_B1_std_601';
b1(end).l.fast = 'WIP_B1_fast_701';
b1(end).h.root = '3T';
b1(end).h.slow = 'B1_cal_long_TE_601';
b1(end).h.fast = 'B1_cal_short_TE_701';

%Patient 14
patient.num     = 14;
patient.r2      = 124.05;
patient.r2s     = 417.9;
patient.disease = 'SCD';
patient.examdate= '8/4/2014';
patient.dob     = '4/20/1997';
patient.sex     ='f';

b1(end+1).patInfo = patient;
b1(end).patRoot  = '3T_014AB/08_05_2014';
b1(end).l.root = '';
b1(end).l.slow = '';
b1(end).l.fast = '';
b1(end).h.root = '3T';
b1(end).h.slow = 'B1_cal_long_TE_501';
b1(end).h.fast = 'B1_cal_short_TE_601';

%b1.root = 

%b1(end+1).patRoot = '';
%b1(end).l.root = '';
%b1(end).l.slow = '';
%b1(end).l.fast = '';
%b1(end).h.root = '';
%b1(end).h.slow = '';
%b1(end).h.fast = '';

% Compare 1.5 and 3T maps

sIndex = [];
fIndex = [];

for n=1:length(b1)
    if ~isempty(b1(n).l.slow) && ~isempty(b1(n).h.slow)
        sIndex(end+1) = n;
    end
    if ~isempty(b1(n).l.fast) && ~isempty(b1(n).h.fast)
        fIndex(end+1) = n;
    end
end

myStatsLow = [0 0];
myStatsHigh = [0 0];
for n=1:length(sIndex)
    ni=sIndex(n);
    [im m s per5 per95 roi myMap] = getStatsSlice(root,b1,sIndex(n),'low','fast',sliceNum);
    b1(ni).res.lowFast.im = im;
    b1(ni).res.lowFast.mean = m;
    b1(ni).res.lowFast.std = s;
    b1(ni).res.lowFast.per5 = per5;
    b1(ni).res.lowFast.per95 = per95;
    b1(ni).res.lowFast.roi = roi;
    b1(ni).res.lowFast.myMap = myMap;
    [im m s per5 per95 roi myMap] = getStatsSlice(root,b1,sIndex(n),'high','fast',sliceNum);
    b1(ni).res.highFast.im = im;
    b1(ni).res.highFast.mean = m;
    b1(ni).res.highFast.std = s;
    b1(ni).res.highFast.per5 = per5;
    b1(ni).res.highFast.per95 = per95;
    b1(ni).res.highFast.roi = roi;
    b1(ni).res.highFast.myMap = myMap;
end

myStatsLow = [0 0];
myStatsHigh = [0 0];
for n=1:length(sIndex)
    ni=sIndex(n);
    [im m s per5 per95 roi myMap] = getStatsSlice(root,b1,sIndex(n),'low','slow',sliceNum);
    b1(ni).res.lowSlow.im = im;
    b1(ni).res.lowSlow.mean = m;
    b1(ni).res.lowSlow.std = s;
    b1(ni).res.lowSlow.per5 = per5;
    b1(ni).res.lowSlow.per95 = per95;
    b1(ni).res.lowSlow.roi = roi;
    b1(ni).res.lowSlow.myMap = myMap;
    [im m s per5 per95 roi myMap] = getStatsSlice(root,b1,sIndex(n),'high','slow',sliceNum);
    b1(ni).res.highSlow.im = im;
    b1(ni).res.highSlow.mean = m;
    b1(ni).res.highSlow.std = s;
    b1(ni).res.highSlow.per5 = per5;
    b1(ni).res.highSlow.per95 = per95;
    b1(ni).res.highSlow.roi = roi;
    b1(ni).res.highSlow.myMap = myMap;
end


patIndex = fIndex;

end   



function [im, m, s, per5, per95, roi, myMap] = getStatsSlice(root,b1,ind,field,speed,slice)

if strcmp(field,'low')
    temp = b1(ind).l;
else
    temp = b1(ind).h;
end

if strcmp(speed,'fast')
    path = fullfile(root, b1(ind).patRoot,temp.root,temp.fast)
    a = dir(path);
    sNum = a(6).name;
    sNum = strsplit(sNum,'-');
    sNum = sNum{2};
    sNum = str2num(sNum);
else
    path = fullfile(root, b1(ind).patRoot,temp.root,temp.slow)
    a = dir(path)
    sNum = a(6).name;
    sNum = strsplit(sNum,'-');
    sNum = sNum{2};
    sNum = str2num(sNum);
end

mapNum = 12+slice %since all the scans are 3 slices -> 2 images, 2
                   %phase, 1 calc per slice, interleaved
assignin('base','sNum','sNum');
scanPrefix = sprintf('IM-%04d-%04d.dcm',sNum,mapNum);
im1Prefix = sprintf('IM-%04d-%04d.dcm',sNum,slice);
im2Prefix = sprintf('IM-%04d-%04d.dcm',sNum,slice+7);
roiPrefix = sprintf('liver-IM-%04i-%04i.dcm.mat',sNum,slice);
fullpath = fullfile(path,scanPrefix);
roiPath = fullfile(path,'ROI',roiPrefix);

%im = readDicomSeries(fullpath,'adjustScale',0);%this is actually ROI
im = readDicomSeries(fullpath);%this is actually ROI
im1 = readDicomSeries(fullfile(path,im1Prefix));%,'adjustScale',0);
im2 = readDicomSeries(fullfile(path,im2Prefix));%,'adjustScale',0);
im1(:,:,2) = im2;
myMap = dualTRb1map(im1,30,20,120);
ims=im; %myMap;
%assignin('base','im',im);
load(roiPath);

liverInd = find(roi);

m = mean(ims(liverInd));
s = std(ims(liverInd));
per5 = prctile(ims(liverInd),25);
per95 = prctile(ims(liverInd),75);

end
