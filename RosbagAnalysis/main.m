%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean initial
clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Réglages centrales
% Carte SBG et Ixblue dans le même sens (câbles vers nous)
% Carte SBG fixée sur la Ixblue pour obtenir les mêmes mouvements
% Carte SBG -> X:forward / Y:left / Z:auto
% Certains signes de valeurs ont été modifiés dans le script afin de
% pouvoir comparer les valeurs (référentiels différents et signes différents dans certains cas)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Choix du chemin d'accès au rosbag
%Explorateur de fichier
%[file,path] = uigetfile;

%Chemin pré-rempli (plus rapide que l'explorateur)
file='statique1.bag';
path='/home/mathis/Documents/Stage_Mathis_Provost/Expériences/Tests_bureau/Statique/sans_mag/Statique1/';
%path='C:\Users\Mathi\Documents\Etudes\SeaTech\2A - SYSMER\Stage 2A/';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% On charge le rosbag contenant les données des 2 centrales

%Données du rosbag
bag=rosbag([path file]);
%Infos du rosbag
bagInfo = rosbag('info',[path file]);
duree=bagInfo.Duration;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%œ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Création tables données

% SBG
[T_accel_sbg,T_gyro_sbg,temps_imu_sbg]=ImuTableSBG(bag,'/sbg/imu_data');
[T_rpy_sbg,temps_rpy_sbg]=RpyTableSBG(bag,'/sbg/ekf_euler');
[T_mag_sbg,temps_mag_sbg]=MagTableSBG(bag,'/sbg/mag');

% IXBLUE
[T_accel_ixblue,T_gyro_ixblue,temps_imu_ixblue]=ImuTableIXBLUE(bag,'ixblue_ins_driver/standard/imu');
[T_rpy_ixblue,temps_rpy_ixblue]=RpyTableIXBLUE(bag,'ixblue_ins_driver/ix/ins');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Décalage temporel

% Calcul
pas=0.0001; %pas pour les delta_t_i : précision
tMax=0.5; %hypothèse du DeltaT_max pour éviter de parcourir tout le vecteur temps : gain de temps de calcul

% Hypothèse que tous les décalages temporels sont les mêmes : on se base sur celui de la vitesse angulaire qui donne les valeurs les plus fiables / PHINS
delta_t_gyro = FindDeltaT(pas, tMax, T_gyro_sbg, temps_imu_sbg, T_gyro_ixblue, temps_imu_ixblue);

% Application
[T_accel_sbg, temps_accel_sbg, T_accel_ixblue] = TimeShift(T_accel_sbg, temps_imu_sbg, T_accel_ixblue, temps_imu_ixblue, delta_t_gyro);
[T_gyro_sbg, temps_gyro_sbg, T_gyro_ixblue] = TimeShift(T_gyro_sbg, temps_imu_sbg, T_gyro_ixblue, temps_imu_ixblue, delta_t_gyro);
[T_rpy_sbg, temps_rpy_sbg, T_rpy_ixblue] = TimeShift(T_rpy_sbg, temps_rpy_sbg, T_rpy_ixblue, temps_rpy_ixblue, delta_t_gyro);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matrice de rotation

% Paramètres lsqnonlin
theta0 = [0 0 0];
max_nb_of_iterations = 200;
options = optimset('LargeScale','on','Display','off','MaxFunEvals',inf,'MaxIter',max_nb_of_iterations, 'Diagnostics', 'off');

% Correction mésalignement gyro
theta_mes_gyro = lsqnonlin(@(theta) Cost(theta, T_gyro_sbg, T_gyro_ixblue, 2), theta0, [], [], options);
T_gyro_sbg = CorrectMes(T_gyro_sbg,theta_mes_gyro,1);

% Correction mésalignement angles
theta_mes_angle= lsqnonlin(@(theta) Cost(theta, T_rpy_sbg, T_rpy_ixblue, 3), theta0, [-2*pi, -2*pi, -2*pi ], [2*pi, 2*pi, 2*pi], options);
T_rpy_sbg = CorrectMes(T_rpy_sbg, theta_mes_angle, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculs indicateurs

% Calcul moyennes & différences
diff_mean_accel=DiffMean(T_accel_sbg, T_accel_ixblue);
diff_mean_gyro = DiffMean(T_gyro_sbg, T_gyro_ixblue);
diff_mean_rpy= DiffMean(T_rpy_sbg, T_rpy_ixblue);

% Plus grande différence mesurée
max_diff_accel=MaxDiff(T_accel_sbg, T_accel_ixblue);
max_diff_gyro=MaxDiff(T_gyro_sbg, T_gyro_ixblue);
max_diff_rpy = MaxDiff(T_rpy_sbg, T_rpy_ixblue);

% Pourcentage de correspondance des valeurs à epsilon près
[corr_accel, eps_accel] = CorrPerCent ([1 1 1], T_accel_sbg, T_accel_ixblue );
[corr_gyro, eps_gyro] = CorrPerCent ([1 1 1], T_gyro_sbg, T_gyro_ixblue );
[corr_rpy, eps_rpy] = CorrPerCent ([1 1 1], T_rpy_sbg, T_rpy_ixblue );

% Calcul eps pour une précision souhaitée
[eps_accel_dt, precision_accel] = FindEpsilon(99.0, 0.01, T_accel_sbg, T_accel_ixblue);
[eps_gyro_dt, precision_gyro] = FindEpsilon(99.0, 0.01, T_gyro_sbg, T_gyro_ixblue);
[eps_rpy_dt, precision_rpy] = FindEpsilon(99.0, 0.01, T_rpy_sbg, T_rpy_ixblue);

% Histogramme distance erreur SBG/Ixblue
[error_accel, range_error_accel]=Histo( [0.01 0.01 0.01], T_accel_sbg, T_accel_ixblue);
[error_gyro, range_error_gyro]=Histo( [0.01 0.01 0.01], T_gyro_sbg, T_gyro_ixblue);
[error_rpy, range_error_rpy]=Histo( [0.01 0.01 0.01], T_rpy_sbg, T_rpy_ixblue);

% Coefficient R2
R2_accel= R2Coeff(T_accel_sbg, T_accel_ixblue);
R2_gyro = R2Coeff(T_gyro_sbg, T_gyro_ixblue);
R2_rpy = R2Coeff(T_rpy_sbg, T_rpy_ixblue);

% Coefficient RMSE
RMSE_accel = RMSECoeff(T_accel_sbg, T_accel_ixblue);
RMSE_gyro = RMSECoeff(T_gyro_sbg, T_gyro_ixblue);
RMSE_rpy = RMSECoeff(T_rpy_sbg, T_rpy_ixblue);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Affichages

%Accel
PlotData(temps_accel_sbg, T_accel_sbg, T_accel_ixblue, duree, delta_t_gyro, max_diff_accel, diff_mean_accel, eps_accel, corr_accel, precision_accel, eps_accel_dt, R2_accel, RMSE_accel,0,1,1);
PlotError(temps_accel_sbg, T_accel_sbg, T_accel_ixblue,1,2)
PlotHisto(error_accel, range_error_accel, 1, 3);

%Vitesse angulaire
PlotData(temps_gyro_sbg, T_gyro_sbg, T_gyro_ixblue, duree, delta_t_gyro,max_diff_gyro, diff_mean_gyro, eps_gyro, corr_gyro, precision_gyro, eps_gyro_dt, R2_gyro, RMSE_gyro,0,2,4);
PlotError(temps_gyro_sbg, T_gyro_sbg, T_gyro_ixblue,2,5)
PlotHisto(error_gyro, range_error_gyro, 2, 6);

%RPY
PlotData(temps_rpy_sbg, T_rpy_sbg, T_rpy_ixblue, duree, delta_t_gyro,max_diff_rpy, diff_mean_rpy, eps_rpy, corr_rpy, precision_rpy, eps_rpy_dt, R2_rpy, RMSE_rpy,theta_mes_angle,3,7);
PlotError(temps_rpy_sbg, T_rpy_sbg, T_rpy_ixblue,3,8)
PlotHisto(error_rpy, range_error_rpy, 3, 9);

%Mag
PlotData(temps_mag_sbg, T_mag_sbg, 0, duree, 0,0,0,0,0,0,0,0,0,0, 4, 10);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clean WS info inutiles

clear file path

clear bag bagInfo

clear precision_accel precision_gyro precision_rpy
clear eps_accel eps_gyro eps_rpy

clear pas tMax
clear temps_imu_ixblue temps_rpy_ixblue temps_imu_sbg

clear range_error_accel range_error_gyro range_error_rpy

clear theta0 options max_nb_of_iterations i

