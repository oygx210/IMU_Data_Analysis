function [T_accel,T_angu,temps] = ImuTableSBG(bag,topic)

bag_topic= select(bag,'Topic', topic);%Sous-rosbag contenant les données du topic voulu
msg_topic = readMessages(bag_topic,'DataFormat','struct'); %Mise en forme des données en struct
size_msg_topic = table(size(msg_topic)).Var1(1); %nombre de lignes de messages du topic

T_accel=zeros(size_msg_topic,3);%Stockage tableau : accel x/ accel y/ accel z
T_angu=zeros(size_msg_topic,3);%Stockage : vit angu x/ vit angu y/ vit angu z
temps=zeros(size_msg_topic,1); %vecteur temps : support temporel pour le plot

%Double boucle pour parcourir tous les messages du topic et remplir les 3
%colonnes de chaque tableau (x,y,z)
for i= 1:size_msg_topic
    
    %Temps référentiel ROS
    temps(i)=bag_topic.MessageList.Time(i)-bag_topic.MessageList.Time(1);
    
    for j=1:3
        %Accel 
        accel=struct2cell(msg_topic{i}.Accel);
        T_accel(i,j)=-accel{j+1} ; 
        
        %Vitesse Angulaire
        delta_angle=struct2cell(msg_topic{i}.DeltaAngle);
        T_angu(i,j)=rad2deg(delta_angle{j+1}) ; 
    end   
    
end

end
