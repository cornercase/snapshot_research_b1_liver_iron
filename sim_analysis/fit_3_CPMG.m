
% notes
% magOut(B1level, [xyz], t, echo)


function [bR, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2_CPMG_round2(varargin)

p=inputParser;
p.addParameter('fitType','no_const');
p.addParameter('TEshortening',false);
p.addParameter('fixEamonPhaseError',false);
p.addParameter('B1_PDE_correction',false);
p.addParameter('B1_echo_correction',false);
p.addParameter('echoTruncAboveFE',-1);
p.addParameter('echoTruncIndxArray',[1 3]);
p.addParameter('noiseCorrection','none');
p.parse(varargin{:});

%% the files
global verbosity;
global B1g; 
global r;
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


resFiles1{end+1} = 'simoutput/CPMG_2/FE_01_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_05_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_10_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_15_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_20_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_25_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_30_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_35_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_40_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_45_3.0.mat';
resFiles1{end+1} = 'simoutput/CPMG_2/FE_50_3.0.mat';
%assignin('base','resFiles',resFiles);

FE = [1 5 10 15 20 25 30 35 40 45 50];
B1g = [48:6:114];
B1 = B1g;
res1 = zeros(length(FE),length(B1));
r = struct;
r.field = '1.5T';
r.fittype = p.Results;
r.R2 = res1;
r.S0 = res1;
r.Res = res1;
r.C = res1;

r(2) = r;
r(2).field = '3T';

for n=1:length(resFiles1)
    fprintf('Loading %s\n',resFiles1{n});
    load( resFiles1{n} );
    fprintf('Field %02.1d\n',out.B0);
    if n==1
        simOutputLow = out.simOutput;
    end
    out.runParams = out.simOutput.runParams;
    doFit(...
        out,p.Results.fitType,...
        p.Results.TEshortening,...
        p.Results.fixEamonPhaseError,...
        p.Results.B1_PDE_correction,...
        p.Results.B1_echo_correction,...
        p.Results.echoTruncAboveFE,...
        p.Results.echoTruncIndxArray,...
        p.Results.noiseCorrection);
end
  
bR = r;


end

function [] = doFit(a,fitType,TEshortening,fixPhase,pdeCor,echoCor,echoTruncFe,echoTruncAr,noiseCorrection)
global r B1g verbosity;
    
    fieldIndx = (a.B0 > 1.5)+1
    if ~exist('a.FEout')
       feIndex = a.FEselect; 
    else
        [b feIndex] =  find(a.FEout==a.simOutput.simParams.FErange);
    end
    B1 = [];
    B1=B1g;
    if verbosity > 0; fprintf('Running iron = %i B1 = %s\n',a.simOutput.simParams.FErange(feIndex),num2str(B1)); end;
    %debugBool = (max(B1==(90-18)) && feIndex == 9 && fieldIndx==1);
    debugBool=0;
    if debugBool
            pause;
    end
    %[S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'bounded2','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    %[S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'bounded2','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit2(a,fitType,'findShortenedTE',TEshortening,'fixEamonPhaseError'...
        ,fixPhase,'echoTruncAboveFE',echoTruncFe,'B1_PDE_correction',pdeCor,'B1_echo_correction',echoCor,'B1',B1,...
        'echoTruncIndxArray',echoTruncAr,'noiseCorrection',noiseCorrection);
    %for bIndx = 1:length(B1o);
%        fprintf('B1Indx = %i\n',bIndx);
        %[a, mainIndex] = find(B1g==B1o(bIndx));
        %if ~isempty(mainIndex)
            warning('this is a kludge')
            %fprintf('B1g = %i, B1o = %i\n',B1g(mainIndex),B1o(bIndx));

            r(fieldIndx).S0(feIndex,:) = S0o;
            r(fieldIndx).R2(feIndex,:) = R2o;
            r(fieldIndx).Res(feIndex,:) = Reso;
            r(fieldIndx).C(feIndex,:) = Co;
            %B1o
       % end
    %end
    
    disp('finished doFit');
end
        
        
        
        
        
        
