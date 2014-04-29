function tableout = yearlyDist(filename,direction,dirBin)
%yearlyDist(filename,direction,dirBin)
% Created:      04-19-2004    
% Author:       Matt Shultz
% Purpose:      This function imports wave data for a number of years and
%               determines the average yearly significant wave height and
%               period for a specified direction.
% CALL arg.     filename    :   name of file to import (expected format is
%                               space delimited with the following fields and one header line: 
%                               [ID YEAR MM DD HH LONG LAT DPTH Hmo DTp Atp tmean wdvmn wv wsp wdir] where:
%                               ID      = station identifier
%                               YEAR    = 4-digit year
%                               MM      = month number
%                               DD      = day of the month
%                               HH      = hour of day
%                               LONG    = longitude of station
%                               LAT     = latitude of station in degrees North
%                               DPTH    = Depth at Station in meters
%                               Hmo     = Significant wave height in meters
%                               DTp     = Peak spectral wave period
%                               Atp 	= Peak spectral wave period in seconds using a parabolic fit in calculation 
%                               tmean 	= Mean wave period in seconds calculated using the inverse first moment 
%                               wdvmn 	= Overall vector mean wave direction in degrees using Meteorological (MET) convention 
%                               wv 	    = Vector mean wave direction at spectral peak frequency in degrees in MET convention 
%                               wsp 	= Wind speed in meters per second 
%                               wdir 	= Wind direction in MET convention
%               direction   :   (optional) wave direction of interest (in degrees, 0-360)
%               dirBin      :   (optional, default = 30 degrees) size of direction band 
%                               that will be centered around the direction of interest.

M = dlmread(filename);
wdvmn = M(:,13);
    ID = M(:,1);
    YEAR = M(:,2);
    MM = M(:,3);
    DD = M(:,4);
    HH = M(:,5);
    LONG = M(:,6);
    LAT = M(:,7);
    Hmo = M(:,9);
    DTp = M(:,10);
    Atp = M(:,11);
    tmean = M(:,12);
    wv = M(:,14);
    wsp = M(:,15);
    wdir = M(:,16);
    DPTH = ones(size(ID)).*33;
    
% check for optional arguments
if nargin < 3, dirBin = 30; end     % no direction bin specified, use default of 30 degrees
if nargin < 2, direction = -1; end  % no direction specified

% if a direction was specified, create a new vectors 
% of values for that direction
if direction~=-1 && direction<=360 && direction>=0
    % find the indexes for the specified direction and bin
    minDir = direction - dirBin./2
    maxDir = direction + dirBin./2
    if minDir<0 
        DirIndexes = find(wdvmn>=(360-minDir) & wdvmn<maxDir);
    elseif maxDir>360
        DirIndexes = find(wdvmn>=minDir & wdvmn<(maxDir-360));
    else
        DirIndexes = find(wdvmn>=minDir & wdvmn<maxDir);
    end
    
    % create new vectors for the specified direction and bin
    ID = ID(DirIndexes);
    YEAR = YEAR(DirIndexes);
    MM = MM(DirIndexes);
    DD = DD(DirIndexes);
    HH = HH(DirIndexes);
    LONG = LONG(DirIndexes);
    LAT = LAT(DirIndexes);
    DPTH = DPTH(DirIndexes);
    Hmo = Hmo(DirIndexes);
    DTp = DTp(DirIndexes);
    Atp = Atp(DirIndexes);
    tmean = tmean(DirIndexes);
    wdvmn = wdvmn(DirIndexes);
    wv = wv(DirIndexes);
    wsp = wsp(DirIndexes);
    wdir = wdir(DirIndexes);    
end

% initialize values
recordCount = length(Hmo)
g           = 9.81;                 % acceleration due to gravity (m/s^2)
prevYear = 0;
years = [];
index = 0;

% loop through the records to determine the years represented by the data
for id = 1:recordCount
    year = YEAR(id);
    if year~=prevYear
        % this is a new year, add to the vector
        index = index+1;
        years(index) = year;
    end
    prevYear = year;
end 

yearCount = length(years)

%loop through years to determine avg Hs and Ts
for id = 1:yearCount
    yearIndexes = find(YEAR==years(id));
    yearHmo = Hmo(yearIndexes);     %significant wave values for this year
    yearDTp = DTp(yearIndexes);     %peak period values for this year
    yearHsAvg(id) = mean(yearHmo);
    yearTsAvg(id) = mean(yearDTp);
end 

avgYearHs = mean(yearHsAvg)
avgYearTs = mean(yearTsAvg) 

% open a text file to store the yearly averages
if direction~=-1
    filename = ['yearlyAvg' int2str(ID(1)) '_' int2str(direction) '.txt'];
else
    filename = ['yearlyAvg' int2str(ID(1)) '.txt'];
end
fid = fopen(filename,'w');

% loop through the years and write out the results to the file
for k = 1:yearCount
    out = [years(k) yearHsAvg(k) yearTsAvg(k)];
    fprintf(fid,'%4.0f %9.5f %9.5f\r',out);
    tableout(k,:) = out;
end

fclose(fid);



