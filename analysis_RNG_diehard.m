function [res_num,diehard_result]=analysis_RNG_diehard(diehard_add_head,diehard_name_old,excel_file_address,label_diehard_excel_num,num_order)
res_num=0;
diehard_add=fullfile(diehard_add_head,diehard_name_old);                
copyfile(diehard_add,pwd);
label_bin=strfind(diehard_name_old,'bin');
filenames_out_old=[diehard_name_old(1:label_bin-1),'out'];
diehard_name='diehard.bin';
filenames_out='diehard.out';
eval(['!rename' 32 diehard_name_old 32 diehard_name]);
fid_parameter=fopen(fullfile(pwd,'parameter.txt'),'w');
fprintf(fid_parameter,diehard_name);
fprintf(fid_parameter,'\r\n');
fprintf(fid_parameter,filenames_out);
fprintf(fid_parameter,'\r\n');
fprintf(fid_parameter,'111111111111111');
fclose(fid_parameter);
[~,~]=dos('diequick.bat');
eval(['!rename' 32 filenames_out 32 filenames_out_old]);
copyfile(fullfile(pwd,filenames_out_old),diehard_add_head);
delete(fullfile(pwd,diehard_name));
delete(fullfile(pwd,filenames_out_old));
fid_address=fopen(fullfile(diehard_add_head,filenames_out_old),'r');
log_info=textscan(fid_address,'%s');
fclose(fid_address);
log_info=log_info{1,1}';%行胞元
label_block=find(strncmp(log_info,'-----',5)==1);        
if length(label_block)<14
    disp(['>Error-',filenames_out_old]);
else
    diehard_result=zeros(1,20);
    [diehard_result(1:19),diehard_result_pass_info,~,~]=get_all_log_value(label_block,log_info);
    diehard_result(end)=str2double(diehard_result_pass_info{1,end});
    diehard_result_head=num_order;
    res_num=str2double(diehard_result_pass_info{1,end});
    if label_diehard_excel_num==1
        diehard_test_name=cell(1,21);
        diehard_test_name{1,1}='data_info';
        diehard_test_name{1,21}='sum_pass';
        [~,diehard_test_name(2:20),~]=xlsread('.\doc_serial\diehard_test_name.xlsx');
        %写入相关信息
        %清除老文件
        if exist(excel_file_address,'file')
            delete(excel_file_address);
        end
        %for office
        xlswrite(excel_file_address,diehard_test_name,'A1:U1');
    end
    xlswrite(excel_file_address,diehard_result_head,'sheet1',['A',num2str(label_diehard_excel_num+1),':A',num2str(label_diehard_excel_num+1)]);
    xlswrite(excel_file_address,diehard_result,'sheet1',['B',num2str(label_diehard_excel_num+1),':U',num2str(label_diehard_excel_num+1)]);
%     write_excel_for_diehard(handles.rng_single_diehard_excel,diehard_result_head,['A',num2str(label_diehard_excel_num+1),':A',num2str(label_diehard_excel_num+1)]);
%     write_excel_for_diehard(handles.rng_single_diehard_excel,diehard_result,['B',num2str(label_diehard_excel_num+1),':U',num2str(label_diehard_excel_num+1)]);
end