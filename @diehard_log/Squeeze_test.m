function block15_info=Squeeze_test(log_obj)
label_value=find(strcmp(log_obj.log_info(log_obj.label_block(11)+1:log_obj.label_block(12)-1),'p-value=')==1);
label_value_1=find(strncmp(log_obj.log_info(log_obj.label_block(11)+1:log_obj.label_block(12)-1),'p-value=1.000000',12)==1);
if (length(label_value)+length(label_value_1))~=1
    disp('log_file has some format error in Minimum_distance_test!!!!');
else
    if isempty(label_value)
        block15_info=1;
    else
        label_value=label_value+log_obj.label_block(11);
        block15_info=str2double(log_obj.log_info{1,label_value+1});
    end
end