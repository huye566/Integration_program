function temp=find0(data)
%ͳ����0��1���ʡ����㷨2
data_temp=ones(1,length(data)+2);
data_temp(1,2:end-1)=data;
data_temp=find(data_temp==1);
data_temp=diff(data_temp);
data_temp=data_temp(logical(data_temp>1))-1;
label=max(data_temp);
temp=zeros(1,label);
for i=1:label
    temp(i)=length(find(data_temp==i));
end
% error=symerr(a,temp)
