
% notes
% magOut(B1level, [xyz], t, echo)


function [brUnc, brCon, FE, B1] = compare_constrained_v_unconstrained_monoexpc_2_hahn()

%% the files
global resFiles B1g; 
global rUnc rCon;
resFiles{1} = 'simoutput/e20151229_hanh_1p5T_20160110_1210_splinter.mat';

%% set up the ouput matricies
FE = [1 5 20 40];
B1g = [45 63 81 90 99 117 135];
B1 = B1g;
res1 = zeros(length(FE),length(B1));
rUnc = struct;
rUnc.field = '1.5T';
rUnc.fittype = 'noPD';
rUnc.R2 = res1;
rUnc.S0 = res1;
rUnc.Res = res1;
rUnc.C = res1;

rUnc(2) = rUnc;
rUnc(2).field = '3T';

rCon = rUnc;
rCon(1).fittype = 'PD';
rCon(2).fittype = 'PD';


%1.5T, 3T SE fits
rIndx1 = []; %3T SE
rIndx2 = [1]; %1.5T SE
rIndx = [rIndx1 rIndx2];
for rIndex=rIndx
  load(resFiles{rIndex});    
  fprintf('loaded %s\n',resFiles{rIndex});
  doFit(simOutput);
end


brUnc = rUnc;
brCon = rCon;
% if strcmp(refit,'y');
%     clear f refit;
%     [f.S0, f.R2, f.Res, f.C, f.B1, f.FE] = constrained_fit(simOutput,'non-negative');
%     f.fit = 'non-negative';
%     [f(2).S0, f(2).R2, f(2).Res, f(2).C, f(2).B1, f(2).FE] = constrained_fit(simOutput,'bounded1');
%     f(2).fit = 'bounded1';
%     clear -regexp ^[A-Z]*
% else
%     
%     make_fig_comparison;
% end
end

function [] = doFit(data)
global resFiles rUnc rCon B1g;
    fieldIndx = (data.simParams.B0 > 1.5)+1;
    %if fieldIndx == 2
    %    B1g(find(B1g == 108)) = 106;
    %end

    
    
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'bounded1');
    for bIndx = 1:length(B1o);
        fprintf('B1Indx = %i\n',bIndx);
        [a, mainIndex] = find(B1g==round(B1o(bIndx)));
        if ~isempty(mainIndex)
            warning('this is a kludge')
            fprintf('B1g = %i, B1o = %i\n',B1g(mainIndex),B1o(bIndx));

            rCon(fieldIndx).S0(:,mainIndex) = S0o(:,bIndx);
            rCon(fieldIndx).R2(:,mainIndex) = R2o(:,bIndx);
            rCon(fieldIndx).Res(:,mainIndex) = Reso(:,bIndx);
            rCon(fieldIndx).C(:,mainIndex) = Co(:,bIndx);
            %B1o
        end
    end
    
    [S0o, R2o, Reso, Co, B1o, FEo] = constrained_fit(data,'non-negative');
    for bIndx = 1:length(B1o);
        [a, mainIndex] = find(B1g==round(B1o(bIndx)));
        if ~isempty(mainIndex)
            rUnc(fieldIndx).S0(:,mainIndex) = S0o(:,bIndx);
            rUnc(fieldIndx).R2(:,mainIndex) = R2o(:,bIndx);
            rUnc(fieldIndx).Res(:,mainIndex) = Reso(:,bIndx);
            rUnc(fieldIndx).C(:,mainIndex) = Co(:,bIndx);
        end
    end    
    
end
        
        
        
        
        
        
