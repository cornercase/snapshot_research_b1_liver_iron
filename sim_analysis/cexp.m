function y = cexp(x,t)
% y = cexp(x,t)
%
% Exponential decay + constant
%
% ARGS :
% x = argument vector [S0 T2 C]
% t = time vector in seconds
%
% RETURNS :
% y = exponential + constant function of t
%
% AUTHOR : Mike Tyszka, Ph.D.
% PLACE  : CHLA, Los Angeles
% DATES  : 07/16/2002 JMT Adapt from gauss.m

y = (x(1)) * exp(-t * x(2));
