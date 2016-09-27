
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
resFiles{1} = 'simoutput/e20150706_1p5T_CPMG_20150708_0949_fastecho.local.mat';
resFiles{2} = 'simoutput/e20150706_3p0T_CPMG_20150708_1309_fastecho.local.mat';

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

rIndx = [1 2];
for rIndex=rIndx
  load(resFiles{rIndex});    
  fprintf('loaded %s\n',resFiles{rIndex});
  
  doFit(simOutput,p.Results.TEshortening,p.Results.fixEamonPhaseError);
end


brUnc = rUnc;
brCon = rCon;

end

function [] = doFit(data,TEshortening,fixPhase)
global resFiles rUnc rCon B1g;
    fieldIndx = (data.simParams.B0 > 1.5)+1;
    
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
    
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'non-negative','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    %[S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'no_const','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
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
        
        
        
        
        
        
