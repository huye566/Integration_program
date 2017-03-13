function block11_info=Count_1_in_specified_bits_test(log_obj)
label_value_bit=find(strcmp(log_obj.log_info(log_obj.label_block(7)+1:log_obj.label_block(8)-1),'bits')==1);
block11_info=zeros(1,length(label_value_bit));
label_value_bit=label_value_bit+log_obj.label_block(7)+6;
for i=1:length(label_value_bit)
    block11_info(i)=str2double(log_obj.log_info{1,label_value_bit(i)});
end



