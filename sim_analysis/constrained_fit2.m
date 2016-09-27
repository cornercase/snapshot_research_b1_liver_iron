function [S0o, R2o, Reso, Co, B1levelo, FE] = constrained_fit2(a,constrained, varargin)
%% that
p = inputParser;
p.addParameter('findShortenedTE',false);
p.addParameter('fixEamonPhaseError',false);
p.addParameter('verbosity',0);
p.addParameter('echoTruncAboveFE',-1);
p.addParameter('echoTruncIndxArray',[1 3]);
p.addParameter('B1_PDE_correction',false);
p.addParameter('B1_echo_correction',false);
p.addParameter('B1',[]);
p.addParameter('noiseCorrection','none');
p.addParameter('noiseInd',114102);
p.addParameter('fitModel','expc');
p.parse(varargin{:});
findShortenedTEbool = p.Results.findShortenedTE;
verbosity = p.Results.verbosity;
echoTruncAboveFE = p.Results.echoTruncAboveFE;
echoTruncIndxArray = p.Results.echoTruncIndxArray;
B1_PDE_correction = p.Results.B1_PDE_correction;
B1_echo_correction = p.Results.B1_echo_correction;
noiseCorrection = p.Results.noiseCorrection;
FE = a.FE(a.FEselect);

t = 0:a.step:a.interval;
TE = a.simOutput.simParams.TE;
for n=1:length(TE)
    TEInd(n) = find(2*TE(n)<=t,1,'first');
end
if isempty(p.Results.B1)
    for n=1:length(a.runParmGp{a.runGpCount})
        B1vals(n) = a.runParmGp{a.runGpCount}(n).FAExcite;
    end
else
    B1vals=p.Results.B1;
end


%% this
fitT2 = zeros(length(FE),length(B1vals));
S0 = fitT2;
T2 = fitT2;
C = fitT2;
Res = fitT2;
forwardT2 = zeros(length(FE),length(TE));
if strcmp(a.runParams(1).SimSelect,'CPMG')
    isCPMG=1;
    display('Running CPMG');
else
    isCPMG=0;
end
switch constrained
    case 'non-negative'
        lb(1:3)=[0,0,0];
        ub(1:3)=[Inf,Inf,Inf];
    case 'no_const'
        lb(1:3)=[0,0,0];
        ub(1:3)=[Inf,Inf,20];
    case 'bounded1'
        lb(1:3)=[a.numProtons*.90,0,0];
        ub(1:3)=[a.numProtons*1.1,1/10,Inf];
    case 'bounded2'
        lb(1:3)=[a.numProtons*.90,0,0];
        ub(1:3)=[a.numProtons*1.1,1/10,20];
    otherwise
        error('pick a proper bounding method');
end

% Initial parameter vector
x0=[a.numProtons,.050,0];

% Setup optimization parameters
options = optimset('lsqcurvefit');
options.Display = 'off';
options.TolFun = 1e-6;
options.TolX = 1e-6;
options.MaxIter = 100;

for FEInd=1:min(length(FE),1)
    FEload = a.FE(a.FEselect);
    if verbosity > 0; fprintf('FEInd = %i\n',FEInd); end;
    
    try 
        B1size = size(a.magOut,1);
    catch err
        B1size = size(a.magnetizationSE,1);
    end
    for B1Ind = 1:B1size
        
        sig = zeros(size(a.magOut,3), size(a.magOut,4));
        TEsize = size(a.magOut,4);
        
        for TEIndx = 1:TEsize
            sig(:,TEIndx) = squeeze(complex(a.magOut(B1Ind,1,:,TEIndx),a.magOut(B1Ind,2,:,TEIndx)));
            %echoes(TEIndx) = sig(TEInd(TEIndx),TEIndx);
        end
        
        
        %myTE = [3.131 4.718 7.4 10.72 15.97 22 35.57];
        %myTE = [3.389 4.789 7.093 10.78 16.72 28.44 49.0 55];
        myTE = TE;
        echoes = zeros(size(myTE));
        tempTE = echoes;
        if findShortenedTEbool
            if isCPMG
                error('te find login will not work with CMPG');
            end
            for n=1:length(myTE)
                myInd(n) = find(myTE(n) <= t,1,'first');
                [echoes(n) tempTE(n)] = findShortenedTE(sig(:,9-n),myTE(n),t);
            end
            myTE = tempTE;
        else
            if isCPMG
                sInt = [];
                for n=1:10
                    [b indT] = find(t>myTE(n),1,'first');
                    sInt(end+1) = sig(indT);
                   % aTE(end+1)  = myTE(n);
                end
                echoes=sInt;
            else
                for TEIndx = 1:length(myTE)
                    %sig(:,TEIndx) = squeeze(complex(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,1,:,TEIndx),simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,2,:,TEIndx)));
                    tVal = TEIndx;
                    if strcmp(a.runParams(1).SimSelect,'CPMG');
                        tVal = 1;
                    end
                    echoes(TEIndx) = sig(TEInd(TEIndx),tVal);
                end
            end
        end
        
        
        %Noise correction
        if ~strcmp(p.Results.noiseCorrection,'none')
            if ~isreal(echoes)
                echoes = abs(echoes);
            end
            for n=1:length(echoes)
            %    bias = calcBias(echoes(n),sig,p.Results.noiseInd,p.Results.noiseCorrection);
            %    echoes(n) = echoes(n)-bias;
            end
        end
            
        if isCPMG
            myTE = myTE(2:2:end);
            if strcmp(noiseCorrection,'complex')
                echoes = abs(echoes(2:2:end));
            end
        end
        
        if B1_echo_correction
            warning('experimental b1 correction, not validated');
            echoCorrectionArray = zeros(1,length(echoes));
            if strcmp(a.runParams(1).SimSelect,'CPMG');
                echoCorrectionArray = ones(1,10);
                %echoCorrectionArray(1:2:end) = cosd(2*B1vals(B1Ind));
                e1 = sqrt((sind(2*B1vals(B1Ind)).*cosd(B1vals(B1Ind))).^2 + sind(B1vals(B1Ind)).^2);
                e2 = sqrt(sind(B1vals(B1Ind)).^2);
                echoCorrectionArray(2:2:end) = e2/e1;
                
                %echoCorrectionArray(1:2:end) = B1vals(B1Ind)/90;
                %echoCorrectionArray(1:2:end) = sind(B1vals(B1Ind)).^2;
                if B1_PDE_correction
                    error('logic probably wrong');
                end
                if FE==50
                    disp 'iron 50';
                end
                
            else
                if B1_PDE_correction
                    b1_excite_cor = 1;
                else
                    b1_excite_cor = sind(B1vals(B1Ind));
                end
                echoCorrectionArray(1) = b1_excite_cor;
                %echoCorrectionArray(1:end) = b1_excite_cor*(cosd(2*B1vals(B1Ind)));
                % i think that the cosine-only method of correction is more
                % mathematically correct, but behaves poorly near cos(angle)=0
                echoCorrectionArray = sqrt((-sind(2*B1vals(B1Ind)).*cosd(B1vals(B1Ind)).^2 ...
                    + sind(B1vals(B1Ind)).^2)).*sind(B1vals(B1Ind));
                %echoCorrectionArray = B1vals(B1Ind)/90; %this pretty much sucked, probably wrong
            end
            echoes = echoes ./ echoCorrectionArray;
        end
        
        if echoTruncAboveFE > 0 && echoTruncAboveFE  <= a.FE(a.FEselect)
            myTE = myTE(echoTruncIndxArray(1):echoTruncIndxArray(2));
            echoes = echoes(echoTruncIndxArray(1):echoTruncIndxArray(2));
        end
        
        %z = squeeze(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,3,:));
        ubi =ub;
        lbi = lb;
        if B1_PDE_correction
            ubi(1) = sind(B1vals(B1Ind))*ubi(1);
            lbi(1) = sind(B1vals(B1Ind))*lbi(1);
            fprintf('Decreasing B1 by %f for excite angle %i\n',sind(B1vals(B1Ind)),B1vals(B1Ind));
        end
        switch p.Results.fitModel
            case 'exp'
                inds = [1 2];
            case 'expc'
                inds = [1 2 3];
            otherwise
                error(['unrecognized fit: ' p.Results.fitModel]);
        end
        eDebug(sprintf('FEInd %i B1Ind %i',FEInd , B1Ind));
        if strcmp(p.Results.fitModel,'exp');
            fitModel = 'expF';
        else
            fitModel = p.Results.fitModel;
        end
        %[xfit,ResT] = lsqcurvefit(fitModel,x0(inds),myTE./1000,abs(echoes),lbi(inds),ubi(inds),options);
        %[S0(FEInd,B1Ind), T2(FEInd,B1Ind), C(FEInd,B1Ind), Res(FEInd,B1Ind)] = fitexp_mc(t(TEInd),abs(sig(TEInd)),50);
        pdeb = [lb(1) ub(1)];
        [S0T,R2T,ResT] = cfitexp(myTE./1000,abs(echoes),'pde_constraint',pdeb);
        S0(FEInd,B1Ind) = S0T;
        T2(FEInd,B1Ind) = 1./R2T;
        %if max(inds) >= 3
        %    C(FEInd,B1Ind) = xfit(3);
        %end
        Res(FEInd,B1Ind)=ResT;
        %fitR2(FEInd,B1Ind) = 1000./T2;
        forwardR2(FEInd,B1Ind) = calcR2fromLIC(FEload,'R2');
        
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
end

%{
function [bias] = calcBias(echo,sig,ind,noiseType)
    [SNR,sigma]=findSNR(echo,sig,ind,noiseType);
    
    bias=sigma*(-0.058*SNR.^3+0.41*SNR.^2-0.98*SNR+0.79);
end

%SNR=expF(x_fit(1:2),t)/sigma;
%                SNR=min(SNR,2.5);
%                bias=sigma*(-0.058*SNR.^3+0.41*SNR.^2-0.98*SNR+0.79);

function [snr,sigma] = findSNR(echo,sig,ind,noiseType)
    sigma = std(sig(ind:end));
    if strcmpi(noiseType,'rician')
        factor = 0.655/sigma;
    else
        error(['unknown noise type: ',noiseType]);
    end

    snr = echo*factor;
end

%}