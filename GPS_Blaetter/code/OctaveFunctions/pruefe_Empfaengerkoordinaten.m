function pruefe_Empfaengerkoordinaten(xE,yE,zE,SP)
tolerance = 0.1;
if max(abs([xE yE zE] - SP.')) > tolerance
    printf('%s\n','Dein Ergebnis ist falsch! Korrigiere dein Gleichungssystem und versuche es noch einmal.')
else
display(xE)
display(yE)
display(zE)
end
endfunction