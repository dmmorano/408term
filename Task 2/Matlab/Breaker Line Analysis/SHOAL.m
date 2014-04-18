function [ Ks ] = SHOAL(T, h)
%SHOAL Calculate shoaling coefficient
%   SHOAL calculates the shoaling coefficient, Ks
%   All equations obtained from 3.10 Slide 18
%   Input:
%       T = wave period from 20 and 50 year predictions
%       h = breaking water depth, m.

% Known:
 
c_o = (9.81 * T) / (2 * pi);
L = c_o .* T;
k = 2 * pi / L;
kh = h*k;

c = c_o * tanh(kh);
cg = (c/2).*(1 + 2*kh./sinh(2*kh));

Ks = sqrt(c_o./(2.*cg));

end

