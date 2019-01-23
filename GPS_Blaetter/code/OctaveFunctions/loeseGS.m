function [xE yE zE] = loeseGS(Gleichungssystem)
Funktion = @(X) Gleichungssystem(X(1),X(2),X(3));
Startpunkt = [0 0 0];

%   Berechnen einer Loesung in der Naehe des Startpunktes
X = fsolve(Funktion,Startpunkt);

%   Speichern der berechneten Loesung
xE = X(1);
yE = X(2);
zE = X(3);

%   Anzeigen der Ergebnisse
format bank
display([xE yE zE])
end