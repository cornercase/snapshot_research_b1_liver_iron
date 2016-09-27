
% notes
% magOut(B1level, [xyz], t, echo)


function [brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_3(varargin)

p=inputParser;
p.addParameter('TEshortening',false);
p.addParameter('fixEamonPhaseError',false);
p.parse(varargin{:});

%% the files
global resFiles B1g; 
global rUnc rCon;
global verbostiy;
verbosity = 0;
fileRoot1 = '~/Desktop/results/shortTE/round1/';
%fileRoot2 = '~/Desktop/results/round2/';
fileRoot = fileRoot1;
filePath = {};
for n=[1:72]+72
    filePath{end+1} = [sprintf('Job%i/Task1.out.mat',n)];
end

%% set up the ouput matricies
FE = [1 5 10 15 20 25 30 35 40];
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
for rIndex=[1:length(filePath)];
    if verbosity > 0; filePath{rIndex}; end
    clear a a2;
    try
        a = load([fileRoot1 filePath{rIndex}],'argsout');
        a = a.argsout{1};
    catch err
      fprintf([fileRoot1 filePath{rIndex} '\n']);
    end
    try
        a2 = load([fileRoot2 filePath{rIndex}],'argsout');
        a2 = a2.argsout{1};
    catch err
        %fprintf([fileRoot2 filePath{rIndex} '\n']);
    end
    if exist('a')
      if exist('a2')
          if isfield(a,'magOut') && isfield(a2,'magOut');
            a.magOut = a.magOut + a2.magOut;
            a.numProtons = a.numProtons + a2.numProtons;
          end
      end
    else
      %a = a2;
    end
    try
    doFit(a,p.Results.TEshortening,p.Results.fixEamonPhaseError);
    catch
        continue;
    end
    
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

function [] = doFit(a,TEshortening,fixPhase)
global resFiles rUnc rCon B1g verbosity;
    fieldIndx = (a.B0 > 1.5)+1;
    if ~exist('a.FEout')
       feIndex = a.FEselect; 
    else
        [b feIndex] =  find(a.FEout==a.simOutput.simParams.FErange);
    end
    B1 = [];
    for n=1:length(a.runParmGp{a.runGpCount})
        B1(end+1) = a.runParmGp{a.runGpCount}(n).FAExcite;
    end
    if verbosity > 0; fprintf('Running iron = %i B1 = %s\n',a.simOutput.simParams.FErange(feIndex),num2str(B1)); end;
    %debugBool = (max(B1==(90-18)) && feIndex == 9 && fieldIndx==1);
    debugBool=0;
    if debugBool
            pause;
    end
    %[S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit2(a,'bounded1','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit2(a,'bounded2','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    for bIndx = 1:length(B1o);
        if verbosity > 0; fprintf('B1Indx = %i\n',bIndx); end
        [dasfas, mainIndex] = find(B1g==B1o(bIndx));
        if verbosity > 0; fprintf('B1g = %i, B1o = %i\n',B1g(mainIndex),B1o(bIndx)); end;
        
        rCon(fieldIndx).S0(feIndex,mainIndex) = S0o(1,bIndx);
        rCon(fieldIndx).R2(feIndex,mainIndex) = R2o(1,bIndx);
        rCon(fieldIndx).Res(feIndex,mainIndex) = Reso(1,bIndx);
        rCon(fieldIndx).C(feIndex,mainIndex) = Co(1,bIndx);

        %B1o
        
    end
    
    %[S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit2(a,'non-negative','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit2(a,'no_const','findShortenedTE',TEshortening,'fixEamonPhaseError',fixPhase);
    
    for bIndx = 1:length(B1o);
        [dasfas, mainIndex] = find(B1g==B1o(bIndx));
        
        rUnc(fieldIndx).S0(feIndex,mainIndex) = S0o(1,bIndx);
        rUnc(fieldIndx).R2(feIndex,mainIndex) = R2o(1,bIndx);
        rUnc(fieldIndx).Res(feIndex,mainIndex) = Reso(1,bIndx);
        rUnc(fieldIndx).C(feIndex,mainIndex) = Co(1,bIndx);
        
    end    
    %}
end
        
        
        
        
        
        
