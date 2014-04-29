% Task 1: Determine design deep water wave heights 
% and periods for dominant directions relative to 
% Narragansett Beach.


%% Determine wave directions (wavedir used as reference)

% Parse data in to useable format

parser('ST63079.txt','ST63079_v01.onlns')

%% Plot wave direction concentrations
wavedir('ST63079.txt');

%% Monthly Extrema

for deg = [150 180 210]
   monthextrema_new('ST63079.txt',deg,30);
end

%% Gumble Distrobution

% Automatic latex table integration
tableout = extremeDist2_new('monthlyExtreme63079_150.txt')
tableizer(tableout,'name','extrema150.tex')

tableout = extremeDist2_new('monthlyExtreme63079_180.txt')
tableizer(tableout,'name','extrema180.tex')

tableout = extremeDist2_new('monthlyExtreme63079_210.txt')
tableizer(tableout,'name','extrema210.tex')

%% Yearly Maximums

tableout = yearlyDist('ST63079.txt',150,30)
tableizer(tableout,'name','yearly150.tex')

tableout = yearlyDist('ST63079.txt',180,30)
tableizer(tableout,'name','yearly180.tex')

tableout = yearlyDist('ST63079.txt',210,30)
tableizer(tableout,'name','yearly210.tex')
