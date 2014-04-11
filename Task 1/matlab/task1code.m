% Task 1: Determine design deep water wave heights 
% and periods for dominant directions relative to 
% Narragansett Beach.


%% Determine wave directions (wavedir used as reference)

% Parse data in to useable format

% parser('ST63079.txt','ST63079_v01.onlns')

%% Plot wave direction concentrations

wavedir('ST63079.txt')

%% Gumble Distrobution of data

extremeDist2_new('ST63079.txt')

%% Month Max Hmo
for dir = [150 180 210]
monthextrema('ST63079.txt',dir,30)
end

