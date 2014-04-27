% Task 1: Determine design deep water wave heights 
% and periods for dominant directions relative to 
% Narragansett Beach.


%% Determine wave directions (wavedir used as reference)

% Parse data in to useable format

% parser('ST63079.txt','ST63079_v01.onlns')

%% Plot wave direction concentrations
wavedir('ST63079.txt');

%% Monthly Extrema

for deg = [150 180 210]
   monthextrema_new('ST63079.txt',deg,30);
end

%% Gumble Distrobution
extremeDist2_new('monthlyExtreme63079_210.txt')

