function block1_info=BS_test(log_obj)
label_value=find(strcmp(log_obj.log_info(1:log_obj.label_block(1)-1),'yields')==1);
block1_info=str2double(log_obj.log_info{1,label_value+1});