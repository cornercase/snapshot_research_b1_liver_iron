
clear
close all;
%[brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2('TEshortening',false);
load('fits_regular');
nset=1;
make_fig_comparison;
figure(1);
suptitle('1.5T No Shortening');
saveas(gcf,'shortening_comp_figs/reg_comp_1p5','pdf');
figure(2);
suptitle('1.5T No Shortening R2 overlay');
%%
saveas(gcf,'shortening_comp_figs/reg_overlay_1p5','pdf');
%%
close all;
nset=2;
make_fig_comparison;
figure(1);
suptitle('3T No Shortening');
saveas(gcf,'shortening_comp_figs/reg_comp_3','pdf');
figure(2);
suptitle('3T No Shortening R2 overlay');

%%
saveas(gcf,'shortening_comp_figs/reg_overlay_3','pdf');
%%
clear
close all;
%[brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2('TEshortening',true);
load('fits_TEshortening');
nset=1;
make_fig_comparison;
figure(1);
suptitle('1.5T TE Shortening');
saveas(gcf,'shortening_comp_figs/short_comp_1p5','pdf');
figure(2);
suptitle('1.5T TE Shortening R2 overlay');
%%
saveas(gcf,'shortening_comp_figs/short_overlay_1p5','pdf');
%%
close all;
nset=2;
make_fig_comparison;
figure(1);
suptitle('3T TE Shortening');
saveas(gcf,'shortening_comp_figs/short_comp_3','pdf');
figure(2);
suptitle('3T TE Shortening R2 overlay');
saveas(gcf,'shortening_comp_figs/short_overlay_3','pdf');