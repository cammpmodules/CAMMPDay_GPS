function pruefe_geoKoordinaten(h,phi,lambda,GK_MU)
tolerance = 0.1;
if max(abs([h phi lambda] - GK_MU)) > tolerance
    if abs(h-GK_MU(1)) > tolerance
        printf('%s\n','Die berechnete Höhe ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    if abs(phi - GK_MU(2)) > tolerance
        printf('%s\n','Die berechnete Breite ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    if abs(lambda - GK_MU(3)) > tolerance
        printf('%s\n','Die berechnete Länge ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    return
else
display(h)
display(phi)
display(lambda)
end
endfunction