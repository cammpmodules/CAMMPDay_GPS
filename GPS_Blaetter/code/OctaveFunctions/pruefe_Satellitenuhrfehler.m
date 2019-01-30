function pruefe_Satellitenuhrfehler(delta_t,delta_t_MU)
tolerance = 1e-07;
if max(abs(delta_t-delta_t_MU))>tolerance
    printf('%s\n','Dein Ergebnis ist falsch! Korrigiere den Zeit-Vektor t.')
else
format short
display(delta_t)
end
endfunction