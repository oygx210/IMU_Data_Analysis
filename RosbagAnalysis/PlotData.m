function PlotData(temps_sbg, T_sbg, T_ixblue, duree, delta_t, max_diff, diff_mean, eps, corr, precision, eps_dt, R2, RMSE, theta_mes, topic, num_fig)
% autres argument : max_diff, diff_mean, eps_accel, corr_accel, precision, eps_dt, R2, RMSE

if topic== 1
    titles=["Comparaison Accel.X","Comparaison Accel.Y","Comparaison Accel.Z"];
    y_label='Accélérations (m/s²)';
    unite=" m/s²";

    
elseif topic== 2
    titles=["Comparaison VitesseAngulaire.X","Comparaison VitesseAngulaire.Y","Comparaison VitesseAngulaire.Z"];
    y_label='Vitesse angulaire (deg/s)';
    unite=" deg/s";
    
elseif topic== 3
    titles=["Comparaison Roll","Comparaison Pitch","Comparaison Yaw"];
    y_label='Angle (deg)';
    unite=" deg";
    
elseif topic==4
    titles=["Mag.X","Mag.Y","Mag.Z"];
    y_label='Magnetometre (Gauss)';
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if topic ~= 4
    figure(num_fig)
    for i=1:3
    subplot(3,2,i*2-1)
        plot(temps_sbg,T_sbg(:,i),'r',temps_sbg, T_ixblue(:,i),'b')
        title(titles(i))
        grid on
        ylabel(y_label)
        xlabel('Temps (s)')
        legend('SBG','IxBlue')
        set(gcf, 'WindowState', 'maximized');

        annotation('line',[0 1],[1.25-0.3*i 1.25-0.3*i])
        annotation('textbox', [0.2, 0.89, 0.1, 0.1], 'String', "Durée d'acquisition :  " + (duree - delta_t) + " s")
        annotation('textbox', [0.45, 0.89, 0.1, 0.1], 'String', "Delta temps corrigé de SBG (shift gauche) : " + delta_t+ " s")

        annotation('textbox', [0.65, 1.1-0.3*i, 0.1, 0.1], 'String', "Plus grande différence mesurée :  " + max_diff(i) + unite)
        annotation('textbox', [0.65, 1.05-0.3*i, 0.1, 0.1], 'String', "Différence de moyenne:  " + diff_mean(i) + unite)
        annotation('textbox', [0.65, 1-0.3*i, 0.1, 0.1], 'String', "Pourcentage de correspondance à " + eps(i) + unite +" près : " + corr(i) + "%")
        annotation('textbox', [0.65, 0.95-0.3*i, 0.1, 0.1], 'String', "Précision des valeurs pour "+precision+"% de correspondance : "+eps_dt(i)+unite )
        
        annotation('textbox', [0.475, 1.05-0.3*i, 0.1, 0.1], 'String', "Coefficient R² : "+R2(i) )
        annotation('textbox', [0.475, 1.0-0.3*i, 0.1, 0.1], 'String', "Coefficient RMSE : "+RMSE(i) )
        if topic ==3
            annotation('textbox', [0.475, 0.95-0.3*i, 0.1, 0.1], 'String', "Angle mésa corrigé : "+theta_mes(4-i)*180/pi+ "°" )
        end
    end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
elseif topic==4
    figure(num_fig)
    for i=1:3
        subplot(3,1,i)
        plot(temps_sbg,T_sbg(:,i),'r')
        title(titles(i))
        grid on
        ylabel(y_label)
        xlabel('Temps (s)')
        legend('SBG ')
        set(gcf, 'WindowState', 'maximized');
        annotation('textbox', [0.45, 0.89, 0.1, 0.1], 'String', "Durée d'acquisition :  " + (duree) + " secondes")
    end  
end

end