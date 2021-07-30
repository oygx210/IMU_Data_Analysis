function R_ypr = RotationMatrix(alpha_yaw, beta_pitch, gamma_roll)
    
  %Matrice de rotation yaw 
    R_yaw = [cos(alpha_yaw) -sin(alpha_yaw)  0 ;
             sin(alpha_yaw) cos(alpha_yaw)   0 ;
             0                 0             1 ]  ;
         
    %Matrice de rotation pitch
    R_pitch = [ cos(beta_pitch) 0 sin(beta_pitch) ;
                   0            1         0       ;
                -sin(beta_pitch) 0 cos(beta_pitch)];

    %Matrice de rotation roll
    R_roll = [ 1        0                 0            ;
               0      cos(gamma_roll) -sin(gamma_roll) ; 
               0      sin(gamma_roll) cos(gamma_roll)] ;

    %Matrice de rotation Y*P*R              
    R_ypr = R_yaw * R_pitch * R_roll ;
    
end