function data_temp=wavedata_2_binary(data,judgment_threshold)
data_temp=data;
if strcmp(judgment_threshold,'mean')==1
       ma=mean(data);
else
       ma=median(data);
end
if length(data_temp(data>ma))<length(data_temp(data<ma))
       data_temp(data>=ma)=1;
       data_temp(data<ma)=0;
else
       data_temp(data>ma)=1;
       data_temp(data<=ma)=0;
end
data_temp=data_temp';%%%不确定是否ok------------------------------------------------