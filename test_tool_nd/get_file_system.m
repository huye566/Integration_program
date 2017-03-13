function [ico_num,dir_address_ds,diehard_dir_address_ico,result_dir_address_ico,...
    diehard_dir_address_ds,result_dir_address_ds,diehard_excel,result_excel,...
    diehard_excel_add,result_excel_add]=get_file_system(origin_add)
label_temp=strfind(origin_add,'\');
end_folder=origin_add(label_temp(end)+1:end);
diehard_origin_add=fullfile(origin_add(1:label_temp(end)-1),[end_folder,'diehard']);
diehard_excel_add=fullfile(diehard_origin_add,'diehard_excel');
result_origin_add=fullfile(origin_add(1:label_temp(end)-1),[end_folder,'_resultlog']);
result_excel_add=fullfile(result_origin_add,'result_excel');
result_excel=fullfile(result_excel_add,'log_result.xlsx');
if ~exist(diehard_excel_add,'dir')
    mkdir(diehard_excel_add);
end
if ~exist(result_excel_add,'dir')
    mkdir(result_excel_add);
end
dir_address_ico=get_all_dir(origin_add);
length_ico=length(dir_address_ico);
diehard_dir_address_ico=cell(1,length_ico);
result_dir_address_ico=cell(1,length_ico);
ico_num=zeros(1,length_ico);
dir_address_ds=cell(1,length_ico);
diehard_dir_address_ds=cell(1,length_ico);
result_dir_address_ds=cell(1,length_ico);
diehard_excel=cell(1,length_ico);
for loop_ico=1:length_ico
    label_temp=strfind(dir_address_ico{1,loop_ico},'ICO-');
    ico_num(loop_ico)=str2double(dir_address_ico{1,loop_ico}(label_temp+4:end));
    label_temp=strfind(dir_address_ico{1,loop_ico},'\');
    end_folder=dir_address_ico{1,loop_ico}(label_temp(end)+1:end);
    diehard_dir_address_ico{1,loop_ico}=fullfile(diehard_origin_add,end_folder);
    result_dir_address_ico{1,loop_ico}=fullfile(result_origin_add,end_folder);
    dir_address_ds{1,loop_ico}=get_all_dir(dir_address_ico{1,loop_ico});
    length_ds=length(dir_address_ds{1,loop_ico});
    diehard_dir_address_ds{1,loop_ico}=cell(2,length_ds);
    result_dir_address_ds{1,loop_ico}=cell(2,length_ds);
    diehard_excel{1,loop_ico}=fullfile(diehard_excel_add,[end_folder,'_diehard.xlsx']);  
    for loop_ds=1:length_ds
        label_temp=strfind(dir_address_ds{1,loop_ico}{1,loop_ds},'DS-');
        diehard_dir_address_ds{1,loop_ico}{2,loop_ds}=str2double(dir_address_ds{1,loop_ico}{1,loop_ds}(label_temp+3:end));
        result_dir_address_ds{1,loop_ico}{2,loop_ds}=str2double(dir_address_ds{1,loop_ico}{1,loop_ds}(label_temp+3:end));
        label_temp=strfind(dir_address_ds{1,loop_ico}{1,loop_ds},'\');
        end_folder=dir_address_ds{1,loop_ico}{1,loop_ds}(label_temp(end)+1:end);
        diehard_dir_address_ds{1,loop_ico}{1,loop_ds}=fullfile(diehard_dir_address_ico{1,loop_ico},end_folder);
        result_dir_address_ds{1,loop_ico}{1,loop_ds}=fullfile(result_dir_address_ico{1,loop_ico},end_folder);
    end
    %创建文件夹
    if ~exist(diehard_dir_address_ico{1,loop_ico},'dir')
        mkdir(diehard_dir_address_ico{1,loop_ico});
    end
    if ~exist(result_dir_address_ico{1,loop_ico},'dir')
        mkdir(result_dir_address_ico{1,loop_ico});
    end
end
   


