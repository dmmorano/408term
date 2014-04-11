%Read Narragansett Bay Bathymetry Data
%Using usgs24kdem, the script imports the latitude and longitude
%coordinates from the .dem file and plots them 


[lat, lon, Z] = usgs24kdem('Nbay_bathy.dem');

latlim = [min(lat(:)) max(lat(:))];

lonlim = [min(lon(:)) max(lon(:))];

figure
usamap(latlim, lonlim)
geoshow(lat, lon, Z, 'DisplayType','surface')
demcmap(Z)
daspectm('m',1)