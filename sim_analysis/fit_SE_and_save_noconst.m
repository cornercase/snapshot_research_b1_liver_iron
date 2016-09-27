function [] = fit_SE_and_save()
[brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2_noconst('TEshortening',true,'fixEamonPhaseError',true);

save('fits_SE_TEshortening_noconst');

clear;
[brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2_noconst('TEshortening',false,'fixEamonPhaseError',true);
save('fits_SE_regular_noconst');


