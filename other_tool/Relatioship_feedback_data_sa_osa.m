function Relatioship_feedback_data_sa_osa(deviceObj,SA_obj,OSA_obj,path_head,filespec_excel_OSC,Precision_choose,label_osc_channel,type_diehard,loop_save)%no TDC,Precision_choose:1-16,1-8,type_diehard=1计算diehard
% path_head='C:\Users\huye\Desktop';
% time=datestr(now,29);
% 循环1:100,每次提示是否执行
% 1.通过OSA获取反馈光功率 feedback_power=**+3dBm+6dBm
% 2.set span, 1.6nm,2.4nm get the OSA data
% 3.set frequency:0~40Ghz, 5Ghz~5.05Ghz, get the SA data
% 4.get the data from OSC 8M*22
%%----OSA
% loop_label=questdlg('是否继续(OSA)？','操作','Yes','No','Yes');
% if ~strcmp(loop_label,'Yes')
%     disp('break');
%     return;
% end
% pause;
disp('Get OSA information');
OSA_file_head=fullfile(path_head,'OSA_file');
if ~exist(OSA_file_head,'dir')
    mkdir(OSA_file_head);
end
try
    for loop_osa=1:2
    fopen(OSA_obj);
    if loop_osa==1
        OSA_bandwidth=2;
    else
        OSA_bandwidth=2.4; 
    end
    fprintf(OSA_obj, ['SPSPANWL',num2str(OSA_bandwidth)]); %波长
    disp(fscanf(OSA_obj));%用于清空缓存SP_SPAN_1.60000391965582nm
    OSA_span_s = query(OSA_obj,'SPSPANWL?');
    OSA_span_value = round(str2double(OSA_span_s(9:end-3)),3);
    fprintf(OSA_obj, 'SPSWP1');
    fscanf(OSA_obj);%用于清空缓存SP_SINGLE_SWEEP
    if OSA_span_value~=round(OSA_bandwidth,3)
        NET.addAssembly('System.Windows.Forms');
           import System.Windows.Forms.*;
       MessageBox.Show('Fails to set the sweep span','Error',...
       MessageBoxButtons.OK,MessageBoxIcon.Error);  
       disp('Fails to set the center wavelength');
       fclose(OSA_obj);
       return;
    end
    DC_Power_s=query(OSA_obj,'SPMEASDETECTORDBM100');%100次统计均值
    DC_Power=round(str2double(DC_Power_s(17:end-1)),3);
    OSA_center_s = query(OSA_obj,'SPCTRWL?');
    OSA_center_value = round(str2double(OSA_center_s(8:end-3)),4);
    %%---file name
    OSA_file_name=['OSA_',num2str(loop_osa),'(',num2str(DC_Power),')_'...
        ,num2str(OSA_center_value),'_',num2str(OSA_span_value)];%OSA+loop+center_frequency+span+DC_power+3dB
    OSA_title_name=['OSA\_',num2str(loop_osa),'(',num2str(DC_Power),')\_'...
        ,num2str(OSA_center_value),'\_',num2str(OSA_span_value)];
    %%--save OSA file and fig
    OSA_spectrum_save(OSA_obj,OSA_file_head,OSA_file_name,OSA_title_name,3);%1-file,2-fig,3-all
%     OSA_spectrum_save_no3db(OSA_obj,file_head,OSA_file_name,OSA_title_name,3);
    fclose(OSA_obj);
    end
catch
    disp('OSA cant be connected!!');
    fclose(OSA_obj);
end
% loop_label=questdlg('是否继续(SA)？','操作','Yes','No','Yes');
loop_label='No';
if ~strcmp(loop_label,'Yes')
    disp('break');
else
    % pause;
%%----SA
disp('Get SA information');
SA_file_head=fullfile(path_head,'SA_file');
if ~exist(SA_file_head,'dir')
    mkdir(SA_file_head);
end
try   
    % fprintf(SA_obj,'RB3000000');%3M**,1M,300k,100k,30k,10k,3k,1k,300,100,30,越小扫的越慢，越大，噪声越小
    % fprintf(SA_obj,'VB30000');%3M,1M,300k,100k,30k**,10k,3k,1k,300,100,30,10越小扫的越慢,越大越不精细
    for loop_sa=1:2
        fopen(SA_obj);
        if loop_sa==1
            fprintf(SA_obj,'RB3000000');%3M**,1M,300k,100k,30k,10k,3k,1k,300,100,30,越小扫的越慢，越大，噪声越小
            fprintf(SA_obj,'VB3000');%3M,1M,300k,100k,30k**,10k,3k,1k,300,100,30,10越小扫的越慢,越大越不精细
            fprintf(SA_obj,'FA0');
            fprintf(SA_obj,'FB35000000000');     
            pause(10);
        else
            fprintf(SA_obj,'FA10000000000');
            fprintf(SA_obj,'FB10100000000');
            fprintf(SA_obj,'RB100000');%3M**,1M,300k,100k,30k,10k,3k,1k,300,100,30,越小扫的越慢，越大，噪声越小
            fprintf(SA_obj,'VB300');%3M,1M,300k,100k,30k**,10k,3k,1k,300,100,30,10越小扫的越慢,越大越不精细       
            pause(8);
        end
        SA_file_name=['SA_file_',num2str(loop_sa),'(',num2str(DC_Power),')'];
        SA_title_name=['SA_file\_',num2str(loop_sa),'(',num2str(DC_Power),')'];
        %%--save SA file and fig
        fprintf(SA_obj,'SI');%single
        pause(0.2);
        SA_spectrum_save(SA_obj,SA_file_head,SA_file_name,SA_title_name,3);%1-file,2-fig,3-all
        fprintf(SA_obj,'SN');%normal,表示repeat
        % pause(0.5);
        % end
        fclose(SA_obj);
    end
catch
    disp('SA cant be connected!!');
    fclose(SA_obj);
end
end

% loop_label=questdlg('是否继续(OSC)？','操作','Yes','No','Yes');
loop_label='Yes';
if ~strcmp(loop_label,'Yes')
    disp('break');
else
    if loop_save==1
        [~,~,figure_head_osc]=xlsread('.\doc_serial\figure_status_head_auto.xlsx');
%         %清除老文件
%         if exist(filespec_excel_OSC(1),'file')
%             delete(filespec_excel_OSC(1));
%         end
%%不清除，有利于再次运行，部分数据修改
        xlswrite(filespec_excel_OSC(1),'Data_info','sheet1','A1:A1');
        xlswrite(filespec_excel_OSC(1),figure_head_osc(4:end),'sheet1','B1:K1');
        diehard_test_name=cell(1,21);
        diehard_test_name{1,1}='data_info';
        diehard_test_name{1,21}='sum_pass';
        [~,diehard_test_name(2:20),~]=xlsread('.\doc_serial\diehard_test_name.xlsx');
        xlswrite(filespec_excel_OSC(2),diehard_test_name,'A1:U1');
    end
    % pause;
%%----OSC
disp('Get OSC information');
OSC_file_head=fullfile(path_head,'OSC_file');
if ~exist(OSC_file_head,'dir')
    mkdir(OSC_file_head);
end
try
    OSC_file_name_bin='OSC_000.bin';
    excel_file_name_osc_diehard='OSC(diehard)_000.xlsx';
    excel_file_name_osc_analy='OSC(analy)_000.xlsx';
    OSC_file_address_bin=fullfile(OSC_file_head,'OSC_000');
    excel_file_address_osc_diehard=fullfile(OSC_file_head,excel_file_name_osc_diehard);
    excel_file_address_osc_analy=fullfile(OSC_file_head,excel_file_name_osc_analy);
    loop_length=11;
    for loop_osc=1:loop_length
    connect(deviceObj);   
    groupObj = get(deviceObj, 'Waveform');
    groupObj = groupObj(1);
    if Precision_choose==1  
        [data1,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
%         pause(0.1);
        [data2,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
    else
        [data1,~,~,~,~] = invoke(groupObj, 'readwaveform', ['channel',num2str(label_osc_channel)]);
%         pause(0.1);
        [data2,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
    end
    disconnect(deviceObj);
    loop_osc_str1=get_the_str((loop_osc-1)*2+1);
    loop_osc_str2=get_the_str(loop_osc*2);
    OSC_file_name1=['OSC_',loop_osc_str1,'.dat'];
    OSC_file_address1=fullfile(OSC_file_head,OSC_file_name1);
    OSC_file_name2=['OSC_',loop_osc_str2,'.dat'];
    OSC_file_address2=fullfile(OSC_file_head,OSC_file_name2);
    if type_diehard==1
        if loop_osc==1
            dlmwrite(OSC_file_address1,data1,'newline','pc','precision',6);
            dlmwrite(OSC_file_address2,data2,'newline','pc','precision',6);
            [~,~,median_num,mean_num,~]=data_statistic3_only_result(data1);
            [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis_only_acf(data1);
            temp_average_sym=abs(mean_num-median_num)/loop_length;
            temp_average_acf=max(abs(maxnum),abs(minnum))/loop_length;
            data_excel={DC_Power,roundn(maxnum,-5),x_maxnum,roundn(minnum,-5),x_minnum,roundn(median_num,-5),...
                        roundn(mean_num,-5),roundn(abs(median_num-mean_num),-5),roundn(max(abs(maxnum),abs(minnum)),-5),0,0};  
            generation_test_file(OSC_file_address_bin,data1,data2,'mean',2,0,1);%覆盖，处理，bin 
        else
            [~,~,median_num,mean_num,~]=data_statistic3_only_result(data1);
            [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data1);
            temp_average_sym=abs(mean_num-median_num)/loop_length+temp_average_sym;
            temp_average_acf=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf;
            generation_test_file(OSC_file_address_bin,data1,data2,'mean',2,1,1);%appand，处理，bin
        end
    else
        dlmwrite(OSC_file_address1,data1,'newline','pc','precision',6);
        dlmwrite(OSC_file_address2,data2,'newline','pc','precision',6);
    end
    end
    if type_diehard==1
        data_excel(end-1:end)={roundn(temp_average_sym,-5),roundn(temp_average_acf,-5)};
        [~,~,figure_head_osc]=xlsread('.\doc_serial\figure_status_head_auto.xlsx');
        %         %清除老文件
        %         if exist(filespec_excel_OSC(1),'file')
        %             delete(filespec_excel_OSC(1));
        %         end
        %%不清除，有利于再次运行，部分数据修改
        xlswrite(excel_file_address_osc_analy,figure_head_osc(4:end),'sheet1','B1:K1');
        xlswrite(excel_file_address_osc_analy,'Data_info','sheet1','A1:A1');
        xlswrite(excel_file_address_osc_analy,data_excel,'sheet1','A2:K2'); 
        xlswrite(filespec_excel_OSC(1),data_excel,'sheet1',['A',num2str(loop_save+1),':K',num2str(loop_save+1)]); 
        [~,diehard_result]=analysis_RNG_diehard(OSC_file_head,OSC_file_name_bin,excel_file_address_osc_diehard,1,DC_Power);
        xlswrite(filespec_excel_OSC(2),DC_Power,'sheet1',['A',num2str(loop_save+1),':A',num2str(loop_save+1)]);
        xlswrite(filespec_excel_OSC(2),diehard_result,'sheet1',['B',num2str(loop_save+1),':U',num2str(loop_save+1)]);
    end
catch
    disp('OSC cant be connected!!');
    disconnect(deviceObj);
end
end


function output_data=get_the_str(input_data)
    if input_data<10
        output_data=['00',num2str(input_data)];
    else
        if input_data<100
            output_data=['0',num2str(input_data)];
        else
            output_data=num2str(input_data);
        end    
    end
