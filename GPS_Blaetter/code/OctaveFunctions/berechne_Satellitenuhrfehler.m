function Delta_t = berechne_Satellitenuhrfehler(t,Ephemeriden)
%BERECHNE_SATELLITENUHRFEHLER Berechnet Zeitfehler der Satellitenuhren
%   Eingabe:
%       - t = Vektor der Zeitpunkte in Sekunden
%       - Ephemeriden = Ephemeridenmatrix
%   Ausgabe:
%       - Delta_t = Vektor der Uhrfehler in Sekunden
%   Aufruf:
%       Delta_t = berechne_Satellitenuhrfehler(t,Ephemeriden)

% Lese Ephemeriden
M0     = Ephemeriden(1,:);
deltan = Ephemeriden(2,:);
ecc    = Ephemeriden(3,:);
rootA  = Ephemeriden(4,:);
toe    = Ephemeriden(16,:);
af0    = Ephemeriden(17,:);
af1    = Ephemeriden(18,:);
af2    = Ephemeriden(19,:);
toc    = Ephemeriden(20,:);

% Vorschrift zur Berechnung der Satellitenuhrfehler
mu = 3.986005e14;
c = 2.99792458e8;
F = -2*sqrt(mu)/c^2;
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
Delta_tr = F*ecc.*rootA.*sin(E);
tk = t-toc;
Delta_t = af0+af1.*tk+af2.*tk.^2+Delta_tr;
end