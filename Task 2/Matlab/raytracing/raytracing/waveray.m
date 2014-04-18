function [] = waveray(T,HO,ang)
% path of fast marching library
% download from http://www.mathworks.com/matlabcentral/fileexchange/24531-accurate-fast-marching
% need to run compile_c_files.m in that directory before using

%Set directory including path of fast marching and bathymetry
%addpath(genpath('C:\Users\Anthony\Documents\Classes\OCE 408\Waveray'))
addpath(genpath('FastMarching_version3b'))



% parameters
T = T; % period
HO = HO; % waveheight
ang = ang; % degrees CW from N

% obtain grid
myRes = 6; % resolution in meters
myGrid = [-15 10 0 30]*1e3; % grid size
ProjectionOrigin = [41.32 -71.44 0]; % coordinates of origin

% compute excess
% add wavefront south of the grid
excess = round(abs(tan(ang*pi/180))*(myGrid(2)-myGrid(1))/myRes+1);
myGrid(3) = myGrid(3) - excess*myRes;

% obtain grid
[E,N] = meshgrid(linspace(myGrid(1)+myRes/2,...
                          myGrid(2)-myRes/2,...
                          (myGrid(2)-myGrid(1))/myRes),...
                 linspace(myGrid(3)+myRes/2,...
                          myGrid(4)-myRes/2,...
                          (myGrid(4)-myGrid(3))/myRes));
                      
% mstruct = defaultm('tranmerc');
% mstruct.scalefactor = 0.9996;
% mstruct.origin = ProjectionOrigin;
% mstruct.geoid = almanac('earth','grs80','kilometers');
% mstruct = defaultm(mstruct);
% [mylat,mylon] = minvtran(mstruct,E/1e3,N/1e3);

R = 6380e3;
mylat = ProjectionOrigin(1)+N/R*180/pi;
mylon = ProjectionOrigin(2)+E/R*180/pi/cos(ProjectionOrigin(1)*pi/180);

% produce bathymetry
% download netcdf file from http://www.ngdc.noaa.gov/mgg/coastal/grddas01/grddas01.htm

%ncid = netcdf.open('C:\Users\Anthony\Documents\Classes\OCE 408\Waveray\ne_atl_crm_v1.nc\ne_atl_crm_v1.nc','NC_NOWRITE');
ncid = netcdf.open('./ne_atl_crm_v1.nc', 'NC_NOWRITE')
varid = netcdf.inqVarID(ncid,'x');
lon = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'y');
lat = netcdf.getVar(ncid,varid);
varid = netcdf.inqVarID(ncid,'z');
z = netcdf.getVar(ncid,varid);
netcdf.close(ncid);

% This is so we don't load the bathy data for the whole north east coastline
% will snyder
%%%%%%%%%%%%%
myGrid = [-15 10 0 30]*1e3; % grid siz
indexlat = lat' > 40.9 & lat' < 42;
indexlon = lon' > -71.8 & lon' < -70.8;
lat = lat(indexlat);
lon = lon(indexlon);
z = z(indexlon, indexlat);
%%%%%%%%%%%%%


[crmlon,crmlat] = meshgrid(lon,lat);
 bathy = -interp2(crmlon,crmlat,double(z'),mod(mylon+180,360)-180,mylat);

% get wavespeed
% requires ldis.m 
h = max(bathy,0.0);
%c = sqrt(9.8*h);
k = 2*pi./ldis(T,h);
cp = sqrt(9.8./k.*tanh(k.*h));
cg = (1+k.*h.*(1-tanh(k.*h).^2)./tanh(k.*h))/2.*cp;

% specify points of initial wavefront
frontx = 1:size(h,2);
if (ang>0)
    fronty = round(tan(-ang*pi/180)*frontx)+excess;
else
    fronty = round(tan(-ang*pi/180)*frontx)+1;
end;
% translate to lat/lon
flon = mylon(sub2ind(size(mylon),fronty,frontx));
flat = mylat(sub2ind(size(mylat),fronty,frontx));

% compute traveltime in seconds
tt = msfm(cp/myRes,[fronty;frontx],true,true);

% compute wave rays
[tx,ty] = gradient(tt,myRes);
dt = sqrt(tx.^2 + ty.^2);
cx = tx./dt.*cg;
cy = ty./dt.*cg;

% make sample plot
figure;
% wave fronts
contour(mylon,mylat,tt,0:1e2:5e3);
% streamlines 
h = streamline(mylon,mylat,cx,cy,flon(1:20:end),flat(1:20:end),[myRes 100000]);
set(h,'Color','red');
% fix aspect ratio
ylim = get(gca,'ylim');
set(gca,'DataAspectRatio',[1 cos(mean(ylim)*pi/180) 1]);
% trim off bottom of graph
axis([mylon(excess+1,1) mylon(excess+1,end) mylat(excess+1,1) mylat(end,1)]);
title(['H_o=' num2str(HO) 'm' 'T=' num2str(T) 's' '\theta=' num2str(ang) '� CW of North'])
xlabel('Longitude')
ylabel('Latitude')
% draft for solving energy equation
% H2 = zeros(size(h));
% H2(excess+1,:) = H0^2;
% for j=excess+1:size(h,1)-1
%     H2(j+1,:) = (cy(j,:).*H2(j,:)-myRes*gradient(cx(j,:).*H2(j,:),myRes))./cy(j,:);
%     H2(j+1,cy(j+1,:)==0)=0;
% end


end