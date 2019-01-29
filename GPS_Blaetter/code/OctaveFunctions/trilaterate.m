function SP=trilaterate(P1,P2,P3,r1,r2,r3)
temp1 = P2-P1;
e_x = temp1/norm(temp1);
temp2 = P3-P1;
i = dot(e_x,temp2);
temp3 = temp2 - i*e_x;
e_y = temp3/norm(temp3);
e_z = cross(e_x,e_y);
d = norm(P2-P1);
j = dot(e_y,temp2);
x = (r1*r1 - r2*r2 + d*d) / (2*d);               
y = (r1*r1 - r3*r3 -2*i*x + i*i + j*j) / (2*j);
temp4 = r1*r1 - x*x - y*y;                            
if temp4<0
    printf('%s\n','Die drei Kugeln schneiden sich nicht!')
else
    z = sqrt(temp4);
    SP1 = P1 + x*e_x + y*e_y + z*e_z;                  
    SP2 = P1 + x*e_x + y*e_y - z*e_z;
    aequatorradius = 6378137.0;
    if abs(norm(SP1)-aequatorradius) < abs(norm(SP2)-aequatorradius)
        SP = SP1;
    else
        SP = SP2;
    end
end
endfunction