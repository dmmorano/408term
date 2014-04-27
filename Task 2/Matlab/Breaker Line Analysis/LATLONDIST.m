T = [10.2 9.58];
HO = [4.16 3.67];
ang = [150 180 210];


[lon, lat] = ginput;

b = [];
refra = [];
shoaling = [];

for n = 1:(length(lon) - 1)
    londiff = lon(n + 1) - lon(n);
    latdiff = lat(n + 1) - lat(n);
    b(n) = sqrt(londiff^2 + latdiff^2);
    
    if n > 1
        refra(n - 1) = REFRA(b(n + 1),b(n));
    end    
end

%m estimated for entire beach region:
m = 1/50;
[H_breaker, h_breaker, Ks] = BREAK(T(1), ang(1), HO(1), m);