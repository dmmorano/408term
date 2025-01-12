function monthextrema_new(filename,direction,dirBin)
%
% monthextrema_new(filename,[direction],[dirBin])
% Created:      04-23-2011    
% Author:       Stephan Grilli, OCE, URI
% Purpose:      This function imports WIS wave data for a number of years and 
%               determines the monthly maximum significant wave heights for
%               a specified direction (note using the spectral peak direciton wv).
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
%               direction   :   (optional) wave direction of interest (in degrees, 0-360). (-1) no direction
%               dirBin      :   (optional, default = 30 degrees) size of direction band 
%                               that will be centered around the direction of interest.
%               nargin      :   Number of srguments in function
%========================================================================================

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

if nargin < 3
    dirBin = 30;    % no direction bin specified -> use default of 30 degrees
end  

if nargin < 2       % no direction specified -> -1
    direction = -1; 
end


length(Hmo)
direction
dirBin


% if a direction was specified, create a new vectors of values for that direction

if ((direction >=0) && (direction <= 360))  
    
    % find the indexes for the specified direction and bin
    
    minDir = direction - dirBin./2
    maxDir = direction + dirBin./2
    if minDir < 0 
        DirIndexes = find(wv >= (360-minDir) & wv < maxDir);
    elseif maxDir > 360
        DirIndexes = find(wv >= minDir & wv < (maxDir-360));
    else
        DirIndexes = find(wv >= minDir & wv < maxDir);
    end
    
    % create new vectors for the specified direction and bin
    
    
    ID = ID(DirIndexes);
    YEAR = YEAR(DirIndexes);
    MM = MM(DirIndexes);
    DD = DD(DirIndexes);
    HH = HH(DirIndexes);
    LONG = LONG(DirIndexes);
    LAT = LAT(DirIndexes);
    Hmo = Hmo(DirIndexes);
    DTp = DTp(DirIndexes);
    Atp = Atp(DirIndexes);
    tmean = tmean(DirIndexes);
    wv = wv(DirIndexes);
    wsp = wsp(DirIndexes);
    wdir = wdir(DirIndexes);

   
end

% initialize values

recordCount  = length(Hmo)
extremeIds   = [];
extremeIndex = 0;
prevMonth    = 0;
maxHmo       = 0;

% loop through the records to find the monthly extreme Hmo indexes

for id = 1:recordCount
    month = MM(id);
    if month == prevMonth
        
        % check to see if this record is the monthly extreme
        
        if Hmo(id) > maxHmo
            maxHmo   = Hmo(id);
            maxHmoId = id;
        end
    else
        
        % if this is not the first loop, set the previous month's extreme Hmo index
        
        if id > 1
            extremeIds(extremeIndex) = maxHmoId;
        end  
        
        % this is a new month, set maxHmo to the first record in month
        
        extremeIndex = extremeIndex + 1;
        maxHmo       = Hmo(id);
        maxHmoId     = id;
    end
    prevMonth = month;
end 

% set the last month's extreme Hmo index

extremeIds(extremeIndex) = maxHmoId;
extremelength            = length(extremeIds)

% open a text file to store the monthly extremes

if direction ~=-1
    filename = ['monthlyExtreme' int2str(ID(1)) '_' int2str(direction) '.txt'];
else
    filename = ['monthlyExtreme' int2str(ID(1)) '.txt'];
end
fid = fopen(filename,'w');

% loop through the extreme IDs and write out the results to the file

for k = 1:extremelength
    out = [ID(extremeIds(k)) YEAR(extremeIds(k)) MM(extremeIds(k)) DD(extremeIds(k))...
        HH(extremeIds(k)) LONG(extremeIds(k)) LAT(extremeIds(k)) DPTH(extremeIds(k))...
        Hmo(extremeIds(k)) DTp(extremeIds(k)) Atp(extremeIds(k)) tmean(extremeIds(k))...
        wdvmn(extremeIds(k)) wv(extremeIds(k)) wsp(extremeIds(k)) wdir(extremeIds(k))];
    fprintf(fid,'%4.0f %4.0f %4.0f %4.0f %4.0f %9.5f %9.5f %9.5f %9.5f %9.5f %9.5f %9.5f %9.5f %9.5f %9.5f %9.5f\r',out);
end 

fclose(fid);

