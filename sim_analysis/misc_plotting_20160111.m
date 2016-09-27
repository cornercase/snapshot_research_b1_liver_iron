if ~exist('simOutput')
    load('e20151229_hanh_1p5T_20160110_1210_splinter.mat');
end

figure(1);clf;
for m=1:4
    subplot(2,2,m);
    colors = goodColors(7);
    for n=1:8
        for o=1:7
            sim = [m o n];
            plot(squeeze(abs(complex(simOutput.signals{sim(1)}.magnetizationSE(sim(2),1,:,sim(3)),simOutput.signals{sim(1)}.magnetizationSE(sim(2),2,:,sim(3))))),'Color',colors(o,:));
            hold on;
        end
    end
    legend('45','63','81','90','99','117','135');
    title(sprintf('FE = %i',simOutput.signals{m}.FE));
end
    