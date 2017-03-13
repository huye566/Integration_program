function block14_info=tripleD_Sphere_test(log_obj)
label_value_3d=find(strcmp(log_obj.log_info(log_obj.label_block(10)+1:log_obj.label_block(11)-1),'3DSPHERES')==1);
label_value_3d=label_value_3d+log_obj.label_block(10)+5;
if strcmp(log_obj.log_info{1,label_value_3d(end)},'p-value=')==1
    block14_info=str2double(log_obj.log_info{1,label_value_3d(end)+1});
else
    block14_info=1;
end