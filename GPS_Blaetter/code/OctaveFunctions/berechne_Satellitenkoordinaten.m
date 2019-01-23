function SK = berechne_Satellitenkoordinaten(t,Ephemeriden)
%BERECHNE_SATELLITENKOORDINATEN berechnet X,Y,Z ECEF Koordinaten
%   Eingabe:
%       - t = Vektor der Zeitpunkte in Sekunden
%       - Ephemeriden = Ephemeridenmatrix
%   Ausgabe:
%       - x,y,z = Koordinaten der Satelliten in Meter
%   Aufruf:
%       [x,y,z] = berechne_Satellitenkoordinaten(t,Ephemeriden)
tolerance = 0.01;
if max(abs(t - [389494.92 389494.92 389494.93])) > tolerance
    printf('%s\n','Der gewählte Zeit-Vektor t ist falsch! Überlege dir, welcher Zeitpunkt zur Bestimmung der Position relevant ist!')
    return
end

% Lese Ephemeriden
M0       = Ephemeriden(1,:);
deltan   = Ephemeriden(2,:);
ecc      = Ephemeriden(3,:);
rootA    = Ephemeriden(4,:);
Omega0   = Ephemeriden(5,:);
i0       = Ephemeriden(6,:);
omega    = Ephemeriden(7,:);
Omegadot = Ephemeriden(8,:);
idot     = Ephemeriden(9,:);
cuc      = Ephemeriden(10,:);
cus      = Ephemeriden(11,:);
crc      = Ephemeriden(12,:);
crs      = Ephemeriden(13,:);
cic      = Ephemeriden(14,:);
cis      = Ephemeriden(15,:);
toe      = Ephemeriden(16,:);

% Vorschrift zur Berechnung der Satellitenkoordinaten
mu = 3.986005e14;
Omegae_dot = 7.2921151467e-5;
A = rootA.*rootA;
n0 = sqrt(mu./A.^3);
tk = t-toe;
n = n0+deltan;
M = M0+n.*tk;
E = M;
for i = 1:20
   E_old = E;
   E = M+ecc.*sin(E);
   dE = E-E_old;
   if max(abs(dE)) < 1.e-12
      break;
   end
end
v = atan2(sqrt(1-ecc.^2).*sin(E), cos(E)-ecc);
phi = v+omega;
u = phi                + cuc.*cos(2*phi)+cus.*sin(2*phi);
r = A.*(1-ecc.*cos(E)) + crc.*cos(2*phi)+crs.*sin(2*phi);
i = i0+idot.*tk        + cic.*cos(2*phi)+cis.*sin(2*phi);
Omega = Omega0+(Omegadot-Omegae_dot).*tk-Omegae_dot*toe;
x1 = cos(u).*r;
y1 = sin(u).*r;
x = x1.*cos(Omega)-y1.*cos(i).*sin(Omega);
y = x1.*sin(Omega)+y1.*cos(i).*cos(Omega);
z = y1.*sin(i);
SK = [x; y; z];

display(SK)
end