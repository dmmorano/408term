
function [ Kr ] = REFRA(bo,b)

%REFRA Refraction Coefficient Calculation
%   REFRA determines the refraction coefficient, Kr
%	using the distance between rays at the breaking water depth.
%   All equations taken from 3.14 Slide 21
%   Input:
%        bo = initial wave ray width
%        b = wave ray width at location of Kr evaluation
%        theta_o = water incident water angle. Will be 150, 180, or 210.

Kr = sqrt(b./bo);

end

