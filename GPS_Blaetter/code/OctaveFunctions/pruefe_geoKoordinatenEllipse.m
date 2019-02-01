function pruefe_geoKoordinatenEllipse(h,phi,lambda,VGK_MU)
tolerance = 0.0001;
if max(abs([phi lambda] - [VGK_MU(2) VGK_MU(3)])) > tolerance || abs(h-VGK_MU(1)) > 2.5
    if abs(h-VGK_MU(1)) > 2.5
        printf('%s\n','Die berechnete Höhe ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    if abs(phi - VGK_MU(2)) > tolerance
        printf('%s\n','Die berechnete Breite ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    if abs(lambda - VGK_MU(3)) > tolerance
        printf('%s\n','Die berechnete Länge ist nicht korrekt! Pruefe deine Berechnungsformel.')
    end
    return
else
display(h)
display(phi)
display(lambda)
end
endfunction