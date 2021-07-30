function [T_accel,T_angu,temps] = ImuTableIXBLUE(bag,topic)

bag_topic= select(bag,'Topic', topic);
msg_topic = readMessages(bag_topic,'DataFormat','struct'); 
size_msg_topic = table(size(msg_topic)).Var1(1); 

T_accel=zeros(size_msg_topic,3);
T_angu=zeros(size_msg_topic,3);
temps=zeros(size_msg_topic,1); 

for i= 1:size_msg_topic
    temps(i)=bag_topic.MessageList.Time(i)-bag_topic.MessageList.Time(1);
    
    for j=1:3
        %Accel (avec correction signe)
        accel=struct2cell(msg_topic{i}.LinearAcceleration);
        if j==2
            T_accel(i,j)= -accel{j+1};
        else
            T_accel(i,j)= accel{j+1};
        end
       
        %Angular Velocity (avec correction signe)
        angular_vel=struct2cell(msg_topic{i}.AngularVelocity);
        if j==1 || j==3
             T_angu(i,j)= -rad2deg(angular_vel{j+1}); 
        else
            T_angu(i,j)=  rad2deg(angular_vel{j+1});
        
        end  
 
    end   
    
end

end
