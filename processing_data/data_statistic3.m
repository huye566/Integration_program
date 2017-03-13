function [length_diff,temp,median_num,mean_num]=data_statistic3(data)
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
mean_num=mean(data);
median_num=median(length_diff);
plot(length_diff*1000,stem_data);
xlim([min(length_diff)*1000,max(length_diff)*1000]);
ylim([0 max(stem_data)+400]);
hold on;
stem(mean_num*1000,max(stem_data)*1.2,'-r','LineWidth',2);
stem(median_num*1000,max(stem_data)*1.2,'-y','LineWidth',2);
hold off;
xlabel('Am/mv');
ylabel('num of Am');
str=[num2str(length(length_diff)),',length(median)=',num2str(median_length)];
title(str);
xlim_text=xlim;
ylim_text=ylim;
text(xlim_text(2)*0.5,ylim_text(2)*0.8...
    ,['red-mean:',num2str(mean_num*1000,'%6.4f')],'FontSize',10,'Color','r','BackgroundColor',[.7 .9 .7]);
text(xlim_text(2)*0.5,ylim_text(2)*0.6...
    ,['yellow-median:',num2str(median_num*1000,'%6.4f')],'FontSize',10,'Color','y','BackgroundColor',[.7 .9 .7]);
text(xlim_text(2)*0.5,ylim_text(2)*0.4...
    ,num2str(abs(median_num-mean_num)*1000,'%6.4f'),'FontSize',10,'Color','b','BackgroundColor',[.7 .9 .7]);
median_num=median_num*1000;
mean_num=mean_num*1000;


