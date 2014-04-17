[lon, lat] = ginput(2);

londiff = lon(2) - lon(1);
latdiff = lat(2) - lat(1);
b = sqrt(londiff^2 + latdiff^2);