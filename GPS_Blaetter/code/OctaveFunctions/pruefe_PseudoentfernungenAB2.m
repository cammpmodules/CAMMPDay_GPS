function pruefe_PseudoentfernungenAB2(dS, dS_MU)
tolerance = 0.1;
if max(abs(dS - dS_MU)) > tolerance
    printf('%s\n','Die berechneten Pseudoentfernungen sind nicht korrekt! Pruefe deine Berechnungsformel unter Berücksichtigung des Satellitenuhrfehlers!')
else
display(dS)
end