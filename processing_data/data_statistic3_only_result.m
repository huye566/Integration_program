function [length_diff,temp,median_num,mean_num,median_length]=data_statistic3_only_result(data)
%length_diff实际有效数值
ma=median(data);
median_length=length(data(data==ma));%中值数量较多
ascending_data=zeros(1,length(data)+1);
temp=sort(data);
ascending_data(2:end)=temp;
ascending_data_diff=diff(ascending_data);
length_diff=temp(ascending_data_diff~=0);
%stem(length_diff,stem_data);
mean_num=mean(data);
median_num=median(length_diff);
median_num=median_num*1000;
mean_num=mean_num*1000;


