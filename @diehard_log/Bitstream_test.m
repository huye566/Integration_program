function block6_info=Bitstream_test(log_obj)
label_value_temp=find(strcmp(log_obj.log_info(log_obj.label_block(4)+1:log_obj.label_block(5)-1),'tst')==1);
label_value_temp=label_value_temp+log_obj.label_block(4)+10;%10¸ö³¤¶È
block6_info=zeros(1,length(label_value_temp));
for i=1:length(label_value_temp)
    if strncmp(log_obj.log_info(label_value_temp(i)),'p-value=1.000000',12)==1
        block6_info(i)=1;
    else
        block6_info(i)=str2double(log_obj.log_info{1,label_value_temp(i)+1});
    end
end
        
