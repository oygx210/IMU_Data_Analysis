function [eps_dt,precision] = FindEpsilon(precision, pas_eps, T_sbg, T_ixblue)

eps_dt=[0 0 0];
corr_dt= [0 0 0];

%Tant que le % de correspondance est inférieure à la précision souhaitée on augmente la valeur de différence acceptable eps
for i=1:3
    while (corr_dt(i) <= precision)
        corr_dt(i)=sum( abs( angle( exp(1i*T_sbg(:,i)*pi/180).*exp(-1i*T_ixblue(:,i)*pi/180))*180/pi ) <= eps_dt(i))/length(T_sbg(:,i)) *100;
        eps_dt(i)=eps_dt(i)+pas_eps;         
    end
end

end