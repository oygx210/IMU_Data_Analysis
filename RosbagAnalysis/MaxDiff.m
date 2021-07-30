function max_diff = MaxDiff(T_sbg, T_ixblue)

max_diff = max( angle( exp(1i*T_sbg*pi/180).*exp(-1i*T_ixblue*pi/180))*180/pi);
    
end