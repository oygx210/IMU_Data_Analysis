function [T_mag,temps] = MagTableSBG(bag,topic)

bag_topic= select(bag,'Topic', topic);
msg_topic = readMessages(bag_topic,'DataFormat','struct'); 
size_msg_topic = table(size(msg_topic)).Var1(1);

T_mag=zeros(size_msg_topic,3);
temps=zeros(size_msg_topic,1); 

for i= 1:size_msg_topic
    temps(i)=bag_topic.MessageList.Time(i)-bag_topic.MessageList.Time(1);
    for j=1:3
        mag=struct2cell(msg_topic{i}.Mag);
        T_mag(i,j)=mag{j+1};  
    end     
end
end
