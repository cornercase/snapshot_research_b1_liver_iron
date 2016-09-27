%%
%load e20150629_72_90_1p5T_SE_20150709_0317_fastecho.local.mat
%%
t = 0:simOutput.simParams.step:simOutput.simParams.interval;
TE = simOutput.simParams.TE;
for n=1:length(TE)
    TEInd(n) = find(TE2(n)<=t,1,'first');
end
%TEInd = fliplr(TEInd);

%%
for FEInd=1:11
    %FEInd = 1;
    sig = zeros(size(simOutput.signals{1}.magnetizationSE.magOut,3), size(simOutput.signals{FEInd}.magnetizationSE.magOut,4));

    myTE = [3.131 4.718 7.4 10.72 15.97 22 35.57]


    for TEIndx = 1:size(simOutput.signals{FEInd}.magnetizationSE.magOut,4)
    sig(:,TEIndx) = squeeze(complex(simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,1,:,TEIndx),simOutput.signals{FEInd}.magnetizationSE.magOut(B1Ind,2,:,TEIndx)));
    %echoes(TEIndx) = sig(TEInd(TEIndx),TEIndx);
    end


    for n=1:length(myTE)
        myInd(n) = find(myTE(n) <= t,1,'first');
        echoes(n) = sig(myInd(n),9-n);
    end

    for a = 2:7
    %    echoes(a-1) = sig(TEInd(a),8-a);
    end

    B1Ind = 3;


    plot(t, abs(sig));hold on;

    plot(myTE(1:end),abs(echoes(1:7)),'LineWidth',3);
    
    pause;
    clf;
end



%% some figure stuff

surf(B1,FE,brCon(1).R2);xlabel('B1 (percent)');ylabel('Iron (mg/g)');
figure; surf(B1,FE,brUnc(1).R2);xlabel('B1 (percent)');ylabel('Iron (mg/g)');
subplot(1,2,1);surf(B1,FE,brCon(1).R2);xlabel('B1 (percent)');ylabel('Iron (mg/g)');
subplot(1,2,2); surf(B1,FE,brUnc(1).R2);xlabel('B1 (percent)');ylabel('Iron (mg/g)');
subplot(1,2,1);zlim([0 1400])
subplot(1,2,1);zlim([0 1000])
subplot(1,2,2);zlim([0 1000])
subplot(1,2,2);zlim([0 1000]); title('unconstrained')
subplot(1,2,1);zlim([0 1000]); title('constrained')