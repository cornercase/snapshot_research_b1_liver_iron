
% notes
% magOut(B1level, [xyz], t, echo)


function [brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2(varargin)

p=inputParser;
p.addParameter('TEshortening',false);
p.addParameter('fixEamonPhaseError',false);
p.parse(varargin{:});

%% the files
global resFiles B1g; 
global rUnc rCon;
resFiles{1} = 'simoutput/e20150629_48_66_1p5T_SE_20150708_1305_fastecho.local.mat';
resFiles{2} = 'simoutput/e20150629_48_66_3p0T_SE_20150715_0723_fastecho.local.mat';
resFiles{3} = 'simoutput/e20150629_72_90_1p5T_SE_20150709_0317_fastecho.local.mat';
%resFiles{4} = 'simoutput/e20150629_72_90_3p0T_SE_20150707_1117_fastecho.local.mat';
resFiles{4} = 'simoutput/e20150629_72_90_3p0T_SE_20151212_0000_fastecho.local_fixed.mat';
resFiles{5} = 'simoutput/e20150629_96_114_1p5T_SE_20150713_1503_fastecho.local.mat';
resFiles{6} = 'simoutput/e20150629_96_114_3p0T_SE_20150710_2158_fastecho.local.mat';
%resFiles{7} = 'simoutput/e20150714_60_88_114_1p5T_SE_20150730_0503_fastecho.local_fixed.mat';
resFiles{7} = 'simoutput/e20150714_60_88_114_1p5T_SE_20150730_0503_fastecho.local.mat';
resFiles{8} = 'simoutput/e20150714_60_88_114_3T_SE_20150806_1521_fastecho.local_fixed.mat';
resFiles{9} = 'simoutput/e20150821_1p5T_SE_84_20150825_0021_splinter.local_fixed.mat';
resFiles{10} = 'simoutput/e20150821_3T_SE_84_20150826_1515_fastecho.local_fixed.mat';
resFiles{11} = 'simoutput/e20150706_1p5T_CPMG_20150708_0949_fastecho.local.mat';
resFiles{12} = 'simoutput/e20150706_3p0T_CPMG_20150708_1309_fastecho.local.mat';
resFiles{13} = 'simoutput/e20151214_106_3T_SE_20151217_2105_splinter.fixed.mat';
resFiles{14} = 'simoutput/e20151214_106_1p5T_SE_20151221_2119_splinter_fixed.mat';
resFiles{15} = 'simoutput/e20160120_3T_SE_84_reducedFE_20160121_1802_splinter.mat';
resFiles{16} = 'simoutput/e20160120_1p5T_60_66_reducedFE_20160122_1738_fastecho.mat';
%resFiles{17} = 'simoutput/e20160127_1p5T_SE_48_54_reducedFE_20160129_2329_splinter.mat';
resFiles{17} = 'simoutput/e20160203_1p5T_SE_48_54_66_reducedFE_splinter_20160205.mat'; %1,5
resFiles{18} = 'simoutput/e20160203_1p5T_SE_48_54_66_reducedFE_fastecho_20160205_0531_fastecho.mat'; %15,10

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
rIndx1 = [2 4 6 8 10 13]; %3T SE
rIndx2 = [1 3 5 7 9 14]; %1.5T SE
rIndx = [rIndx1 rIndx2];
for rIndex=rIndx
  load(resFiles{rIndex});    
  fprintf('loaded %s\n',resFiles{rIndex});
  if rIndex==1
      temp = load(resFiles{16});
      for n=1:length(temp.simOutput.signals)
          simOutput.signals{n}.magnetizationSE.magOut(end,:,:,:) = temp.simOutput.signals{n}.magnetizationSE(2,:,:,:);
      end
      temp = load(resFiles{17});
        simOutput.signals{1}.magnetizationSE.magOut(:,:,:,:) = temp.simOutput.signals{1}.magnetizationSE(:,:,:,:);
        simOutput.signals{2}.magnetizationSE.magOut(:,:,:,:) = temp.simOutput.signals{2}.magnetizationSE(:,:,:,:);
      temp = load(resFiles{18});
        simOutput.signals{4}.magnetizationSE.magOut(:,:,:,:) = temp.simOutput.signals{1}.magnetizationSE(:,:,:,:);
        simOutput.signals{3}.magnetizationSE.magOut(:,:,:,:) = temp.simOutput.signals{2}.magnetizationSE(:,:,:,:);
      %for n=1:length(temp.simOutput.signals)
      %    simOutput.signals{n}.magnetizationSE.magOut(1,:,:,:) = temp.simOutput.signals{n}.magnetizationSE(1,:,:,:);
      %    simOutput.signals{n}.magnetizationSE.magOut(2,:,:,:) = temp.simOutput.signals{n}.magnetizationSE(2,:,:,:);
      %end
  end
  if rIndex==7
      %temp = load(resFiles{16});
      %for n=1:length(temp.simOutput.signals)
      %    simOutput.signals{n}.magnetizationSE.magOut(1,:,:,:) = temp.simOutput.signals{n}.magnetizationSE(1,:,:,:);
      %end
  end
  if rIndex==4
      temp = load('simoutput/e20150629_72_90_3p0T_SE_20150707_1117_fastecho.local.mat');
      simOutput.signals{10} = temp.simOutput.signals{10};
      simOutput.signals{11} = temp.simOutput.signals{11};
  
  if rIndex==10
      temp = load(resFiles{15});
      for n=1:length(simOutput.signals)
          for m = 1:length(temp.simOutput.signals)
            if simOutput.signals{n}.FE == temp.simOutput.signals{m}.FE
                simOutput.signals{n}.magnetizationSE.magOut(1,:,:,:) = temp.simOutput.signals{m}.magnetizationSE(1,:,:,:);
            end
          end
      end
  end
  
  doFit(simOutput,p.Results.TEshortening,p.Results.fixEamonPhaseError);
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

function [] = doFit(data,TEshortening,fixPhase)
global resFiles rUnc rCon B1g;
    fieldIndx = (data.simParams.B0 > 1.5)+1;
    if fieldIndx == 2
        B1g(find(B1g == 108)) = 106;
    end

    
    
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'bounded1','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    %[S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'bounded2','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    for bIndx = 1:length(B1o);
        fprintf('B1Indx = %i\n',bIndx);
        [a, mainIndex] = find(B1g==B1o(bIndx));
        if ~isempty(mainIndex)
            warning('this is a kludge')
            fprintf('B1g = %i, B1o = %i\n',B1g(mainIndex),B1o(bIndx));

            rCon(fieldIndx).S0(:,mainIndex) = S0o(:,bIndx);
            rCon(fieldIndx).R2(:,mainIndex) = R2o(:,bIndx);
            rCon(fieldIndx).Res(:,mainIndex) = Reso(:,bIndx);
            rCon(fieldIndx).C(:,mainIndex) = Co(:,bIndx);
            %B1o
        end
    end
    
    %[S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'non-negative','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'no_const','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
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
        
        
        
        
        
        
