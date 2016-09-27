



[brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2();
myylims = [0 .5];
%%
brUnc90_1 = brUnc(1).R2(:,find(B1==90));
brUnc90_1 = repmat(brUnc90_1, 1,max(size(B1)));
brUnc(1).R2_perc = (brUnc(1).R2 - brUnc90_1)./ brUnc90_1;
subplot(2,2,1);plot(B1,brUnc(1).R2_perc);ylim(myylims);


brUnc90_2 = brUnc(2).R2(:,find(B1==90));
brUnc90_2 = repmat(brUnc90_2, 1,max(size(B1)));
brUnc(2).R2_perc = (brUnc(2).R2 - brUnc90_2)./ brUnc90_2;
subplot(2,2,3);plot(B1,brUnc(2).R2_perc);ylim(myylims);



brCon90_1 = brCon(1).R2(:,find(B1==90));
brCon90_1 = repmat(brCon90_1, 1,max(size(B1)));
brCon(1).R2_perc = (brCon(1).R2 - brCon90_1)./ brCon90_1;
subplot(2,2,2);plot(B1,brCon(1).R2_perc);ylim(myylims);


brCon90_2 = brCon(2).R2(:,find(B1==90));
brCon90_2 = repmat(brCon90_2, 1,max(size(B1)));
brCon(2).R2_perc = (brCon(2).R2 - brCon90_2)./ brCon90_2;
subplot(2,2,4);plot(B1,brCon(2).R2_perc);ylim(myylims);