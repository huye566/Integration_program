addpath('.\test_tool_nd');
addpath('.\processing_data');
origin_add=uigetdir('C:\Users\li\Desktop\bin_data_01');
label_temp=strfind(origin_add,'\');
if length(label_temp)==1
    return;
end
end_folder=origin_add(label_temp(end)+1:end);
if strncmp(end_folder,'bin_data',8)==1
    disp('ok');
else
    disp('error');
    return;
end
diehard_origin_add=fullfile(origin_add(1:label_temp(end)-1),[end_folder,'diehard']);
diehard_excel_add=fullfile(diehard_origin_add,'diehard_excel');
result_origin_add=fullfile(origin_add(1:label_temp(end)-1),[end_folder,'_resultlog']);
result_excel_add=fullfile(result_origin_add,'result_excel');
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
result_excel=cell(1,length_ico);
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
    result_excel{1,loop_ico}=fullfile(result_excel_add,[end_folder,'_result.xlsx']);
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
 
data_excel=cell(1,length(ico_num));
%parpool(4);
%parfor loop_ico=1:length(ico_num)  
for loop_ico=1:length(ico_num)  
    data_excel_temp=zeros(length(dir_address_ds{1,loop_ico}),10);%除去ok.bin   
    for loop_ds=1:length(dir_address_ds{1,loop_ico})        
        temp_bin_add=get_all_file(dir_address_ds{1,loop_ico}{1,loop_ds},'*.bin');
        for loop_file=1:length(temp_bin_add)
            fid_bin= fopen(temp_bin_add{1,loop_file},'rb');
            data=fread(fid_bin);
            fclose(fid_bin);
            if loop_file==1
                dist_add_txtname=fullfile(dir_address_ds{1,loop_ico}{1,loop_ds},'huye_xor_distribution.txt');
                dist_add_figname1=fullfile(dir_address_ds{1,loop_ico}{1,loop_ds},'huye_xor_dis1.fig');
                dist_add_figname2=fullfile(dir_address_ds{1,loop_ico}{1,loop_ds},'huye_xor_dis2.fig');
                if length(data)<8e6
                    [~,~,~]=distribution_analysis_batch(data,2,dist_add_txtname,dist_add_figname1,dist_add_figname2);
                    [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis_only_acf(data);  
                else
                    [~,~,~]=distribution_analysis_batch(data(1:8e6),2,dist_add_txtname,dist_add_figname1,dist_add_figname2);
                    [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis_only_acf(data(1:8e6));  
                end                
                diehard_binary_improvement(diehard_dir_address_ds{1,loop_ico}{1,loop_ds},data,2,0);
            else
                diehard_binary_improvement(diehard_dir_address_ds{1,loop_ico}{1,loop_ds},data,2,1);
            end
        end
        data_excel_temp(loop_ds,1:end)=[diehard_dir_address_ds{1,loop_ico}{2,loop_ds},ico_num(loop_ico),maxnum,...
                x_maxnum,minnum,x_minnum,0,0,0,max(abs(maxnum),abs(minnum))];      
    end
    data_excel{1,loop_ico}=data_excel_temp;
end
% delete(gcp('nocreate'));
for i=start_position:num_dir
        xlswrite(diehard_excel{1,i},data_excel{1,i});
    %     write_excel(diehard_excel{i},data_excel{1,i});
end


diehard_test_name=cell(1,21);
diehard_test_name{1,1}='data_info';
diehard_test_name{1,21}='sum_pass';
[~,diehard_test_name(2:20),~]=xlsread('.\doc_serial\diehard_test_name.xlsx');
%写入相关信息
%清除老文件
if exist(result_excel,'file')
   delete(result_excel);
end
%for office
xlswrite(result_excel,diehard_test_name,'A1:U1');
log_data_all=cell(1,length(ico_num));
%parpool(4);
%parfor loop_ico=1:length(ico_num)  
for loop_ico=1:length(ico_num)
    temp_log_data=cell(1,length(dir_address_ds{1,loop_ico}));
    for loop_ds=1:length(dir_address_ds{1,loop_ico})         
        copyfile([diehard_dir_address_ds{1,loop_ico}{1,loop_ds},'.bin'],pwd);
        label_temp=strfind(diehard_dir_address_ds{1,loop_ico}{1,loop_ds},'\');
        diehard_name=[diehard_dir_address_ds{1,loop_ico}{1,loop_ds}(label_temp(end)+1:end),'.bin'];
        logfile_name=[diehard_dir_address_ds{1,loop_ico}{1,loop_ds}(label_temp(end)+1:end),'.out'];
        fid_parameter=fopen(fullfile(pwd,'parameter.txt'),'w');
        fprintf(fid_parameter,diehard_name);
        fprintf(fid_parameter,'\r\n');
        fprintf(fid_parameter,logfile_name);
        fprintf(fid_parameter,'\r\n');
        fprintf(fid_parameter,'111111111111111');
        fclose(fid_parameter);
        [~,~]=dos('diequick.bat');
        copyfile(fullfile(pwd,logfile_name),diehard_dir_address_ico{1,loop_ico});
        copyfile(fullfile(pwd,logfile_name),result_dir_address_ico{1,loop_ico});
        delete(fullfile(pwd,diehard_name));
        delete(fullfile(pwd,logfile_name));
        fid_address=fopen(fullfile(diehard_dir_address_ico{1,loop_ico},logfile_name),'r');
        log_info=textscan(fid_address,'%s');
        fclose(fid_address);
        log_info=log_info{1,1}';%行胞元
        label_block=find(strncmp(log_info,'-----',5)==1);        
        if length(label_block)<14
            disp(['>Error-',logfile_name]);
        else
            diehard_result=zeros(1,20);
            [diehard_result(1:19),diehard_result_pass_info,~,~]=get_all_log_value(label_block,log_info);
            diehard_result(end)=str2double(diehard_result_pass_info{1,end});
            diehard_result_head=[num2str(ico_num(loop_ico)),'/',num2str(result_dir_address_ds{1,loop_ico}{2,loop_ds})];
            diehard_data=cell(1,21);
            diehard_data{1,1}=diehard_result_head;
            for i=2:21
                diehard_data{1,i}=diehard_result(i-1);
            end
            temp_log_data{1,loop_ds}=diehard_data;
            %xlswrite(result_excel,diehard_data,'sheet1',['A',num2str(log_info_num+1),':U',num2str(log_info_num+1)]);
            %write_excel_for_diehard(result_excel,diehard_data,['A',num2str(log_info_num+1),':U',num2str(log_info_num+1)]);
        end
    end
    log_data_all{1,loop_ico}=temp_log_data;
end

% delete(gcp('nocreate'));
log_info_num=1;
for i=1:length(log_data_all)
    for j=1:length(log_data_all{1,i})
        log_info_num=log_info_num+1;
        xlswrite(result_excel,log_data_all{1,i}{1,j},'sheet1',['A',num2str(log_info_num),':U',num2str(log_info_num)]);
        %write_excel_for_diehard(result_excel,log_data_all{1,i}{1,j},'sheet1',['A',num2str(log_info_num),':U',num2str(log_info_num)]);
    end
end