function wavedir(filename)
%wavedir(filename)
% Created:      04-14-2004    
% Author:       Matt Shultz
% Purpose:      This function plots wave direction for the imported data in
%               a rose diagram.
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


M = dlmread(filename);
wdvmn = M(:,13);
recordCount = length(wdvmn);
degAvg = mean(wdvmn);

% instantiate vector to set direction bins
degCount = [0 30 60 90 120 150 180 210 240 270 300 330];

% convert bins and wave direction to THETA values
wdvmnTHETA = wdvmn.*pi.*2 ./360;
degCountTHETA = degCount.*pi.*2 ./360;

% plot wave directions
figure(1)
rose(wdvmnTHETA,degCountTHETA)

% format plot
view(90,90);
title('N','FontSize',14);
xlabel('W','FontSize',14);
set(get(gca,'Title'),'Vertical','Baseline');
set(get(gca,'XLabel'),'Rotation',0.0);
set(get(gca,'XLabel'),'Vertical','Middle');
set(get(gca,'XLabel'),'Horizontal','Left');
set(gca,'XDir','reverse');
set(findobj(gca,'Type','line'),'LineWidth',1.5);
