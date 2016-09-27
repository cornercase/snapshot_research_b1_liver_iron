function [] = fit_hahn_and_save()

[brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2_hahn();


save('fits_TEshortening_hahn');