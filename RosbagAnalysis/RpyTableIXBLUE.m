function [T_rpy,temps] = RpyTableIXBLUE(bag,topic)

bag_topic= select(bag,'Topic', topic);
msg_topic = readMessages(bag_topic,'DataFormat','struct'); 
size_msg_topic = table(size(msg_topic)).Var1(1); 

T_rpy=zeros(size_msg_topic,3);
temps=zeros(size_msg_topic,1); 

for i= 1:size_msg_topic
    temps(i)=bag_topic.MessageList.Time(i)-bag_topic.MessageList.Time(1);
    
    for j=1:3
        T_rpy(i,1)=-msg_topic{i}.Roll; %Signe négatif
        T_rpy(i,2)=msg_topic{i}.Pitch; 
        T_rpy(i,3)=msg_topic{i}.Heading;
    end      
end
end
