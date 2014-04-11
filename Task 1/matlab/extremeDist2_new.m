function extremeDist2_new(filename)

close all;
%e.g., filename = 'monthlyExtreme79.txt'

%extremeDist2_new(filename)
% Created:      04-23-2011    
% Author:       Stephan Grilli, OCE< URI
% Purpose:      This function takes a monthly maximum series of
%                    extreme values and plots their freq.  distribution along with
%                   the Gumbel probability distribution function.
% CALL arg.     filename    :   name of file to import (expected WIS format is
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
%                                         (0 deg. N, clockwise, 180 deg. S)
%                               wv 	    = Vector mean wave direction at spectral peak frequency in degrees in MET convention 
%                               wsp 	= Wind speed in meters per second 
%                               wdir 	= Wind direction in MET convention 
%========================================================================================
%
g            = 9.81;       % acceleration due to gravity (m/s^2)
Dt           = 1/12;       % time interval of monthy mx dat in years
CLtresh      = 0.05;       % 1- alha = 95% confidence limit level     
extremeMarks = [100 75 50 20 10 1 .1];  % Set of regular and extreme Tr values 

[ID YEAR MM DD HH LONG LAT DPTH Hmo DTp Atp tmean wdvmn wv wsp wdir ]...
 = textread(filename,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',0);

dirmean =  mean(wv)

% initialize values
%
N   = length(Hmo);       % Sample length
Fm  = 1 - (1:N)/(N+1);   % Freq/Prob that x(m) will not be exceeded
Trm = Dt./(1 - Fm);      % Return period of x(m) in years
    
% Hmo analyses
% 
Hmo       = sort(Hmo,'descend');   % sort Hmo array in descending order
HmoMean   = mean(Hmo)              % Mean Hs
HmoStdDev = std(Hmo)               % sigma Hs
Tp        = 15.66.*sqrt((Hmo/g));  % Tp values for data based on FDS assumption

Ath = 0.78*HmoStdDev               % Theoretical Gumbel coefficient A 
Bth = HmoMean - 0.45*HmoStdDev     % Theoretical Gumbel coefficient B 

% Gumbel linear curve fit and its confidence hyperbolas
% 
Pp       = -log(-log(Fm))';         % Gumbel transformation
p        = polyfit(Pp,Hmo,1);
Hmofit   = polyval(p,Pp);
A        = p(1)
B        = p(2)

STC      = sum((Hmo - HmoMean).^2);
SCR      = sum((Hmo - Hmofit).^2);
R2       = 1 - SCR/STC

s2res    = SCR/(N-2);
PpMean   = mean(Pp);                     
SFp2     = sum((Pp - PpMean).^2);        
tstudent =  tinv(1-CLtresh/2,N-2)        % value of t-student distribution with N-2 
                                         % dofs for excedence probability 1-CLtresh/2  
dTyrs    = (100 - Dt*1.001)/9999;                                      
Tyrs     = 100:-dTyrs:Dt*1.001;          % Tr vector to 100 years
Fyrs     = 1 - Dt./Tyrs;
Fp       = -log(-log(Fyrs))';


HmoTyrs  = A*Fp + B;
Tpyrs    = 15.66.*sqrt((HmoTyrs/g));     % Tp values for data based on FDS assumption

srescl     = sqrt(s2res*(1 + 1/N + (Fp - PpMean).^2/SFp2)); % !! Use the initial average of the data sample
CLHmo_up   = HmoTyrs + srescl*tstudent;  %  Upper CL of Hs
CLHmo_down = HmoTyrs - srescl*tstudent;  %  Lower CL of Hs
CLTp_up    = 15.66.*sqrt((CLHmo_up/g));
CLTp_down  = 15.66.*sqrt((CLHmo_down/g));

% plot distributions of Hs

figure (1)
hold on;
plot(Pp,Hmo,'b.');  % Sample N
plot(Fp,HmoTyrs,'k-')
plot(Fp,CLHmo_up,'k-.')
plot(Fp,CLHmo_down,'k-.')

legend('Data','Gumbel fit','95% CL',4);

extremeMarks = [100 75 50 20 10 1 .1];
exceedFreq   = 1 - Dt./extremeMarks;
exceedFreqp  = -log(-log(exceedFreq));
set(gca,'xtick',sort(exceedFreqp));
set(gca,'xticklabel',sort(extremeMarks),'FontSize',16);
 
grid on;
axis tight;
box on;
degrees = filename(size(filename,2)-6:size(filename,2)-4);
str = {['WIS Station: ' int2str(ID(1))...
    ', Years: ' int2str(YEAR(1)) '-' int2str(YEAR(length(YEAR)))...
    ', Dirm.: ' int2str(dirmean)]};
title(str,'FontSize',16);
xlabel('{\it T_r }(y)','FontSize',16);
ylabel('{\it H_s }(m)','FontSize',16);
hold off

% plot distributions of Tp assuming FDS

figure (2)
hold on;
plot(Pp,Tp,'b.');  % Sample N
plot(Fp,Tpyrs,'k-')
plot(Fp,CLTp_up,'k-.')
plot(Fp,CLTp_down,'k-.')

legend('Data','Gumbel fit','95% CL',4);

exceedFreq   = 1 - Dt./extremeMarks;
exceedFreqp  = -log(-log(exceedFreq));
set(gca,'xtick',sort(exceedFreqp));
set(gca,'xticklabel',sort(extremeMarks),'FontSize',16);
 
grid on;
axis tight;
box on;
degrees = filename(size(filename,2)-6:size(filename,2)-4);
str = {['WIS Station: ' int2str(ID(1))...
    ', Years: ' int2str(YEAR(1)) '-' int2str(YEAR(length(YEAR)))...
    ', Dirm.: ' int2str(dirmean)]};
title(str,'FontSize',16);
xlabel('{\it T_r }(y)','FontSize',16);
ylabel('{\it T_p }(s)','FontSize',16);
hold off

% Compare FDS Tp to measured Tp

figure (3)
hold on;
plot(Tp,DTp,'b.');  % FDS vs. Sample N
plot(Tp,Tp,'k-');   % 45 deg. best fit line
grid on;
box on;
degrees = filename(size(filename,2)-6:size(filename,2)-4);
str = {['WIS Station: ' int2str(ID(1))...
    ', Years: ' int2str(YEAR(1)) '-' int2str(YEAR(length(YEAR)))...
    ', Dirm.: ' int2str(dirmean)]};
title(str,'FontSize',16);
xlabel('{\it T_p (FDS) }(s)','FontSize',16);
ylabel('{\it T_p (obs.)}(s)','FontSize',16);
axis equal;

% Calculate extreme values and write out results

Fext        = 1 - Dt./extremeMarks;
Fextp       = -log(-log(Fext))';
Hmoext      = A*Fextp + B;
Tpext       = 15.66.*sqrt((Hmoext/g));     % Tp values for data based on FDS assumption

sresext     = sqrt(s2res*(1 + 1/N + (Fextp - PpMean).^2/SFp2));
CLHmo_upext = Hmoext + sresext*tstudent;   %  Upper CL of Hs
CLTp_upext  = 15.66.*sqrt((CLHmo_upext/g));

outs = 'Tr (y) Hs (m)   Tp (s)   CL95 Hs (m) CL95 Tp (s)';
fprintf(1,'%s\r',outs)
for k = 1:4
    out = [extremeMarks(k) Hmoext(k) Tpext(k) CLHmo_upext(k) CLTp_upext(k)];
    fprintf(1,'%4.0f %9.5f %9.5f %9.5f %9.5f\r',out);
end 