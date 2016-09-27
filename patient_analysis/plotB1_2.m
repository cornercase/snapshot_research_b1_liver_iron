
tVecHF = struct;
maxL= [0 0 0 0];
tVecHS = struct;
tVecLF = struct;
tVecLS = struct;
counter = 0;
for n=patIndex
    counter=counter+1;
    timg = b1(n).res.highFast.im;
    tVecHF(counter).vec = timg(find(b1(n).res.highFast.roi));
    if maxL(1) < length( tVecHF(counter).vec ); maxL(1) = length(tVecHF(counter).vec); end
    timg = b1(n).res.highSlow.im;
    tVecHS(counter).vec = timg(find(b1(n).res.highSlow.roi));
    if maxL(2) < length( tVecHF(counter).vec ); maxL(2) = length(tVecHS(counter).vec); end
    timg = b1(n).res.lowFast.im;
    tVecLF(counter).vec = timg(find(b1(n).res.lowFast.roi));
    if maxL(3) < length( tVecHF(counter).vec ); maxL(3) = length(tVecLF(counter).vec); end
    timg = b1(n).res.lowSlow.im;
    tVecLS(counter).vec = timg(find(b1(n).res.lowSlow.roi));
    if maxL(4) < length( tVecHF(counter).vec ); maxL(4) = length(tVecLS(counter).vec); end
end
vec = struct;
vec(1).vs = tVecHF;
vec(2).vs = tVecHS;
vec(3).vs = tVecLF;
vec(4).vs = tVecLS;
v = struct;
for n=1:4
    v(n).mat = nan(maxL(n),length(patIndex));
    for m=1:length(patIndex)
        temp = vec(n).vs(m).vec;
        v(n).mat(1:length(temp),m) = temp;
    end

end


%%
mtitle{1} = 'High Fast';
mtitle{2} = 'High Slow';
mtitle{3} = 'Low Fast';
mtitle{4} = 'Low Slow';

for m=1:4

g = [];
for n=patIndex
    g(end+1) = b1(n).patInfo.r2;
end
subplot(2,2,m);
boxplot(v(m).mat,g)
    ylim([0 160]);
    xlabel('R2 [Hz]');
    ylabel('B1 Percent');
title(mtitle(m));
end



