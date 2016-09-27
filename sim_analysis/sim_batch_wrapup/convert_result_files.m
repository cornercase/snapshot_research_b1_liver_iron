clear;
for n=[1:33 35:36]
    load(sprintf('Job%i/Task1.out.mat',n));
    out = argsout{1};
    clear