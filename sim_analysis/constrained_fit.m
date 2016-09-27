function [S0o, R2o, Reso, Co, B1levelo, FE] = constrained_fit(simOutput,constrained, varargin)
%% that
p = inputParser;
p.addParameter('findShortenedTE',false);
p.addParameter('fixEamonPhaseError',false);
p.parse(varargin{:});
findShortenedTEbool = p.Results.findShortenedTE

FE = simOutput.simParams.FErange;
t = 0:simOutput.simParams.step:simOutput.simParams.interval;
TE = simOutput.simParams.TE;
for n=1:length(TE)
    TEInd(n) = find(TE(n)<=t,1,'first');
end
for n=1:length(simOutput.runParams)
    B1vals(n) = simOutput.runParams(n).FAExcite;
end



%% this
fitT2 = zeros(length(FE),length(B1vals));
S0 = fitT2;
T2 = fitT2;
C = fitT2;
Res = fitT2;
forwardT2 = zeros(length(FE),length(TE));
switch constrained
    case 'non-negative'
        lb(1:3)=[0,0,0];
        ub(1:3)=[Inf,Inf,Inf];
    case 'no_const'
        lb(1:3)=[0,0,0];
        ub(1:3)=[Inf,Inf,20];
    case 'bounded1'
        lb(1:3)=[simOutput.simParams.numProtons*.90,0,0];
        ub(1:3)=[simOutput.simParams.numProtons*1.1,1/10,Inf];
    case 'bounded2'
        lb(1:3)=[simOutput.simParams.numProtons*.90,0,0];
        ub(1:3)=[simOutput.simParams.numProtons*1.1,1/10,20];
    otherwise
        error('pick a proper bounding method');
end

% Initial parameter vector
x0=[simOutput.simParams.numProtons,.050,0];

% Setup optimization parameters
options = optimset('lsqcurvefit');
options.Display = 'off';
options.TolFun = 1e-6;
options.TolX = 1e-6;
options.MaxIter = 100;

for FEInd=1:min(length(FE),length(simOutput.signals))
    fprintf('FEInd = %i\n',FEInd);
    FEload = simOutput.signals{FEInd}.FE;
    try 
        B1size = size(simOutput.signals{1}.magnetizationSE.magOut,1);
    catch err
        B1size = size(simOutput.signals{1}.magnetizationSE,1);
    end
    for B1Ind = 1:B1size
        try
            sig = zeros(size(simOutput.signals{FEInd}.magnetizationSE.magOut,3), size(simOutput.signals{FEInd}.magnetizationSE.magOut,4));
            TEsize = size(simOutput.signals{FEInd}.magnetizationSE.magOut,4);
        catch err
            sig = zeros(size(simOutput.signals{FEInd}.magnetizationSE,3), size(simOutput.signals{FEInd}.magnetizationSE,4));
            TEsize = size(simOutput.signals{FEInd}.magnetizationSE,4);
        end
        
        
        for TEIndx = 1:TEsize
            try
                sig(:,TEIndx) = squeeze(complex(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,1,:,TEIndx),simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,2,:,TEIndx)));
            catch
                sig(:,TEIndx) = squeeze(complex(simOutput.signals{FEInd}.magnetizationSE(B1Ind,1,:,TEIndx),simOutput.signals{FEInd}.magnetizationSE(B1Ind,2,:,TEIndx)));
            end
        %echoes(TEIndx) = sig(TEInd(TEIndx),TEIndx);
        end
        
        %myTE = [3.131 4.718 7.4 10.72 15.97 22 35.57];
        %myTE = [3.389 4.789 7.093 10.78 16.72 28.44 49.0 55];
        myTE = TE;
        echoes = zeros(size(myTE));
        tempTE = echoes;
        
        if findShortenedTEbool
            for n=1:length(myTE)
                myInd(n) = find(myTE(n) <= t,1,'first');
                [echoes(n) tempTE(n)] = findShortenedTE(sig(:,9-n),myTE(n),t);
            end
            myTE = tempTE;
        else
            for TEIndx = 1:length(myTE)
                %sig(:,TEIndx) = squeeze(complex(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,1,:,TEIndx),simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,2,:,TEIndx)));
                tVal = TEIndx;
                if strcmp(simOutput.runParams(1).SimSelect,'CPMG');
                    tVal = 1;
                end
                echoes(TEIndx) = sig(TEInd(TEIndx),tVal);
             end
        end
        
        if p.Results.fixEamonPhaseError
            %z = squeeze(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,3,:));
            [xfit,ResT] = lsqcurvefit('expc',x0,myTE(1:2:length(TE))./1000,abs(echoes(1:2:length(TE))),lb,ub,options);
            %[S0(FEInd,B1Ind), T2(FEInd,B1Ind), C(FEInd,B1Ind), Res(FEInd,B1Ind)] = fitexp_mc(t(TEInd),abs(sig(TEInd)),50);

            S0(FEInd,B1Ind) = xfit(1);
            T2(FEInd,B1Ind) = xfit(2);
            C(FEInd,B1Ind) = xfit(3);
            Res(FEInd,B1Ind)=ResT;
            %fitR2(FEInd,B1Ind) = 1000./T2;
            %[xfit,ResT] = lsqcurvefit('expc',x0,myTE(2:2:length(TE))./1000,abs(echoes(2:2:length(TE)),lb,ub,options);
            %T2(FEInd,B1Ind) = mean(xfit(2),T2(FEInd,B1Ind));
            forwardR2(FEInd,B1Ind) = calcR2fromLIC(FEload,'R2');
            
        else
            %z = squeeze(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,3,:));
            [xfit,ResT] = lsqcurvefit('expc',x0,myTE./1000,abs(echoes),lb,ub,options);
            %[S0(FEInd,B1Ind), T2(FEInd,B1Ind), C(FEInd,B1Ind), Res(FEInd,B1Ind)] = fitexp_mc(t(TEInd),abs(sig(TEInd)),50);

            S0(FEInd,B1Ind) = xfit(1);
            T2(FEInd,B1Ind) = xfit(2);
            C(FEInd,B1Ind) = xfit(3);
            Res(FEInd,B1Ind)=ResT;
            %fitR2(FEInd,B1Ind) = 1000./T2;
            forwardR2(FEInd,B1Ind) = calcR2fromLIC(FEload,'R2');
        end
   end
end
%%
%forwardR2new = [forwardR2(:,end-2:end) forwardR2(:,1:end-3)];
fitR2 = 1./T2;
%fitR2a = [fitR2(:,end-2:end) fitR2(:,1:end-3)];
%B1a = [fliplr(B1vals(end-2:end)) B1vals(1:end-3)];
%S0a = [fliplr(S0(:,end-2:end)) S0(:,1:end-3)];
%fitR2a = [fliplr(fitR2(:,end-2:end)) fitR2(:,1:end-3)];
%Ca = [fliplr(C(:,end-2:end)) C(:,1:end-3)];
%Resa = [fliplr(Res(:,end-2:end)) Res(:,1:end-3)];

S0o = S0;
R2o = fitR2;
Reso = Res;
Co = C;
B1levelo = B1vals;

