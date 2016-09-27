
% notes
% magOut(B1level, [xyz], t, echo)


function [brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2_CPMG_round2(varargin)

p=inputParser;
p.addParameter('TEshortening',false);
p.addParameter('fixEamonPhaseError',false);
p.parse(varargin{:});

%% the files
global resFiles B1g; 
global rUnc rCon;
%clear resFiles b1g rUnc rCon simOutputHigh simOutputLow;
resFiles1{1}     = 'simoutput/CPMG_2/FE_01_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_05_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_10_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_15_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_20_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_25_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_30_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_35_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_40_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_45_1.5.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_50_1.5.mat';


resFiles2{1}     = 'simoutput/CPMG_2/FE_01_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_05_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_10_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_15_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_20_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_25_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_30_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_35_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_40_3p0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_45_3.0.mat';
resFiles2{end+1} = 'simoutput/CPMG_2/FE_50_3.0.mat';
%assignin('base','resFiles',resFiles);


for n=1:length(resFiles1)
    fprintf('Loading %s\n',resFiles1{n});
    load( resFiles1{n} );
    fprintf('Field %02.1d\n',out.B0);
    if n==1
        simOutputLow = out.simOutput;
    end
    simOutputLow.signals{n}.magnetizationSE = out.magOut;
    simOutputLow.signals{n}.FE = out.FEOut;
end

for n=1:length(resFiles2)
    fprintf('Loading %s\n',resFiles2{n});
    load( resFiles2{n} );
    fprintf('Field %02.1d\n',out.B0);
    if n==1
        simOutputHigh = out.simOutput;
    end
    simOutputHigh.signals{n}.magnetizationSE = out.magOut;
    simOutputHigh.signals{n}.FE = out.FEOut;
end
assignin('base','simOutputLow',simOutputLow);
assignin('base','simOutputHigh',simOutputHigh);

%% set up the ouput matricies
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
%for rIndex=rIndx
%  load(resFiles{rIndex});    
% fprintf('loaded %s\n',resFiles{rIndex});
disp('fitting low');  
  doFit(simOutputLow,p.Results.TEshortening,p.Results.fixEamonPhaseError);
disp('fitting high');
  doFit(simOutputHigh,p.Results.TEshortening,p.Results.fixEamonPhaseError);%end


  
  
brUnc = rUnc;
brCon = rCon;

end

function [] = doFit(data,TEshortening,fixPhase)
global rUnc rCon B1g;
    fieldIndx = (data.simParams.B0 > 1.5)+1
    fprintf('Field is %2.1f\n',data.simParams.B0);
    
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'bounded2','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
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
    disp('finished doFit');
end
        
        
        
        
        
        
