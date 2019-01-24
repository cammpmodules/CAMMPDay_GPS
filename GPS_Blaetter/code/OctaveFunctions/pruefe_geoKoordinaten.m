function pruefe_geoKoordinaten(h,phi,lambda)
tolerance = 0.1;
if max(abs([h phi lambda] - [-18174 50.343 10.297])) > tolerance
    if abs(h-(-18174)) > tolerance
        printf('%s\n','Die berechnete Höhe ist nicht korrekt! Pruefe deine Berechnungsformel!')
    end
    if abs(phi - 50.343) > tolerance
        printf('%s\n','Die berechnete Breite ist nicht korrekt! Pruefe deine Berechnungsformel!')
    end
    if abs(lambda - 10.297) > tolerance
        printf('%s\n','Die berechnete Länge ist nicht korrekt! Pruefe deine Berechnungsformel!')
    end
    return
end
display(h)
display(phi)
display(lambda)
end