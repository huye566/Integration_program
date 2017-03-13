function block12_info=Parking_lot_test(log_obj)
label_value=find(strcmp(log_obj.log_info(log_obj.label_block(8)+1:log_obj.label_block(9)-1),'p=')==1);
label_value=label_value+log_obj.label_block(8);
block12_info=str2double(log_obj.log_info{1,label_value+1});