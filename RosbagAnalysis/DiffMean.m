function diff_mean = DiffMean(T_sbg, T_ixblue)

moy_sbg=mean(angle( exp(1i*T_sbg*pi/180).*exp(-1i*0*pi/180))*180/pi);
moy_ixblue=mean(angle( exp(1i*T_ixblue*pi/180).*exp(-1i*0*pi/180))*180/pi);
diff_mean= angle( exp(1i*moy_sbg*pi/180).*exp(-1i*moy_ixblue*pi/180))*180/pi;

end