function [S0,R2,Res] = cfitexp(t,s,varargin)
% [S0,T2,C,Res] = fitexp(t,s)
%
% Fit an exponential + constant to the real signal, s(t)
%
% ARGS :
% t = time vector in seconds
% s = S(t) in arbitrary units
%
% RETURNS :
% S0 = s(t = 0) from model fit
% T2 = T2 relaxation time of the exponential component
%
% AUTHOR : Mike Tyszka, Ph.D.
% PLACE  : CHLA, Los Angeles
% DATES  : 07/16/2002 JMT Adapt from fitgauss.m

% Verbosity flag

p=inputParser;
p.addRequired('t');
p.addRequired('s');
p.addOptional('pde_constraint',[]);
p.parse(t,s,varargin{:});

global verbose
verbose =0;
if ~exist('verbose','var')
    verbose = 0;
end

% Initialize return arguments
sd = [];

% Flatten t and s
t = t(:);
s = s(:);

% Initial parameter estimates
S0_est = abs(s(1));
R2_est = 100+j*400*pi;

% Setup optimization parameters
options = optimset('lsqcurvefit');
options.Display = 'off';
options.TolFun = 1e-6;
options.TolX = 1e-6;
options.MaxIter = 100;

% Initial parameter vector
x0 = [S0_est R2_est];

% Parameter constraints
lb = [0   0 ];
ub = [Inf Inf ];
if ~isempty(p.Results.pde_constraint);
    lb(1) = p.Results.pde_constraint(1);
    ub(1) = p.Results.pde_constraint(2);
end

% Start optimization
[x_fit,Res] = lsqcurvefit('cexp',x0,t,s,lb,ub,options);

% Calculate fitted function values
s_fit = cexp(x_fit,t);

% Calculate return values
S0 = x_fit(1);
R2 = x_fit(2);
 

% Optional verbose output and graph
if verbose
  
  plot(t,abs(s_fit),t,abs(s),'o');
  xlabel('Time (s)');
  drawnow; pause;
  
  fprintf('Fit parameters:\n');
  fprintf('  S0 : %g\n', S0);
  fprintf('  R2 : %g\n', R2);
end