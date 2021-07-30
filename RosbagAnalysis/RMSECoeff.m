function RMSE_coef = RMSECoeff(T_sbg, T_ixblue)

RMSE_coef = sqrt(mean(( angle( exp(1i*T_sbg*pi/180).*exp(-1i*T_ixblue*pi/180))*180/pi).^2   ));

end