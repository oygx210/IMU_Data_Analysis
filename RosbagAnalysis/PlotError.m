function PlotError(temps_sbg, T_sbg, T_ixblue, topic, num_fig)

    error = T_ixblue- T_sbg ; 

    if topic== 1
        titles=["Erreur Accel.X","Erreur Accel.Y","Erreur Accel.Z"];
        y_label='Accélérations (m/s²)';

    elseif topic== 2
        titles=["ErreurVitesseAngulaire.X","Erreur VitesseAngulaire.Y","Erreur VitesseAngulaire.Z"];
        y_label='Vitesse angulaire (deg/s)';

    elseif topic== 3
        titles=["Erreur Roll","Erreur Pitch","Erreur Yaw"];
        y_label='Angle (deg)';
    end
    
    figure(num_fig)
    for i=1:3
        subplot(3,1,i)
            plot(temps_sbg,error(:,i))
            title(titles(i))
            grid on
            ylabel(y_label)
            xlabel('Temps (s)')
            set(gcf, 'WindowState', 'maximized');

    end

end