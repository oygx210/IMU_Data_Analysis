function PlotHisto(error, range_error, topic, num_fig)

if topic == 1
    titles=["Distribution erreur Accel.X","Distribution erreur Accel.Y","Distribution erreur Accel.Z"];
    titles2=["Cumcount erreur Accel.X","Cumcount erreur Accel.Y","Cumcount erreur Accel.Z"];
    x_label="Fourchette d'erreur en m/s²";
    y_label1='Pourcentage de points ';
    y_label2='Nombre de points ';
    
elseif topic==2
    titles=["Distribution erreur VitesseAngu.X","Distribution erreur VitesseAngu.Y","Distribution erreur VitesseAngu.Z"];
    titles2=["Cumcount erreur VitesseAngu.X","Cumcount erreur VitesseAngu.Y","Cumcount erreur VitesseAngu.Z"];
    x_label="Fourchette d'erreur en deg/s";
    y_label1='Pourcentage de points ';
    y_label2='Nombre de points ';
    
elseif topic==3
    titles=["Distribution erreur RPY.X","Distribution erreur RPY.Y","Distribution erreur RPY.Z"];
    titles2=["Cumcount erreur RPY.X","Cumcount erreur RPY.Y","Cumcount erreur RPY.Z"];
    x_label="Fourchette d'erreur en deg/s";
    y_label1='Pourcentage de points ';
    y_label2='Nombre de points ';
end

    
figure(num_fig)
for i=1:3
    subplot(3,2,2*i-1)
    histogram(error(:,i),'BinWidth',range_error(i),'Normalization','probability')
    title(titles(i))
    ylabel(y_label1)
    xlabel(x_label)
    set(gcf, 'WindowState', 'maximized');
    grid on

    subplot(3,2,2*i)
    histogram(error(:,i),'BinWidth',range_error(i),'Normalization','cumcount')
    title(titles2(i))
    ylabel(y_label2)
    xlabel(x_label)
    set(gcf, 'WindowState', 'maximized');
    grid on
    
end
end