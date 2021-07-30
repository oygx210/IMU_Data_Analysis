function T_sbg = CorrectMes(T_sbg, theta_mes, capteur)

if capteur==1
    R_ypr_gyro = RotationMatrix(theta_mes(1), theta_mes(2), theta_mes(3));
    T_sbg = (R_ypr_gyro * T_sbg')' ;
    
elseif capteur==2
    for i=1:3
        T_sbg(:,i)=T_sbg(:,i) + 180*theta_mes(4-i)/pi;
    end
    
end
end