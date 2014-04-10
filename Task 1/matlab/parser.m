function parser(fileout,filein)
disp 'Parsing Data...'

[DATE, STATION, LAT, LONG, WNDSPD, WNDDIR, USTAR, CD, WAVSTRS, Hmo, TPD, TP, TM, TM1, TM2, WAVD, SPRD, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~]...
    = textread(filein,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',0);

% Date parsing
DATEstring = num2str(DATE);
[YY,MM,DD,HH,mm,ss] = datevec(DATEstring,'yyyymmddHHMMSS');
ID = STATION;
YEAR = YY;
DPTH = YY;  %Depth not record, arbitrarily used YY so matrix agrees
DTp = TPD;
Atp = TP;
tmean = TM1;
wdvmn = WAVD;
wv = WAVD;
wsp = WNDSPD;
wdir = WNDDIR;

parsed = [ID YEAR MM DD HH LONG LAT DPTH Hmo DTp Atp tmean wdvmn wv wsp wdir];
dlmwrite(fileout,parsed);
disp 'Output File Produced'
end


