function varargout = My_RNG_auto(varargin)
% MY_RNG_AUTO MATLAB code for My_RNG_auto.fig
%      MY_RNG_AUTO, by itself, creates a new MY_RNG_AUTO or raises the existing
%      singleton*.
%
%      H = MY_RNG_AUTO returns the handle to a new MY_RNG_AUTO or the handle to
%      the existing singleton*.
%
%      MY_RNG_AUTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MY_RNG_AUTO.M with the given input arguments.
%
%      MY_RNG_AUTO('Property','Value',...) creates a new MY_RNG_AUTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before My_RNG_auto_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to My_RNG_auto_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help My_RNG_auto

% Last Modified by GUIDE v2.5 04-Jan-2017 17:16:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @My_RNG_auto_OpeningFcn, ...
                   'gui_OutputFcn',  @My_RNG_auto_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before My_RNG_auto is made visible.
function My_RNG_auto_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to My_RNG_auto (see VARARGIN)

% Choose default command line output for My_RNG_auto
handles.output = hObject;
 
% Update handles structure
guidata(hObject, handles);

%base-noise----
global base_noise
base_noise=[];
% base_noise=dlmread('.\sample_data\10mv_div\bpd_no_signal_base_noise.dat');
%bpd_no_signal_base_noise.dat
%no_pd_base_noise.dat
%pd_no_signal_base_noise.dat

addpath(genpath('.\test_tool_nd'));
addpath(genpath('.\control'));
addpath(genpath('.\writing_file'));
addpath(genpath('.\email_send'));
addpath('C:\MATLAB\R2016b\toolbox\instrument\instrument\drivers');
addpath(genpath('.\processing_data'));

global initial_am
initial_am=0.05;

fid=fopen('.\doc_serial\error_message_auto.txt','w');
fclose(fid);

global serial_obj
global label_open%用于判断com口是否打开
label_open=0;
serial_obj='nocom';

%%----initial SA
global SA_obj
% %%----方式1
%%find SA COM
% getcom=instrhwinfo('serial');%获取可用串口
% com_available=getcom.AvailableSerialPorts;
% sa_com='';
% if isempty(com_available)
%     NET.addAssembly('System.Windows.Forms');
%     import System.Windows.Forms.*;
%     MessageBox.Show('No available COM port!','Information',...
%         MessageBoxButtons.OK,MessageBoxIcon.Information);
%     return;
% else   
%     com_available_length=length(com_available);
%     for i=1:com_available_length
%         % Find a serial port object.
% %         obj_sa = instrfind('Type', 'serial', 'Port', com_available{1,i}, 'Tag', '');
%         SA_obj=serial(com_available{i,1});
%         SA_obj.Timeout=2;%加快验证
%         % Create the serial port object if it does not exist
%         % otherwise use the object that was found.
%         SA_obj=SA_obj(1);
%         fopen(SA_obj);
%         try
%             identity_info = query(SA_obj, '*IDN?');
%         catch
%             identity_info='no data';
%         end
%         fclose(SA_obj);
%         if strncmp(identity_info,'ADVANTEST,R3182,110401382,E00',25)
%            sa_com=com_available{i,1};
%            fclose(SA_obj);
%            break;
%         end      
%     end
% end
%%----方式2
sa_com='COM6';
SA_obj=serial(sa_com);
SA_obj.Timeout=2;%加快验证
SA_obj=SA_obj(1);
fopen(SA_obj);
try
   identity_info = query(SA_obj, '*IDN?');
catch
   identity_info='no data';
end
fclose(SA_obj);
if ~strncmp(identity_info,'ADVANTEST,R3182,110401382,E00',25)
    disp('SA error com!!');
    sa_com='';
end
%%----------------------------------------
if isempty(sa_com)
    disp('NO suitable Instrument!!');
else
    SA_obj.BaudRate=9600;
    SA_obj.Terminator='CR';
    SA_obj.Parity='none';
    SA_obj.DataBits=8;
    SA_obj.StopBits=1;
    SA_obj.InputBufferSize=1000000;
    SA_obj.OutputBufferSize=1000000;
    SA_obj.Timeout=2; 
end

%---osc_connect
global interfaceObj
global deviceObj
global label_osc_connect
interfaceObj='';
deviceObj='';
label_osc_connect=0;

global label_osc_channel
label_osc_channel=3;

global label_stop
label_stop=0;

global judgment_threshold
judgment_threshold='mean';

global table_info
[~,~,table_info]=xlsread('.\doc_serial\table_message.xlsx');
table_info{2,6}=num2str(table_info{2,6});
table_info{2,5}=num2str(table_info{2,5});

global label_generate_bin
label_generate_bin=0;

global label_nist
label_nist=0;


time=datestr(now,15);
time=strrep(time,':','-');
time_folder=[datestr(now,29),' ',time];
set(handles.folder_edit,'String',time_folder);

%---clear tdc_information.text
fid=fopen('.\doc_serial\tdc_information_auto.txt','w');
fprintf(fid,'Welcome!--made by huye:)!!');
fprintf(fid,'\r\n');
fclose(fid);
status_slider_Callback(hObject, eventdata, handles);

set(handles.am_settled_radiobutton,'Value',1);
set(handles.self_adaption_radiobutton,'Value',0);


% UIWAIT makes My_RNG_auto wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = My_RNG_auto_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function make_folder(hObject, eventdata, handles)
path_head=get(handles.path_select_edit,'String');
time_folder=get(handles.folder_edit,'String');
handles.diehard_folder=[path_head,'\diehard_file\',time_folder];
handles.nist_folder=[path_head,'\nist_file\',time_folder];
% handles.diehard_word=[handles.tool_single_folder,'\tool_huye_single.docx'];
% handles.diehard_excel=[handles.tool_single_folder,'\tool_huye_single.xlsx'];
if ~exist(handles.diehard_folder,'dir') 
    mkdir(handles.diehard_folder);        % 若不存在，在当前目录中产生一个子目录‘Figure’
end
if ~exist(handles.nist_folder,'dir') 
    mkdir(handles.nist_folder);        % 若不存在，在当前目录中产生一个子目录‘Figure’
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in generate_bin_button.
function generate_bin_button_Callback(hObject, eventdata, handles)
% hObject    handle to generate_bin_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global serial_obj
global label_open%用于判断com口是否打开
global table_info
global judgment_threshold
global deviceObj
global label_osc_connect
global label_stop
global initial_am
global label_osc_channel
label_stop=0;
global label_generate_bin
global SA_obj%---------------------------------------------------------
global base_noise
time_base=str2double(get(handles.osc_set_timebase_edit,'String'))*1e-6;
fs=str2double(get(handles.osc_set_fs_edit,'String'))*1e9;
table_info{2,3}=[num2str(fs/1e9),'Gss'];%information of ds  
data_length=fs*10*time_base;
table_info{2,4}=[num2str(data_length/1e6),'M'];
loop_length=floor(8e7/data_length)+1;
if loop_length<3
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show(['Fs:',table_info{2,3},'and Timebase:',get(handles.osc_set_timebase_edit,'String'),'us is not suitable!!'],'Information',...
         MessageBoxButtons.OK,MessageBoxIcon.Information);
    return;
end
ico_start=floor(str2double(get(handles.ico_start_edit,'String')));
ico_step=floor(str2double(get(handles.ico_step_edit,'String')));
ico_stop=floor(str2double(get(handles.ico_stop_edit,'String')));
ds_start=floor(str2double(get(handles.ds_start_edit,'String')));
ds_step=floor(str2double(get(handles.ds_step_edit,'String')));
ds_stop=floor(str2double(get(handles.ds_stop_edit,'String')));
am_settled=get(handles.osc_set_am_edit,'String');
label_record=get(handles.record_checkbox,'Value');
label_wavedata_saved=get(handles.save_wavedata_checkbox,'Value');
label_am_type=get(handles.am_settled_radiobutton,'Value');
label_average=get(handles.control_average_checkbox,'Value');

makesure_info=cell(1,6);
makesure_info{1,1}='是否按以下要求执行(diehard_bin)？';
makesure_info{1,2}=['>ICO: ',num2str(ico_start),':',num2str(ico_step),':',num2str(ico_stop)];
makesure_info{1,3}=['>DS : ',num2str(ds_start),':',num2str(ds_step),':',num2str(ds_stop)];
if label_am_type==1
    makesure_info{1,4}=['>AM : ',num2str(am_settled),'mV'];
else
    makesure_info{1,4}='>AM : self-adaption!!';
end
if label_wavedata_saved==1
    makesure_info{1,5}='>wavedata_saved : ON';
else
    makesure_info{1,5}='>wavedata_saved : OFF';
end
if label_average==1
    makesure_info{1,6}='>Sym&ACF(average) : ON';
else
    makesure_info{1,6}='>Sym&ACF(average) : OFF';
end
makesure = questdlg(makesure_info,'info','OK','Cancel','OK') ;
temp_path=get(handles.path_select_edit,'String');
temp_disk_position=strfind(temp_path,'\');
temp_disk=temp_path(1:temp_disk_position);
diskspace_s=java.io.File(temp_disk);
freespace_s=floor(diskspace_s.getFreeSpace/(1024*1024*1024));
if label_wavedata_saved==1
    needspace=3*length(ico_start:ico_step:ico_stop)*length(ds_start:ds_step:ds_stop);
else
    needspace=0.26*length(ico_start:ico_step:ico_stop)*length(ds_start:ds_step:ds_stop);
end
if freespace_s<needspace+10
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show(['Freespace(',num2str(freespace_s),'GB) 小于','needspace(',num2str(needspace+10),'GB)'],'Information',...
         MessageBoxButtons.OK,MessageBoxIcon.Information);
    return;
else
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show(['Freespace(',num2str(freespace_s),'GB) 大于','needspace(',num2str(needspace+10),'GB)'],'Information',...
         MessageBoxButtons.OK,MessageBoxIcon.Information);
end
if strcmp(makesure,'OK')
label_connect=tdc_connect_test(hObject, eventdata, handles,label_open,serial_obj);
osc_connect_test(hObject, eventdata, handles);
if label_connect==1&&label_osc_connect==1
    t2=clock;
    %---close nist
    label_generate_bin=label_generate_bin+1;
    str_label_generate_bin=get_ordered_str_2(hObject, eventdata, handles,label_generate_bin);
    set(handles.times_text,'String',['Times:',num2str(label_generate_bin)]);
    make_folder(hObject, eventdata, handles);
    handles=guidata(hObject);%-----------------------------------------------------------------------------
    set(handles.nist_button,'Enable','off');     
    %---bin-address
    if label_record==1
        word_address=fullfile(handles.diehard_folder,['word_file_',str_label_generate_bin]);
        excel_address=fullfile(handles.diehard_folder,['excel_file_',str_label_generate_bin]);
        if ~exist(word_address,'dir') 
            mkdir(word_address);        % 若不存在，在当前目录中产生一个子目录‘Figure’
        end 
        if ~exist(excel_address,'dir') 
            mkdir(excel_address);        % 若不存在，在当前目录中产生一个子目录‘Figure’
        end 
    end
    [~,~,figure_head]=xlsread('.\doc_serial\figure_status_head_auto.xlsx');
    for loop_ico=ico_start:ico_step:ico_stop
        set(handles.ico_start_edit,'String',num2str(loop_ico));
         t1=clock;
         collapse=-1;%重新定位初始文档
         tabel_num=1;%必须初始化表格长度
         table_info{2,6}=num2str(loop_ico);%information of ICO
        %---bin_address
        file_name_num=(loop_ico-ico_start)/ico_step+1;
        file_name_num=get_ordered_str_3(hObject, eventdata, handles,file_name_num);
        dir_name=['Experiment_data-',file_name_num,'-ICO-',num2str(loop_ico)];
        bindata_address=fullfile(fullfile(handles.diehard_folder,['bin_data_',str_label_generate_bin]),dir_name);
        if ~exist(bindata_address,'dir') 
            mkdir(bindata_address);        % 若不存在，在当前目录中产生一个子目录‘Figure’
        end
        if label_wavedata_saved==1
        %---wave_address
            wavedata_address=fullfile(fullfile(handles.diehard_folder,['wave_data_',str_label_generate_bin]),dir_name);
            if ~exist(wavedata_address,'dir') 
                mkdir(wavedata_address);        % 若不存在，在当前目录中产生一个子目录‘Figure’
            end
        end
        if label_record==1
            filespec_doc=fullfile(word_address,[dir_name,'.docx']);
            filespec_excel=fullfile(excel_address,[dir_name,'.xlsx']);
            %清空xls 
            if exist(filespec_excel,'file')
                delete(filespec_excel);
            end          
            % write_excel_single(filespec_excel,figure_head,'A1:M1');%wps必须
            xlswrite(filespec_excel,figure_head,'sheet1','A1:M1');%最后两个是sym(average),acf(average);
        end
        label_connect=tdc_connect_test(hObject, eventdata, handles,label_open,serial_obj);
        if label_connect==0
            serial_obj='nocom';
            label_open=0;
            disp('TDC isnt connected!');
            message=cell(1,1);
            message{1,1}='>TDC isnt connected!';
            write_tdc_information(hObject, eventdata, handles,message);
            status_slider_Callback(hObject, eventdata, handles);
            error_date=datestr(now,31);
            subject=['实验结果',error_date,'-breaking!'];
            content='TDC isnt connected!';
            if get(handles.email_checkbox,'Value')==1
                try
                   qq=get(handles.qq_edit,'String');
                   MySendMail_simple(qq,subject,content);
                   disp('Email is sent OK!!');
                   message=cell(1,1);
                   message{1,1}='>Email is sent OK!!';
                   write_tdc_information(hObject, eventdata, handles,message);
                   status_slider_Callback(hObject, eventdata, handles);
                catch
                   disp('Network isnt connected(Email)!');
                   message=cell(1,1);
                   message{1,1}='>Network isnt connected(Email)!';
                   write_tdc_information(hObject, eventdata, handles,message);
                   status_slider_Callback(hObject, eventdata, handles);
                 end
            end
            fid=fopen('.\doc_serial\error_message_auto.txt','a');
            fprintf(fid,error_date);
            fprintf(fid,'\r\n');
            fprintf(fid,'Error: TDC isnt connected!');
            fprintf(fid,'\r\n');
            fclose(fid);
            return;
        else
        ico_command=['ds ico ',num2str(loop_ico)];
        tdc_information_ico=tdc_state_test(hObject, eventdata, handles,ico_command,serial_obj);
        write_tdc_information(hObject, eventdata, handles,tdc_information_ico);
        status_slider_Callback(hObject, eventdata, handles);        
        end
        %traverse the ds of TDC
        page_down_command=0;
        for loop_ds=ds_start:ds_step:ds_stop%--------------------------------------------------
            set(handles.ds_start_edit,'String',num2str(loop_ds));
            t0=clock;
            %%----------------SA data save-----------------------------
            try
                fopen(SA_obj);                  
                %%---考虑多组区间                                                    
                fprintf(SA_obj,'RB3000000');%3M**,1M,300k,100k,30k,10k,3k,1k,300,100,30,越小扫的越慢，越大，噪声越小
                fprintf(SA_obj,'VB3000');%3M,1M,300k,100k,30k**,10k,3k,1k,300,100,30,10越小扫的越慢,越大越不精细
                fprintf(SA_obj,'FA0');
                fprintf(SA_obj,'FB35000000000');
                fclose(SA_obj);
            catch
                fclose(SA_obj);
                disp('SA cant be connected!!');
            end              
            %----------------------------------------------------------
            if label_stop==1
                label_stop=0;
                return;
            end
            file_name_num_2=(loop_ds-ds_start)/ds_step+1;
            file_name_num_2=get_ordered_str_3(hObject, eventdata, handles,file_name_num_2);
            dir_name_2=['Experiment_data-',file_name_num_2,'-DS-',num2str(loop_ds)];
            bindata_address_2=fullfile(bindata_address,dir_name_2);
            if ~exist(bindata_address_2,'dir') 
                mkdir(bindata_address_2);        % 若不存在，在当前目录中产生一个子目录‘Figure’
            end
            if label_wavedata_saved==1
        %---wave_address
                wavedata_address_2=fullfile(wavedata_address,dir_name_2);
                if ~exist(wavedata_address_2,'dir') 
                    mkdir(wavedata_address_2);        % 若不存在，在当前目录中产生一个子目录‘Figure’
                end
            end
            collapse=collapse+1;%覆盖写操作
            table_info{2,5}=num2str(loop_ds);%information of ds    
            ds_command=['ds set ',num2str(loop_ds)];
            tdc_information_ds=tdc_state_test(hObject, eventdata, handles,ds_command,serial_obj);
            write_tdc_information(hObject, eventdata, handles,tdc_information_ds);
            status_slider_Callback(hObject, eventdata, handles);
           %%---------------------------------------------------------------------------
            temp_average_sym=0;
            temp_average_acf=0;
%             temp_average_acf_xor=0;
            for i=1:loop_length
            if label_stop==1
                label_stop=0;
                return;
            end
            try
                connect(deviceObj);
            catch
                disconnect(deviceObj);
                disp('Network isnt connected!');
                message=cell(1,1);
                message{1,1}='>OSC isnt connected!';
                write_tdc_information(hObject, eventdata, handles,message);
                status_slider_Callback(hObject, eventdata, handles);
                error_date=datestr(now,31);
                subject=['实验结果',error_date,'-breaking!'];
                content='Network isnt connected!';
                if get(handles.email_checkbox,'Value')==1
                    try
                        qq=get(handles.qq_edit,'String');
                        MySendMail_simple(qq,subject,content);
                        disp('Email is sent OK!!');
                        message=cell(1,1);
                        message{1,1}='>Email is sent OK!!';
                        write_tdc_information(hObject, eventdata, handles,message);
                        status_slider_Callback(hObject, eventdata, handles);
                    catch
                        disp('Network isnt connected(Email)!');
                        message=cell(1,1);
                        message{1,1}='>Network isnt connected(Email)!';
                        write_tdc_information(hObject, eventdata, handles,message);
                        status_slider_Callback(hObject, eventdata, handles);
                    end
                end
                fid=fopen('.\doc_serial\error_message_auto.txt','a');
                fprintf(fid,error_date);
                fprintf(fid,'\r\n');
                fprintf(fid,'Error: OSC isnt connected!');
                fprintf(fid,'\r\n');
                fclose(fid);
                return;
            end
            if i==1
                if label_am_type==1
                    am_set=str2double(am_settled)/1000;
                    set(deviceObj.Channel(label_osc_channel),'Scale',am_set);%set the Am
                    table_info{2,2}=[am_settled,'mv'];
                else
                set(deviceObj.Channel(label_osc_channel),'Scale',initial_am);%set the Am
                pause(4);
                set(deviceObj.Measurement(1), 'Source', ['channel',num2str(label_osc_channel)]);
                signal_Am=zeros(1,4);
                signal_base=zeros(1,4);
                signal_top=zeros(1,4);
                signal_Max=zeros(1,4);
                for signal_num=1:4
                % get the Amplitude
                    set(deviceObj.Measurement(1),'MeasurementType','amplitude');
                    signal_Am(signal_num)=get(deviceObj.Measurement(1),'Value');
                %get the base of signal
                    set(deviceObj.Measurement(1),'MeasurementType','base');
                    signal_base(signal_num)=get(deviceObj.Measurement(1),'Value');
                %get the decision value
                    signal_top(signal_num)=signal_Am(signal_num)+signal_base(signal_num);
                    signal_Max(signal_num)=max(abs(signal_top(signal_num)),abs(signal_base(signal_num)));
                end
                signal_decision=max(signal_Max);
                %choose the suitable Am
                label_am=am_num(signal_decision,initial_am,0.01);
                set(deviceObj.Channel(label_osc_channel),'Scale',(initial_am-(label_am-1)*0.01+0.002));%set the Am
                table_info{2,2}=[num2str(initial_am-(label_am-1)*0.01+0.002),'mv'];
                pause(4);%--------------------------------------------------------------------------
                end  
            end
            groupObj = get(deviceObj, 'Waveform');
            groupObj = groupObj(1);       
%             [data,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str);
            [data1,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
            pause(1);
            [data2,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
            disconnect(deviceObj);
            if label_wavedata_saved==1
                num_str=get_ordered_str_4(hObject, eventdata, handles,(i-1)*2+1);
                wavedata_add_1=fullfile(wavedata_address_2,['huye_',num_str,'.dat']);
                num_str=get_ordered_str_4(hObject, eventdata, handles,i*2);
                wavedata_add_2=fullfile(wavedata_address_2,['huye_',num_str,'.dat']);
                dlmwrite(wavedata_add_1,data1,'newline','pc','precision',6);
                dlmwrite(wavedata_add_2,data2,'newline','pc','precision',6);
            end
            if i==1
                table_info{2,7}='huye_0001.dat';
                dlmwrite(fullfile(bindata_address_2,'huye_0001.dat'),data1,'newline','pc','precision',6);
                dlmwrite(fullfile(bindata_address_2,'huye_0002.dat'),data2,'newline','pc','precision',6);                             
                if label_record==1
                    %prcessing the data,and create the pic
                    handle_pic=figure(11);
                    set (gcf,'Position',[500,300,1070,600], 'color','w') ;
                    set(gcf,'Visible','off');
                    %plot(sin(0:0.1:10));%for test
                    subplot(221);
                    [~,~,median_num,mean_num]=data_statistic3(data1);
                    subplot(222);
                    [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis(data1,1,fs,1);
                    subplot(212);
                    if isempty(base_noise)
                        myplot_analysis(data1,3,fs,1);
                    else
                        myplot_analysis(data1,3,fs,1,base_noise);
                    end
%                     ylim([0 6e-5]);%------------------------------------
                    % saveas(gcf,pic_address);
                    disp('start writing doc.................');
                    message=cell(1,2);
                    message{1,1}='>Start writing doc.........';
                    message{1,2}='>Waiting..........................';
                    write_tdc_information(hObject, eventdata, handles,message);
                    status_slider_Callback(hObject, eventdata, handles);
                    tabel_num=write_doc(handle_pic,table_info,filespec_doc,tabel_num,collapse,page_down_command);
                    str_ico=get_ordered_str_3(hObject, eventdata, handles,loop_ico);
                    str_ds=get_ordered_str_4(hObject, eventdata, handles,loop_ds);
                    data_excel={['\序号_',str_ico,'-',str_ds],loop_ds,loop_ico,roundn(maxnum,-5),x_maxnum,roundn(minnum,-5),x_minnum,roundn(median_num,-5),...
                        roundn(mean_num,-5),roundn(abs(median_num-mean_num),-5),roundn(max(abs(maxnum),abs(minnum)),-5),0,0};                   
                    if label_average==1
                        temp_average_sym=abs(mean_num-median_num)/loop_length+temp_average_sym;
                        temp_average_acf=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf;
%                     data3=wavedata_2_binary(data1,judgment_threshold);
%                     data4=wavedata_2_binary(data2,judgment_threshold);
%                     data5=xor(data3,data4);
%                     [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data5);
%                     temp_average_acf_xor=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf_xor;%acf(xor)      
%                     clear data3 data4 data5
%                     temp_average_sym=0;
%                     temp_average_acf=0;
%                     temp_average_acf_xor=0;
                    end 
                    excel_range=['A',num2str(tabel_num),':M',num2str(tabel_num)]; 
                    % write_excel_single(filespec_excel,data_excel,excel_range);%wps必须
                    xlswrite(filespec_excel,data_excel,'sheet1',excel_range);  
                    message=cell(1,1);
                    message{1,1}='>OK!!';
                    write_tdc_information(hObject, eventdata, handles,message);
                    status_slider_Callback(hObject, eventdata, handles);
                end
            else
                if label_average==1
                    [~,~,median_num,mean_num,~]=data_statistic3_only_result(data1);
                    [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data1);
                    temp_average_sym=abs(mean_num-median_num)/loop_length+temp_average_sym;
                    temp_average_acf=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf;
%                     data3=wavedata_2_binary(data1,judgment_threshold);
%                     data4=wavedata_2_binary(data2,judgment_threshold);
%                     data5=xor(data3,data4);
%                     [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data5);
%                     temp_average_acf_xor=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf_xor;%acf(xor)      
%                     clear data3 data4 data5
%                     temp_average_sym=0;
%                     temp_average_acf=0;
%                     temp_average_acf_xor=0;
                end        
            end
            if i==floor(loop_length/2)
                %%----------------SA data save-----------------------------
                try
                    fopen(SA_obj);                  
                    %%---考虑多组区间                   
                    SA_file_name='SA_1';
                    SA_title_name='SA\_1';                                        
                    %%--save SA file and fig
                    fprintf(SA_obj,'SI');%single
                    pause(0.2);
                    SA_spectrum_save(SA_obj,bindata_address_2,SA_file_name,SA_title_name,3);%1-file,2-fig,3-all
                    fprintf(SA_obj,'SN');%normal,表示repeat
                    fprintf(SA_obj,'FA10000000000');
                    fprintf(SA_obj,'FB10100000000');
                    fprintf(SA_obj,'RB100000');%3M**,1M,300k,100k,30k,10k,3k,1k,300,100,30,越小扫的越慢，越大，噪声越小
                    fprintf(SA_obj,'VB100');%3M,1M,300k,100k,30k**,10k,3k,1k,300,100,30,10越小扫的越慢,越大越不精细
                    % pause(0.5);
                    fclose(SA_obj);
                catch
                    fclose(SA_obj);
                    disp('SA cant be connected!!');
                end              
                %----------------------------------------------------------
            end
            
            num_str=get_ordered_str_4(hObject, eventdata, handles,i);
            bin_add=fullfile(bindata_address_2,['huye_',num_str]);
            message=cell(1,1);
            message{1,1}=['>generate bin fle: huye_',num_str,'.bin.....'];
            write_tdc_information(hObject, eventdata, handles,message);
            status_slider_Callback(hObject, eventdata, handles);
            generation_test_file(bin_add,data1,data2,judgment_threshold,3,0,1);%覆盖，不作处理，bin         
            end
            if label_record==1
                 excel_range=['L',num2str(tabel_num),':M',num2str(tabel_num)]; 
               % write_excel_single(filespec_excel,data_excel,excel_range);%wps必须
                 xlswrite(filespec_excel,{roundn(temp_average_sym,-5),roundn(temp_average_acf,-5)},'sheet1',excel_range);  
            end
            %%----------------SA data save-----------------------------
            try
                fopen(SA_obj);                  
                %%---考虑多组区间                   
                SA_file_name='SA_1';
                SA_title_name='SA\_1';                                        
                %%--save SA file and fig
                fprintf(SA_obj,'SI');%single
                pause(0.2);
                SA_spectrum_save(SA_obj,bindata_address_2,SA_file_name,SA_title_name,3);%1-file,2-fig,3-all
                fprintf(SA_obj,'SN');%normal,表示repeat
                fprintf(SA_obj,'RB3000000');%3M**,1M,300k,100k,30k,10k,3k,1k,300,100,30,越小扫的越慢，越大，噪声越小
                fprintf(SA_obj,'VB3000');%3M,1M,300k,100k,30k**,10k,3k,1k,300,100,30,10越小扫的越慢,越大越不精细
                fprintf(SA_obj,'FA0');
                fprintf(SA_obj,'FB35000000000');                
                % pause(0.5);
                fclose(SA_obj);
            catch
                fclose(SA_obj);
                disp('SA cant be connected!!');
            end              
            %----------------------------------------------------------
            time=etime(clock,t0);
            set_run_time(hObject, eventdata, handles,time,'b1');
        end
        %%-------------------------------------
        if label_record==1
        %检测出合理的下降曲线
        [excel_data,~,~]=xlsread(filespec_excel,1);
        handle_pic=figure(11);
        set (gcf,'Position',[500,300,1070,900], 'color','w') ;
        set(gcf,'Visible','off');
        %plot(sin(0:0.1:10));%for test
        subplot(411)
        plot(excel_data(1:end,1),excel_data(1:end,3));
        xlabel('dispersion/ps/km');
        ylabel('ACF(+)');
        title(['ICO=',num2str(excel_data(1,2)),' Ghz']);
        subplot(412)
        plot(excel_data(1:end,1),excel_data(1:end,5));
        xlabel('dispersion/ps/km');
        ylabel('ACF(-)');
        subplot(413)
        plot(excel_data(1:end,1),excel_data(1:end,10));       
        hold on;
        plot(excel_data(1:end,1),excel_data(1:end,12));
        xlabel('dispersion/ps/km');
        ylabel('ACF');
        hold off;
        legend('ACF','ACF(av)');
        subplot(414)
        plot(excel_data(1:end,1),excel_data(1:end,9));
        hold on;
        plot(excel_data(1:end,1),excel_data(1:end,12));
        xlabel('dispersion/ps/km');
        ylabel('median-mean/mV');
        hold off;
        legend('Symmetry','Symmetry(av)');           
        write_doc_sum(handle_pic,filespec_doc,tabel_num,collapse,page_down_command);
        write_doc_save(filespec_doc);
        end
        subject=[dir_name,'-OK!'];
        fid=fopen('.\doc_serial\error_message_auto.txt','r');
        message=textscan(fid,'%[^\n]');
        content=message{1,1}';
        my_content='you will see the error_message below:';
        for i=1:length(content)
            my_content=[my_content,char(10)',content{1,i}];
        end
        fclose(fid);
        if get(handles.email_checkbox,'Value')==1
        try
            qq=get(handles.qq_edit,'String');
            if label_record==1                
                MySendMail(qq,subject,my_content,filespec_doc);
            else
                MySendMail_simple(qq,subject,my_content);
            end
             disp('Email is sent OK!!');
             message=cell(1,1);
             message{1,1}='>Email is sent OK!!';
             write_tdc_information(hObject, eventdata, handles,message);
             status_slider_Callback(hObject, eventdata, handles);
        catch
            disp('Network isnt connected(Email)!');
            message=cell(1,1);
            message{1,1}='Network isnt connected(Email)!';
            write_tdc_information(hObject, eventdata, handles,message);
            status_slider_Callback(hObject, eventdata, handles);
        end
        end
        time=etime(clock,t1);
        set_run_time(hObject, eventdata, handles,time,'b2');
    end
    set(handles.nist_button,'Enable','on'); 
    %%--add integration_excel and process part
    [data_ico,data_ds]=integration_excel_ico_single(excel_address);
    process_excel_analyse(excel_address,data_ds,data_ico,2);
    time=etime(clock,t2);
    set_run_time(hObject, eventdata, handles,time,'b3');    
else    
    message=cell(1,1);
    message{1,1}='>Please make the TDC and OSC connectivity!';
    write_tdc_information(hObject, eventdata, handles,message);
    status_slider_Callback(hObject, eventdata, handles);
end
end


function set_run_time(hObject, eventdata, handles,time,str)
message=cell(1,1);
if time<100
  message{1,1}=['Run time(',str,'): ',num2str(time,'%.2f'),'seconds'];
else
    if time<3600
        message{1,1}=['Run time(',str,'): ',num2str(time/60,'%.1f'),'minutes'];
    else
        message{1,1}=['Run time(',str,'): ',num2str(time/3600,'%.1f'),'hours'];
    end
end
disp(message{1,1});
set(handles.run_time_text,'String',message{1,1});
write_tdc_information(hObject, eventdata, handles,message);
status_slider_Callback(hObject, eventdata, handles);

function num_str=get_ordered_str_4(hObject, eventdata, handles,num)
if num<10
        num_str=['000',num2str(num)];
else
    if num<100
            num_str=['00',num2str(num)];
    else
        if num<1000
            num_str=['0',num2str(num)];
        else
                num_str=num2str(num);
        end
    end
end
function num_str=get_ordered_str_3(hObject, eventdata, handles,num)
if num<10
        num_str=['00',num2str(num)];
else
    if num<100
        num_str=['0',num2str(num)];
    else
        num_str=num2str(num);
    end
end
function num_str=get_ordered_str_2(hObject, eventdata, handles,num)
if num<10
        num_str=['0',num2str(num)];
else 
        num_str=num2str(num);
end

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_stop
label_stop=1;
set(handles.nist_button,'Enable','on');
set(handles.generate_bin_button,'Enable','on');

% --- Executes on button press in diehard_test_button.
function diehard_test_button_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_test_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
origin_add=uigetdir(get(handles.path_select_edit,'String'));
if origin_add==0
    return;
end
label_temp=strfind(origin_add,'\');
if length(label_temp)==1
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show('选择的文件夹无效！','Information',...
         MessageBoxButtons.OK,MessageBoxIcon.Information);
    return;
end
end_folder=origin_add(label_temp(end)+1:end);
if strncmp(end_folder,'bin_data',8)~=1
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show('选择的文件夹无效！','Information',...
         MessageBoxButtons.OK,MessageBoxIcon.Information);
    return;
end
label_average=get(handles.control_average_checkbox,'Value');
[ico_num,dir_address_ds,diehard_dir_address_ico,result_dir_address_ico,...
    diehard_dir_address_ds,result_dir_address_ds,diehard_excel,result_excel,...
    diehard_excel_add,result_excel_add]=get_file_system(origin_add);
t0=clock;
generate_test_bin_auto(hObject, eventdata, handles,ico_num,dir_address_ds,diehard_dir_address_ds,diehard_excel,label_average);
%%--add integration_excel and process part
[data_ico,data_ds]=integration_excel_ico_single(diehard_excel_add);
process_excel_analyse(diehard_excel_add,data_ds,data_ico,2);
time=etime(clock,t0);
set_run_time(hObject, eventdata, handles,time,'t');
t1=clock;
generate_log_file_auto(hObject, eventdata, handles,ico_num,dir_address_ds,...
    diehard_dir_address_ico,diehard_dir_address_ds,result_dir_address_ico,result_dir_address_ds,result_excel);
process_excel_diehard(result_excel_add,data_ds,data_ico,2);
time=etime(clock,t1);
set_run_time(hObject, eventdata, handles,time,'l');

function generate_test_bin_auto(hObject, eventdata, handles,ico_num,dir_address_ds,diehard_dir_address_ds,diehard_excel,label_average)
data_excel=cell(1,length(ico_num));
% parpool(2);%max 4 worker
parfor loop_ico=1:length(ico_num)  
% for loop_ico=1:length(ico_num)  
    data_excel_temp=zeros(length(dir_address_ds{1,loop_ico}),12);%10位,第十一位为acf（average）;
%     t3=clock;%--------------------------------------------------------
    for loop_ds=1:length(dir_address_ds{1,loop_ico})        
        temp_bin_add=get_all_file(dir_address_ds{1,loop_ico}{1,loop_ds},'*.bin');
        temp_average_acf=0;
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
                if label_average==1%--------------------------------------------------------------------------
                    temp_average_acf=max(abs(maxnum),abs(minnum))/length(temp_bin_add);
                end
                diehard_binary_improvement([diehard_dir_address_ds{1,loop_ico}{1,loop_ds},'.bin'],data,2,0);%覆盖
            else
                if label_average==1%----------------------------------------------------------------------------------
                    [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data);
                    temp_average_acf=max(abs(maxnum),abs(minnum))/length(temp_bin_add)+temp_average_acf;
                end
                diehard_binary_improvement([diehard_dir_address_ds{1,loop_ico}{1,loop_ds},'.bin'],data,2,1);%append
            end
        end
        data_excel_temp(loop_ds,1:end)=[diehard_dir_address_ds{1,loop_ico}{2,loop_ds},ico_num(loop_ico),roundn(maxnum,-5),...
                x_maxnum,roundn(minnum,-5),x_minnum,0,0,0,roundn(max(abs(maxnum),abs(minnum)),-5),0,roundn(temp_average_acf,-5)];      
    end
    data_excel{1,loop_ico}=data_excel_temp;
%     time=etime(clock,t3);%-----------------------------------------------
%     set_run_time(hObject, eventdata, handles,time,'t2');
end
% delete(gcp('nocreate'));%----------------------------------------------------

for i=1:length(ico_num)
    if exist(diehard_excel{1,i},'file')
      delete(diehard_excel{1,i})%-------------------------------------------------------------
    end
    xlswrite(diehard_excel{1,i},data_excel{1,i});
    %     write_excel(diehard_excel{i},data_excel{1,i});
end
subject='Diehard_bin生成结果';
content='All is OK!';
if get(handles.email_checkbox,'Value')==1
   try
        qq=get(handles.qq_edit,'String');
        MySendMail_simple(qq,subject,content);
        disp('Email is sent OK!!');
        message=cell(1,1);
        message{1,1}='>Email is sent OK!!';
        write_tdc_information(hObject, eventdata, handles,message);
        status_slider_Callback(hObject, eventdata, handles);
   catch
        disp('Network isnt connected(Email)!');
        message=cell(1,1);
        message{1,1}='>Network isnt connected(Email)!';
        write_tdc_information(hObject, eventdata, handles,message);
        status_slider_Callback(hObject, eventdata, handles);
   end
end


function generate_log_file_auto(hObject, eventdata, handles,ico_num,dir_address_ds,...
    diehard_dir_address_ico,diehard_dir_address_ds,result_dir_address_ico,result_dir_address_ds,result_excel)
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
    t2=clock;%----------------------------------------------------------
    for loop_ds=1:length(dir_address_ds{1,loop_ico})         
        copyfile([diehard_dir_address_ds{1,loop_ico}{1,loop_ds},'.bin'],pwd);
        label_temp=strfind(diehard_dir_address_ds{1,loop_ico}{1,loop_ds},'\');
        diehard_name=[diehard_dir_address_ds{1,loop_ico}{1,loop_ds}(label_temp(end)+1:end),'.bin'];
        logfile_name=[diehard_dir_address_ds{1,loop_ico}{1,loop_ds}(label_temp(end)+1:end),'.out'];
        diehard_name_temp=['huye',num2str(loop_ico),'.bin'];
        logfile_name_temp=['huye',num2str(loop_ico),'.out'];
        eval(['!rename' 32 diehard_name 32 diehard_name_temp]);
        fid_parameter=fopen(fullfile(pwd,'parameter.txt'),'w');
        fprintf(fid_parameter,diehard_name_temp);
        fprintf(fid_parameter,'\r\n');
        fprintf(fid_parameter,logfile_name_temp);
        fprintf(fid_parameter,'\r\n');
        fprintf(fid_parameter,'111111111111111');
        fclose(fid_parameter);
        [~,~]=dos('diequick.bat');
        eval(['!rename' 32 logfile_name_temp 32 logfile_name]);
        copyfile(fullfile(pwd,logfile_name),diehard_dir_address_ico{1,loop_ico});
        copyfile(fullfile(pwd,logfile_name),result_dir_address_ico{1,loop_ico});
        delete(fullfile(pwd,diehard_name_temp));
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
    time=etime(clock,t2);%--------------------------------------------------
    set_run_time(hObject, eventdata, handles,time,'l2');
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
%%email----------------------------------------------
subject='Diehard测试结果';
content='All is OK!';
if get(handles.email_checkbox,'Value')==1
   try
        qq=get(handles.qq_edit,'String');             
        MySendMail(qq,subject,content,result_excel);
        disp('Email is sent OK!!');
        message=cell(1,1);
        message{1,1}='>Email is sent OK!!';
        write_tdc_information(hObject, eventdata, handles,message);
        status_slider_Callback(hObject, eventdata, handles);
   catch
        disp('Network isnt connected(Email)!');
        message=cell(1,1);
        message{1,1}='>Network isnt connected(Email)!';
        write_tdc_information(hObject, eventdata, handles,message);
        status_slider_Callback(hObject, eventdata, handles);
   end
end



% --- Executes on button press in save_wavedata_checkbox.
function save_wavedata_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to save_wavedata_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_wavedata_checkbox


% --- Executes on slider movement.
function status_slider_Callback(hObject, eventdata, handles)
% hObject    handle to status_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid=fopen('.\doc_serial\tdc_information_auto.txt','r');
message=textscan(fid,'%[^\n]');
fclose(fid);
message=message{1,1}';
message_length=length(message);
if message_length>500
    fid=fopen('.\doc_serial\tdc_information_auto.txt','w');
    fprintf(fid,'Welcome!--made by huye:)!!');
    fprintf(fid,'\r\n');
    fclose(fid);
    message_length=1;
end
length_text=24;
if message_length<length_text
    set(handles.status_text,'String',message);
    set(handles.status_slider,'SliderStep',[1,1]);
else
    set(handles.status_slider,'SliderStep',[1/(message_length-length_text+1),1/(message_length-length_text+1)]);
    add_value=get(handles.status_slider,'Value');
    add_value=1-add_value;
    add_value=floor((message_length-length_text+1)*add_value);
    set(handles.status_text,'String',message(1+add_value:length_text-1+add_value));
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%---write_information
function write_tdc_information(hObject, eventdata, handles,message)
fid=fopen('.\doc_serial\tdc_information_auto.txt','a');
info_date=datestr(now,31);
fprintf(fid,['>>',info_date]);
fprintf(fid,'\r\n');
for i=1:length(message)
    fprintf(fid,message{1,i});
    fprintf(fid,'\r\n');
end
fclose(fid);

% --- Executes during object creation, after setting all properties.
function status_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to status_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function path_select_edit_Callback(hObject, eventdata, handles)
% hObject    handle to path_select_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_select_edit as text
%        str2double(get(hObject,'String')) returns contents of path_select_edit as a double


% --- Executes during object creation, after setting all properties.
function path_select_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path_select_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in path_select_button.
function path_select_button_Callback(hObject, eventdata, handles)
% hObject    handle to path_select_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path_head=uigetdir(get(handles.path_text,'String'));
if ~isempty(path_head)
    set(handles.path_select_edit,'String',path_head);
end


function folder_edit_Callback(hObject, eventdata, handles)
% hObject    handle to folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folder_edit as text
%        str2double(get(hObject,'String')) returns contents of folder_edit as a double


% --- Executes during object creation, after setting all properties.
function folder_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folder_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function osc_set_fs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of osc_set_fs_edit as text
%        str2double(get(hObject,'String')) returns contents of osc_set_fs_edit as a double


% --- Executes during object creation, after setting all properties.
function osc_set_fs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_set_fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function osc_set_timebase_edit_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_timebase_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of osc_set_timebase_edit as text
%        str2double(get(hObject,'String')) returns contents of osc_set_timebase_edit as a double


% --- Executes during object creation, after setting all properties.
function osc_set_timebase_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_set_timebase_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function osc_set_am_edit_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_am_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of osc_set_am_edit as text
%        str2double(get(hObject,'String')) returns contents of osc_set_am_edit as a double


% --- Executes during object creation, after setting all properties.
function osc_set_am_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_set_am_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in am_settled_radiobutton.
function am_settled_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to am_settled_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',1);
set(handles.self_adaption_radiobutton,'Value',0);
% Hint: get(hObject,'Value') returns toggle state of am_settled_radiobutton


% --- Executes on button press in self_adaption_radiobutton.
function self_adaption_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to self_adaption_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',1);
set(handles.am_settled_radiobutton,'Value',0);
% Hint: get(hObject,'Value') returns toggle state of self_adaption_radiobutton



function ds_start_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ds_start_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ds_start=str2double(get(hObject,'String'));
if isnan(inpchk(ds_start,[-2100 2100],[1,1]))
    set(hObject,'String','10');
else
    set(hObject,'String',num2str(floor(ds_start)));
end
% Hints: get(hObject,'String') returns contents of ds_start_edit as text
%        str2double(get(hObject,'String')) returns contents of ds_start_edit as a double


% --- Executes during object creation, after setting all properties.
function ds_start_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ds_start_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ds_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ds_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ds_step=str2double(get(hObject,'String'));
if isnan(inpchk(ds_step,[0 400],[1,1]))
    set(hObject,'String','100');
else
    set(hObject,'String',num2str(floor(ds_step)));
end
% Hints: get(hObject,'String') returns contents of ds_step_edit as text
%        str2double(get(hObject,'String')) returns contents of ds_step_edit as a double


% --- Executes during object creation, after setting all properties.
function ds_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ds_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ds_stop_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ds_stop_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ds_stop=str2double(get(hObject,'String'));
ds_start=str2double(get(handles.ds_start_text,'String'));
if isnan(inpchk(ds_stop,[ds_start 2100],[1,1]))
    set(hObject,'String','0');
else
    set(hObject,'String',num2str(floor(ds_stop)));
end
% Hints: get(hObject,'String') returns contents of ds_stop_edit as text
%        str2double(get(hObject,'String')) returns contents of ds_stop_edit as a double


% --- Executes during object creation, after setting all properties.
function ds_stop_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ds_stop_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ico_start_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ico_start_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ico_start=str2double(get(hObject,'String'));
if isnan(inpchk(ico_start,[-99 99],[1,1]))
    set(hObject,'String','0');
else
    set(hObject,'String',num2str(floor(ico_start)));
end
% Hints: get(hObject,'String') returns contents of ico_start_edit as text
%        str2double(get(hObject,'String')) returns contents of ico_start_edit as a double


% --- Executes during object creation, after setting all properties.
function ico_start_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ico_start_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ico_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ico_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ico_step=str2double(get(hObject,'String'));
if isnan(inpchk(ico_step,[0 20],[1,1]))
    set(hObject,'String','0');
else
    set(hObject,'String',num2str(floor(ico_step)));
end
% Hints: get(hObject,'String') returns contents of ico_step_edit as text
%        str2double(get(hObject,'String')) returns contents of ico_step_edit as a double


% --- Executes during object creation, after setting all properties.
function ico_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ico_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ico_stop_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ico_stop_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ico_stop=str2double(get(hObject,'String'));
ico_start=str2double(get(handles.ico_start_text,'String'));
if isnan(inpchk(ico_stop,[ico_start 99],[1,1]))
    set(hObject,'String','0');
else
    set(hObject,'String',num2str(floor(ico_stop)));
end
% Hints: get(hObject,'String') returns contents of ico_stop_edit as text
%        str2double(get(hObject,'String')) returns contents of ico_stop_edit as a double


% --- Executes during object creation, after setting all properties.
function ico_stop_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ico_stop_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%---osc_connect_test
function osc_connect_test(hObject, eventdata, handles)
global deviceObj
global label_osc_connect
global label_osc_channel
try
    connect(deviceObj);
    %identify the instrument
    identify_ifo = get(deviceObj, 'Identity');
    if strcmp(identify_ifo,'LECROY,SDA845ZI-A,LCRY0430N57027,7.6.1')==1%please add the information of the instrument!
        switch label_osc_channel
            case 1
                set(deviceObj.Channel(1),'State','on');
                set(deviceObj.Channel(2),'State','off');
                set(deviceObj.Channel(3),'State','off');
                set(deviceObj.Channel(4),'State','off');
            case 2
                set(deviceObj.Channel(1),'State','off');
                set(deviceObj.Channel(2),'State','on');
                set(deviceObj.Channel(3),'State','off');
                set(deviceObj.Channel(4),'State','off');    
           case 3
                set(deviceObj.Channel(1),'State','off');
                set(deviceObj.Channel(2),'State','off');
                set(deviceObj.Channel(3),'State','on');
                set(deviceObj.Channel(4),'State','off');        
          case 4
                set(deviceObj.Channel(1),'State','off');
                set(deviceObj.Channel(2),'State','off');
                set(deviceObj.Channel(3),'State','off');
                set(deviceObj.Channel(4),'State','on');     
        end
        label_osc_connect=1;
        disp('The instrument is right!');
        message=cell(1,1);
        message{1,1}='>The instrument is right!';
        write_tdc_information(hObject, eventdata, handles,message);
        status_slider_Callback(hObject, eventdata, handles);
        set(handles.initial_osc_text,'String','OK');
        set(handles.initial_osc_text,'BackgroundColor',[0 0.498 0]);
        timebase=str2double(get(handles.osc_set_timebase_edit,'String'))/1e6;
        set(deviceObj.Acquisition(1),'Timebase',timebase);
        timebase=get(deviceObj.Acquisition(1),'Timebase');
        set(handles.osc_set_timebase_edit,'String',num2str(timebase*1e6));
        disconnect(deviceObj);
    else
        label_osc_connect=0;
        disp('The instrument is unmatched!');
        message=cell(1,1);
        message{1,1}='>The instrument is unmatched!';
        write_tdc_information(hObject, eventdata, handles,message);
        status_slider_Callback(hObject, eventdata, handles);
        set(handles.initial_osc_text,'String','NULL');
        set(handles.initial_osc_text,'BackgroundColor',[1 0 0]);
        disconnect(deviceObj);
    end
catch
    disp('OSC isnt connected!');
    message=cell(1,1);
    message{1,1}='>OSC isnt connected!';
    write_tdc_information(hObject, eventdata, handles,message);
    status_slider_Callback(hObject, eventdata, handles);
    set(handles.initial_osc_text,'String','NULL');
    set(handles.initial_osc_text,'BackgroundColor',[1 0 0]);
    label_osc_connect=0;
    disconnect(deviceObj);
end

% --- Executes on button press in initial_com_button.
function initial_com_button_Callback(hObject, eventdata, handles)
% hObject    handle to initial_com_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global serial_obj
global label_open%用于判断com口是否打开
[serial_obj,label_open] = COM_parameter(serial_obj,label_open);
if label_open==1
    set(handles.initial_com_text,'BackgroundColor',[0 0.498 0]);
    set(handles.initial_com_text,'String','OK');
else
    set(handles.initial_com_text,'BackgroundColor',[1 0 0]);
    set(handles.initial_com_text,'String','NULL');
end

%----tdc连通检测程序    
function label_connect=tdc_connect_test(hObject, eventdata, handles,label_open_temp,serial_obj_temp)
label_connect=0;
if label_open_temp==0
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show('Please initial com firstly!','Information',...
        MessageBoxButtons.OK,MessageBoxIcon.Information);    
else 
    getcom=instrhwinfo('serial');%获取可用串口
    com_available=getcom.AvailableSerialPorts;
    if isempty(com_available)==1
        NET.addAssembly('System.Windows.Forms');
        import System.Windows.Forms.*;
        MessageBox.Show('No available COM port!','Information',...
            MessageBoxButtons.OK,MessageBoxIcon.Information);
        set(handles.initial_com_text,'BackgroundColor',[1 0 0]);
        set(handles.initial_com_text,'String','NULL');
    else
        if strcmp(com_available,serial_obj_temp.Port)==0
            NET.addAssembly('System.Windows.Forms');
            import System.Windows.Forms.*;
            MessageBox.Show('COM port is not right!','Information',...
                MessageBoxButtons.OK,MessageBoxIcon.Information);
            set(handles.initial_com_text,'BackgroundColor',[1 0 0]);
            set(handles.initial_com_text,'String','NULL');
        else
                try
                    fopen(serial_obj_temp);
                    if strcmp(serial_obj_temp.status,'closed')==1
                        NET.addAssembly('System.Windows.Forms');
                        import System.Windows.Forms.*;
                        MessageBox.Show('COM port is not opened!','Information',...
                            MessageBoxButtons.OK,MessageBoxIcon.Information);
                        set(handles.initial_com_text,'BackgroundColor',[1 0 0]);
                        set(handles.initial_com_text,'String','NULL');
                    else
                       fclose(serial_obj_temp);
                       label_connect=1; 
                    end
                catch
                        NET.addAssembly('System.Windows.Forms');
                        import System.Windows.Forms.*;
                        MessageBox.Show('COM port can not be opened!','Information',...
                            MessageBoxButtons.OK,MessageBoxIcon.Information);
                        set(handles.initial_com_text,'BackgroundColor',[1 0 0]);
                        set(handles.initial_com_text,'String','NULL');                  
                end
        end
     end
end

%---tdc状态稳定自检
function tdc_information=tdc_state_test(hObject, eventdata, handles,tdc_command_temp,serial_obj_temp)
global label_stop
global table_info
tdc_command(serial_obj_temp,tdc_command_temp);
isok=0;
error_loop=0;
temp_text=cell(1,2);
temp_text{1,1}=['>',tdc_command_temp];
temp_text{1,2}='>waiting.................';
write_tdc_information(hObject, eventdata, handles,temp_text);
status_slider_Callback(hObject, eventdata, handles);
while(isok==0)
    drawnow;
   [isok,BW,tdc_information]=tdc_command(serial_obj_temp,'ds');
   error_loop=error_loop+1;
   if error_loop>500
      error_date=datestr(now,31);
      fid=fopen('.\doc_serial\tdc_error_message_auto.txt','a');
      fprintf(fid,error_date);
      fprintf(fid,'\r\n');
      fprintf(fid,['Error: ',tdc_command_temp,',The TDC is always busy!!']);
      fprintf(fid,'\r\n');
      fclose(fid);
      %pause;
      isok=1;
   end
   table_info{1,6}=['ICO/',BW,' GHz'];
   if label_stop==1
       return;
   end
end

% --- Executes on button press in initial_osc_button.
function initial_osc_button_Callback(hObject, eventdata, handles)
% hObject    handle to initial_osc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global interfaceObj
global deviceObj
osc_ip='192.168.1.110';%--------------------------------------------------
osc_port=1861;
inputbuffersize=100e6;
outputbuffersize=30e6;
% Create a TCPIP object. initialize the osc
interfaceObj = instrfind('Type', 'tcpip', 'RemoteHost', osc_ip, 'RemotePort', osc_port, 'Tag', '');
% Create the TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
   interfaceObj = tcpip(osc_ip, osc_port);
else
   fclose(interfaceObj);
   interfaceObj = interfaceObj(1);
end
% Create a device object. %lecroy_lt344l_ex.mdd
deviceObj = icdevice('lecroy_8600a.mdd', interfaceObj);
set(interfaceObj, 'InputBufferSize', inputbuffersize);
set(interfaceObj, 'OutputBufferSize', outputbuffersize);
% Connect device object to hardware.
osc_connect_test(hObject, eventdata, handles);

    

% --- Executes on button press in nist_button.
function nist_button_Callback(hObject, eventdata, handles)
% hObject    handle to nist_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global serial_obj
global label_open%用于判断com口是否打开
global table_info
global judgment_threshold
global deviceObj
global label_osc_connect
global label_stop
global initial_am
global label_osc_channel
label_stop=0;
global label_nist
global base_noise

time_base=str2double(get(handles.osc_set_timebase_edit,'String'))*1e-6;
fs=str2double(get(handles.osc_set_fs_edit,'String'))*1e9;
table_info{2,3}=[num2str(fs/1e9),'Gss'];%information of ds  
data_length=fs*10*time_base;
table_info{2,4}=[num2str(data_length/1e6),'M'];
loop_length=floor(1e9/data_length)+1;
if loop_length<26
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show(['Fs:',table_info{2,3},'and Timebase:',get(handles.osc_set_timebase_edit,'String'),'us is not suitable!!'],'Information',...
         MessageBoxButtons.OK,MessageBoxIcon.Information);
    return;
end
ico_start=floor(str2double(get(handles.ico_start_edit,'String')));
ico_step=floor(str2double(get(handles.ico_step_edit,'String')));
ico_stop=floor(str2double(get(handles.ico_stop_edit,'String')));
ds_start=floor(str2double(get(handles.ds_start_edit,'String')));
ds_step=floor(str2double(get(handles.ds_step_edit,'String')));
ds_stop=floor(str2double(get(handles.ds_stop_edit,'String')));
am_settled=get(handles.osc_set_am_edit,'String');
label_record=get(handles.record_checkbox,'Value');
label_wavedata_saved=get(handles.save_wavedata_checkbox,'Value');
label_am_type=get(handles.am_settled_radiobutton,'Value');
label_average=get(handles.control_average_checkbox,'Value');

makesure_info=cell(1,6);
makesure_info{1,1}='是否按以下要求执行(Nist_bin)？';
makesure_info{1,2}=['>ICO: ',num2str(ico_start),':',num2str(ico_step),':',num2str(ico_stop)];
makesure_info{1,3}=['>DS : ',num2str(ds_start),':',num2str(ds_step),':',num2str(ds_stop)];
if label_am_type==1
    makesure_info{1,4}=['>AM : ',num2str(am_settled),'mV'];
else
    makesure_info{1,4}='>AM : self-adaption!!';
end
if label_wavedata_saved==1
    makesure_info{1,5}='>wavedata_saved : ON';
else
    makesure_info{1,5}='>wavedata_saved : OFF';
end
if label_average==1
    makesure_info{1,6}='>Sym&ACF(average) : ON';
else
    makesure_info{1,6}='>Sym&ACF(average) : OFF';
end
makesure = questdlg(makesure_info,'info','OK','Cancel','OK') ;
temp_path=get(handles.path_select_edit,'String');
temp_disk_position=strfind(temp_path,'\');
temp_disk=temp_path(1:temp_disk_position);
diskspace_s=java.io.File(temp_disk);
freespace_s=floor(diskspace_s.getFreeSpace/(1024*1024*1024));
if label_wavedata_saved==1
    needspace=30*length(ico_start:ico_step:ico_stop)*length(ds_start:ds_step:ds_stop);
else
    needspace=1.2*length(ico_start:ico_step:ico_stop)*length(ds_start:ds_step:ds_stop);
end
if freespace_s<needspace+10
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show(['Freespace(',num2str(freespace_s),'GB) 小于','needspace(',num2str(needspace+10),'GB)'],'Information',...
         MessageBoxButtons.OK,MessageBoxIcon.Information);
    return;
end
if strcmp(makesure,'OK')==1
label_connect=tdc_connect_test(hObject, eventdata, handles,label_open,serial_obj);
osc_connect_test(hObject, eventdata, handles);
if label_connect==1&&label_osc_connect==1
    t2=clock;
    %---close nist
    label_nist=label_nist+1;
    str_label_nist_bin=get_ordered_str_2(hObject, eventdata, handles,label_nist);
    set(handles.nist_text,'String',['Times:',num2str(label_nist)]);
    make_folder(hObject, eventdata, handles);
    handles=guidata(hObject);%-----------------------------------------------------------------------------
    set(handles.generate_bin_button,'Enable','off');     
    %---bin-address
    if label_record==1
        word_address=fullfile(handles.nist_folder,['word_file_',str_label_nist_bin]);
        excel_address=fullfile(handles.nist_folder,['excel_file_',str_label_nist_bin]);
        if ~exist(word_address,'dir') 
            mkdir(word_address);        % 若不存在，在当前目录中产生一个子目录‘Figure’
        end 
        if ~exist(excel_address,'dir') 
            mkdir(excel_address);        % 若不存在，在当前目录中产生一个子目录‘Figure’
        end 
    end
    [~,~,figure_head]=xlsread('.\doc_serial\figure_status_head_auto.xlsx');
    for loop_ico=ico_start:ico_step:ico_stop
        set(handles.ico_start_edit,'String',num2str(loop_ico));
        t1=clock;
         collapse=-1;%重新定位初始文档
         tabel_num=1;%必须初始化表格长度
         table_info{2,6}=num2str(loop_ico);%information of ICO
        %---bin_address
        file_name_num=(loop_ico-ico_start)/ico_step+1;
        file_name_num=get_ordered_str_3(hObject, eventdata, handles,file_name_num);
        dir_name=['Experiment_data-',file_name_num,'-ICO-',num2str(loop_ico)];
        bindata_address=fullfile(fullfile(handles.nist_folder,['bin_data_',str_label_nist_bin]),dir_name);
        if ~exist(bindata_address,'dir') 
            mkdir(bindata_address);        % 若不存在，在当前目录中产生一个子目录‘Figure’
        end
        if label_wavedata_saved==1
        %---wave_address
            wavedata_address=fullfile(fullfile(handles.nist_folder,['wave_data_',str_label_nist_bin]),dir_name);
            if ~exist(wavedata_address,'dir') 
                mkdir(wavedata_address);        % 若不存在，在当前目录中产生一个子目录‘Figure’
            end
        end
        if label_record==1
            filespec_doc=fullfile(word_address,[dir_name,'.docx']);
            filespec_excel=fullfile(excel_address,[dir_name,'.xlsx']);
            %清空xls 
            if exist(filespec_excel,'file')
                delete(filespec_excel);
            end          
            % write_excel_single(filespec_excel,figure_head,'A1:K1');%wps必须
            xlswrite(filespec_excel,figure_head,'sheet1','A1:M1');
        end
        label_connect=tdc_connect_test(hObject, eventdata, handles,label_open,serial_obj);
        if label_connect==0
            serial_obj='nocom';
            label_open=0;
            disp('TDC isnt connected!');
            message=cell(1,1);
            message{1,1}='>TDC isnt connected!';
            write_tdc_information(hObject, eventdata, handles,message);
            status_slider_Callback(hObject, eventdata, handles);
            error_date=datestr(now,31);
            subject=['实验结果',error_date,'-breaking!'];
            content='TDC isnt connected!';
            if get(handles.email_checkbox,'Value')==1
                try
                   qq=get(handles.qq_edit,'String');
                   MySendMail_simple(qq,subject,content);
                   disp('Email is sent OK!!');
                   message=cell(1,1);
                   message{1,1}='>Email is sent OK!!';
                   write_tdc_information(hObject, eventdata, handles,message);
                   status_slider_Callback(hObject, eventdata, handles);
                catch
                   disp('network isnt connected(Email)!');
                   message=cell(1,1);
                   message{1,1}='>Network isnt connected(Email)!';
                   write_tdc_information(hObject, eventdata, handles,message);
                   status_slider_Callback(hObject, eventdata, handles);
                 end
            end
            fid=fopen('.\doc_serial\error_message_auto.txt','a');
            fprintf(fid,error_date);
            fprintf(fid,'\r\n');
            fprintf(fid,'Error: TDC isnt connected!');
            fprintf(fid,'\r\n');
            fclose(fid);
            return;
        else
        ico_command=['ds ico ',num2str(loop_ico)];
        tdc_information_ico=tdc_state_test(hObject, eventdata, handles,ico_command,serial_obj);
        write_tdc_information(hObject, eventdata, handles,tdc_information_ico);
        status_slider_Callback(hObject, eventdata, handles);        
        end
        %traverse the ds of TDC
        page_down_command=0;
        for loop_ds=ds_start:ds_step:ds_stop
            set(handles.ds_start_edit,'String',num2str(loop_ds));
            t0=clock;
            if label_stop==1
                label_stop=0;
                return;
            end 
            file_name_num_2=(loop_ds-ds_start)/ds_step+1;
            file_name_num_2=get_ordered_str_3(hObject, eventdata, handles,file_name_num_2);
            dir_name_2=['Experiment_data-',file_name_num_2,'-DS-',num2str(loop_ds)];
            bindata_address_2=fullfile(bindata_address,dir_name_2);
            if ~exist(bindata_address_2,'dir') 
                mkdir(bindata_address_2);        % 若不存在，在当前目录中产生一个子目录‘Figure’
            end
            if label_wavedata_saved==1
        %---wave_address
                wavedata_address_2=fullfile(wavedata_address,dir_name_2);
                if ~exist(wavedata_address_2,'dir') 
                    mkdir(wavedata_address_2);        % 若不存在，在当前目录中产生一个子目录‘Figure’
                end
            end
            collapse=collapse+1;%覆盖写操作
            table_info{2,5}=num2str(loop_ds);%information of ds    
            ds_command=['ds set ',num2str(loop_ds)];
            tdc_information_ds=tdc_state_test(hObject, eventdata, handles,ds_command,serial_obj);
            write_tdc_information(hObject, eventdata, handles,tdc_information_ds);
            status_slider_Callback(hObject, eventdata, handles);
            for i=1:126
            if label_stop==1
                label_stop=0;
                return;
            end
            try
                connect(deviceObj);
            catch
                disconnect(deviceObj);
                disp('Network isnt connected!');
                message=cell(1,1);
                message{1,1}='>OSC isnt connected!';
                write_tdc_information(hObject, eventdata, handles,message);
                status_slider_Callback(hObject, eventdata, handles);
                error_date=datestr(now,31);
                subject=['实验结果',error_date,'-breaking!'];
                content='Network isnt connected!';
                if get(handles.email_checkbox,'Value')==1
                    try
                        qq=get(handles.qq_edit,'String');
                        MySendMail_simple(qq,subject,content);
                        disp('Email is sent OK!!');
                        message=cell(1,1);
                        message{1,1}='>Email is sent OK!!';
                        write_tdc_information(hObject, eventdata, handles,message);
                        status_slider_Callback(hObject, eventdata, handles);
                    catch
                        disp('Network isnt connected(Email)!');
                        message=cell(1,1);
                        message{1,1}='>Network isnt connected(Email)!';
                        write_tdc_information(hObject, eventdata, handles,message);
                        status_slider_Callback(hObject, eventdata, handles);
                    end
                end
                fid=fopen('.\doc_serial\error_message_auto.txt','a');
                fprintf(fid,error_date);
                fprintf(fid,'\r\n');
                fprintf(fid,'Error: OSC isnt connected!');
                fprintf(fid,'\r\n');
                fclose(fid);
                return;
            end
            if label_am_type==1
                am_set=str2double(am_settled)/1000;
                set(deviceObj.Channel(label_osc_channel),'Scale',am_set);%set the Am
                table_info{2,2}=[am_settled,'mv'];
            else
            set(deviceObj.Channel(label_osc_channel),'Scale',initial_am);%set the Am
            pause(4);
            set(deviceObj.Measurement(1), 'Source', ['channel',num2str(label_osc_channel)]);
            signal_Am=zeros(1,4);
            signal_base=zeros(1,4);
            signal_top=zeros(1,4);
            signal_Max=zeros(1,4);
            for signal_num=1:4
            % get the Amplitude
                set(deviceObj.Measurement(1),'MeasurementType','amplitude');
                signal_Am(signal_num)=get(deviceObj.Measurement(1),'Value');
            %get the base of signal
                set(deviceObj.Measurement(1),'MeasurementType','base');
                signal_base(signal_num)=get(deviceObj.Measurement(1),'Value');
            %get the decision value
                signal_top(signal_num)=signal_Am(signal_num)+signal_base(signal_num);
                signal_Max(signal_num)=max(abs(signal_top(signal_num)),abs(signal_base(signal_num)));
            end
            signal_decision=max(signal_Max);
            %choose the suitable Am
            label_am=am_num(signal_decision,initial_am,0.01);
            set(deviceObj.Channel(label_osc_channel),'Scale',(initial_am-(label_am-1)*0.01+0.05));%set the Am
            table_info{2,2}=[num2str(initial_am-(label_am-1)*0.01+0.05),'mv'];
            pause(4);
            end            
            groupObj = get(deviceObj, 'Waveform');
            groupObj = groupObj(1);       
%             [data,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str);
            [data1,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
            pause(1);
            [data2,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
            disconnect(deviceObj);
            if label_wavedata_saved==1
                num_str=get_ordered_str_4(hObject, eventdata, handles,(i-1)*2+1);
                wavedata_add_1=fullfile(wavedata_address_2,['huye_',num_str,'.dat']);
                num_str=get_ordered_str_4(hObject, eventdata, handles,i*2);
                wavedata_add_2=fullfile(wavedata_address_2,['huye_',num_str,'.dat']);
                dlmwrite(wavedata_add_1,data1,'newline','pc','precision',6);
                dlmwrite(wavedata_add_2,data2,'newline','pc','precision',6);
            end
            if i==1
                table_info{2,7}='huye_0001.dat';
                dlmwrite(fullfile(bindata_address_2,'huye_0001.dat'),data1,'newline','pc','precision',6);
                dlmwrite(fullfile(bindata_address_2,'huye_0002.dat'),data2,'newline','pc','precision',6);
                if label_record==1
                    %prcessing the data,and create the pic
                    handle_pic=figure(11);
                    set (gcf,'Position',[500,300,1070,600], 'color','w') ;
                    set(gcf,'Visible','off');
                    %plot(sin(0:0.1:10));%for test
                    subplot(221);
                    [~,~,median_num,mean_num]=data_statistic3(data1);
                    subplot(222);
                    [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis(data1,1,fs,1);
                    subplot(212);
                    if isempty(base_noise)
                        myplot_analysis(data1,3,fs,1);
                    else
                        myplot_analysis(data1,3,fs,1,base_noise);
                    end
%                     ylim([0 6e-5]);%-------------------------------------
                    % saveas(gcf,pic_address);
                    disp('start writing doc.................');
                    message=cell(1,2);
                    message{1,1}='>Start writing doc.........';
                    message{1,2}='>Waiting..........................';
                    write_tdc_information(hObject, eventdata, handles,message);
                    status_slider_Callback(hObject, eventdata, handles);
                    tabel_num=write_doc(handle_pic,table_info,filespec_doc,tabel_num,collapse,page_down_command);
                    str_ico=get_ordered_str_3(hObject, eventdata, handles,loop_ico);
                    str_ds=get_ordered_str_4(hObject, eventdata, handles,loop_ds);
                    data_excel={['\序号_',str_ico,'-',str_ds],loop_ds,loop_ico,roundn(maxnum,-5),x_maxnum,roundn(minnum,-5),x_minnum,roundn(median_num,-5),...
                        roundn(mean_num,-5),roundn(abs(median_num-mean_num),-5),roundn(max(abs(maxnum),abs(minnum)),-5),0,0};
                    %--------------------------------------------------------------------------------
                    if label_average==1
                        temp_average_sym=abs(mean_num-median_num)/loop_length+temp_average_sym;
                        temp_average_acf=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf;
%                     data3=wavedata_2_binary(data1,judgment_threshold);
%                     data4=wavedata_2_binary(data2,judgment_threshold);
%                     data5=xor(data3,data4);
%                     [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data5);
%                     temp_average_acf_xor=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf_xor;%acf(xor)      
%                     clear data3 data4 data5
%                     temp_average_sym=0;
%                     temp_average_acf=0;
%                     temp_average_acf_xor=0;
                    end 
                    excel_range=['A',num2str(tabel_num),':M',num2str(tabel_num)]; 
                    % write_excel_single(filespec_excel,data_excel,excel_range);%wps必须
                    xlswrite(filespec_excel,data_excel,'sheet1',excel_range);  
                    message=cell(1,1);
                    message{1,1}='>OK!!';
                    write_tdc_information(hObject, eventdata, handles,message);
                    status_slider_Callback(hObject, eventdata, handles);
                end
            else
                if label_average==1&&i<26
                    [~,~,median_num,mean_num,~]=data_statistic3_only_result(data1);
                    [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data1);
                    temp_average_sym=abs(mean_num-median_num)/loop_length+temp_average_sym;
                    temp_average_acf=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf;
%                     data3=wavedata_2_binary(data1,judgment_threshold);
%                     data4=wavedata_2_binary(data2,judgment_threshold);
%                     data5=xor(data3,data4);
%                     [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data5);
%                     temp_average_acf_xor=max(abs(maxnum),abs(minnum))/loop_length+temp_average_acf_xor;%acf(xor)      
%                     clear data3 data4 data5
%                     temp_average_sym=0;
%                     temp_average_acf=0;
%                     temp_average_acf_xor=0;
                end        
            end
            num_str=get_ordered_str_4(hObject, eventdata, handles,i);
            bin_add=fullfile(bindata_address_2,['huye_',num_str]);
            message=cell(1,1);
            message{1,1}=['>generate bin fle: huye_',num_str,'.bin.....'];
            write_tdc_information(hObject, eventdata, handles,message);
            status_slider_Callback(hObject, eventdata, handles);
            generation_test_file(bin_add,data1,data2,judgment_threshold,3,0,1);%覆盖，不作处理，bin         
            end
            if label_record==1
                 excel_range=['L',num2str(tabel_num),':M',num2str(tabel_num)]; 
               % write_excel_single(filespec_excel,data_excel,excel_range);%wps必须
                 xlswrite(filespec_excel,{roundn(temp_average_sym,-5),roundn(temp_average_acf,-5)},'sheet1',excel_range);  
            end
            time=etime(clock,t0);
            set_run_time(hObject, eventdata, handles,time,'n1');
        end
        write_doc_save(filespec_doc);
        subject=[dir_name,'-OK!'];
        fid=fopen('.\doc_serial\error_message_auto.txt','r');
        message=textscan(fid,'%[^\n]');
        content=message{1,1}';
        my_content='you will see the error_message below:';
        for i=1:length(content)
            my_content=[my_content,char(10)',content{1,i}];
        end
        fclose(fid);
        if get(handles.email_checkbox,'Value')==1
        try
            qq=get(handles.qq_edit,'String');
            if label_record==1                
                MySendMail(qq,subject,my_content,filespec_doc);
            else
                MySendMail_simple(qq,subject,my_content);
            end
            disp('Email is sent OK!!');
            message=cell(1,1);
            message{1,1}='>Email is sent OK!!';
            write_tdc_information(hObject, eventdata, handles,message);
            status_slider_Callback(hObject, eventdata, handles);
        catch
            disp('Network isnt connected(Email)!');
            message=cell(1,1);
            message{1,1}='>Network isnt connected(Email)!';
            write_tdc_information(hObject, eventdata, handles,message);
            status_slider_Callback(hObject, eventdata, handles);
        end
        end
        time=etime(clock,t1);
        set_run_time(hObject, eventdata, handles,time,'n2');
    end
    set(handles.nist_button,'Enable','on'); 
    time=etime(clock,t2);
    set_run_time(hObject, eventdata, handles,time,'n3');
else    
    message=cell(1,1);
    message{1,1}='>Please make the TDC and OSC connectivity!';
    write_tdc_information(hObject, eventdata, handles,message);
    status_slider_Callback(hObject, eventdata, handles);
end
end


% --- Executes on button press in record_checkbox.
function record_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to record_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of record_checkbox


% --- Executes on button press in email_checkbox.
function email_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to email_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of email_checkbox



function qq_edit_Callback(hObject, eventdata, handles)
% hObject    handle to qq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qq_edit as text
%        str2double(get(hObject,'String')) returns contents of qq_edit as a double


% --- Executes during object creation, after setting all properties.
function qq_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qq_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function information_menu_Callback(hObject, eventdata, handles)
% hObject    handle to information_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
note();


% --- Executes on button press in control_average_checkbox.
function control_average_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to control_average_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of control_average_checkbox
