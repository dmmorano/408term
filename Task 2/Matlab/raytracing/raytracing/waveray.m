clear all;
clc;

T_150 = [12.59 13.33];
T_180 = [13.06 13.77];
T_210 = [12.86 13.87];
HO_150 = [6.34 7.10];
HO_180 = [6.83 7.59];
HO_210 = [6.61 7.36];
ang = [150 180 210];
%lon = [0 0];
%lat = [0 0];
%[lon, lat] = ginput(2);

T = T_150(2);
HO = HO_150(2);
ang = 150;


%function [] = waveray(T,HO,ang,lat1, lat2, lon1, lon2)
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
myRes = 10; % resolution in meters
myGrid = [-10 10 -5 20]*1e3; % grid size
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
myGrid = [-10 10 -5 20]*1e3; % grid siz
indexlat = lat' > 40.9 & lat' < 42;
indexlon = lon' > -71.54 & lon' < -70.34;
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

%specify points of initial wavefront
frontx = 1:size(h,2);
frontxx = (size(h,2))/2:size(h,2);
if (ang>0)
    fronty = round(tan(-ang*pi/180)*frontx)+excess;
    frontyy = round(tan(-ang*pi/180)*frontxx)+excess;

else
    frontyy = round(tan(-ang*pi/180)*frontxx)+1;
end;
% translate to lat/lon
flon = mylon(sub2ind(size(mylon),frontyy,frontxx));
flat = mylat(sub2ind(size(mylat),frontyy,frontxx));

% londiff = (lon2 - lon1).*tan(25*pi/180);
% 
% frontxx = find(flon > lon1 & flon < lon2);
% frontyy = find(flat > lat1 & flat < londiff + lat1);
% 
% if length(frontyy) >= length(frontxx)
%     frontyy = frontyy(1:length(frontxx));
% else
%     frontxx = frontxx(1:length(frontyy));
% end
% 
% flon = mylon(frontxx);
% flat = mylat(frontyy);



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
hb = streamline(mylon,mylat,cx,cy,flon(1:20:end),flat(1:20:end),[myRes 100000]);
set(hb,'Color','red');
% fix aspect ratio
ylim = get(gca,'ylim');
set(gca,'DataAspectRatio',[1 cos(mean(ylim)*pi/180) 1]);
% trim off bottom of graph
axis([mylon(excess+1,1) mylon(excess+1,end) mylat(excess+1,1) mylat(end,1)]);
title(['H_o=' num2str(HO) 'm' 'T=' num2str(T) 's' '\theta=' num2str(ang) 'CW of North'])
xlabel('Longitude')
ylabel('Latitude')
% draft for solving energy equation
% H2 = zeros(size(h));
% H2(excess+1,:) = H0^2;
% for j=excess+1:size(h,1)-1
%     H2(j+1,:) = (cy(j,:).*H2(j,:)-myRes*gradient(cx(j,:).*H2(j,:),myRes))./cy(j,:);
%     H2(j+1,cy(j+1,:)==0)=0;
% end


%end