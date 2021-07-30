function [corr, eps] = CorrPerCent(eps, T_sbg, T_ixblue)

corr=zeros(1,3);

for i=1:3
    corr(i) = sum(abs(  angle( exp(1i*T_ixblue(:,i)*pi/180).*exp(-1i*T_sbg(:,i) *pi/180))*180/pi   ) <= eps(i) )/length(T_sbg(:,i)) *100;
end

end

