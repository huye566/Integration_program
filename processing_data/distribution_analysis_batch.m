function [portion,temp_find0,temp_find1]=distribution_analysis_batch(data,method,dist_add_txtname,dist_add_figname1,dist_add_figname2)
%method=2更快
%统计连0连1比率——算法1
if(method==1)
%find0
temp_find0=find0or1(data,0);
disp('processing0 is ok');
%find1
temp_find1=find0or1(data,1);
disp('processing1 is ok');
end
if(method==2)
%find0
temp_find0=find0(data);
disp('processing0 is ok');
%find1
temp_find1=find1(data);
disp('processing1 is ok');
end
if(method~=1&&method~=2)
    disp('method number is out of range 1~2（integer）');
    return;
end
length0=length(temp_find0);
length1=length(temp_find1);
max_length=max(length0,length1);
bar_temp=zeros(max_length,2);
bar_temp(1:length0,1)=temp_find0';
bar_temp(1:length1,2)=temp_find1';

sum_0=length(find(data==0));
sum_1=length(find(data==1));
portion(1)=sum(temp_find0(1,1:3))/sum_0;
portion(2)=sum(temp_find1(1,1:3))/sum_1;
portion(3)=sum_0/length(data);
portion(4)=sum_0-sum_1;
%将处理数据写入文本
fid=fopen(dist_add_txtname,'w');
fprintf(fid,'0&1-distrubtion(%d):\r\n',length(data));
fprintf(fid,'sum of 0 is:%d\t the portion is:%8.6f\r\n',sum_0,portion(3));
fprintf(fid,'sum of 1 is:%d\r\nthe difference between 0 and 1:%d\r\n',sum_1,portion(4));
if length0>=11
for i=1:10
    fprintf(fid,'%d\t:%d      \t\t',i,bar_temp(i,1));
    fprintf(fid,'%d\t:%d      \t\t',i,bar_temp(i,2));
    fprintf(fid,'%d\t:%8.6f      \t\t',i,bar_temp(i,1)/bar_temp(i+1,1));
    fprintf(fid,'%d\t:%8.6f\r\n',i,bar_temp(i,2)/bar_temp(i+1,2));

end
for i=11:length0
    fprintf(fid,'%d\t:%d      \t\t',i,bar_temp(i,1));
    fprintf(fid,'%d\t:%d\r\n',i,bar_temp(i,2));
end
else
    for i=1:length0
    fprintf(fid,'%d\t:%d      \t\t',i,bar_temp(i,1));
    fprintf(fid,'%d\t:%d\r\n',i,bar_temp(i,2));
    end
end
fprintf(fid,'%4.3f\t\t\t\t%4.3f\r\n',temp_find0(1,1)/sum_0,temp_find1(1,1)/sum_0);
fprintf(fid,'%4.3f\t\t\t\t%4.3f\r\n',sum(temp_find0(1,2))/sum_0,sum(temp_find1(1,2))/sum_0);
fprintf(fid,'%4.3f\t\t\t\t%4.3f\r\n',sum(temp_find0(1,3))/sum_0,sum(temp_find1(1,3))/sum_0);
fprintf(fid,'%4.3f\t\t\t\t%4.3f\r\n',portion(1),portion(2));
fclose(fid);

%绘图
% text(bar_temp, num2str(bar_temp,'%d'),'center');
% ...
%     'HorizontalAlignment', 'center', ...
%     'VerticalAlignment', 'bottom')
h=figure(15);
bar(bar_temp);
legend('0-distribution','1-distribution');
str1=strcat('portion-0=',num2str(portion(1),'%4.3f'));
str2=strcat('portion-1=',num2str(portion(2),'%4.3f'));
text(max_length*4/5,max(max(temp_find0),max(temp_find1))*4/5,str1,'HorizontalAlignment', 'left','Color','red','FontSize',14);
text(max_length*4/5,max(max(temp_find0),max(temp_find1))*7/10,str2,'HorizontalAlignment', 'left','Color','red','FontSize',14);
xlabel('x-num ');
ylabel('y-sum');
saveas(gcf,dist_add_figname1);
close(h);
h=figure(16);
plot(log(bar_temp)/log(2));
saveas(gcf,dist_add_figname2);
close(h);

%plot类型
% str=[repmat(', Y:',5,1) num2str(bar_temp)];
% text(bar_temp',cellstr(str));
% y=[300 311;390 425; 312 321; 250 185; 550 535; 420 432; 410 520;];
% b=bar(y);
% grid on;
% ch = get(b,'children');
% set(gca,'XTickLabel',{'0','1','2','3','4','5','6'})
% set(ch,'FaceVertexCData',[1 0 1;0 0 0;])
% legend('基于XXX的算法','基于YYY的算法');
% xlabel('x axis ');
% ylabel('y axis');

%统计连0连1比率——算法2
