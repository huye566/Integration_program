function Extract_file_get(deviceObj,path_head,label_osc_channel)%no TDC,Precision_choose:1-16,1-8,type_diehard=1计算diehard
% path_head='C:\Users\huye\Desktop';

% loop_label=questdlg('是否继续(OSC)？','操作','Yes','No','Yes');
loop_label='Yes';
if ~strcmp(loop_label,'Yes')
    disp('break');
else
    % pause;
%%----OSC
disp('Get OSC information');
OSC_file_head=fullfile(path_head,'OSC_file');
if ~exist(OSC_file_head,'dir')
    mkdir(OSC_file_head);
end
try
    loop_length=22;
    for loop_osc=1:loop_length
    connect(deviceObj);   
    groupObj = get(deviceObj, 'Waveform');
    groupObj = groupObj(1);
    [data,~]=precision_int16_binary(groupObj,['channel',num2str(label_osc_channel)],true);
    disconnect(deviceObj);
    loop_osc_str=get_the_str(loop_osc);
    OSC_file_name=['OSC_',loop_osc_str,'.dat'];
    OSC_file_address=fullfile(OSC_file_head,OSC_file_name);
    dlmwrite(OSC_file_address,data,'newline','pc');
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
