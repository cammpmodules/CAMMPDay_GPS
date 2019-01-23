function Satellitendaten = einlesen_Satellitendaten(Dateien)
%EINLESEN_SATELLITENDATEN liest Eintraege aus den Rinexdateien aus
%   Die Dateien werden ausgelesen und strukturiert abgespeichert.

warning('off','GPS:einlesen_Satellitendaten')

[Obs,Nav] = readrnx(Dateien);

Satellitendaten = [];

Spalte = Obs(:,7);
[, idx] = unique(Spalte, 'first');
IDnumbers = Spalte(sort(idx));

for id = IDnumbers.'
    
    obs = Obs(Obs(:,7)==id & Obs(:,8)==0,:);
    
    if isempty(obs)
        warning('GPS:einlesen_Satellitendaten','Keine gültigen Daten bei ID-Nummer %d',id)
        continue
    end
    
    if size(unique(obs(:,1:6),'rows'),1) ~= 1
        warning('GPS:einlesen_Satellitendaten','Empfangszeiten der Satellitensignale sind verschieden.');
        continue
    end
    
    Anzahl_Satelliten = size(obs,1);
    Signalstaerken = NaN(1,Anzahl_Satelliten);
    Wochennummern  = NaN(1,Anzahl_Satelliten);
    Empfangszeiten = NaN(1,Anzahl_Satelliten);
    Sendezeiten    = NaN(1,Anzahl_Satelliten);
    Ephemeriden    = NaN(21,Anzahl_Satelliten);
    
    n = 0;
    
    for i = 1 : Anzahl_Satelliten
        % Auslesen der Satellitennummern
        prn = obs(i,9);
        % Berechnen von GPS-Woche und Empfangszeit in der GPS-Woche
        day = datenum(obs(i,1:3))-datenum(1980,1,6);
        week = floor(day/7);
        time = mod(day,7)*86400+obs(i,4:6)*[3600;60;1];
        % find correct prn in eph matrix (only when SV health == 0)
        nav = Nav(Nav(:,1)==prn & Nav(:,32)==0,:);
        % make sure there is data for that prn
        if isempty(nav)
            warning('GPS:einlesen_Satellitendaten','Keine gueltigen Daten für Satellit mit PRN %d',prn);
            continue
        end
        % make sure there are valid data in some fit intervall
        nav = nav(abs((week-nav(:,29))*604800+(time-nav(:,19)))<=nav(:,36)/2*3600,:);
        if isempty(nav)
            warning('GPS:einlesen_Satellitendaten','Keine gueltigen Daten für Satellit mit PRN %d',prn);
            continue
        end
        % find correct ephemerides for that prn (the closest toe to the time)
        [~,row] = min(abs((week-nav(:,29))*604800+(time-nav(:,19))));
        % Anpassen von GPS-Woche und berechnen der Empfangs- und Sendezeit
        GPS_Woche = nav(row,29);
        Empfangszeit = time+(week-GPS_Woche)*604800;
        Sendezeit = Empfangszeit-obs(i,10)/299792458;
        % Berechnen des Toc (Toc ist dann gleich Toe, wenn 
        day = datenum(nav(row,2:4))-datenum(1980,1,6);
        week = floor(day/7);
        time = mod(day,7)*86400+nav(row,5:7)*[3600;60;1];
        toc = time+(week-GPS_Woche)*604800;
        if toc ~= nav(row,19)
            warning('GPS:einlesen_Satellitendaten','Toc ist ungleich Toe.');
            % Der Fall Toc ungleich Toe ist in Ordnung. Er ist mir bisher nur nie begegnet.
            % Selbst Kai Borre setzt in seiner GPS Easy Suite einfach Toc gleich Toe.
            % Ich vermute aber, dass es durchaus Faelle gibt, wo es einen Unterschied gibt,
            % denn sonst waere die Variable Toc ueberfluessig.
            % Deshalb hier kein Abbruch mit "continue".
        end
        % copy data
        n = n+1;
        Wochennummern(n)  = GPS_Woche;
        Empfangszeiten(n) = Empfangszeit;
        Sendezeiten(n)    = Sendezeit;
        Signalstaerken(n) = obs(i,11);
        % copy ephemerides
        Ephemeriden(1,n)  = nav(row,14); % M0
        Ephemeriden(2,n)  = nav(row,13); % Delta n
        Ephemeriden(3,n)  = nav(row,16); % e
        Ephemeriden(4,n)  = nav(row,18); % sqrt(A)
        Ephemeriden(5,n)  = nav(row,21); % OMEGA0
        Ephemeriden(6,n)  = nav(row,23); % i0
        Ephemeriden(7,n)  = nav(row,25); % omega
        Ephemeriden(8,n)  = nav(row,26); % OMEGADOT
        Ephemeriden(9,n)  = nav(row,27); % idot
        Ephemeriden(10,n) = nav(row,15); % Cuc
        Ephemeriden(11,n) = nav(row,17); % Cus
        Ephemeriden(12,n) = nav(row,24); % Crc
        Ephemeriden(13,n) = nav(row,12); % Crs
        Ephemeriden(14,n) = nav(row,20); % Cic
        Ephemeriden(15,n) = nav(row,22); % Cis
        Ephemeriden(16,n) = nav(row,19); % Toe
        Ephemeriden(17,n) = nav(row,8);  % af0
        Ephemeriden(18,n) = nav(row,9);  % af1
        Ephemeriden(19,n) = nav(row,10); % af2
        Ephemeriden(20,n) = toc;         % Toc
        Ephemeriden(21,n) = prn;         % prn
    end
    
    if n<4
        warning('GPS:einlesen_Satellitendaten','Zu wenig Daten bei ID %d',id)
        continue
    end
    
    Datensatz = struct('Satelliten',1:n,...
        'Wochennummern',Wochennummern(:,1:n),...
        'Empfangszeiten',Empfangszeiten(:,1:n),...
        'Sendezeiten',Sendezeiten(:,1:n),...
        'Signalstaerken',Signalstaerken(:,1:n),...
        'Ephemeriden',Ephemeriden(:,1:n));
    
    Satellitendaten = [Satellitendaten Datensatz];   
end

end


function [obs,nav] = readrnx(files)
% READRNX : read rinex observation data/navigation message files
%
% Read RINEX (Receiver Independent Exchange Format) GPS/GNSS observation data
% (OBS) and navigation message (NAV) files. Only supports GPS.
%
% Original file by T.TAK5ASU from 2006 modified for CAMMP in 2014
% Origin: http://gpspp.sakura.ne.jp/prog/rtkdemo/readrnx.m 
%
% argin  : files = RINEX OBS/NAV file paths (cell array)
%
% argout :  obs = observation data sorted by sampling time (nan:no data)
%               obs(n,1:6) : sampling time [year,month,day,hour,min,sec]
%               obs(n,7)   : id number
%               obs(n,8)   : health flag (0 = data is valid)
%               obs(n,9)   : satellite PRN number
%               obs(n,10)  : C1 pseudorange (m)
%               obs(n,11)  : S1 signal strength (dBHz)
%           nav = navigation messages
%               nav(n,1) : satellite PRN number
%               nav(n,2:7): Toc [year,month,day,hour,min,sec]
%               nav(n,8:10): SV Clock [bias,drift,drift-rate]
%               nav(n,11) : IODE,    nav(n,12) : Crs,     nav(n,13) : Delta n
%               nav(n,14) : M0,      nav(n,15) : Cuc,     nav(n,16) : e
%               nav(n,17) : Cus,     nav(n,18) : sqrt(A), nav(n,19) : Toe
%               nav(n,20) : Cic,     nav(n,21) : OMEGA0,  nav(n,22) : Cis
%               nav(n,23) : i0,      nav(n,24) : Crc,     nav(n,25) : omega
%               nav(n,26) : OMEGADOT,nav(n,27) : idot,    nav(n,28) : Codes on L2
%               nav(n,29) : GPS Week #,    nav(n,30) : L2 P data flag
%               nav(n,31) : SV accuracy,   nav(s,32) : SV health
%               nav(s,33) : TGD,           nav(n,34) : IODC
%               nav(n,35) : Trans. time,   nav(n,36) : fit interval
%               nav(n,37:38) : spare

obs=[]; nav=[]; id=1;
for n=1:length(files)
    f=fopen(files{n},'rt');
    if f<0, error(['Fehler beim Öffnen der Datei : ',files{n}]); end
    display(['Lese Rinex Datei ... : ',files{n}]);
    [trnx,tobs]=readrnxh(f);
    if trnx=='O'
        [o, id]=readrnxo(f,tobs,id); obs=[obs;o];
    elseif trnx=='N'
        v=readrnxn(f); nav=[nav;v];
    end
    fclose(f);
end
if ~isempty(obs), obs=sortrows(obs); end
if ~isempty(nav), nav=unique(nav,'rows'); end
end

% read rinex header -----------------------------------------------------------
function [trnx,tobs]=readrnxh(f)
trnx=''; tobs={};
while 1
    s=fgetl(f); if ~ischar(s), break, end
    label=subs(s,61,20);
    if strfind(label,'RINEX VERSION / TYPE')
        trnx=subs(s,21,1);
    elseif strfind(label,'# / TYPES OF OBSERV')
        p=11;
        for i=1:s2n(s,1,6)
            if p>=59, s=fgetl(f); p=11; end
            tobs{i}=subs(s,p,2); p=p+6;
        end
    elseif strfind(label,'END OF HEADER'), break
    end
end
end

% read rinex observation data --------------------------------------------------
function [obs,id]=readrnxo(f,tobs,id)
to={'C1','S1'}; l=length(to); ind=zeros(1,length(tobs));
for n=1:l, i=find(strcmp(to{n},tobs)); if ~isempty(i), ind(i)=n; end
end
obs=zeros(100000,9+l); n=0;
while 1
    s=fgetl(f); if ~ischar(s), break, end
    e=s2e(s,1,26);
    if length(e)>=6
        if e(1)<80, e(1)=2000+e(1); else e(1)=1900+e(1); end
        flag=s2n(s,27,3);
        a=[e,id,flag];
        ns=s2n(s,30,3);
        obs(n+(1:ns),1:8)=repmat(a,ns,1);
        p=33;
        for i=1:ns
            if p>=69, s=fgetl(f); p=33; end
            if any(subs(s,p,1)==' G'), obs(n+i,9)=s2n(s,p+1,2); end
            p=p+3;
        end
        for i=1:ns
            s=fgetl(f); p=1;
            for j=1:length(tobs)
                if p>=80, s=fgetl(f); p=1; end
                if ind(j)>0, obs(n+i,9+ind(j))=s2n(s,p,14); end
                p=p+16;
            end
        end
        n=n+ns; id=id+1;
    end
end
obs=obs(1:n,:); obs=obs(obs(:,9)>0,:);
end

% read rinex navigation message ------------------------------------------------
function nav=readrnxn(f)
nav=zeros(2000,38); n=0; m=1;
while 1
    s=fgetl(f); if ~ischar(s), break, end
    s=strrep(s,'D','E');
    if m==1, prn=s2n(s,1,2); e=s2e(s,3,20);
        if e(1)<80, e(1)=2000+e(1); else e(1)=1900+e(1); end
        a=[prn,e];
    else a=[a,s2n(s,4,19)];
    end
    for p=23:19:61, a=[a,s2n(s,p,19)]; end
    if m<8, m=m+1; 
    else n=n+1; nav(n,:)=a; m=1;
    end
end
nav=nav(1:n,1:36);
end

% string to number/epoch/substring  --------------------------------------------
function a=s2n(s,p,n), a=sscanf(subs(s,p,n),'%f');
    if isempty(a), a=nan; end
end

function e=s2e(s,p,n), e=sscanf(subs(s,p,n),'%d %d %d %d %d %f',6)';
end

function s=subs(s,p,n), s=s(p:min(p+n-1,length(s)));
end