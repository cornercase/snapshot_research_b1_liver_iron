
% notes
% magOut(B1level, [xyz], t, echo)


function [brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc()

%% the files
global resFiles B1g; 
global rUnc rCon;
resFiles{1} = 'simoutput/e20150629_48_66_1p5T_SE_20150708_1305_fastecho.local.mat';
resFiles{2} = 'simoutput/e20150629_48_66_3p0T_SE_20150715_0723_fastecho.local.mat';
resFiles{3} = 'simoutput/e20150629_72_90_1p5T_SE_20150709_0317_fastecho.local.mat';
resFiles{4} = 'simoutput/e20150629_72_90_3p0T_SE_20150707_1117_fastecho.local.mat';
resFiles{5} = 'simoutput/e20150629_96_114_1p5T_SE_20150713_1503_fastecho.local.mat';
resFiles{6} = 'simoutput/e20150629_96_114_3p0T_SE_20150710_2158_fastecho.local.mat';
resFiles{7} = 'simoutput/e20150714_60_88_114_1p5T_SE_20150730_0503_fastecho.local_fixed.mat';
resFiles{8} = 'simoutput/e20150714_60_88_114_3T_SE_20150806_1521_fastecho.local_fixed.mat';
resFiles{9} = 'simoutput/e20150706_1p5T_CPMG_20150708_0949_fastecho.local.mat';
resFiles{10} = 'simoutput/e20150706_3p0T_CPMG_20150708_1309_fastecho.local.mat';

%% set up the ouput matricies
FE = [1 5 10 15 20 25 30 35 40 45 50];
B1g = [48:6:114];
B1 = B1g;
res1 = zeros(length(FE),length(B1));
rUnc = struct;
rUnc.field = '1.5T';
rUnc.fittype = 'noPD';
rUnc.R2 = res1;
rUnc.S0 = res1;
rUnc.Res = res1;
rUnc.C = res1;

rUnc(2) = rUnc;
rUnc(2).field = '3T';

rCon = rUnc;
rCon(1).fittype = 'PD';
rCon(2).fittype = 'PD';


%1.5T, 3T SE fits
for rIndx = [  6 8]
  load(resFiles{rIndx});    
  fprintf('loaded %s',resFiles{rIndx});
  doFit(simOutput);
end


brUnc = rUnc;
brCon = rCon;
% if strcmp(refit,'y');
%     clear f refit;
%     [f.S0, f.R2, f.Res, f.C, f.B1, f.FE] = constrained_fit(simOutput,'non-negative');
%     f.fit = 'non-negative';
%     [f(2).S0, f(2).R2, f(2).Res, f(2).C, f(2).B1, f(2).FE] = constrained_fit(simOutput,'bounded1');
%     f(2).fit = 'bounded1';
%     clear -regexp ^[A-Z]*
% else
%     
%     make_fig_comparison;
% end
end

function [] = doFit(data)
global resFiles rUnc rCon B1g;
    fieldIndx = (data.simParams.B0 > 1.5)+1;
    
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'bounded1');
    for bIndx = 1:length(B1o);
        bIndx
        [a, mainIndex] = find(B1g==B1o(bIndx));
        if ~isempty(mainIndex)
            warning('this is a kludge')
            B1g(mainIndex)
            B1o(bIndx)

            rCon(fieldIndx).S0(:,mainIndex) = S0o(:,bIndx);
            rCon(fieldIndx).R2(:,mainIndex) = R2o(:,bIndx);
            rCon(fieldIndx).Res(:,mainIndex) = Reso(:,bIndx);
            rCon(fieldIndx).C(:,mainIndex) = Co(:,bIndx);
            B1o
        end
    end
    
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'non-negative');
    for bIndx = 1:length(B1o);
        [a, mainIndex] = find(B1g==B1o(bIndx));
        if ~isempty(mainIndex)
            rUnc(fieldIndx).S0(:,mainIndex) = S0o(:,bIndx);
            rUnc(fieldIndx).R2(:,mainIndex) = R2o(:,bIndx);
            rUnc(fieldIndx).Res(:,mainIndex) = Reso(:,bIndx);
            rUnc(fieldIndx).C(:,mainIndex) = Co(:,bIndx);
        end
    end    
    
end
        
        
        
        
        
        
