function Relatioship_feedback_osa_power_tdc(OSA_obj,path_head,serial_obj,excel_file_name,num_order)%no TDC,Precision_choose:1-16,1-8
% path_head='C:\Users\huye\Desktop';
% time=datestr(now,29);
% 循环1:100,每次提示是否执行
% 1.通过OSA获取反馈光功率 feedback_power=**+3dBm+6dBm
% 2.set span, 1.6nm,2.4nm get the OSA data
% 3.set frequency:0~40Ghz, 5Ghz~5.05Ghz, get the SA data
% 4.get the data from OSC 8M*22
%%----TDC
[~,~,tdc_information]=tdc_command(serial_obj,'ds');
position_1=strfind(tdc_information{2},':')+2;
position_2=strfind(tdc_information{2},'ps')-2;
ds_value_str=tdc_information{2}(position_1:position_2);
ds_temp=floor(str2double(ds_value_str))+2100;
ds_temp=get_the_str(ds_temp);
position_1=strfind(tdc_information{3},':')+2;
position_2=strfind(tdc_information{3},'GHz')-2;
ico_value_str=tdc_information{3}(position_1:position_2);  
ico_temp=floor(str2double(ico_value_str))+99;
ico_temp=get_the_str(ico_temp);
%%----OSA
disp('Get OSA information');
OSA_file_head=fullfile(path_head,'OSA_file');
if ~exist(OSA_file_head,'dir')
    mkdir(OSA_file_head);
end
excel_file_address=fullfile(path_head,excel_file_name);
try
    fopen(OSA_obj);
    fprintf(OSA_obj, 'SPSWP1');
    fscanf(OSA_obj);%用于清空缓存SP_SINGLE_SWEEP
    OSA_span_s = query(OSA_obj,'SPSPANWL?');
    OSA_span_value = round(str2double(OSA_span_s(9:end-3)),3);
    DC_Power_s=query(OSA_obj,'SPMEASDETECTORDBM100');%100次统计均值
    DC_Power=round(str2double(DC_Power_s(17:end-1)),3);
    OSA_center_s = query(OSA_obj,'SPCTRWL?');
    OSA_center_value = round(str2double(OSA_center_s(8:end-3)),4);
    %%---file name
    OSA_file_name=['OSA_DS_',ds_temp,'_ICO_',ico_temp,'(',num2str(DC_Power),')_'...
        ,num2str(OSA_center_value),'_',num2str(OSA_span_value)];%OSA+loop+center_frequency+span+DC_power+3dB
    OSA_title_name=['OSA\_DS\_',ds_temp,'\_ICO\_',ico_temp,'(',num2str(DC_Power),')\_'...
        ,num2str(OSA_center_value),'\_',num2str(OSA_span_value)];
    %%--save OSA file and fig
    bandwidth_3dB=OSA_spectrum_save(OSA_obj,OSA_file_head,OSA_file_name,OSA_title_name,3);%1-file,2-fig,3-all
%     OSA_spectrum_save_no3db(OSA_obj,file_head,OSA_file_name,OSA_title_name,3);
    fclose(OSA_obj);
    if num_order==1
        excel_head_flag={'DS','ICO','Power','Span','CenterWavelength','Bandwidth_3dB'};
        if exist(excel_file_address,'file')
            delete(excel_file_address);
        end
        %for office
        xlswrite(excel_file_address,excel_head_flag,'A1:F1');
    end
    excel_info=[str2double(ds_value_str),str2double(ico_value_str),DC_Power,OSA_span_value,OSA_center_value,bandwidth_3dB];
    xlswrite(excel_file_address,excel_info,'sheet1',['A',num2str(num_order+1),':F',num2str(num_order+1)]);
catch
    disp('OSA cant be connected!!');
    fclose(OSA_obj);
end

function output_data=get_the_str(input_data)
    if input_data<10
        output_data=['000',num2str(input_data)];
    else
        if input_data<100
            output_data=['00',num2str(input_data)];
        else
            if input_data<1000
                output_data=['0',num2str(input_data)];
            else
                 output_data=num2str(input_data);
            end
        end    
    end
