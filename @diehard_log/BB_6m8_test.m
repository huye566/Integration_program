function block5_info=BB_6m8_test(log_obj)
label_value_1=find(strncmp(log_obj.log_info(log_obj.label_block(3)+1:log_obj.label_block(4)-1),'p-value=1.000000',12)==1);
label_value=find(strcmp(log_obj.log_info(log_obj.label_block(3)+1:log_obj.label_block(4)-1),'p-value=')==1);
if (length(label_value_1)+length(label_value))~=1
    disp('log_file has some format error in BB_6m8_test!!!!');
else
    if isempty(label_value_1)
        label_value=label_value+log_obj.label_block(3);
        block5_info=str2double(log_obj.log_info{1,label_value+1});
    else
        block5_info=1;
    end
end
