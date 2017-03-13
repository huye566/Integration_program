function block16_info=OSUM_test(log_obj)
label_value=find(strcmp(log_obj.log_info(log_obj.label_block(12)+1:log_obj.label_block(13)-1),'p-values:')==1);
label_value=label_value+log_obj.label_block(12);
block16_info=str2double(log_obj.log_info{1,label_value+1});