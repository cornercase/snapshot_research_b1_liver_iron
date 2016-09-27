
function [s, TE] = findShortenedTE(sig,TEover2,t,varargin)

if size(varargin)>0
    plotting = varargin{1};
else
    plotting=false;
end
    
sig = sig(:);
t = t(:);
boundedT = t(find(t>TEover2*1.8));
boundedS = sig(find(t>TEover2*1.8));
boundedS = boundedS(find(boundedT<=2*TEover2));
boundedT = boundedT(find(boundedT<=2*TEover2));

s = max(boundedS);
[a b c] = find(max(boundedS)==boundedS,1);
TE = boundedT(a);

if plotting
    figure;
    plot(t,sig);
    hold on;
    plot(boundedT,boundedS,'r');
    plot(TE,s,'g*');
end
end