function block10_info=Count_1_in_stream_test(log_obj)
label_value_byte=find(strcmp(log_obj.log_info(log_obj.label_block(6)+1:log_obj.label_block(7)-1),'byte')==1);
block10_info=zeros(1,length(label_value_byte));
label_value_byte=label_value_byte+log_obj.label_block(6)+6;
for i=1:length(label_value_byte)
    block10_info(i)=str2double(log_obj.log_info{1,label_value_byte(i)});
end


