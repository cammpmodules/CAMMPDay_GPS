function pruefe_EmpfaengerkoordinatenAB2(xE,yE,zE,delta_tE,SP,delta_tE_MU)
tolerance = 0.1;
c = 299792458;
if max(abs([xE yE zE delta_tE*c] - [SP delta_tE*c])) > tolerance
    printf('%s\n','Dein Ergebnis ist falsch! Korrigiere dein Gleichungssystem und versuche es noch einmal.')
else
display(xE)
display(yE)
display(zE)
format short
display(delta_tE)
end
endfunction