function temp_find=find0or1(data,find_aim)
%ͳ����0��1���ʡ����㷨1
datafind=find(data==find_aim);
label=1;
sum_0=length(datafind);
temp_find=zeros(1,sum_0);
temp_find(label)=sum_0;
while(datafind)
datafind=diff(datafind);
datafind=find(datafind==1);
label=label+1;
temp_find(label)=length(datafind);
end
label=label-1;
temp_find=temp_find(1,1:label);
for i=1:label-1
    for j=1:i
    temp_find(label-i)=temp_find(label-i)-temp_find(label-j+1)*(i+2-j);
    end
end