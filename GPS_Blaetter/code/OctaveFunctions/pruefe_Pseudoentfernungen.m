function pruefe_Pseudoentfernungen(dS, dS_MU)
tolerance = 0.1;
if max(abs(dS - dS_MU)) > tolerance
    printf('%s\n','Die berechneten Pseudoentfernungen sind nicht korrekt! Pruefe deine Berechnungsformel und die Ausbreitungsgeschwindigkeit!')
else
display(dS)
end