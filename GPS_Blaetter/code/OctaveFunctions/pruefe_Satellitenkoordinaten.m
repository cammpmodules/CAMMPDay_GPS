function pruefe_Satellitenkoordinaten(SK,SK_MU)
tolerance = 0.1;
if max(abs(SK-SK_MU))>tolerance
    printf('%s\n','Dein Ergebnis ist falsch! Korrigiere den Zeit-Vektor t.')
else
display(SK)
end
endfunction