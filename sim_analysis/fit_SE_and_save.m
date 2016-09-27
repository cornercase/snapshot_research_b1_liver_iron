function [] = fit_SE_and_save(op)
resDir = './fitres/';
ds = datestr(datetime(),'yyyy_mm_dd_HHMMss');
resDir = [resDir ds '/'];
mkdir(resDir);
if strfind(op,'reg')
%[brUnc, brCon, FE, B1] = fit_3('TEshortening',true,'fixEamonPhaseError',false,'B1_PDE_correction',false);
[brUnc, brCon, FE, B1] = fit_4_rician('TEshortening',true,'fixEamonPhaseError',false,'B1_PDE_correction',false, 'noiseCorrection','rician');
save([resDir 'fits_SE_TEshortening_2']);

clear brUnc brCon FE B1;
end

if strfind(op,'pdeonly')
%[brUnc, brCon, FE, B1] = fit_3('TEshortening',true,'fixEamonPhaseError',false,'B1_PDE_correction',true);
[brUnc, brCon, FE, B1] = fit_4_rician('TEshortening',true,'fixEamonPhaseError',false,'B1_PDE_correction',true, 'noiseCorrection','rician');

save([resDir 'fits_SE_TEshortening_2_PDEcor']);
clear brUnc brCon FE B1;
end

if strfind(op,'pdeechos')
%[brUnc, brCon, FE, B1] = fit_3('TEshortening',true,'fixEamonPhaseError',false,'B1_PDE_correction',false,'B1_echo_correction',true);
[brUnc, brCon, FE, B1] = fit_4_rician('TEshortening',true,'fixEamonPhaseError',false,'B1_PDE_correction',false,'B1_echo_correction',true, 'noiseCorrection','rician');

save([resDir 'fits_SE_TEshortening_2_Echocor']);
clear brUnc brCon FE B1;
end


if strfind(op,'loweredTE')
%    [brUnc, brCon, FE, B1] = fit_3shortTE('TEshortening',true,'fixEamonPhaseError',false);
    [brUnc, brCon, FE, B1] = fit_3shortTE('TEshortening',true,'fixEamonPhaseError',false);
save([resDir 'fits_SElowTE_TEshortening_2']);
%[brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_3('TEshortening',false,'fixEamonPhaseError',false);
%save('fits_SE_regular_2');
end

[gitinfo,hostinfo,gitstatus] = gitBasicInfo();
save([resDir 'git_info'],'gitinfo','hostinfo','gitstatus');