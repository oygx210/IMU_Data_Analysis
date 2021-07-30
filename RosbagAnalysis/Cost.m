function r = Cost(theta, T_sbg, T_ixblue, capteur)

% Calcul différence angle rpy
alpha_yaw = theta(1);
beta_pitch = theta(2);
gamma_roll = theta(3);

%Longueur vecteur données
N=length(T_sbg);

%%%%% Vitesse Angu %%%%%%%%
if capteur == 2 
    %Matrice de rotation Y*P*R
    R_ypr = RotationMatrix(alpha_yaw, beta_pitch, gamma_roll);
    %Vecteur PHINS estimé
    T_ixblue_est = (R_ypr * T_sbg')' ;
    %Résidu entre vraie valeur PHINS et estimée
    r = T_ixblue - T_ixblue_est ;

%%%%% Angles RPY %%%%%%%%
elseif capteur ==3 %si RPY
    AnglesDiff = [ones(size(T_sbg,1),1)*gamma_roll,ones(size(T_sbg,1),1)*beta_pitch,ones(size(T_sbg,1),1)*alpha_yaw];
    T_ixblue_est = T_sbg*pi/180;
    r = angle(exp(1i*pi*T_ixblue/180).*exp(-1i*T_ixblue_est).*exp(-1i*AnglesDiff));
end

%met les 3 colonnes à la suite
r = reshape(r,[3*N, 1])/(0.5*pi/180); 

end