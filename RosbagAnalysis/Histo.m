function [error, range_step_error] = Histo(range_step_error, T_sbg, T_ixblue)

error=abs( angle( exp(1i*T_sbg*pi/180).*exp(-1i*T_ixblue*pi/180) )*180/pi ) ;

end
