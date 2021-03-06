function [Satelliten,Satellitenauswahl,Wochen,tE,tS,Signalstaerken,Ephemeriden] = show_data(Satellitendaten, Satellitenauswahl)
    %   Auswaehlen eines Datensatzes
    Datensatznummer = 1;
    Datensatz = Satellitendaten(Datensatznummer);

    %   Satelliten, deren Nachrichten empfangen wurden
    Satelliten = Datensatz.Satelliten;

    %   Auslesen der ausgewaehlten Satellitendaten
    Wochen = Datensatz.Wochennummern(Satellitenauswahl);
    tE = Datensatz.Empfangszeiten(Satellitenauswahl);
    tS = Datensatz.Sendezeiten(Satellitenauswahl);
    Signalstaerken = Datensatz.Signalstaerken(Satellitenauswahl);
    Ephemeriden = Datensatz.Ephemeriden(:,Satellitenauswahl);
    
    %   Anzeigen der Ergebnisse
    format shortG
    display(Satelliten)
    display(Satellitenauswahl)
    format bank
    display(Wochen)
    display(tE)
    display(tS)
    display(Signalstaerken)
    display(Ephemeriden)
end
