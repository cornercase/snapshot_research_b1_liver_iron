jobs = 22:34;

for n=jobs
    clear out;
    out= load(myJobs(n));
    pause(5);
    out= load(myJobs(n));
    
    out.FEOut
    
    fname = sprintf('FE_%02i_%02.1f.mat',out.FEOut,out.B0);
    save(fname,'out');
end