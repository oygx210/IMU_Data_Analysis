function [T_sbg_dt, temps_sbg_dt, T_ixblue_dt] = TimeShift(T_sbg, temps_sbg, T_ixblue, temps_ixblue, delta_t)

temps_sbg_dt = temps_sbg - delta_t ;
a = sum(temps_sbg_dt <= 0);
temps_sbg_dt = temps_sbg_dt(1+a:end,:) ;
T_sbg_dt = T_sbg(1+a:end,:) ;
T_ixblue_dt = interp1(temps_ixblue, T_ixblue, temps_sbg_dt, 'linear');

end