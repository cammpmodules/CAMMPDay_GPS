function pruefe_Empfaengerkoordinaten(xE,yE,zE,info)
if info ~= 1
    printf('%s\n','Das Gleichungssystem konnte von fsolve nicht erfolgreich gelöst werden. Versuche einen anderen Startpunkt zu wählen!')
    return
else
    tolerance = 0.01;
    if max(abs([xE yE zE] - [3993459.69    725545.77   4896426.57])) > tolerance
        printf('%s\n','Das Gleichungssystem konnte von fsolve gelöst werden, aber das Ergebnis ist falsch. Korrigiere dein Gleichungssystem und versuche es nocheinmal.')
        return
    end
end
display(xE)
display(yE)
display(zE)
endfunction