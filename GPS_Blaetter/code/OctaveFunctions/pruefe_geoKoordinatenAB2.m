function pruefe_geoKoordinatenAB2(h_0,phi_0,lambda_0,GK_MU)
tolerance = 0.1;
if max(abs([h_0 phi_0 lambda_0] - GK_MU)) > tolerance
    if abs(h-(-18174)) > tolerance
        printf('%s\n','Die berechnete Höhe ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    if abs(phi - 50.343) > tolerance
        printf('%s\n','Die berechnete Breite ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    if abs(lambda - 10.297) > tolerance
        printf('%s\n','Die berechnete Länge ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    return
else
display(h_0)
display(phi_0)
display(lambda_0)
end
endfunction