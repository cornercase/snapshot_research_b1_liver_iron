function [] = fit_CPMG_and_save()
resDir = './fitres/';
ds = datestr(datetime(),'yyyy_mm_dd_HHMMss');
resDir = [resDir ds '/'];
mkdir(resDir);
%[brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2_CPMG('TEshortening',true,'fixEamonPhaseError',true);
%save('fits_CPMG_TEshortening');
op = 'no_const';

if strfind(op,'no_const')
[r, FE, B1] = fit_3_CPMG('fitType',op,'TEshortening',false,'fixEamonPhaseError',false,'noiseCorrection','complex');
save([resDir 'fits_CPMG_2']);
end

[gitinfo,hostinfo,gitstatus] = gitBasicInfo();
save([resDir 'git_info'],'gitinfo','hostinfo','gitstatus');