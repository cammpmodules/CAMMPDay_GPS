function pruefe_Pseudoentfernungen(dS)
tolerance = 0.1;
if max(abs(dS - [22717609.10   23165457.21   21000054.55])) > tolerance
    printf('%s\n','Die berechneten Pseudoentfernungen sind nicht korrekt! Pruefe deine Berechnungsformel und die Ausbreitungsgeschwindigkeit!')
    return
end
display(dS)
end