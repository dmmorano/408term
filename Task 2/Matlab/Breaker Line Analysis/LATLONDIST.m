clear all;
clc;

T_150 = [12.59 13.33];
T_180 = [13.06 13.77];
T_210 = [12.86 13.87];
HO_150 = [6.34 7.10];
HO_180 = [6.83 7.59];
HO_210 = [6.61 7.36];
ang = [150 180 210];

lat20y_150 = [41.4385 41.4357];
lon20y_150 = [-71.452  -71.446];
lat20y_180 = [41.4361 41.4375];
lon20y_180 = [-71.45 -71.4463];

lat50y_150 = [41.4385 41.4357];
lon50y_150 = [-71.452  -71.4463];
lat50y_180 = [41.4325 41.437];
lon50y_180 = [-71.4534 -71.448];

lon = lon50y_180;
lat = lat50y_180;

m = 1/50;


b = [];
refra = [];
shoaling = [];
H_breaker = [];
h_breaker = [];
Ks = [];

% b(1) = ginput(1);
% [lon, lat] = ginput;

for n = 1
    b(1) = 250;
    refra(1) = 0;
    londiff = (lon(1,n+1) - lon(1,n))*(3600)*30.89*cosd(lat(1,n));
    latdiff = (lat(1,n+1) - lat(1,n))*(3600)*30.89;
    b(n + 1) = sqrt(londiff^2 + latdiff^2);
    refra(n+1) = REFRA(b(n),b(1));
end

for n = 1:length(lon)
    [H_breaker(n), h_breaker(n), Ks(n)] = BREAK(T_180(2), ang(2), HO_180(2), m, b(n), b(1));
end

tableize = [refra', Ks', H_breaker', h_breaker', H_breaker'./h_breaker'];
tableizer(tableize)