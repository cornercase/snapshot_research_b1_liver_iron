%% that
FE = simOutput.simParams.FErange;
t = 0:simOutput.simParams.step:simOutput.simParams.interval;
TE = simOutput.simParams.TE;
for n=1:length(TE)
    TEInd(n) = find(TE(n)<=t,1,'first');
end
for n=1:7
    B1vals(n) = simOutput.runParams(n).FAExcite;
end
%for FEInd=1:length(FE)
%   for B1Ind = 1:size(simOutput.signals{1}.magnetizationSE


%% this
fitT2 = zeros(length(FE),length(B1vals));
S0 = fitT2;
T2 = fitT2;
C = fitT2;
Res = fitT2;
forwardT2 = zeros(length(FE),length(TE));
lb(1:3)=[0,0,0];
ub(1:3)=[Inf,Inf,Inf];

% Initial parameter vector
x0=[1500,.050,0];

% Setup optimization parameters
options = optimset('lsqcurvefit');
options.Display = 'off';
options.TolFun = 1e-6;
options.TolX = 1e-6;
options.MaxIter = 100;

for FEInd=1:length(FE)
    FEload = simOutput.signals{FEInd}.FE;
    for B1Ind = 1:size(simOutput.signals{1}.magnetizationSE.magOut,1)
        sig = squeeze(complex(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,1,:),simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,2,:)));
        z = squeeze(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,3,:));
        [xfit,ResT] = lsqcurvefit('expc',x0,t(TEInd)./1000,abs(sig(TEInd))',lb,ub,options);
        %[S0(FEInd,B1Ind), T2(FEInd,B1Ind), C(FEInd,B1Ind), Res(FEInd,B1Ind)] = fitexp_mc(t(TEInd),abs(sig(TEInd)),50);
        
        S0(FEInd,B1Ind) = xfit(1);
        T2(FEInd,B1Ind) = xfit(2);
        C(FEInd,B1Ind) = xfit(3);
        Res(FEInd,B1Ind)=ResT;
        %fitR2(FEInd,B1Ind) = 1000./T2;
        forwardR2(FEInd,B1Ind) = calcR2fromLIC(FEload,'R2');
   end
end
%%
forwardR2new = [forwardR2(:,end-2:end) forwardR2(:,1:end-3)];
fitR2 = 1./T2;
fitR2a = [fitR2(:,end-2:end) fitR2(:,1:end-3)];
B1a = [fliplr(B1vals(end-2:end)) B1vals(1:end-3)];
S0a = [fliplr(S0(:,end-2:end)) S0(:,1:end-3)];
fitR2a = [fliplr(fitR2(:,end-2:end)) fitR2(:,1:end-3)];
Ca = [fliplr(C(:,end-2:end)) C(:,1:end-3)];
Resa = [fliplr(Res(:,end-2:end)) Res(:,1:end-3)];

   

