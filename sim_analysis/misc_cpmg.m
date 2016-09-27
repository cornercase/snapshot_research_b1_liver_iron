
root = './simoutput/CPMG_2/';

%  This fileis just scratch paper
if ~exist('a')
    a = load([root 'FE_01_1.5.mat']);
    a = a.out;
    %rG = a.runParmGp;
    B1 = 48:6:114;
    FE = a.FE;
end
pickB1 = 90;
pickIronLoad = 30;
pickField = 3;
shortenedTE = true;
s0mult=1;

brUnc = load('fits_CPMG_2_no_const.mat','r');
brUnc.bR = brUnc.r;
brCon = load('fits_CPMG_2_bounded2.mat','r');
brCon.bR = brCon.r;
brCor = load('fits_CPMG_2_bounded2_EchoCor.mat','r');
brCor.bR = brCor.r;

fname = sprintf('FE_%02i_%0.1f.mat',pickIronLoad,pickField);
a = load([root fname]);
a = a.out;

%for m=1:length(a.simOutput.runParams)
 %   if a.simOutput.runParams.FAExcite(m) == pickB1;
%        b1fitind = [m];
%    end
%end




[b B1idx] = find(B1==pickB1);
idx = [a.FEselect,B1idx];

shortenedTE = false;
t = 0:a.step:a.interval;
te = a.simOutput.simParams.TE;
aTE = [];
sInt = [];
figure;

feInd =1 ;
for n=1:10
    try
        sig = squeeze(abs(complex( ...
        a.magOut(feInd,1,:), ...
        a.magOut(feInd,2,:))));
    end
    h = plot( t, sig);
    hold on;
    if shortenedTE
        [sInt(end+1) aTE(end+1)] = findShortenedTE(sig,te(n),t);
    else
        [b indT] = find(t>te(n),1,'first');
        sInt(end+1) = sig(indT);
        aTE(end+1)  = te(n);
    end
    
    plot(aTE,sInt,'b.','MarkerSize',25);
    %set(h,'Color',[get(h,'Color') .2]);
    set(h,'Color',[get(h,'Color')]);
end
echoes = sInt;
TE = aTE;
echoCorrectionArray = ones(1,10);
echoCorrectionArray(1:2:end) = abs(cosd(2*pickB1));
echoesCor = echoes ./ echoCorrectionArray;
plot(aTE,echoesCor,'g.','MarkerSize',25);
xlabel('Time (ms)')
ylabel('Transverse magnetization (a.u.)');
field = round(pickField/1.5);
overlayCon = s0mult*brCon.bR(field).S0(idx(1),idx(2)) .* exp( -brCon.bR(field).R2(idx(1),idx(2)).*t/1000 ) + brCon.bR(field).C(idx(1),idx(2));
overlayCor = s0mult*brCon.bR(field).S0(idx(1),idx(2)) .* exp( -brCon.bR(field).R2(idx(1),idx(2)).*t/1000 ) + brCon.bR(field).C(idx(1),idx(2));
overlayUnc = s0mult*brUnc.bR(field).S0(idx(1),idx(2)) .* exp( -brUnc.bR(field).R2(idx(1),idx(2)).*t/1000 ) + brUnc.bR(field).C(idx(1),idx(2));

plot(t, overlayCon, 'r','LineWidth',2)
plot(t, overlayCor, 'b','LineWidth',2)
plot(t, overlayUnc, 'g','LineWidth',2)
title(sprintf('Excitation angle = %i  Iron = %i',pickB1, pickIronLoad));
axes('Position',[.75,.75,.12,.12]);
set(gca,'XTick',[],'YTick',[],'XTickLabel',[],'YTickLabel',[]);
set(gca,'visible','off');
axis off;
xlim([0 1]);
ylim([0,1]);
plot([0 1],[.25,.25],'r','LineWidth',2);
hold on;
plot([0 1],[.75,.75],'g','LineWidth',2);
set(gca,'Box','off','YColor',[1 1 1],'XColor',[1 1 1]);
text(-1.2,.25,'Constrained')
text(-1.2,.25-.25,sprintf('S0 = %3.1f\nR2 = %3.1f',...
    s0mult*brCon.bR(field).S0(idx(1),idx(2)),...
    brCon.bR(field).R2(idx(1),idx(2))));
text(-1.2,.75,'Unconstrained')
text(-1.2,.75-.25,sprintf('S0 = %3.1f\nR2 = %3.1f',...
    s0mult*brUnc.bR(field).S0(idx(1),idx(2)),...
    brUnc.bR(field).R2(idx(1),idx(2))));

posi = get(gcf,'Position');
set(gcf,'PaperUnits','points','PaperSize',posi(3:4),'PaperPosition',[0 0 posi(3:4)]);
set(gcf,'Color',[1 1 1 0]);
set(gcf,'Renderer','painters');
set(gcf,'RendererMode','manual');
fname = sprintf('./temp_figs/echoes_FE_%i_B1_%i', pickIronLoad,pickB1);
myin = 'n';
myin = input(['Save as ' fname ': [n] ]'],'s');
if strcmp(myin,'y');
    saveas(gcf,fname,'pdf');
end


%% CPMG plotting
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

fe = 5;
b1 = 4;

load(resFiles1{fe});
mag = out.magOut;
t = 0:out.simParams.step:out.simParams.interval;
sig = abs(squeeze(complex(mag(b1,1,:),mag(b1,2,:))));
plot(t,sig);


field = 1;

FEidx = fe;
B1idx = b1;



te = out.simParams.TE;
aTE = [];
sInt = [];
hold on;
overlay = brUnc.bR(field).S0(FEidx,B1idx) .* exp( -brUnc.bR(field).R2(FEidx,B1idx).*t/1000 ) + brUnc.bR(field).C(FEidx,B1idx);

plot(t, overlay, 'g')
