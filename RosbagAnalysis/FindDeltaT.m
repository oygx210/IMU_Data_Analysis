function [delta_t_opti] = FindDeltaT(pas, tMax, T_sbg, temps_sbg, T_ixblue, temps_ixblue)

N = tMax/pas +1; 
delta_t=0;
temps_sbg_dt = temps_sbg;
residu=zeros(4,N);
i=1;

while(temps_sbg_dt(end)> temps_sbg(end) - tMax) 

    temps_sbg_dt = temps_sbg - delta_t; %décalage temporel de delta_t
    
    a=sum(temps_sbg_dt <= 0); %nombre temps <0 
    temps_sbg_dt = temps_sbg_dt(1+a:end,:); % on tronque
    T_sbg_dt = T_sbg(1+a:end,:); % on tronque
    
    %Les tableaux IxBlue contiennent beaucoup plus de données que ceux de SBG
    %Il faut faire une interpolation linéaire pour estimer les valeurs IxBlue aux
    %valeurs de temps exacte mesurées pour les données de SBG afin de pouvoir
    %travailler sur des tableaux de même tailles et les comparer.
    T_ixblue_dt = interp1(temps_ixblue , T_ixblue(:,:), temps_sbg_dt ,'linear');
    
    for j=1:3
        residu(j,i)=sum( (   angle( exp(1i*T_ixblue_dt(:,j)*pi/180).*exp(-1i*T_sbg_dt(:,j) *pi/180))*180/pi   ).^2   ) ;
        residu(4,i)=mean(residu(1:3,i));
    end
   
    
    i=i+1; 
    delta_t=delta_t+pas; %on incremente le delta_t du pas fixé
end

[~,index_residu]=min(residu(4,:)); %on recupere l'indice ou la somme des résidus au carré est minimum
delta_t_opti=index_residu*pas-pas; %on recupere le delta_t correspondant à cet indice

end