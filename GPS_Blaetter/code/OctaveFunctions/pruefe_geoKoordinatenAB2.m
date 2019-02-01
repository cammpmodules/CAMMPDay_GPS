function pruefe_geoKoordinatenAB2(h_0,phi_0,lambda_0,GK_MU)
tolerance = 0.1;
if max(abs([h_0 phi_0 lambda_0] - GK_MU)) > tolerance
if abs(h_0-GK_MU(1)) > tolerance
    printf('%s\n','Die berechnete Höhe ist nicht korrekt! Pruefe deine Berechnungsformel.')
end
if abs(phi_0 - GK_MU(2)) > tolerance
    printf('%s\n','Die berechnete Breite ist nicht korrekt! Pruefe deine Berechnungsformel.')
end
if abs(lambda_0 - GK_MU(3)) > tolerance
    printf('%s\n','Die berechnete Länge ist nicht korrekt! Pruefe deine Berechnungsformel.')
end
return
else
display(h_0)
display(phi_0)
display(lambda_0)
end
endfunction