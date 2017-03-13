function [length_diff,temp]=data_statistic(data)
%length_diff实际有效数值
ma=median(data);
median_length=length(data(data==ma));%中值数量较多
ascending_data=zeros(1,length(data)+1);
temp=sort(data);
ascending_data(2:end)=temp;
ascending_data_diff=diff(ascending_data);
length_diff=temp(ascending_data_diff~=0);
ascending_data_diff_add=ones(1,length(ascending_data_diff)+1);
ascending_data_diff_add(1:end-1)=ascending_data_diff;
stem_data_index=find(ascending_data_diff_add~=0);
stem_data=diff(stem_data_index);
%stem(length_diff,stem_data);
stem(stem_data);
ylim([0 max(stem_data)+400]);
hold on;
stem(floor(length(stem_data)/2),max(stem_data)+400,'-r','LineWidth',2);
hold off;
str=[num2str(length(length_diff)),',length(median)=',num2str(median_length)];
title(str);