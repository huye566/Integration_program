function [block7_info,block8_info,block9_info]=OPSO_OQSO_DNA_test(log_obj)
%输出为行向量
label_value_opso=find(strcmp(log_obj.log_info(log_obj.label_block(5)+1:log_obj.label_block(6)-1),'OPSO')==1);
label_value_oqso=find(strcmp(log_obj.log_info(log_obj.label_block(5)+1:log_obj.label_block(6)-1),'OQSO')==1);
label_value_dna=find(strcmp(log_obj.log_info(log_obj.label_block(5)+1:log_obj.label_block(6)-1),'DNA')==1);
block7_info=zeros(1,length(label_value_opso));
block8_info=zeros(1,length(label_value_oqso));
block9_info=zeros(1,length(label_value_dna));
label_value_opso=label_value_opso+log_obj.label_block(5)+10;
label_value_oqso=label_value_oqso+log_obj.label_block(5)+10;
label_value_dna=label_value_dna+log_obj.label_block(5)+10;
for i=1:length(label_value_opso)
    block7_info(i)=str2double(log_obj.log_info{1,label_value_opso(i)});%无p-value
end
for i=1:length(label_value_oqso)
    block8_info(i)=str2double(log_obj.log_info{1,label_value_oqso(i)});%无p-value
end
for i=1:length(label_value_dna)
    block9_info(i)=str2double(log_obj.log_info{1,label_value_dna(i)});%无p-value
end

    