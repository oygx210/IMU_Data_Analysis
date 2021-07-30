function R2_coef = R2Coeff(T_sbg, T_ixblue)

R2_coef = 1 - sum( ( angle( exp(1i*T_sbg*pi/180).*exp(-1i*T_ixblue*pi/180))*180/pi ).^2)./ sum( (T_ixblue(:,:) - mean(T_ixblue(:,:))).^2);

end