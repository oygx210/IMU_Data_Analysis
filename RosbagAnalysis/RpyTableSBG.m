function [T_ekf,temps] = RpyTableSBG(bag,topic)

bag_topic= select(bag,'Topic', topic);
msg_topic = readMessages(bag_topic,'DataFormat','struct'); 
size_msg_topic = table(size(msg_topic)).Var1(1);

T_ekf=zeros(size_msg_topic,3);
temps=zeros(size_msg_topic,1); 

for i= 1:size_msg_topic
    
    temps(i)=bag_topic.MessageList.Time(i)-bag_topic.MessageList.Time(1);
    
    for j=1:3
        ekf=struct2cell(msg_topic{i}.Angle);
     
        if j==3 %Heading : correction [-180°;180°] -> [0°;360°] 
            T_ekf(i,j)=rad2deg(ekf{j+1})+180;  
            
        else %Roll&Pitch: pas de correction  
            T_ekf(i,j)=rad2deg(ekf{j+1}) ;
        end

    end   
    
end

end
