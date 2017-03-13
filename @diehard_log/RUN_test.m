function [block17_info,block18_info]=RUN_test(log_obj)
block17_info=zeros(1,2);
block18_info=zeros(1,2);
label_value_ks=find(strcmp(log_obj.log_info(log_obj.label_block(13)+1:log_obj.label_block(14)-1),'ks')==1);
label_value_ks=label_value_ks+log_obj.label_block(13)+4;
if strcmp(log_obj.log_info{1,label_value_ks(1)},'p''s:')==1
     block17_info(1)=str2double(log_obj.log_info{1,label_value_ks(1)+1});
else
     block17_info(1)=1;
end
if strcmp(log_obj.log_info{1,label_value_ks(2)},'p''s:')==1
     block18_info(1)=str2double(log_obj.log_info{1,label_value_ks(2)+1});
else
     block18_info(1)=1;
end
if strcmp(log_obj.log_info{1,label_value_ks(1)},'p''s:')==1
     block17_info(2)=str2double(log_obj.log_info{1,label_value_ks(3)+1});
else
     block17_info(2)=1;
end
if strcmp(log_obj.log_info{1,label_value_ks(4)},'p''s:')==1
     block18_info(2)=str2double(log_obj.log_info{1,label_value_ks(4)+1});
else
     block18_info(2)=1;
end

