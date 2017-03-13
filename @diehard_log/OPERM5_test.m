function block2_info=OPERM5_test(log_obj)
block2_info=zeros(1,2);
label_value_1=find(strncmp(log_obj.log_info(log_obj.label_block(1)+1:log_obj.label_block(2)-1),'p-value=1.000000',12)==1);
label_value=find(strcmp(log_obj.log_info(log_obj.label_block(1)+1:log_obj.label_block(2)-1),'p-value=')==1);
if (length(label_value_1)+length(label_value))~=2
    disp('log_file has some format error in BB_31m31_and_32m32_test!!!!');
else
    switch(length(label_value_1))
        case 0  
            label_value=label_value+log_obj.label_block(1);        
            for i=1:length(label_value)
                block2_info(i)=str2double(log_obj.log_info{1,label_value(i)+1});
            end
        case 1
            label_value=label_value+log_obj.label_block(1);  
            label_value_1=label_value_1+log_obj.label_block(1);  
            if label_value_1<label_value
                block2_info(1)=1;
                block2_info(2)=str2double(log_obj.log_info{1,label_value+1});
            else           
                block2_info(1)=str2double(log_obj.log_info{1,label_value+1});
                block2_info(2)=1;
            end
        case 2
            block2_info(1)=1;
            block2_info(2)=1;
    end
end
        
        
        
        
        