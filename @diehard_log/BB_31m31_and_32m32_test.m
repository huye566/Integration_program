function [block3_info,block4_info]=BB_31m31_and_32m32_test(log_obj)
label_value_1=find(strncmp(log_obj.log_info(log_obj.label_block(2)+1:log_obj.label_block(3)-1),'p-value=1.000000',12)==1);
label_value=find(strcmp(log_obj.log_info(log_obj.label_block(2)+1:log_obj.label_block(3)-1),'p-value=')==1);
if (length(label_value_1)+length(label_value))~=2
    disp('log_file has some format error in BB_31m31_and_32m32_test!!!!');
else
    switch(length(label_value_1))
        case 0        
            label_value=label_value+log_obj.label_block(2);
            block3_info=str2double(log_obj.log_info{1,label_value(1)+1});
            block4_info=str2double(log_obj.log_info{1,label_value(2)+1});
        case 1
            label_value=label_value+log_obj.label_block(2);
            label_value_1=label_value_1+log_obj.label_block(2);
            if label_value_1<label_value
                block3_info=1;
                block4_info=str2double(log_obj.log_info{1,label_value+1});
            else
                block3_info=str2double(log_obj.log_info{1,label_value+1});
                block4_info=1;
            end
        case 2
            block3_info=1;
            block4_info=1;
    end
end
            