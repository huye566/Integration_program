function varargout = My_RNG(varargin)
% MY_RNG MATLAB code for My_RNG.fig
%      MY_RNG, by itself, creates a new MY_RNG or raises the existing
%      singleton*.
%
%      H = MY_RNG returns the handle to a new MY_RNG or the handle to
%      the existing singleton*.
%
%      MY_RNG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MY_RNG.M with the given input arguments.
%
%      MY_RNG('Property','Value',...) creates a new MY_RNG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before My_RNG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to My_RNG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help My_RNG

% Last Modified by GUIDE v2.5 13-Feb-2017 22:08:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @My_RNG_OpeningFcn, ...
                   'gui_OutputFcn',  @My_RNG_OutputFcn, ...
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


% --- Executes just before My_RNG is made visible.
function My_RNG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to My_RNG (see VARARGIN)

% Choose default command line output for My_RNG
handles.output = hObject;

%base-noise----
global base_noise
base_noise=[];
% base_noise=dlmread('.\sample_data\10mv_div\bpd_no_signal_base_noise.dat');
%bpd_no_signal_base_noise.dat
%no_pd_base_noise.dat
%pd_no_signal_base_noise.dat

handles.Fs=40e9;
global time_folder
time=datestr(now,15);
time=strrep(time,':','-');
time_folder=[datestr(now,29),' ',time];

% Update handles structure
guidata(hObject, handles);

check_freespace(hObject, eventdata, handles);
% make_folder(hObject, eventdata, handles);

%---clear tdc_information.text
fid=fopen('.\doc_serial\tdc_information.txt','w');
fprintf(fid,'Welcome!--made by huye:)!!');
fprintf(fid,'\r\n');
fclose(fid);
tdc_status_slider_Callback(hObject, eventdata, handles);

global table_info
[~,~,table_info]=xlsread('.\doc_serial\table_message.xlsx');
table_info{2,6}=num2str(table_info{2,6});
table_info{2,5}=num2str(table_info{2,5});



%---control_panel
set(handles.tool_panel,'Visible','on');
set(handles.rng_analyse_panel,'Visible','off');

%---cycle_model
global label_cycle_type
label_cycle_type=0;
set(handles.tdc_ds_cycle_radiobutton,'value',1);
set(handles.tdc_ico_cycle_radiobutton,'value',0);
set(handles.cycle_pane,'Title','DS');
%---control_model
global label_control
label_control=0;
set(handles.tdc_cycle_delay_radiobutton,'value',1);
set(handles.tdc_cycle_pause_radiobutton,'value',0);

set(handles.time_domain_sym_radiobutton,'Value',1);
set(handles.time_domain_td_radiobutton,'Value',0);

%---cycle_stop
global label_cycle_stop
label_cycle_stop=0;
%---cycle_continue
global label_cycle_continue
label_cycle_continue=0;

%---osc_connect
global interfaceObj
global deviceObj
global label_osc_connect
interfaceObj='';
deviceObj='';
label_osc_connect=0;

%---osc_parameter
% global osc_info_head
% osc_info_head=cell(1,11);
% osc_info_head{1,1}='>Device info: ';
% osc_info_head{1,2}='>IP: ';
% osc_info_head{1,3}='>Port: ';
% osc_info_head{1,4}='>Connectivity: ';
% osc_info_head{1,5}='>Channel3: ';
% osc_info_head{1,6}='>Fs: ';
% osc_info_head{1,7}='>DataLength: ';
% osc_info_head{1,8}='>Timebase: ';
% osc_info_head{1,9}='>BandWidth: ';
% osc_info_head{1,10}='>Amplitude: ';
% osc_info_head{1,11}='>State: ';
global osc_info
osc_info=cell(1,11);
osc_info{1,1}='NULL! ';
osc_info{1,2}='169.254.61.13';
osc_info{1,3}='1861';
osc_info{1,4}='disconnect!';%%%%%%
osc_info{1,5}='off';
osc_info{1,6}='40Gss';
osc_info{1,7}='8e6';
osc_info{1,8}='20us';
osc_info{1,9}='Full';
osc_info{1,10}='50mV';
osc_info{1,11}='auto';
global label_osc_info
label_osc_info=zeros(1,3);
%---select channel
global label_osc_channel
label_osc_channel=3;
set(handles.osc_initial_channel1_radiobutton,'value',0);
set(handles.osc_initial_channel2_radiobutton,'value',0);
set(handles.osc_initial_channel3_radiobutton,'value',1);
set(handles.osc_initial_channel4_radiobutton,'value',0);

%---wave_model
global label_wave
label_wave=0;
set(handles.osc_set_wave_single_radiobutton,'value',1);
set(handles.osc_set_wave_continue_radiobutton,'value',0);

global all_status_info
all_status_info=cell(1,6);
all_status_info{1,1}='Unknown';
global tdc_num_info
tdc_num_info='';

global label_word_count
label_word_count=zeros(1,7);

global label_x_end
label_x_end=zeros(1,3);

global diehard_data_all
diehard_data_all=zeros(4,400);

global label_diehard_stop
label_diehard_stop=0;

global label_diehard_cycle_stop
label_diehard_cycle_stop=0;

global judgment_threshold
judgment_threshold='mean';

global label_make_folder
label_make_folder=0;

addpath(genpath('.\test_tool_nd'));
addpath(genpath('.\control'));
addpath(genpath('.\writing_file'));
% addpath(genpath('.\email_send'));
addpath('C:\MATLAB\R2016b\toolbox\instrument\instrument\drivers');
addpath(genpath('.\processing_data'));
addpath(genpath('.\Plug_in Fun'));
addpath(genpath('.\other_tool'));

global serial_obj
global label_open%用于判断com口是否打开
label_open=0;
serial_obj='nocom';

global SA_obj
global SA_open_label
SA_obj='';
SA_open_label=0;

global OSA_obj
global OSA_open_label
OSA_obj='';
OSA_open_label=0;

file_head=get(handles.osc_wavefile_add_text,'String');
if ~exist(file_head,'dir')
    mkdir(file_head);
end
temp_bin_add=get_all_file(file_head,'*.dat');
length_file=length(temp_bin_add);
file_num=get_ordered_str(hObject, eventdata, handles,length_file+1);
set(handles.osc_file_name_text,'String',['File_name(Next):  ','C',num2str(label_osc_channel),'_',file_num,'.dat']);


% UIWAIT makes My_RNG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = My_RNG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function check_freespace(hObject, eventdata, handles)
diskspace_s=java.io.File(get(handles.path_text,'String'));
freespace_s=floor(diskspace_s.getFreeSpace/(1024*1024*1024));
set(handles.freespace_text,'String',[num2str(freespace_s),'GB']);

function make_folder(hObject, eventdata, handles)
global time_folder
path_head=get(handles.path_text,'String');
check_freespace(hObject, eventdata, handles);
handles.tool_single_folder=[path_head,'\tool\Single\',time_folder];
handles.tool_continue_folder=[path_head,'\tool\Continue\',time_folder];
handles.tool_single_word=[handles.tool_single_folder,'\tool_huye_single.docx'];
handles.tool_single_excel=[handles.tool_single_folder,'\tool_huye_single.xlsx'];
if ~exist(handles.tool_single_folder,'dir') 
    mkdir(handles.tool_single_folder);        % 若不存在，在当前目录中产生一个子目录‘Figure’
end
if ~exist(handles.tool_continue_folder,'dir') 
    mkdir(handles.tool_continue_folder);        % 若不存在，在当前目录中产生一个子目录‘Figure’
end
handles.rng_single_folder=[path_head,'\rng\Single\',time_folder];
handles.rng_cycle_folder=[path_head,'\rng\Cycle\',time_folder];
handles.rng_single_word=[handles.rng_single_folder,'\rng_huye_single.docx'];
handles.rng_single_excel=[handles.rng_single_folder,'\rng_huye_single.xlsx'];
handles.rng_single_diehard_excel=[handles.rng_single_folder,'rng_huye_single_diehard.xlsx'];
if ~exist(handles.rng_single_folder,'dir') 
    mkdir(handles.rng_single_folder);        % 若不存在，在当前目录中产生一个子目录‘Figure’
end
if ~exist(handles.rng_cycle_folder,'dir') 
    mkdir(handles.rng_cycle_folder);        % 若不存在，在当前目录中产生一个子目录‘Figure’
end
handles.rng_nist=[path_head,'\rng\nist\',time_folder];
if ~exist(handles.rng_nist,'dir') 
    mkdir(handles.rng_nist);        % 若不存在，在当前目录中产生一个子目录‘Figure’
end
%清空xls 
if exist(handles.tool_single_excel,'file')
    delete(handles.tool_single_excel);
end
[~,~,figure_head]=xlsread('.\doc_serial\figure_status_head.xlsx');
% write_excel_single(handles.tool_single_excel,figure_head,'A1:K1');%wps必须
xlswrite(handles.tool_single_excel,figure_head,'sheet1','A1:K1');
%清空xls 
if exist(handles.rng_single_excel,'file')
    delete(handles.rng_single_excel);
end
[~,~,figure_head]=xlsread('.\doc_serial\figure_status_head_plus.xlsx');
% write_excel_single(handles.rng_single_excel,figure_head,'A1:O1');%wps必须
xlswrite(handles.rng_single_excel,figure_head,'sheet1','A1:O1');
%---diehard_result
diehard_test_name=cell(1,21);
diehard_test_name{1,1}='data_info';
diehard_test_name{1,21}='sum_pass';
[~,diehard_test_name(2:20),~]=xlsread('.\doc_serial\diehard_test_name.xlsx');
%写入相关信息
%清除老文件
if exist(handles.rng_single_diehard_excel,'file')
    delete(handles.rng_single_diehard_excel);
end
%for office
xlswrite(handles.rng_single_diehard_excel,diehard_test_name,'A1:U1');
%for wps
%write_excel_for_diehard(handles.rng_single_diehard_excel,diehard_test_name,'A1:U1');
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in path_select_button.
function path_select_button_Callback(hObject, eventdata, handles)
% hObject    handle to path_select_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_make_folder
original_path=get(handles.path_text,'String');
path_head=uigetdir(original_path);
if ~isempty(path_head)&&strcmp(path_head,original_path)~=1
    set(handles.path_text,'String',path_head);
    label_make_folder=0;
    %make_folder(hObject, eventdata, handles);
end


% --- Executes on button press in tdc_initial_button.
function tdc_initial_button_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_initial_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.tdc_com_parameter_pane,'Visible','on');
global serial_obj
global label_open%用于判断com口是否打开
[serial_obj,label_open] = COM_parameter(serial_obj,label_open);
if label_open==1
    set(handles.tdc_initial_status_text,'BackgroundColor',[0 0.498 0]);
    set(handles.tdc_initial_status_text,'String','OK');
else
    set(handles.tdc_initial_status_text,'BackgroundColor',[1 0 0]);
    set(handles.tdc_initial_status_text,'String','NULL');
end


% --- Executes on button press in tdc_single_confirm_button.
function tdc_single_confirm_button_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_single_confirm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global serial_obj
global label_open%用于判断com口是否打开
global label_cycle_stop
label_cycle_stop=0;
ds_command=get(handles.tdc_single_ds_edit,'String');
ico_command=get(handles.tdc_single_ico_edit,'String');
label_connect=tdc_connect_test(hObject, eventdata, handles,label_open,serial_obj);
if label_connect==0
    serial_obj='nocom';
    label_open=0;
else
    set(handles.tdc_cycle_confirm_button,'Enable','off');        
    ds_command=['ds set ',ds_command];
    tdc_information_ds=tdc_state_test(hObject, eventdata, handles,ds_command,serial_obj);
    write_tdc_information(hObject, eventdata, handles,tdc_information_ds);
    tdc_status_slider_Callback(hObject, eventdata, handles);    
    ico_command=['ds ico ',ico_command];
    tdc_information_ico=tdc_state_test(hObject, eventdata, handles,ico_command,serial_obj);
    write_tdc_information(hObject, eventdata, handles,tdc_information_ico);
    tdc_status_slider_Callback(hObject, eventdata, handles);
    set(handles.tdc_cycle_confirm_button,'Enable','on');
end

%----tdc连通检测程序    
function label_connect=tdc_connect_test(hObject, eventdata, handles,label_open_temp,serial_obj_temp)
label_connect=0;
if label_open_temp==0
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show('Please select com port firstly!','Information',...
        MessageBoxButtons.OK,MessageBoxIcon.Information);    
else 
    getcom=instrhwinfo('serial');%获取可用串口
    com_available=getcom.AvailableSerialPorts;
    if isempty(com_available)==1
        NET.addAssembly('System.Windows.Forms');
        import System.Windows.Forms.*;
        MessageBox.Show('No available COM port!','Information',...
            MessageBoxButtons.OK,MessageBoxIcon.Information);
        set(handles.tdc_initial_status_text,'BackgroundColor',[1 0 0]);
        set(handles.tdc_initial_status_text,'String','NULL');
    else
        if strcmp(com_available,serial_obj_temp.Port)==0
            NET.addAssembly('System.Windows.Forms');
            import System.Windows.Forms.*;
            MessageBox.Show('COM port is not right!','Information',...
                MessageBoxButtons.OK,MessageBoxIcon.Information);
            set(handles.tdc_initial_status_text,'BackgroundColor',[1 0 0]);
            set(handles.tdc_initial_status_text,'String','NULL');
        else
                try
                    fopen(serial_obj_temp);
                    if strcmp(serial_obj_temp.status,'closed')==1
                        NET.addAssembly('System.Windows.Forms');
                        import System.Windows.Forms.*;
                        MessageBox.Show('COM port is not opened!','Information',...
                            MessageBoxButtons.OK,MessageBoxIcon.Information);
                        set(handles.tdc_initial_status_text,'BackgroundColor',[1 0 0]);
                        set(handles.tdc_initial_status_text,'String','NULL');
                    else
                       fclose(serial_obj_temp);
                       label_connect=1; 
                    end
                catch
                        NET.addAssembly('System.Windows.Forms');
                        import System.Windows.Forms.*;
                        MessageBox.Show('COM port can not be opened!','Information',...
                            MessageBoxButtons.OK,MessageBoxIcon.Information);
                        set(handles.tdc_initial_status_text,'BackgroundColor',[1 0 0]);
                        set(handles.tdc_initial_status_text,'String','NULL');                  
                end
        end
     end
end

%---tdc状态稳定自检
function tdc_information=tdc_state_test(hObject, eventdata, handles,tdc_command_temp,serial_obj_temp)
global label_cycle_stop
global table_info
tdc_command(serial_obj_temp,tdc_command_temp);
isok=0;
error_loop=0;
temp_text=cell(1,2);
temp_text{1,1}=['>',tdc_command_temp];
temp_text{1,2}='>waiting.................';
write_tdc_information(hObject, eventdata, handles,temp_text);
tdc_status_slider_Callback(hObject, eventdata, handles);
while(isok==0)
   [isok,BW,tdc_information]=tdc_command(serial_obj_temp,'ds');
   error_loop=error_loop+1;
   if error_loop>500
      error_date=datestr(now,31);
      fid=fopen('.\doc_serial\tdc_error_message.txt','a');
      fprintf(fid,error_date);
      fprintf(fid,'\r\n');
      fprintf(fid,['Error: ',tdc_command_temp,',The TDC is always busy!!']);
      fprintf(fid,'\r\n');
      fclose(fid);
      %pause;
      isok=1;
   end
   table_info{1,6}=['ICO/',BW,' GHz'];
   drawnow;
   if label_cycle_stop==1
       return;%只退出当前子函数
   end
end


% --- Executes on button press in tdc_ds_cycle_radiobutton.
function tdc_ds_cycle_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_ds_cycle_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_cycle_type
label_cycle_type=0;
set(handles.tdc_ds_cycle_radiobutton,'value',1);
set(handles.tdc_ico_cycle_radiobutton,'value',0);
set(handles.cycle_pane,'Title','DS');
set(handles.tdc_cycle_single_text,'String','ICO:');
set(handles.tdc_cycle_range_text,'String','DS_range:');
set(handles.tdc_cycle_single_edit,'String','0');
set(handles.tdc_cycle_start_edit,'String','0');
set(handles.tdc_cycle_stop_edit,'String','2100');

% Hint: get(hObject,'Value') returns toggle state of tdc_ds_cycle_radiobutton


% --- Executes on button press in tdc_ico_cycle_radiobutton.
function tdc_ico_cycle_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_ico_cycle_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_cycle_type
label_cycle_type=1;
set(handles.tdc_ds_cycle_radiobutton,'value',0);
set(handles.tdc_ico_cycle_radiobutton,'value',1);
set(handles.cycle_pane,'Title','ICO');
set(handles.tdc_cycle_single_text,'String','DS:');
set(handles.tdc_cycle_range_text,'String','ICO_range:');
set(handles.tdc_cycle_single_edit,'String','0');
set(handles.tdc_cycle_start_edit,'String','0');
set(handles.tdc_cycle_stop_edit,'String','98');
% Hint: get(hObject,'Value') returns toggle state of tdc_ico_cycle_radiobutton

% --- Executes on button press in tdc_cycle_delay_radiobutton.
function tdc_cycle_delay_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_delay_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_control
label_control=0;
set(handles.tdc_cycle_delay_radiobutton,'value',1);
set(handles.tdc_cycle_pause_radiobutton,'value',0);
% Hint: get(hObject,'Value') returns toggle state of tdc_cycle_delay_radiobutton

% --- Executes on button press in tdc_cycle_pause_radiobutton.
function tdc_cycle_pause_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_pause_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_control
label_control=1;
set(handles.tdc_cycle_delay_radiobutton,'value',0);
set(handles.tdc_cycle_pause_radiobutton,'value',1);
% Hint: get(hObject,'Value') returns toggle state of tdc_cycle_pause_radiobutton

function tdc_cycle_delay_model(hObject, eventdata, handles)
global label_control
global label_cycle_continue
if label_control==0
    list=get(handles.tdc_cycle_delay_popupmenu,'String');
    if iscell(list)
        time_delay_list=get(handles.tdc_cycle_delay_popupmenu,'value');
        time_delay=str2double(list{time_delay_list});
    else
        time_delay=str2double(list);
    end
    pause(time_delay);
else
    %pause;
    while(1)
        drawnow;
        if label_cycle_continue==1
            label_cycle_continue=0;
            return;
        end
%         disp('???????');
    end
end

% --- Executes on button press in tdc_cycle_confirm_button.
function tdc_cycle_confirm_button_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_confirm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_cycle_type
global serial_obj
global label_open%用于判断com口是否打开
global label_cycle_stop
global label_cycle_continue
label_cycle_stop=0;
label_cycle_continue=0;
label_connect=tdc_connect_test(hObject, eventdata, handles,label_open,serial_obj);
if label_connect==0
    serial_obj='nocom';
    label_open=0;
else
    set(handles.tdc_single_confirm_button,'Enable','off');
    if label_cycle_type==0
    %-----考虑超出范围的问题
    %--新增代码
    %---------------------------
    ds_start=str2double(get(handles.tdc_cycle_start_edit,'String'));
    ds_stop=str2double(get(handles.tdc_cycle_stop_edit,'String'));
    list=get(handles.tdc_cycle_step_popupmenu,'String');
    if iscell(list)
        ds_step_list=get(handles.tdc_cycle_step_popupmenu,'value');
        ds_step=str2double(list{ds_step_list});
    else
        ds_step=str2double(list);
    end
    if ds_stop<ds_start
        tdc_information_error=cell(1,1);
        tdc_information_error{1,1}='>ICO range is error!!';
        write_tdc_information(hObject, eventdata, handles,tdc_information_error);
        set(handles.tdc_single_confirm_button,'Enable','on');
        return;
    end
    ico_command=get(handles.tdc_cycle_single_edit,'String');
    set(handles.tdc_single_ico_edit,'String',ico_command);
    ico_command=['ds ico ',ico_command];
    tdc_information_ico=tdc_state_test(hObject, eventdata, handles,ico_command,serial_obj);
    write_tdc_information(hObject, eventdata, handles,tdc_information_ico);
    tdc_status_slider_Callback(hObject, eventdata, handles);    
    for i=ds_start:ds_step:ds_stop
        ds_command=['ds set ',num2str(i)];
        set(handles.tdc_single_ds_edit,'String',num2str(i));
        tdc_information_ds=tdc_state_test(hObject, eventdata, handles,ds_command,serial_obj);
        write_tdc_information(hObject, eventdata, handles,tdc_information_ds);
        tdc_status_slider_Callback(hObject, eventdata, handles);
        if label_cycle_stop==1
            label_cycle_stop=0;
            set(handles.tdc_single_confirm_button,'Enable','on');
            return;
        end
        tdc_cycle_delay_model(hObject, eventdata, handles);
    end  
    else
    %-----考虑超出范围的问题
    %--新增代码
    %---------------------------
    ico_start=str2double(get(handles.tdc_cycle_start_edit,'String'));
    ico_stop=str2double(get(handles.tdc_cycle_stop_edit,'String'));
    list=get(handles.tdc_cycle_step_popupmenu,'String');
    if iscell(list)
        ico_step_list=get(handles.tdc_cycle_step_popupmenu,'value');
        ico_step=str2double(list{ico_step_list});
    else
        ico_step=str2double(list);
    end
    if ico_stop<ico_start       
        tdc_information_error=cell(1,1);
        tdc_information_error{1,1}='>ICO range is error!!';
        write_tdc_information(hObject, eventdata, handles,tdc_information_error);
        tdc_status_slider_Callback(hObject, eventdata, handles);
        set(handles.tdc_single_confirm_button,'Enable','on');
        return;
    end
    ds_command=get(handles.tdc_cycle_single_edit,'String');
    set(handles.tdc_single_ds_edit,'String',ds_command);
    ds_command=['ds set ',ds_command];
    tdc_information_ds=tdc_state_test(hObject, eventdata, handles,ds_command,serial_obj);
    write_tdc_information(hObject, eventdata, handles,tdc_information_ds);
    tdc_status_slider_Callback(hObject, eventdata, handles);    
    for i=ico_start:ico_step:ico_stop
        ico_command=['ds ico ',num2str(i)];
        set(handles.tdc_single_ico_edit,'String',num2str(i));
        tdc_information_ico=tdc_state_test(hObject, eventdata, handles,ico_command,serial_obj);
        write_tdc_information(hObject, eventdata, handles,tdc_information_ico);
        tdc_status_slider_Callback(hObject, eventdata, handles);       
        if label_cycle_stop==1
            label_cycle_stop=0;
            set(handles.tdc_single_confirm_button,'Enable','on');
            return;
        end
        tdc_cycle_delay_model(hObject, eventdata, handles);
    end  
    end
    set(handles.tdc_single_confirm_button,'Enable','on');
end

% --- Executes on button press in tdc_cycle_stop_button.
function tdc_cycle_stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_cycle_stop
label_cycle_stop=1;
set(handles.tdc_cycle_confirm_button,'Enable','on');
set(handles.tdc_single_confirm_button,'Enable','on');


% --- Executes on button press in tdc_cycle_continue_button.
function tdc_cycle_continue_button_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_continue_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_cycle_continue
label_cycle_continue=1;


function tdc_single_ds_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_single_ds_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ds=str2double(get(hObject,'String'));
if isnan(inpchk(ds,[-2100 2100],[1,1]))
    set(hObject,'String','0');
else
    set(hObject,'String',num2str(floor(ds)));
end
% Hints: get(hObject,'String') returns contents of tdc_single_ds_edit as text
%        str2double(get(hObject,'String')) returns contents of tdc_single_ds_edit as a double


% --- Executes during object creation, after setting all properties.
function tdc_single_ds_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdc_single_ds_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tdc_single_ico_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_single_ico_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ico=str2double(get(hObject,'String'));
if isnan(inpchk(ico,[-99 99],[1,1]))
    set(hObject,'String','0');
else
    set(hObject,'String',num2str(floor(ico)));
end
% Hints: get(hObject,'String') returns contents of tdc_single_ico_edit as text
%        str2double(get(hObject,'String')) returns contents of tdc_single_ico_edit as a double


% --- Executes during object creation, after setting all properties.
function tdc_single_ico_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdc_single_ico_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tdc_cycle_delay_popupmenu.
function tdc_cycle_delay_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_delay_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tdc_cycle_delay_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tdc_cycle_delay_popupmenu


% --- Executes during object creation, after setting all properties.
function tdc_cycle_delay_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_delay_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tdc_cycle_single_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_single_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_cycle_type
if label_cycle_type==0
    ico=str2double(get(hObject,'String'));
    if isnan(inpchk(ico,[-99 99],[1,1]))
        set(hObject,'String','0');
    else
        set(hObject,'String',num2str(floor(ico)));
    end
else
    ds=str2double(get(hObject,'String'));
    if isnan(inpchk(ds,[-2100 2100],[1,1]))
        set(hObject,'String','0');
    else
        set(hObject,'String',num2str(floor(ds)));
    end
end
% Hints: get(hObject,'String') returns contents of tdc_cycle_single_edit as text
%        str2double(get(hObject,'String')) returns contents of tdc_cycle_single_edit as a double


% --- Executes during object creation, after setting all properties.
function tdc_cycle_single_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_single_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function tdc_cycle_stop_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_stop_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_cycle_type
if label_cycle_type==0
    ds=str2double(get(hObject,'String'));
    ds_start=str2double(get(handles.tdc_cycle_start_edit,'String'));
    if isnan(inpchk(ds,[ds_start 2100],[1,1]))
        set(hObject,'String','0');
    else
        set(hObject,'String',num2str(floor(ds)));
    end
else
    ico=str2double(get(hObject,'String'));
    ico_start=str2double(get(handles.tdc_cycle_start_edit,'String'));
    if isnan(inpchk(ico,[ico_start 99],[1,1]))
        set(hObject,'String','0');
    else
        set(hObject,'String',num2str(floor(ico)));
    end
end
% Hints: get(hObject,'String') returns contents of tdc_cycle_stop_edit as text
%        str2double(get(hObject,'String')) returns contents of tdc_cycle_stop_edit as a double


% --- Executes during object creation, after setting all properties.
function tdc_cycle_stop_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_stop_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tdc_cycle_start_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_start_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_cycle_type
if label_cycle_type==0
    ds=str2double(get(hObject,'String'));
    ds_stop=str2double(get(handles.tdc_cycle_stop_edit,'String'));
    if isnan(inpchk(ds,[-2100 2100],[1,1]))
        set(hObject,'String','0');
    else
        if ds>ds_stop            
            set(handles.tdc_cycle_stop_edit,'String',num2str(floor(ds)));
        end
        set(hObject,'String',num2str(floor(ds)));
    end
else
    ico=str2double(get(hObject,'String'));
    ico_stop=str2double(get(handles.tdc_cycle_stop_edit,'String'));
    if isnan(inpchk(ico,[-99 99],[1,1]))
        set(hObject,'String','0');
    else
        if ico>ico_stop            
            set(handles.tdc_cycle_stop_edit,'String',num2str(floor(ico)));
        end
        set(hObject,'String',num2str(floor(ico)));
    end
end
% Hints: get(hObject,'String') returns contents of tdc_cycle_start_edit as text
%        str2double(get(hObject,'String')) returns contents of tdc_cycle_start_edit as a double


% --- Executes during object creation, after setting all properties.
function tdc_cycle_start_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_start_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tdc_cycle_step_popupmenu.
function tdc_cycle_step_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_step_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tdc_cycle_step_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tdc_cycle_step_popupmenu


% --- Executes during object creation, after setting all properties.
function tdc_cycle_step_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdc_cycle_step_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function tdc_status_slider_Callback(hObject, eventdata, handles)
% hObject    handle to tdc_status_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid=fopen('.\doc_serial\tdc_information.txt','r');
message=textscan(fid,'%[^\n]');
message=message{1,1}';
message_length=length(message);
length_text=21;
if message_length<length_text
    set(handles.tdc_status_text,'String',message);
    set(handles.tdc_status_slider,'SliderStep',[1,1]);
else
    set(handles.tdc_status_slider,'SliderStep',[1/(message_length-length_text+1),1/(message_length-length_text+1)]);
    add_value=get(handles.tdc_status_slider,'Value');
    add_value=1-add_value;
    add_value=floor((message_length-length_text+1)*add_value);
    set(handles.tdc_status_text,'String',message(1+add_value:length_text-1+add_value));
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


%---write_information
function write_tdc_information(hObject, eventdata, handles,message)
fid=fopen('.\doc_serial\tdc_information.txt','a');
info_date=datestr(now,31);
fprintf(fid,['>>',info_date]);
fprintf(fid,'\r\n');
for i=1:length(message)
    fprintf(fid,message{1,i});
    fprintf(fid,'\r\n');
end
fclose(fid);




% --- Executes during object creation, after setting all properties.
function tdc_status_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tdc_status_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%---osc_connect_test
function osc_connect_test(hObject, eventdata, handles)
global deviceObj
global osc_info
global label_osc_info
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
        osc_info{1,1}=identify_ifo;
        osc_info{1,4}='connecting!';
        osc_info{1,5}=get(deviceObj.Channel(label_osc_channel),'State');       
        time_base=get(deviceObj.Acquisition(1),'Timebase');
        if time_base*1e12<1000
            osc_info{1,8}=[num2str(time_base*1e12),'ps'];
        else
            if time_base*1e9<1000
                osc_info{1,8}=[num2str(time_base*1e9),'ns'];
            else
                if time_base*1e6<1000
                    osc_info{1,8}=[num2str(time_base*1e6),'us'];                  
                else
                    osc_info{1,8}=[num2str(time_base*1e3),'ms'];
                end
            end
        end
        if time_base*handles.Fs*10<1e6
            osc_info{1,7}=num2str(time_base*handles.Fs*10);
        else
            osc_info{1,7}=[num2str(floor(time_base*handles.Fs*10/1e6)),'e6'];
        end
        scale=get(deviceObj.Channel(label_osc_channel),'Scale');
        bandwidthlimit=get(deviceObj.Channel(label_osc_channel),'BandwidthLimit');
        if strcmp(bandwidthlimit,'off')==1
            osc_info{1,9}='Full';
        else
            osc_info{1,9}=bandwidthlimit;
        end
        osc_info{1,10}=[num2str(scale*1e3),'mV'];
        osc_info{1,11}=get(deviceObj.Acquisition(1),'Control');
        label_osc_connect=1;
        label_osc_info(:)=1;
        disp('The instrument is right!');
        set(handles.osc_status_text,'String','The instrument is right!');
        disconnect(deviceObj);
    else
        disp('The instrument is unmatched!');
        set(handles.osc_status_text,'String','The instrument is unmatched!');
        osc_info{1,1}='NULL!';
        osc_info{1,4}='disconnect!';
        osc_info{1,5}='off'; 
        label_osc_connect=0;
        label_osc_info(:)=0;
        disconnect(deviceObj);
    end
catch
    disp('Network isnt connected!');
    disconnect(deviceObj);
    osc_info{1,1}='NULL!';
    osc_info{1,4}='disconnect!';
    osc_info{1,5}='off';
    set(handles.osc_status_text,'String','Network isnt connected!')
    label_osc_connect=0;
    label_osc_info(:)=0;
end

%---write_osc_status
function write_osc_status(hObject, eventdata, handles)
global osc_info
global label_osc_info
global label_osc_connect
global label_osc_channel
if label_osc_connect==0
    set(handles.osc_initial_text,'String','NULL');
    set(handles.osc_initial_text,'BackgroundColor',[1 0 0]);
else
    set(handles.osc_initial_text,'String','OK');
    set(handles.osc_initial_text,'BackgroundColor',[0 0.498 0]);
end
set(handles.osc_info_1,'String',osc_info{1,1});
if label_osc_info(1)==0
    set(handles.osc_info_1,'ForegroundColor',[1 0 0]);
else
    set(handles.osc_info_1,'ForegroundColor',[0.078 0.169 0.549]);
end
set(handles.osc_info_2,'String',osc_info{1,2});
set(handles.osc_info_3,'String',osc_info{1,3});
set(handles.osc_info_4,'String',osc_info{1,4});
if label_osc_info(2)==0
    set(handles.osc_info_4,'ForegroundColor',[1 0 0]);
else
    set(handles.osc_info_4,'ForegroundColor',[0 0.498 0]);
end
set(handles.osc_info_5,'String',osc_info{1,5});
set(handles.osc_info_head_5,'String',['Channel',num2str(label_osc_channel),':'])
if label_osc_info(3)==0
    set(handles.osc_info_5,'ForegroundColor',[1 0 0]);
else
    set(handles.osc_info_5,'ForegroundColor',[0 0.498 0]);
end
set(handles.osc_info_6,'String',osc_info{1,6});
set(handles.osc_info_7,'String',osc_info{1,7});
set(handles.osc_info_8,'String',osc_info{1,8});
set(handles.osc_info_9,'String',osc_info{1,9});
set(handles.osc_info_10,'String',osc_info{1,10});
set(handles.osc_info_11,'String',osc_info{1,11});


% --- Executes on button press in osc_initial_button.
function osc_initial_button_Callback(hObject, eventdata, handles)
% hObject    handle to osc_initial_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%parameter of osc
% text(0.5,0.5,'\color{red}red\color{blue}blue');
global interfaceObj
global deviceObj
osc_ip='192.168.1.110';
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
write_osc_status(hObject, eventdata, handles);
    


% --- Executes on selection change in osc_set_bandwidth_popupmenu.
function osc_set_bandwidth_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_bandwidth_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global osc_info
global deviceObj
global label_osc_channel
if label_osc_connect==1
    bandwidth_num=get(handles.osc_set_bandwidth_popupmenu,'Value');
    list=get(handles.osc_set_bandwidth_popupmenu,'String');
    bandwidth=list{bandwidth_num};
    try
    connect(deviceObj);   
    set(deviceObj.Channel(label_osc_channel),'BandwidthLimit',bandwidth);
    osc_info{1,9}=bandwidth;
    write_osc_status(hObject, eventdata, handles);
    disconnect(deviceObj);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
        set(handles.osc_set_bandwidth_popupmenu,'Value',1);
        set(handles.osc_status_text,'String','osc disconnect!!');
    end
else
    set(handles.osc_set_state_popupmenu,'Value',1);
    set(handles.osc_status_text,'String','osc disconnect!!');
end
% Hints: contents = cellstr(get(hObject,'String')) returns osc_set_bandwidth_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from osc_set_bandwidth_popupmenu


% --- Executes during object creation, after setting all properties.
function osc_set_bandwidth_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_set_bandwidth_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function osc_set_TB_slider_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_TB_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global osc_info
global deviceObj
if label_osc_connect==1
    timebase=get(handles.osc_set_TB_slider,'Value');
    timebase=floor(timebase*10);
    try
    connect(deviceObj);
    switch(timebase)
        case timebase<4
            timebase_num=1e-10;
            set(handles.osc_set_TB_text,'String','TB:100ps');
            set(deviceObj.Acquisition(1),'Timebase',timebase_num);
            time_base=get(deviceObj.Acquisition(1),'Timebase');  
            osc_info{1,8}=[num2str(time_base*1e12),'ps'];
            osc_info{1,7}=num2str(time_base*4e11);
        case 4
            timebase_num=1e-9;
            set(handles.osc_set_TB_text,'String','TB:1ns');
            set(deviceObj.Acquisition(1),'Timebase',timebase_num);
            time_base=get(deviceObj.Acquisition(1),'Timebase');
            osc_info{1,8}=[num2str(time_base*1e9),'ns'];
            osc_info{1,7}=num2str(time_base*4e11);
        case 5
            timebase_num=1e-8;
            set(handles.osc_set_TB_text,'String','TB:10ns');
            set(deviceObj.Acquisition(1),'Timebase',timebase_num);
            time_base=get(deviceObj.Acquisition(1),'Timebase');
            osc_info{1,8}=[num2str(time_base*1e9),'ns'];
            osc_info{1,7}=num2str(time_base*4e11);
        case 6
            timebase_num=1e-7;
            set(handles.osc_set_TB_text,'String','TB:100ns');
            set(deviceObj.Acquisition(1),'Timebase',timebase_num);
            time_base=get(deviceObj.Acquisition(1),'Timebase');
            osc_info{1,8}=[num2str(time_base*1e9),'ns'];
            osc_info{1,7}=num2str(time_base*4e11);
        case 7
            timebase_num=1e-6;
            set(handles.osc_set_TB_text,'String','TB:1us');
            set(deviceObj.Acquisition(1),'Timebase',timebase_num);
            time_base=get(deviceObj.Acquisition(1),'Timebase');
            osc_info{1,8}=[num2str(time_base*1e6),'us'];
            osc_info{1,7}=num2str(time_base*4e11);
        case 8
            timebase_num=1e-5;
            set(handles.osc_set_TB_text,'String','TB:10us');
            set(deviceObj.Acquisition(1),'Timebase',timebase_num);
            time_base=get(deviceObj.Acquisition(1),'Timebase');
            osc_info{1,8}=[num2str(time_base*1e6),'us'];
            osc_info{1,7}=[num2str(time_base*4e5),'e6'];
        case 9
            timebase_num=2e-5;
            set(handles.osc_set_TB_text,'String','TB:20us');
            set(deviceObj.Acquisition(1),'Timebase',timebase_num);
            time_base=get(deviceObj.Acquisition(1),'Timebase');
            osc_info{1,8}=[num2str(time_base*1e6),'us'];
            osc_info{1,7}=[num2str(time_base*4e5),'e6'];
        otherwise
            timebase_num=4e-5;
            set(handles.osc_set_TB_text,'String','TB:40us');
            set(deviceObj.Acquisition(1),'Timebase',timebase_num);
            time_base=get(deviceObj.Acquisition(1),'Timebase');
            osc_info{1,8}=[num2str(time_base*1e6),'us'];
            osc_info{1,7}=[num2str(time_base*4e5),'e6'];
    end  
    write_osc_status(hObject, eventdata, handles);
    disconnect(deviceObj);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        set(handles.osc_set_TB_slider,'value',0.9);
        set(handles.osc_set_TB_text,'String','TB:20us');
        set(handles.osc_status_text,'String','osc disconnect!!');
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
    end
else
    set(handles.osc_set_TB_slider,'value',0.9);
    set(handles.osc_set_TB_text,'String','TB:20us');
    set(handles.osc_status_text,'String','osc disconnect!!');
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function osc_set_TB_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_set_TB_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function osc_set_am_slider_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_am_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global osc_info
global deviceObj
global label_osc_channel
if label_osc_connect==1
    am=get(handles.osc_set_am_slider,'Value');
    am=(floor(am*49)*2+2);
    set(handles.osc_set_am_text,'String',[num2str(am),'mV']);
    try
    connect(deviceObj);   
    set(deviceObj.Channel(label_osc_channel),'Scale',am/1000);
    osc_info{1,10}=[num2str(am),'mV'];
    write_osc_status(hObject, eventdata, handles);
    disconnect(deviceObj);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        set(handles.osc_set_am_slider,'value',1);
        set(handles.osc_set_am_text,'String','Am:100mV');
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
        set(handles.osc_status_text,'String','osc disconnect!!');
    end
else
    set(handles.osc_set_am_slider,'value',1);
    set(handles.osc_set_am_text,'String','Am:100mV');
    set(handles.osc_status_text,'String','osc disconnect!!');
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function osc_set_am_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_set_am_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on selection change in osc_set_state_popupmenu.
function osc_set_state_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_state_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global osc_info
global deviceObj
global label_osc_channel
if label_osc_connect==1
    state_num=get(handles.osc_set_state_popupmenu,'Value');
    list=get(handles.osc_set_state_popupmenu,'String');
    state=list{state_num};
    try
    connect(deviceObj);   
    set(deviceObj.Channel(label_osc_channel),'State',state);
    osc_info{1,5}=state;
    write_osc_status(hObject, eventdata, handles);
    disconnect(deviceObj);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
        set(handles.osc_set_state_popupmenu,'Value',1);
        set(handles.osc_status_text,'String','osc disconnect!!');
    end
else
    set(handles.osc_set_state_popupmenu,'Value',1);
    set(handles.osc_status_text,'String','osc disconnect!!');
end

% Hints: contents = cellstr(get(hObject,'String')) returns osc_set_state_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from osc_set_state_popupmenu


% --- Executes during object creation, after setting all properties.
function osc_set_state_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_set_state_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in osc_initial_channel1_radiobutton.
function osc_initial_channel1_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_initial_channel1_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_channel
set(handles.osc_initial_channel1_radiobutton,'value',1);
set(handles.osc_initial_channel2_radiobutton,'value',0);
set(handles.osc_initial_channel3_radiobutton,'value',0);
set(handles.osc_initial_channel4_radiobutton,'value',0);
label_osc_channel=1;
handles.Fs=40e9;
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of osc_initial_channel1_radiobutton


% --- Executes on button press in osc_initial_channel2_radiobutton.
function osc_initial_channel2_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_initial_channel2_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_channel
set(handles.osc_initial_channel1_radiobutton,'value',0);
set(handles.osc_initial_channel2_radiobutton,'value',1);
set(handles.osc_initial_channel3_radiobutton,'value',0);
set(handles.osc_initial_channel4_radiobutton,'value',0);
label_osc_channel=2;
handles.Fs=40e9;
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of osc_initial_channel2_radiobutton


% --- Executes on button press in osc_initial_channel3_radiobutton.
function osc_initial_channel3_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_initial_channel3_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_channel
set(handles.osc_initial_channel1_radiobutton,'value',0);
set(handles.osc_initial_channel2_radiobutton,'value',0);
set(handles.osc_initial_channel3_radiobutton,'value',1);
set(handles.osc_initial_channel4_radiobutton,'value',0);
label_osc_channel=3;
handles.Fs=40e9;
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of osc_initial_channel3_radiobutton


% --- Executes on button press in osc_initial_channel4_radiobutton.
function osc_initial_channel4_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_initial_channel4_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_channel
set(handles.osc_initial_channel1_radiobutton,'value',0);
set(handles.osc_initial_channel2_radiobutton,'value',0);
set(handles.osc_initial_channel3_radiobutton,'value',0);
set(handles.osc_initial_channel4_radiobutton,'value',1);
label_osc_channel=4;
handles.Fs=40e9;
% Update handles structure
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of osc_initial_channel4_radiobutton


% --- Executes on button press in osc_set_wave_single_radiobutton.
function osc_set_wave_single_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_wave_single_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_wave
label_wave=0;
set(handles.osc_set_wave_single_radiobutton,'value',1);
set(handles.osc_set_wave_continue_radiobutton,'value',0);
% Hint: get(hObject,'Value') returns toggle state of osc_set_wave_single_radiobutton


% --- Executes on button press in osc_set_wave_continue_radiobutton.
function osc_set_wave_continue_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_wave_continue_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_wave
label_wave=1;
set(handles.osc_set_wave_single_radiobutton,'value',0);
set(handles.osc_set_wave_continue_radiobutton,'value',1);
% Hint: get(hObject,'Value') returns toggle state of osc_set_wave_continue_radiobutton


% --- Executes on button press in osc_set_wave_button.
function osc_set_wave_button_Callback(hObject, eventdata, handles)
% hObject    handle to osc_set_wave_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%与之后的区分
set(handles.type_text,'String','Wave_get:');
global label_wave
global label_osc_connect
global deviceObj
global label_open
get_all_status_info(hObject, eventdata, handles);%含通断检测功能
write_osc_status(hObject, eventdata, handles);
if get(handles.only_osc_radiobutton,'Value')==0&&label_open==0
    return;
end
if label_osc_connect==1
    if label_wave==0        
        connect(deviceObj);   
        show_control(hObject, eventdata, handles,1);
        disconnect(deviceObj);   
    else
        while(label_wave)
            drawnow;
            get_all_status_info(hObject, eventdata, handles);%含通断检测功能
            write_osc_status(hObject, eventdata, handles);
            connect(deviceObj);   
            show_control(hObject, eventdata, handles,2);
            disconnect(deviceObj); 
            %pause(10);
        end       
    end    
end
check_freespace(hObject, eventdata, handles);

function show_control(hObject, eventdata, handles,type)
t0=clock;%------------------------------------------
global deviceObj
global all_status_info
global tdc_num_info
global label_word_count
global label_x_end
global table_info
global label_osc_channel
global label_make_folder
global base_noise
if label_make_folder==0
  make_folder(hObject, eventdata, handles);
  label_make_folder=1;
end
handles=guidata(hObject);%----------------------------------------------------------------------------------------
label_word_temp=zeros(1,2);
temp_osc_info=cell(1,2);
time_domain_save_data_label=get(handles.time_domain_save_data_checkbox,'Value');
time_domain_on_label=get(handles.time_domain_checkbox,'Value');
time_domain_sym_label=get(handles.time_domain_sym_radiobutton,'Value');
frequency_domain_save_data_label=get(handles.frequency_domain_save_data_checkbox,'Value');
frequency_domain_on_label=get(handles.frequency_domain_checkbox,'Value');
acf_save_data_label=get(handles.acf_save_data_checkbox,'Value');
acf_on_label=get(handles.acf_on_checkbox,'Value');
record_on_label=get(handles.record_radiobutton,'Value');
drawnow;
if type==1
    label_word_count(1)=label_word_count(1)+1;
    label_word_temp(1)=label_word_count(1);
    set(handles.show_text,'String',['Single: ',num2str(label_word_temp(1))]);
    wave_save_folder=[handles.tool_single_folder,'\序号_',tdc_num_info,'_ICO_',all_status_info{1,2},'_DS_',all_status_info{1,3},'-实验结果'];    
else
    label_word_count(3)=label_word_count(3)+1;
    label_word_temp(1)=label_word_count(3);
    set(handles.show_text,'String',['Continue: ',num2str(label_word_temp(1))]);
    wave_save_folder=[handles.tool_continue_folder,'\序号_',tdc_num_info,'_ICO_',all_status_info{1,2},'_DS_',all_status_info{1,3},'-实验结果'];
end
if ~exist(wave_save_folder,'dir') 
    mkdir(wave_save_folder);    % 若不存在，在当前目录中产生一个子目录‘Figure’
end
temp_osc_info{1,1}=wave_save_folder;
num_str=get_ordered_str(hObject, eventdata, handles,label_word_temp(1));
if type==1
    wave_save_address=[wave_save_folder,'\single_huye_',num_str,'_wave.dat'];
    sym_save_address=[wave_save_folder,'\single_huye_',num_str,'_sym.fig'];
    frequency_save_address=[wave_save_folder,'\single_huye_',num_str];
    acf_save_address=[wave_save_folder,'\single_huye_',num_str];
else
    wave_save_address=[wave_save_folder,'\continue_huye_',num_str,'_wave.dat'];
    sym_save_address=[wave_save_folder,'\continue_huye_',num_str,'_sym.fig'];
    frequency_save_address=[wave_save_folder,'\continue_huye_',num_str];
    acf_save_address=[wave_save_folder,'\continue_huye_',num_str];
end
groupObj = get(deviceObj, 'Waveform');
groupObj = groupObj(1);
%             [data,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str);
[data,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
label_x_end(1)=length(data);
label_x_end(2)=handles.Fs/2;
label_x_end(3)=length(data);
%save和show分开
%if get(handles.time_domain_save_data_checkbox,'Value')==1 
if time_domain_save_data_label==1
     temp_osc_info{1,2}='>Start saving data.................';
     set(handles.osc_status_text,'String',temp_osc_info);
     dlmwrite(wave_save_address,data,'newline','pc','precision',6);
     figure(10);
     data_statistic3_batch(data,sym_save_address);
     %if get(handles.frequency_domain_save_data_checkbox,'Value')==1  
     if frequency_domain_save_data_label==1
          figure(10);
          if isempty(base_noise)
            myplot_analysis_batch(data,3,handles.Fs,1,1,frequency_save_address);%frequency
          else
            myplot_analysis_batch(data,3,handles.Fs,1,1,frequency_save_address,base_noise);  
          end
     end
     %if get(handles.acf_save_data_checkbox,'Value')==1    
     if acf_save_data_label==1
         figure(10);
         myplot_analysis_batch(data,1,handles.Fs,1,1,acf_save_address);%acf
     end
     temp_osc_info{1,2}='>OK!!';
     set(handles.osc_status_text,'String',temp_osc_info);
end      
%if get(handles.time_domain_checkbox,'Value')==1
if time_domain_on_label==1
    %if get(handles.time_domain_sym_radiobutton,'Value')==1
    if time_domain_sym_label==1
       axes(handles.axes_time_domain);
       data_statistic3(data);
    else
       axes(handles.axes_time_domain);
       plot(data);
       x_length=floor(get(handles.time_domain_xlimend_slider,'Value')*label_x_end(1));           
       set(handles.time_domain_xlimend_text,'String',num2str(x_length));
       xlim([0 x_length]);
    end
end
%if get(handles.frequency_domain_checkbox,'Value')==1
if frequency_domain_on_label==1
   axes(handles.axes_frequency_domain);
   if isempty(base_noise)
       myplot_analysis(data,3,handles.Fs,1); 
   else
       myplot_analysis(data,3,handles.Fs,1,base_noise); 
   end
%    title('');
%    ylim([0 6e-5]);
   x_length=floor(get(handles.frequency_domain_xlimend_slider,'Value')*label_x_end(2));           
   set(handles.frequency_domain_xlimend_text,'String',num2str(x_length));
   xlim([0 x_length]);
end   
%if get(handles.acf_on_checkbox,'Value')==1
if acf_on_label==1
   axes(handles.axes_acf_domain);
   [~,~,~,~,midrange]=myplot_analysis(data,1,handles.Fs,1);%acf
   title('');
   set(handles.acf_xlimend_slider,'Value',(2*midrange+500)/label_x_end(3));           
   set(handles.acf_xlimend_text,'String',num2str(2*midrange+500));
end
%if get(handles.record_radiobutton,'Value')==1&&get(handles.time_domain_save_data_checkbox,'Value')==1 
%------只有record和wave_data同时开启才记录-----------------------------------------------------------------------------------------
% if record_on_label==1&&time_domain_save_data_label==1
if record_on_label==1
    if type==1
        label_word_count(2)=label_word_count(2)+1;
        label_word_temp(2)=label_word_count(2);
    else
        label_word_count(4)=label_word_count(4)+1;
        label_word_temp(2)=label_word_count(4);
    end
 %table_info{2,1}=[all_status_info{1,1},'dbm'];
    table_info{2,2}=all_status_info{1,5};
    table_info{2,3}=[num2str(handles.Fs/1e9),'Gss'];
    table_info{2,4}=[num2str(floor(length(data)/1e6)),'M'];
    table_info{2,5}=[all_status_info{1,3},'ps/km'];
    table_info{2,6}=[all_status_info{1,2},'Ghz'];
    if type==1
        table_info{2,7}=['single_huye_',num_str,'_wave.dat'];
    else
        table_info{2,7}=['continue_huye_',num_str,'_wave.dat'];
    end
    handle_pic=figure(11);
    set (gcf,'Position',[500,300,1070,600], 'color','w') ;
    set(gcf,'Visible','off');
    subplot(221);
    [~,~,median_num,mean_num]=data_statistic3(data);
    subplot(222);
    [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis(data,1,handles.Fs,1);%acf
    subplot(212);
    if isempty(base_noise)
        myplot_analysis(data,3,handles.Fs,1);
    else
        myplot_analysis(data,3,handles.Fs,1,base_noise);
    end
%     ylim([0 6e-5]);%-----------------------------------------------------
    data_excel={['\序号_',num_str],all_status_info{1,3},all_status_info{1,2},roundn(maxnum,-5),x_maxnum,roundn(minnum,-5),x_minnum,roundn(median_num,-5),...
         roundn(mean_num,-5),roundn(abs(median_num-mean_num),-5),roundn(max(abs(maxnum),abs(minnum)),-5)};
    % saveas(gcf,pic_address);
    disp('start writing doc.................');
    temp_osc_info{1,2}='>Start writing doc.................';
    set(handles.osc_status_text,'String',temp_osc_info);
    if type==1
        write_doc(handle_pic,table_info,handles.tool_single_word,label_word_temp(2),label_word_temp(2)-1,0); 
        excel_range=['A',num2str(label_word_temp(2)+1),':K',num2str(label_word_temp(2)+1)]; 
        % write_excel_single(handles.tool_single_excel,figure_head,'A1:K1');%wps必须
        xlswrite(handles.tool_single_excel,data_excel,'sheet1',excel_range);
    else
        write_doc(handle_pic,table_info,handles.tool_continue_word,label_word_temp(2),label_word_temp(2)-1,0); 
        excel_range=['A',num2str(label_word_temp(2)+1),':K',num2str(label_word_temp(2)+1)]; 
        % write_excel_single(handles.tool_continue_excel,figure_head,'A1:K1');%wps必须
        xlswrite(handles.tool_continue_excel,data_excel,'sheet1',excel_range);
    end      
    temp_osc_info{1,2}='>OK!!';
     set(handles.osc_status_text,'String',temp_osc_info);
end
time=etime(clock,t0);
set_run_time(hObject, eventdata, handles,time);


function set_run_time(hObject, eventdata, handles,time)
if time<100
  set(handles.run_time_text,'String',[' ',num2str(time,'%.2f'),'seconds']);
else
    if time<3600
        set(handles.run_time_text,'String',[' ',num2str(time/60,'%.1f'),'minutes']);
    else
        set(handles.run_time_text,'String',[' ',num2str(time/3600,'%.1f'),'hours']);
    end
end


function num_str=get_ordered_str(hObject, eventdata, handles,num)
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


function get_all_status_info(hObject, eventdata, handles)
%含通断检测功能
global all_status_info
global serial_obj
global label_open
global label_osc_connect
global osc_info
global tdc_num_info
if get(handles.only_osc_radiobutton,'Value')==0
label_connect=tdc_connect_test(hObject, eventdata, handles,label_open,serial_obj);
if label_connect==0
    serial_obj='nocom';
    label_open=0;
    disp('no com available!!');
else
    [~,~,tdc_information]=tdc_command(serial_obj,'ds');
    position_1=strfind(tdc_information{2},':')+2;
    position_2=strfind(tdc_information{2},'ps')-2;
    all_status_info{1,3}=tdc_information{2}(position_1:position_2);
    ds_temp=floor(str2double(tdc_information{2}(position_1:position_2)))+2100;
    ds_temp=get_ordered_str(hObject, eventdata, handles,ds_temp);
    position_1=strfind(tdc_information{3},':')+2;
    position_2=strfind(tdc_information{3},'GHz')-2;
    all_status_info{1,2}=tdc_information{3}(position_1:position_2);  
    ico_temp=floor(str2double(tdc_information{3}(position_1:position_2)))+99;
    if ico_temp<10
        ico_temp=['00',num2str(ico_temp)];
    else
        if ico_temp<100
        ico_temp=['0',num2str(ico_temp)];
        else
            ico_temp=num2str(ico_temp);
        end
    end
    tdc_num_info=[ico_temp,'-',ds_temp];
end
all_status_info{1,4}=handles.Fs;
osc_connect_test(hObject, eventdata, handles);
if label_osc_connect==1
    all_status_info{1,5}=osc_info{1,10};
    all_status_info{1,6}=osc_info{1,9};
else
    all_status_info{1,5}='null';
    all_status_info{1,6}='null';
end
else
    all_status_info{1,3}='null';
    all_status_info{1,2}='null';  
    tdc_num_info='null';
    all_status_info{1,4}=handles.Fs;
    osc_connect_test(hObject, eventdata, handles);
    if label_osc_connect==1
        all_status_info{1,5}=osc_info{1,10};
        all_status_info{1,6}=osc_info{1,9};
    else
        all_status_info{1,5}='null';
        all_status_info{1,6}='null';
    end
end



% --- Executes on button press in acf_save_data_checkbox.
function acf_save_data_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to acf_save_data_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of acf_save_data_checkbox


% --- Executes on button press in acf_on_checkbox.
function acf_on_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to acf_on_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of acf_on_checkbox


% --- Executes on button press in frequency_domain_save_data_checkbox.
function frequency_domain_save_data_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_domain_save_data_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frequency_domain_save_data_checkbox


% --- Executes on button press in frequency_domain_checkbox.
function frequency_domain_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_domain_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frequency_domain_checkbox


% --- Executes on button press in time_domain_save_data_checkbox.
function time_domain_save_data_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to time_domain_save_data_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of time_domain_save_data_checkbox


% --- Executes on button press in time_domain_checkbox.
function time_domain_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to time_domain_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of time_domain_checkbox


% --- Executes on slider movement.
function time_domain_xlimend_slider_Callback(hObject, eventdata, handles)
% hObject    handle to time_domain_xlimend_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_x_end
if get(handles.time_domain_checkbox,'Value')==1
     if get(handles.time_domain_sym_radiobutton,'Value')==0
        axes(handles.axes_time_domain);
        x_length=floor(get(hObject,'Value')*label_x_end(1));           
        set(handles.time_domain_xlimend_text,'String',num2str(x_length));
        xlim([0 x_length]);
     end
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function time_domain_xlimend_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_domain_xlimend_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function frequency_domain_xlimend_slider_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_domain_xlimend_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_x_end
if get(handles.frequency_domain_checkbox,'Value')==1
    axes(handles.axes_frequency_domain);
    x_length=floor(get(hObject,'Value')*label_x_end(2));           
    set(handles.frequency_domain_xlimend_text,'String',num2str(x_length));
    xlim([0 x_length]);
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function frequency_domain_xlimend_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency_domain_xlimend_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function acf_xlimend_slider_Callback(hObject, eventdata, handles)
% hObject    handle to acf_xlimend_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_x_end
if get(handles.acf_on_checkbox,'Value')==1
    axes(handles.axes_acf_domain);
    x_length=floor(get(hObject,'Value')*label_x_end(3));           
    set(handles.acf_xlimend_text,'String',num2str(x_length));
    xlim([0 x_length]);
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function acf_xlimend_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acf_xlimend_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in tool_panel_button.
function tool_panel_button_Callback(hObject, eventdata, handles)
% hObject    handle to tool_panel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tool_panel,'Visible','on');
set(handles.rng_analyse_panel,'Visible','off');
set(handles.tool_panel_button,'BackgroundColor',[0.231 0.443 0.337]);
set(handles.rng_analyse_panel_button,'BackgroundColor',[0.941 0.941 0.941]);

% --- Executes on button press in rng_analyse_panel_button.
function rng_analyse_panel_button_Callback(hObject, eventdata, handles)
% hObject    handle to rng_analyse_panel_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tool_panel,'Visible','off');
set(handles.rng_analyse_panel,'Visible','on');
set(handles.rng_analyse_panel_button,'BackgroundColor',[0.231 0.443 0.337]);
set(handles.tool_panel_button,'BackgroundColor',[0.941 0.941 0.941]);

% --- Executes on button press in time_domain_td_radiobutton.
function time_domain_td_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to time_domain_td_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',1);
set(handles.time_domain_sym_radiobutton,'Value',0);
% Hint: get(hObject,'Value') returns toggle state of time_domain_td_radiobutton


% --- Executes on button press in time_domain_sym_radiobutton.
function time_domain_sym_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to time_domain_sym_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',1);
set(handles.time_domain_td_radiobutton,'Value',0);
% Hint: get(hObject,'Value') returns toggle state of time_domain_sym_radiobutton


% --- Executes on button press in diehard_post_process_button.
function diehard_post_process_button_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_post_process_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in diehard_cycle_button.
function diehard_cycle_button_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_cycle_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_diehard_cycle_stop
global label_make_folder
makesure = questdlg('是否按以下要求执行(Cycle)？','info','OK','Cancel','OK') ;
if strcmp(makesure,'OK')~=1
    return;
end
if label_make_folder==0
    make_folder(hObject, eventdata, handles);
    label_make_folder=1;
end
handles=guidata(hObject);%-------------------------------------------------------------------------------------
while(label_diehard_cycle_stop==0)
    drawnow;
    diehard_single_button_Callback(hObject, eventdata, handles);
    handles=guidata(hObject);%------------------------------------------------------------------
end
label_diehard_cycle_stop=0;

% --- Executes on button press in diehard_single_button.
function diehard_single_button_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_single_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t0=clock;
set(handles.type_text,'String','Single(D):');
global label_osc_connect
global label_word_count
global deviceObj
global all_status_info
global tdc_num_info
global label_osc_channel
global diehard_data_all
global label_diehard_stop
global judgment_threshold
global label_make_folder
global table_info
global label_open
global base_noise
check_freespace(hObject, eventdata, handles);
get_all_status_info(hObject, eventdata, handles);%含通断检测功能
write_osc_status(hObject, eventdata, handles);
if get(handles.only_osc_radiobutton,'Value')==0&&label_open==0
    return;
end
temp_info_parameter=cell(1,8);
temp_info_parameter{1,1}='Parameter';
temp_info_parameter{1,2}=['>DS: ',all_status_info{1,3},'ps/km'];
temp_info_parameter{1,3}=['>ICO: ',all_status_info{1,2},'Ghz'];
label_wave_saved=get(handles.diehard_wave_saved_checkbox,'Value');
label_bin_saved=get(handles.diehard_bin_saved_checkbox,'Value');
record_label=get(handles.record_radiobutton,'Value');
diehard_on_acf_label=get(handles.diehard_on_acf_radiobutton,'Value');
diehard_wave_acf_label=get(handles.diehard_wave_acf_radiobutton,'Value');
diehard_on_sym_label=get(handles.diehard_on_sym_radiobutton,'Value');
diehard_on_res_label=get(handles.diehard_on_res_radiobutton,'Value');
acf_average_label=get(handles.diehard_average_radiobutton,'Value');
loop_file=11;%diehard data 
if label_osc_connect==1
    if handles.Fs==40e9
        if label_make_folder==0
            make_folder(hObject, eventdata, handles);
            label_make_folder=1;
        end
        handles=guidata(hObject);%----------------------------------------------------------------
%         connect(deviceObj);
% %         set(deviceObj.Acquisition(1),'Timebase',2e-5);%-只对应40Gss
% %         set(deviceObj.Acquisition(1),'Timebase',1e-5);%-只对应80Gss
%         disconnect(deviceObj);
        get_all_status_info(hObject, eventdata, handles);%含通断检测功能
        write_osc_status(hObject, eventdata, handles);
        label_word_count(5)=label_word_count(5)+1;
        num_str=get_ordered_str(hObject, eventdata, handles,label_word_count(5));
        set(handles.diehard_single_text,'String',['Times: ',num2str(label_word_count(5))]);
        save_folder=[handles.rng_single_folder,'\序号_',tdc_num_info,'_ICO_',all_status_info{1,2},'_DS_',all_status_info{1,3},'-实验结果'];
        temp_info_parameter{1,7}=save_folder;
        wave_save_folder=[save_folder,'\wave_data_',num_str];
        binary_save_folder=[save_folder,'\bin_data_',num_str];
        if ~exist(wave_save_folder,'dir') 
            mkdir(wave_save_folder);    % 若不存在，在当前目录中产生一个子目录‘Figure’
        end
        if ~exist(binary_save_folder,'dir') 
            mkdir(binary_save_folder);    % 若不存在，在当前目录中产生一个子目录‘Figure’
        end
        wave_save_add=cell(1,40);%------------------------------------------------------------------------------------------
        bin_save_add=cell(1,40);%------------------------------------------------------------------------------------------
        for i=1:40
            if i<10
               wave_save_add{1,i}=[wave_save_folder,'\huye_wave_00',num2str(i),'.dat'];
               bin_save_add{1,i}=[binary_save_folder,'\huye_bin_00',num2str(i)];
            else
                if i<100
                wave_save_add{1,i}=[wave_save_folder,'\huye_wave_0',num2str(i),'.dat'];
                bin_save_add{1,i}=[binary_save_folder,'\huye_bin_0',num2str(i)]; 
                else
                    wave_save_add{1,i}=[wave_save_folder,'\huye_wave_',num2str(i),'.dat'];
                    bin_save_add{1,i}=[binary_save_folder,'\huye_bin_',num2str(i)]; 
                end
            end
        end
        diehard_test_add=[binary_save_folder,'\ICO_',all_status_info{1,2},'_DS_',all_status_info{1,3},'-diehard'];%generation_test_file无需bin后缀，另一个improvement需要
%         bin_save_address=[save_folder,'\single_huye__wave.bin'];
        try 
            connect(deviceObj);
        catch
            disconnect(deviceObj);
            get_all_status_info(hObject, eventdata, handles);%含通断检测功能
            write_osc_status(hObject, eventdata, handles);
            check_freespace(hObject, eventdata, handles);
            return;
        end
        groupObj = get(deviceObj, 'Waveform');
        groupObj = groupObj(1);
%             [data,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str);
        [data1,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
        pause(1);
        [data2,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
        disconnect(deviceObj);
        if label_wave_saved==1
            label_temp=strfind(wave_save_add{1,1},'\');
            wave_data_name=wave_save_add{1,1}(label_temp(end)+1:end);
            temp_info_parameter{1,8}=['>Start saving ',wave_data_name,'*2......'];
            set(handles.parameter_text,'String',temp_info_parameter);
            dlmwrite(wave_save_add{1,1},data1,'newline','pc','precision',6);
            dlmwrite(wave_save_add{1,2},data2,'newline','pc','precision',6);
            if label_bin_saved==1 
                label_temp=strfind(bin_save_add{1,1},'\');
                bin_data_name=bin_save_add{1,1}(label_temp(end)+1:end);
                temp_info_parameter{1,8}=['>Start saving ',bin_data_name,'.bin......'];
                set(handles.parameter_text,'String',temp_info_parameter);
                generation_test_file(bin_save_add{1,1},data1,data2,judgment_threshold,3,0,1);%覆盖，不作处理，bin
            end  
%             temp_info_parameter{1,8}='>OK!!';
%             set(handles.parameter_text,'String',temp_info_parameter);
        else  
            if label_bin_saved==1
                label_temp=strfind(bin_save_add{1,1},'\');
                bin_data_name=bin_save_add{1,1}(label_temp(end)+1:end);
                temp_info_parameter{1,8}=['>Start saving ',bin_data_name,'.bin(include 2 dat file)...'];
                set(handles.parameter_text,'String',temp_info_parameter);
                dlmwrite(wave_save_add{1,1},data1,'newline','pc','precision',6);
                dlmwrite(wave_save_add{1,2},data2,'newline','pc','precision',6);
                generation_test_file(bin_save_add{1,1},data1,data2,judgment_threshold,3,0,1);%覆盖，不作处理，bin
%                 temp_info_parameter{1,8}='>OK!!';
%                 set(handles.parameter_text,'String',temp_info_parameter);
            end            
        end
        temp_info_parameter{1,8}='>Start saving diehard.bin(test)......1';
        set(handles.parameter_text,'String',temp_info_parameter);
        generation_test_file(diehard_test_add,data1,data2,judgment_threshold,2,0,1);%覆盖，处理，bin
%         temp_info_parameter{1,8}='>OK!!';
%         set(handles.parameter_text,'String',temp_info_parameter);
        if record_label==1%-----------------------------------------------------------------------------------
%         if record_label==1&&(label_wave_saved==1||label_bin_saved==1)
            label_word_count(6)=label_word_count(6)+1;
            %table_info{2,1}=[all_status_info{1,1},'dbm'];
            table_info{2,2}=all_status_info{1,5};
            table_info{2,3}=[num2str(handles.Fs/1e9),'Gss'];
            table_info{2,4}=[num2str(floor(length(data1)/1e6)),'M'];
            table_info{2,5}=[all_status_info{1,3},'ps/km'];
            table_info{2,6}=[all_status_info{1,2},'Ghz'];
            table_info{2,7}=['.\wave_data_',num_str,'\huye_wave_001.dat'];
            handle_pic=figure(11);
            set (gcf,'Position',[500,300,1070,600], 'color','w') ;
            set(gcf,'Visible','off');
            subplot(221);
            [~,~,median_num,mean_num]=data_statistic3(data1);
            subplot(222);
            [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis(data1,1,handles.Fs,1);
            subplot(212);
            if iseempty(base_noise)
                myplot_analysis(data1,3,handles.Fs,1);
            else
                myplot_analysis(data1,3,handles.Fs,1,base_noise);
            end
%             ylim([0 6e-5]);%---------------------------------------------
            data_excel={['\序号_',num_str],all_status_info{1,3},all_status_info{1,2},roundn(maxnum,-5),x_maxnum,roundn(minnum,-5),x_minnum,roundn(median_num,-5),...
                    roundn(mean_num,-5),roundn(abs(median_num-mean_num),-5),roundn(max(abs(maxnum),abs(minnum)),-5),0,0,0,0};
            if acf_average_label==1
                diehard_data_all(2,label_word_count(5))=abs(mean_num-median_num)/loop_file;%sym
                diehard_data_all(1,label_word_count(5))=max(abs(maxnum),abs(minnum))/loop_file;%acf_wave
            else
                diehard_data_all(2,label_word_count(5))=abs(mean_num-median_num);%sym
                diehard_data_all(1,label_word_count(5))=max(abs(maxnum),abs(minnum));%acf_wave
            end
            % saveas(gcf,pic_address);           
           disp('start writing doc.................');
           temp_info_parameter{1,8}='>Start writing doc.................';
           set(handles.parameter_text,'String',temp_info_parameter);
           write_doc(handle_pic,table_info,handles.rng_single_word,label_word_count(6),label_word_count(6)-1,0); 
           excel_range=['A',num2str(label_word_count(6)+1),':O',num2str(label_word_count(6)+1)]; 
        % write_excel_single(handles.rng_single_excel,figure_head,'A1:O1');%wps必须
           xlswrite(handles.rng_single_excel,data_excel,'sheet1',excel_range);      
%            temp_info_parameter{1,5}='>OK!!';
%            set(handles.parameter_text,'String',temp_info_parameter);
        else
            [~,~,median_num,mean_num,~]=data_statistic3_only_result(data1);
            [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data1);
            if acf_average_label==1
                diehard_data_all(2,label_word_count(5))=abs(mean_num-median_num)/loop_file;%sym
                diehard_data_all(1,label_word_count(5))=max(abs(maxnum),abs(minnum))/loop_file;%acf_wave
            else
                diehard_data_all(2,label_word_count(5))=abs(mean_num-median_num);%sym
                diehard_data_all(1,label_word_count(5))=max(abs(maxnum),abs(minnum));%acf_wave
            end
        end
        data1=wavedata_2_binary(data1,judgment_threshold);
        data2=wavedata_2_binary(data2,judgment_threshold);
        data=xor(data1,data2);
        [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data);
        temp_xor_acf=max(abs(maxnum),abs(minnum));
         if acf_average_label==1
            diehard_data_all(3,label_word_count(5))=max(abs(maxnum),abs(minnum))/loop_file;%acf_xor              
         else
            diehard_data_all(3,label_word_count(5))=max(abs(maxnum),abs(minnum));
         end
        for i=2:loop_file
            if label_diehard_stop==1
                label_diehard_stop=0;
                check_freespace(hObject, eventdata, handles);
                return;
            end
            try
                connect(deviceObj);
            catch
                disconnect(deviceObj);
                get_all_status_info(hObject, eventdata, handles);%含通断检测功能
                write_osc_status(hObject, eventdata, handles);
                check_freespace(hObject, eventdata, handles);
                return;
            end
            groupObj = get(deviceObj, 'Waveform');
            groupObj = groupObj(1);
%             [data,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str);
            [data1,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
            pause(1);
%             groupObj = get(deviceObj, 'Waveform');
%             groupObj = groupObj(2);
            [data2,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
            disconnect(deviceObj);
            %%average add code---------------------------------------------------------------------------------            
            if acf_average_label==1
                [~,~,median_num,mean_num,~]=data_statistic3_only_result(data1);
                [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data1);
                diehard_data_all(2,label_word_count(5))=abs(mean_num-median_num)/loop_file+diehard_data_all(2,label_word_count(5));%sym
                diehard_data_all(1,label_word_count(5))=max(abs(maxnum),abs(minnum))/loop_file+diehard_data_all(1,label_word_count(5));%acf_wave
                data3=wavedata_2_binary(data1,judgment_threshold);
                data4=wavedata_2_binary(data2,judgment_threshold);
                data5=xor(data3,data4);
                [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data5);
                diehard_data_all(3,label_word_count(5))=max(abs(maxnum),abs(minnum))/loop_file+diehard_data_all(3,label_word_count(5));%acf(xor)      
                clear data3 data4 data5
            end               
            %%-------------------------------------------------------------------------------------------------            
            if label_wave_saved==1
                label_temp=strfind(wave_save_add{1,(i-1)*2+1},'\');
                wave_data_name=wave_save_add{1,(i-1)*2+1}(label_temp(end)+1:end);
                temp_info_parameter{1,8}=['>Start saving ',wave_data_name,'*2......'];
                set(handles.parameter_text,'String',temp_info_parameter);
                dlmwrite(wave_save_add{1,(i-1)*2+1},data1,'newline','pc','precision',6);
                dlmwrite(wave_save_add{1,i*2},data2,'newline','pc','precision',6);
%                 temp_info_parameter{1,8}='>OK!!';
%                 set(handles.parameter_text,'String',temp_info_parameter);
            end 
            if label_bin_saved==1
                label_temp=strfind(bin_save_add{1,i},'\');
                bin_data_name=bin_save_add{1,i}(label_temp(end)+1:end);
                temp_info_parameter{1,8}=['>Start saving ',bin_data_name,'.bin......'];
                set(handles.parameter_text,'String',temp_info_parameter);
                generation_test_file(bin_save_add{1,i},data1,data2,judgment_threshold,3,0,1);%覆盖，不作处理，bin
%                 temp_info_parameter{1,8}='>OK!!';
%                 set(handles.parameter_text,'String',temp_info_parameter);           
            end
            temp_info_parameter{1,8}=['>Start saving diehard.bin(test)......',num2str(i)];
            set(handles.parameter_text,'String',temp_info_parameter);
            generation_test_file(diehard_test_add,data1,data2,judgment_threshold,2,1,1);%appand，处理，bin
%             temp_info_parameter{1,8}='>OK!!';
%             set(handles.parameter_text,'String',temp_info_parameter);
        end        
        if record_label==1%-----------------------------------------------------------------------------------
            excel_range=['L',num2str(label_word_count(6)+1),':O',num2str(label_word_count(6)+1)]; 
            % write_excel_single(handles.rng_single_excel,figure_head,'A1:K1');%wps必须
            xlswrite(handles.rng_single_excel,{roundn(temp_xor_acf,-5),roundn(diehard_data_all(2,1:label_word_count(5)),-5),roundn(diehard_data_all(1,1:label_word_count(5)),-5),roundn(diehard_data_all(3,label_word_count(5)),-5)},'sheet1',excel_range);      
        end
        if acf_average_label==1
            temp_info_parameter{1,4}=['>ACF(wave-average):  ',num2str(diehard_data_all(1,label_word_count(5)),'%.5f')];
            temp_info_parameter{1,5}=['>ACF(xor-average):  ',num2str(diehard_data_all(3,label_word_count(5)),'%.5f')];
            temp_info_parameter{1,6}=['>Sym(average):  ',num2str(diehard_data_all(2,label_word_count(5)),'%.5f')];
        else
            temp_info_parameter{1,4}=['>ACF(wave):  ',num2str(diehard_data_all(1,label_word_count(5)),'%.5f')];
            temp_info_parameter{1,5}=['>ACF(xor):  ',num2str(diehard_data_all(3,label_word_count(5)),'%.5f')];
            temp_info_parameter{1,6}=['>Sym:  ',num2str(diehard_data_all(2,label_word_count(5)),'%.5f')];
        end
        set(handles.parameter_text,'String',temp_info_parameter);
        
        res_num=generate_diehard_log(hObject, eventdata, handles,binary_save_folder,['ICO_',all_status_info{1,2},'_DS_',all_status_info{1,3},'-diehard.bin'],label_word_count(5),temp_info_parameter,tdc_num_info);       
        diehard_data_all(4,label_word_count(5))=res_num;
        %if get(handles.diehard_on_acf_radiobutton,'Value')==1
        if diehard_on_acf_label==1
              axes(handles.axes_acf);
              %if get(handles.diehard_wave_acf_radiobutton,'Value')==1
              if diehard_wave_acf_label==1
                  plot(diehard_data_all(1,1:label_word_count(5)),'-k*','LineWidth',1);
                  ylim([0 max(diehard_data_all(1,1:label_word_count(5)))*1.2])
              else
                  plot(diehard_data_all(3,1:label_word_count(5)),'-g*','LineWidth',1);
                  ylim([0 max(diehard_data_all(3,1:label_word_count(5)))*1.2])
              end
%               ylim([0 1]);
              xlim([1 label_word_count(5)+5]);
        end
        %if get(handles.diehard_on_sym_radiobutton,'Value')==1
        if diehard_on_sym_label==1
              axes(handles.axes_sym);
              plot(diehard_data_all(2,1:label_word_count(5)),'-b*','LineWidth',1);
              ylim([0 max(diehard_data_all(2,1:label_word_count(5)))*1.2]);
              xlim([1 label_word_count(5)+5]);
        end
        if diehard_on_res_label==1
              axes(handles.axes_res);
              plot(diehard_data_all(4,1:label_word_count(5)),'-r*','LineWidth',1);
              ylim([0 max(diehard_data_all(4,1:label_word_count(5)))+5]);
              xlim([1 label_word_count(5)+5]);
        end
        if res_num~=0
            temp_info_parameter{1,8}='>OK!!';
            set(handles.parameter_text,'String',temp_info_parameter);
        end
    else
        disp('fs~=40gss!');
        set(handles.parameter_text,'String','>Fs~=40gss!');
    end
end
check_freespace(hObject, eventdata, handles);
time=etime(clock,t0);
set_run_time(hObject, eventdata, handles,time);
        
        

function res_num=generate_diehard_log(hObject, eventdata, handles,diehard_add_head,diehard_name_old,label_diehard_excel_num,temp_info_parameter,num_order)
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
    temp_info_parameter{1,8}=['error-',filenames_out_old];
    set(handles.parameter_text,'String',temp_info_parameter);
else
    diehard_result=zeros(1,20);
    [diehard_result(1:19),diehard_result_pass_info,~,~]=get_all_log_value(label_block,log_info);
    diehard_result(end)=str2double(diehard_result_pass_info{1,end});
    diehard_result_head=num_order;
    diehard_result_temp=cell(1,20);
    diehard_result_temp{1,1}='P_Value:';  
    diehard_result_pass_info_temp=cell(1,21);
    diehard_result_pass_info_temp{1,1}='Results:';
    diehard_result_pass_info_temp{1,end}=diehard_result_pass_info{1,end};
    for i=2:20
        diehard_result_temp{1,i}=num2str(diehard_result(i-1));
        diehard_result_pass_info_temp{1,i}=diehard_result_pass_info{1,i-1};
    end
    set(handles.info_text2,'String',diehard_result_temp);
    set(handles.info_text3,'String',diehard_result_pass_info_temp);
    res_num=str2double(diehard_result_pass_info_temp{1,end});
    xlswrite(handles.rng_single_diehard_excel,diehard_result_head,'sheet1',['A',num2str(label_diehard_excel_num+1),':A',num2str(label_diehard_excel_num+1)]);
    xlswrite(handles.rng_single_diehard_excel,diehard_result,'sheet1',['B',num2str(label_diehard_excel_num+1),':U',num2str(label_diehard_excel_num+1)]);
%     write_excel_for_diehard(handles.rng_single_diehard_excel,diehard_result_head,['A',num2str(label_diehard_excel_num+1),':A',num2str(label_diehard_excel_num+1)]);
%     write_excel_for_diehard(handles.rng_single_diehard_excel,diehard_result,['B',num2str(label_diehard_excel_num+1),':U',num2str(label_diehard_excel_num+1)]);
end
        


% --- Executes on button press in diehard_wave_saved_checkbox.
function diehard_wave_saved_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_wave_saved_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diehard_wave_saved_checkbox


% --- Executes on button press in diehard_bin_saved_checkbox.
function diehard_bin_saved_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_bin_saved_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diehard_bin_saved_checkbox


% --- Executes on button press in diehard_stop_button.
function diehard_stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_diehard_stop
label_diehard_stop=1;


function diehard_folder_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_folder_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diehard_folder_name_edit as text
%        str2double(get(hObject,'String')) returns contents of diehard_folder_name_edit as a double


% --- Executes during object creation, after setting all properties.
function diehard_folder_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diehard_folder_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in diehard_on_acf_radiobutton.
function diehard_on_acf_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_on_acf_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diehard_on_acf_radiobutton


% --- Executes on button press in diehard_on_sym_radiobutton.
function diehard_on_sym_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_on_sym_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diehard_on_sym_radiobutton


% --- Executes on button press in diehard_on_res_radiobutton.
function diehard_on_res_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_on_res_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diehard_on_res_radiobutton


% --- Executes on button press in diehard_on_lav_radiobutton.
function diehard_on_lav_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_on_lav_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diehard_on_lav_radiobutton


% --- Executes on button press in record_radiobutton.
function record_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to record_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of record_radiobutton


% --- Executes on button press in diehard_wave_acf_radiobutton.
function diehard_wave_acf_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_wave_acf_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',1);
set(handles.diehard_xor_acf_radiobutton,'Value',0);
% Hint: get(hObject,'Value') returns toggle state of diehard_wave_acf_radiobutton


% --- Executes on button press in diehard_xor_acf_radiobutton.
function diehard_xor_acf_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_xor_acf_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Value',1);
set(handles.diehard_wave_acf_radiobutton,'Value',0);
% Hint: get(hObject,'Value') returns toggle state of diehard_xor_acf_radiobutton



% --- Executes on button press in diehard_status_button.
function diehard_status_button_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_status_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global deviceObj
global label_osc_channel
global judgment_threshold
global label_diehard_stop
global all_status_info
global label_make_folder
global label_open
check_freespace(hObject, eventdata, handles);
get_all_status_info(hObject, eventdata, handles);%含通断检测功能
write_osc_status(hObject, eventdata, handles);
if get(handles.only_osc_radiobutton,'Value')==0&&label_open==0
    return;
end
makesure_info=cell(1,3);
makesure_info{1,1}='是否按以下要求执行(Status)？';
makesure_info{1,2}=['>DS: ',all_status_info{1,3},'ps/km'];
makesure_info{1,3}=['>ICO: ',all_status_info{1,2},'Ghz'];
makesure = questdlg(makesure_info,'info','OK','Cancel','OK') ;
if strcmp(makesure,'OK')~=1
    return;
end
t0=clock;%----------------------------------------------------------------------------
set(handles.type_text,'String','Status');
if label_osc_connect==1
    if handles.Fs==40e9
        if label_make_folder==0
            make_folder(hObject, eventdata, handles);
            label_make_folder=1;
        end
        handles=guidata(hObject);%------------------------------------------------------
%         connect(deviceObj);
% %         set(deviceObj.Acquisition(1),'Timebase',2e-5);%--只适用40Gss
% %         set(deviceObj.Acquisition(1),'Timebase',1e-5);%--只适用80Gss
%         disconnect(deviceObj);
        get_all_status_info(hObject, eventdata, handles);%含通断检测功能
        write_osc_status(hObject, eventdata, handles);
        sym_temp=zeros(2,30);
        acf_temp=zeros(2,30);
        xor_acf_temp=zeros(1,30);
        for i=1:30
        if label_diehard_stop==1
            label_diehard_stop=0;
            check_freespace(hObject, eventdata, handles);
            return;
        end
        try 
            connect(deviceObj);
        catch
            disconnect(deviceObj);
            get_all_status_info(hObject, eventdata, handles);%含通断检测功能
            write_osc_status(hObject, eventdata, handles);
            check_freespace(hObject, eventdata, handles);
            return;
        end
        groupObj = get(deviceObj, 'Waveform');
        groupObj = groupObj(1);       
%             [data,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str);
        [data1,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
        [~,~,median_num,mean_num,~]=data_statistic3_only_result(data1);
        sym_temp(1,i)=abs(mean_num-median_num);
        [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data1);
        acf_temp(1,i)=max(abs(maxnum),abs(minnum));
        [data2,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
        disconnect(deviceObj);
        [~,~,median_num,mean_num,~]=data_statistic3_only_result(data2);
        sym_temp(2,i)=abs(mean_num-median_num);
        [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data2);
        acf_temp(2,i)=max(abs(maxnum),abs(minnum));
        data1=wavedata_2_binary(data1,judgment_threshold);
        data2=wavedata_2_binary(data2,judgment_threshold);
        data=xor(data1,data2);
        [maxnum,~,minnum,~,~]=myplot_analysis_only_acf(data);
        xor_acf_temp(i)=max(abs(maxnum),abs(minnum));
        figure(30);
        subplot(311);
        plot(sym_temp,'-g*','LineWidth',1);
        subplot(312);
        plot(acf_temp,'-b*','LineWidth',1);
        subplot(313);
        plot(xor_acf_temp,'-r*','LineWidth',1);       
        end
    else
        disp('fs~=40gss!');
        set(handles.parameter_text,'String','>Fs~=40gss!'); 
    end
end
check_freespace(hObject, eventdata, handles);
time=etime(clock,t0);
set_run_time(hObject, eventdata, handles,time);

% --- Executes on button press in nist_button.
function nist_button_Callback(hObject, eventdata, handles)
% hObject    handle to nist_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global label_word_count
global deviceObj
global all_status_info
global tdc_num_info
global label_osc_channel
global label_diehard_stop
global judgment_threshold
global label_make_folder
global label_open
check_freespace(hObject, eventdata, handles);
get_all_status_info(hObject, eventdata, handles);%含通断检测功能
write_osc_status(hObject, eventdata, handles);
if get(handles.only_osc_radiobutton,'Value')==0&&label_open==0
    return;
end
temp_info_parameter=cell(1,6);
temp_info_parameter{1,1}='Parameter';
temp_info_parameter{1,2}=['>DS: ',all_status_info{1,3},'ps/km'];
temp_info_parameter{1,3}=['>ICO: ',all_status_info{1,2},'Ghz'];
makesure_info=cell(1,3);
makesure_info{1,1}='是否按以下要求执行(Nist_bin)？';
makesure_info{1,2}=temp_info_parameter{1,3};
makesure_info{1,3}=temp_info_parameter{1,2};
makesure = questdlg(makesure_info,'info','OK','Cancel','OK') ;
if strcmp(makesure,'OK')~=1
    return;
end
t0=clock;%----------------------------------------------------
set(handles.type_text,'String','Nist:');
if label_osc_connect==1
    if handles.Fs==40e9
        if label_make_folder==0
            make_folder(hObject, eventdata, handles);
            label_make_folder=1;
        end
        handles=guidata(hObject);%--------------------------------------------
%         connect(deviceObj);
% %         set(deviceObj.Acquisition(1),'Timebase',2e-5);%--只适用40Gss
% %         set(deviceObj.Acquisition(1),'Timebase',1e-5);%--只适用80Gss
%         disconnect(deviceObj);
        get_all_status_info(hObject, eventdata, handles);%含通断检测功能
        write_osc_status(hObject, eventdata, handles);      
        label_word_count(7)=label_word_count(7)+1;
        num_str=get_ordered_str(hObject, eventdata, handles,label_word_count(7));        
        save_folder=[handles.rng_nist,'\序号_',tdc_num_info,'_ICO_',all_status_info{1,2},'_DS_',all_status_info{1,3},'-实验结果'];
        temp_info_parameter{1,4}=save_folder;
        %wave_save_folder=[save_folder,'\wave_data_',num_str];
        binary_save_folder=[save_folder,'\bin_data_',num_str];
%         if ~exist(wave_save_folder) 
%             mkdir(wave_save_folder);    % 若不存在，在当前目录中产生一个子目录‘Figure’
%         end
        if ~exist(binary_save_folder,'dir') 
            mkdir(binary_save_folder);    % 若不存在，在当前目录中产生一个子目录‘Figure’
        end
        %wave_save_add=cell(1,400);%------------------------------------------------------------------------------------------
        bin_save_add=cell(1,400);%------------------------------------------------------------------------------------------
        for i=1:400
            if i<10
               %wave_save_add{1,i}=[wave_save_folder,'\huye_wave_00',num2str(i),'.dat'];
               bin_save_add{1,i}=[binary_save_folder,'\huye_bin_00',num2str(i)];
            else
                if i<100
                %wave_save_add{1,i}=[wave_save_folder,'\huye_wave_0',num2str(i),'.dat'];
                bin_save_add{1,i}=[binary_save_folder,'\huye_bin_0',num2str(i)]; 
                else
                    %wave_save_add{1,i}=[wave_save_folder,'\huye_wave_',num2str(i),'.dat'];
                    bin_save_add{1,i}=[binary_save_folder,'\huye_bin_',num2str(i)]; 
                end
            end
        end
        for i=1:130
            if label_diehard_stop==1
                label_diehard_stop=0;
                check_freespace(hObject, eventdata, handles);
                return;
            end
            try
                connect(deviceObj);
            catch
                disconnect(deviceObj);
                get_all_status_info(hObject, eventdata, handles);%含通断检测功能
                write_osc_status(hObject, eventdata, handles);
                check_freespace(hObject, eventdata, handles);
                return;
            end           
            groupObj = get(deviceObj, 'Waveform');
            groupObj = groupObj(1);
%             [data,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str);
            [data1,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
            pause(1);
            [data2,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
            disconnect(deviceObj);
            temp_info_parameter{1,5}=['>Start saving huye_bin_',num2str(i)];
            temp_info_parameter{1,6}='>Waiting..................';
            set(handles.parameter_text,'String',temp_info_parameter);
            generation_test_file(bin_save_add{1,i},data1,data2,judgment_threshold,3,0,1);%appand，处理，bin
            temp_info_parameter{1,6}='>OK!!';
            set(handles.parameter_text,'String',temp_info_parameter);       
        end    
    else
        disp('fs~=40gss!');
        set(handles.parameter_text,'String','>Fs~=40gss!');
    end
end
check_freespace(hObject, eventdata, handles);
time=etime(clock,t0);
set_run_time(hObject, eventdata, handles,time);


% --- Executes on button press in only_osc_radiobutton.
function only_osc_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to only_osc_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of only_osc_radiobutton


% --- Executes on button press in diehard_diehard_button.
function diehard_diehard_button_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_diehard_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in diehard_cycle_stop_button.
function diehard_cycle_stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_cycle_stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_diehard_cycle_stop
label_diehard_cycle_stop=1;


% --------------------------------------------------------------------
function information_menu_Callback(hObject, eventdata, handles)
% hObject    handle to information_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
note();


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in osc_state_auto_radiobutton.
function osc_state_auto_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_state_auto_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global osc_info
global deviceObj
set(handles.osc_state_auto_radiobutton,'Value',1);
set(handles.osc_state_auto_radiobutton,'BackgroundColor',[0.85 0.33 0.1]);
set(handles.osc_state_auto_radiobutton,'ForegroundColor',[0 0 1]);
% set(handles.osc_state_single_radiobutton,'Value',0);
set(handles.osc_state_single_radiobutton,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.osc_state_single_radiobutton,'ForegroundColor',[0 0 0]);
% set(handles.osc_state_stop_radiobutton,'Value',0);
set(handles.osc_state_stop_radiobutton,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.osc_state_stop_radiobutton,'ForegroundColor',[0 0 0]);
if label_osc_connect==1
    try
    connect(deviceObj);   
    set(deviceObj.Acquisition(1),'Control','auto');
    osc_info{1,11}='auto';
    write_osc_status(hObject, eventdata, handles);
    disconnect(deviceObj);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
        set(handles.osc_status_text,'String','osc disconnect!!');
    end
else
    set(handles.osc_status_text,'String','osc disconnect!!');
end
% Hint: get(hObject,'Value') returns toggle state of osc_state_auto_radiobutton


% --- Executes on button press in osc_state_single_radiobutton.
function osc_state_single_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_state_single_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global osc_info
global deviceObj
% set(handles.osc_state_auto_radiobutton,'Value',0);
set(handles.osc_state_auto_radiobutton,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.osc_state_auto_radiobutton,'ForegroundColor',[0 0 0]);
set(handles.osc_state_single_radiobutton,'Value',1);
set(handles.osc_state_single_radiobutton,'BackgroundColor',[0.85 0.33 0.1]);
set(handles.osc_state_single_radiobutton,'ForegroundColor',[0 0 1]);
% set(handles.osc_state_stop_radiobutton,'Value',0);
set(handles.osc_state_stop_radiobutton,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.osc_state_stop_radiobutton,'ForegroundColor',[0 0 0]);
if label_osc_connect==1
    try
    connect(deviceObj);   
    set(deviceObj.Acquisition(1),'Control','single');
    osc_info{1,11}='single';
    write_osc_status(hObject, eventdata, handles);
    disconnect(deviceObj);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
        set(handles.osc_status_text,'String','osc disconnect!!');
    end
else
    set(handles.osc_status_text,'String','osc disconnect!!');
end
% Hint: get(hObject,'Value') returns toggle state of osc_state_single_radiobutton


% --- Executes on button press in osc_state_stop_radiobutton.
function osc_state_stop_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to osc_state_stop_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global osc_info
global deviceObj
% set(handles.osc_state_auto_radiobutton,'Value',0);
set(handles.osc_state_auto_radiobutton,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.osc_state_auto_radiobutton,'ForegroundColor',[0 0 0]);
% set(handles.osc_state_single_radiobutton,'Value',0);
set(handles.osc_state_single_radiobutton,'BackgroundColor',[0.94 0.94 0.94]);
set(handles.osc_state_single_radiobutton,'ForegroundColor',[0 0 0]);
set(handles.osc_state_stop_radiobutton,'Value',1);
set(handles.osc_state_stop_radiobutton,'BackgroundColor',[0.85 0.33 0.1]);
set(handles.osc_state_stop_radiobutton,'ForegroundColor',[0 0 1]);
if label_osc_connect==1
    try
    connect(deviceObj);   
    set(deviceObj.Acquisition(1),'Control','stop');
    osc_info{1,11}='stop';
    write_osc_status(hObject, eventdata, handles);
    disconnect(deviceObj);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
        set(handles.osc_status_text,'String','osc disconnect!!');
    end
else
    set(handles.osc_status_text,'String','osc disconnect!!');
end
% Hint: get(hObject,'Value') returns toggle state of osc_state_stop_radiobutton


% --- Executes on button press in osc_wavesave_button.
function osc_wavesave_button_Callback(hObject, eventdata, handles)
% hObject    handle to osc_wavesave_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global deviceObj
global label_osc_channel
% set(hObject,'BackgroundColor',[0.85 0.33 0.1]);
Precision_choose=get(handles.osc_precision_16_radiobutton,'Value');
file_head=get(handles.osc_wavefile_add_text,'String');
if ~exist(file_head,'dir')
    mkdir(file_head);
end
temp_bin_add=get_all_file(file_head,'*.dat');
length_file=length(temp_bin_add);
file_num=get_ordered_str(hObject, eventdata, handles,length_file+1);
file_num_add=get_ordered_str(hObject, eventdata, handles,length_file+2);
set(handles.osc_file_name_text,'String',['File_name(Next):  ','C',num2str(label_osc_channel),'_',file_num,'.dat']);
file_path=fullfile(file_head,['C',num2str(label_osc_channel),'_',file_num,'.dat']);
if exist(file_path,'file')
    disp('文件命名错误');
%     set(hObject,'BackgroundColor',[0.5 0.5 0.5]);
    return;
end
winopen(file_head);
clipboard('copy',file_path);
if label_osc_connect==1
    try
    connect(deviceObj);   
    groupObj = get(deviceObj, 'Waveform');
    groupObj = groupObj(1);
    if Precision_choose==1  
        [data,~]=precision_int16(groupObj, ['channel',num2str(label_osc_channel)],true);
    else
        [data,~,~,~,~] = invoke(groupObj, 'readwaveform', ['channel',num2str(label_osc_channel)]);
    end
    disconnect(deviceObj);
    dlmwrite(file_path,data,'newline','pc','precision',6);
    set(handles.osc_file_name_text,'String',['File_name(Next):  ','C',num2str(label_osc_channel),'_',file_num_add,'.dat  ',num2str(length(data))]);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
        set(handles.osc_status_text,'String','osc disconnect!!');
    end
else
    set(handles.osc_status_text,'String','osc disconnect!!');
end
% set(hObject,'BackgroundColor',[0.5 0.5 0.5]);

% --- Executes on button press in osc_dir_button.
function osc_dir_button_Callback(hObject, eventdata, handles)
% hObject    handle to osc_dir_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
original_path=get(handles.osc_wavefile_add_text,'String');
path_head=uigetdir(original_path);
if ~isempty(path_head)&&strcmp(path_head,original_path)~=1
    set(handles.osc_wavefile_add_text,'String',path_head);
    %make_folder(hObject, eventdata, handles);
end


% --- Executes on button press in osc_wave_plot_button.
function osc_wave_plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to osc_wave_plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_head=get(handles.osc_wavefile_add_text,'String');
if ~exist(file_head,'dir')
    disp('dir is error!!');
    return;
end
temp_bin_add=get_all_file(file_head,'*.dat');

%%方法一：-----------------------------------------------------
if ~exist(temp_bin_add{1,end},'file')&&~isempty(temp_bin_add)
    disp('file is missing!!');
    return;
end
data=dlmread(temp_bin_add{1,end});
figure(20);
plot(data);

%%方法二：-----------------------------------------------------
% length_file=length(temp_bin_add);
% file_num=get_ordered_str(hObject, eventdata, handles,length_file);
% file_path=fullfile(file_head,['C',num2str(label_osc_channel),'_',file_num,'.dat']);
% if ~exist(file_path,'file')
%     disp('file is missing!!');
%     return;
% end
% data=dlmread(file_path);
% figure(20);
% plot(data);


% --- Executes on button press in diehard_average_radiobutton.
function diehard_average_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to diehard_average_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of diehard_average_radiobutton



function osc_delay_edit_Callback(hObject, eventdata, handles)
% hObject    handle to osc_delay_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delay_value=str2double(get(hObject,'String'));
if isnan(delay_value)
      NET.addAssembly('System.Windows.Forms');%调用窗体动态库
    import System.Windows.Forms.*;%导入窗体的所有类“*”
    MessageBox.Show('Please input a num!!','Error',MessageBoxButtons.OK,MessageBoxIcon.Error);
    set(hObject,'String','0');
end
% list=get(handles.osc_delay_unit_popupmenu,'String');
% delay_unit=list{delay_unit_num};

% Hints: get(hObject,'String') returns contents of osc_delay_edit as text
%        str2double(get(hObject,'String')) returns contents of osc_delay_edit as a double


% --- Executes during object creation, after setting all properties.
function osc_delay_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_delay_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in osc_delay_unit_popupmenu.
function osc_delay_unit_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to osc_delay_unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns osc_delay_unit_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from osc_delay_unit_popupmenu


% --- Executes during object creation, after setting all properties.
function osc_delay_unit_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to osc_delay_unit_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in osc_delay_button.
function osc_delay_button_Callback(hObject, eventdata, handles)
% hObject    handle to osc_delay_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_osc_connect
global deviceObj
global label_osc_channel
delay_value=str2double(get(handles.osc_delay_edit,'String'));
delay_unit_num=get(handles.osc_delay_unit_popupmenu,'Value');
% list=get(handles.osc_delay_unit_popupmenu,'String');
% delay_unit=list{delay_unit_num};
switch(delay_unit_num)
    case 1
        delay_value=delay_value*1e-12;
    case 2
        delay_value=delay_value*1e-9;
    case 3
        delay_value=delay_value*1e-6;
    case 4
        delay_value=delay_value*1e-3;
    otherwise 
end
% set(hObject,'BackgroundColor',[0.85 0.33 0.1]);
if label_osc_connect==1
    try
        connect(deviceObj);   
        set(deviceObj.Acquisition(1),'Delay',delay_value);
%         set(deviceObj.Channel(label_osc_channel),'Delay',delay_value);
        disconnect(deviceObj);
    catch
        label_osc_connect=0;
        disconnect(deviceObj);
        osc_connect_test(hObject, eventdata, handles);
        write_osc_status(hObject, eventdata, handles);
        set(handles.osc_status_text,'String','osc disconnect!!');
    end
else
    set(handles.osc_status_text,'String','osc disconnect!!');
end


% --- Executes on button press in plug_in_function.
function plug_in_function_Callback(hObject, eventdata, handles)
% hObject    handle to plug_in_function (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%----function 0
% global label_osc_connect
% global deviceObj
% precision_type=get(handles.osc_precision_16_radiobutton,'Value');
% if label_osc_connect==1
%    [label_osc_connect,lagDiff,coeff]=compare_two_channel_delay(deviceObj,precision_type,2,3);
%    set(handles.osc_status_text,'String',['time_delay(',num2str(lagDiff),'): ',num2str(lagDiff/handles.Fs*1e9),'ns']);
% else
%     set(handles.osc_status_text,'String','osc disconnect!!');
% end
%%----function 1
% app1(hObject, eventdata, handles,'0');
% app1(hObject, eventdata, handles,'2000');
%%----function 2
% app2();
%%----function 3
app3(hObject, eventdata, handles);


function app1(hObject, eventdata, handles,ds_command)
%%----function 1
%---osc_connect
global serial_obj
global OSA_obj
time=datestr(now,29);
% ds_command='2000';
loop_ico_start=-98;
loop_ico_step=2;
loop_ico_stop=98;
path_head=fullfile(fullfile('E:\EXP1(feedback_-3.82_tdc_power)',['Experiment1_',time])...
    ,['DS_',ds_command,'_ICO(',num2str(loop_ico_start),'-',num2str(loop_ico_step),'-',num2str(loop_ico_stop),')']);
excel_file_name='TDC功率测试（OSA与TDC）.xlsx';
ds_command=['ds set ',ds_command];
tdc_information_ds=tdc_state_test(hObject, eventdata, handles,ds_command,serial_obj);
write_tdc_information(hObject, eventdata, handles,tdc_information_ds);
tdc_status_slider_Callback(hObject, eventdata, handles); 
num_order=0;
for loop_ico=loop_ico_start:loop_ico_step:loop_ico_stop
    ico_command=['ds ico ',num2str(loop_ico)];
    tdc_state_test(hObject, eventdata, handles,ico_command,serial_obj);
%     tdc_information_ico=tdc_state_test(hObject, eventdata, handles,ico_command,serial_obj);
%     write_tdc_information(hObject, eventdata, handles,tdc_information_ico);
%     tdc_status_slider_Callback(hObject, eventdata, handles);
    num_order=num_order+1;
    Relatioship_feedback_osa_power_tdc(OSA_obj,path_head,serial_obj,excel_file_name,num_order);%no TDC,Precision_choose:1-16,1-8
end

function app2()
%%----function 2
%无TDC
global deviceObj
global SA_obj
global OSA_obj
global label_osc_channel
time=datestr(now,29);
path_head_origin=fullfile('E:',['Experiment2_',time]);
for loop_save=1:100
    %%-----------------------------
    loop_label=questdlg('是否继续？(OSA)','操作','Yes','No','Yes');
    if ~strcmp(loop_label,'Yes')
        disp('break');
        break;
    end
    fopen(OSA_obj);
    DC_Power_s=query(OSA_obj,'SPMEASDETECTORDBM100');%100次统计均值
    DC_Power=round(str2double(DC_Power_s(17:end-1)),3);
    disp(['>Loop_times: ',num2str(loop_save)]);
    disp(['>Feedback: ',num2str(DC_Power)]);
    disp('');
    fclose(OSA_obj);
    if loop_save<10
        loop_save_str=['0',num2str(loop_save)];
    else
        loop_save_str=num2str(loop_save);
    end
    path_head=fullfile(path_head_origin,['Feedback_power_',loop_save_str,'(',num2str(DC_Power),')']);
    filespec_excel_OSC={fullfile(path_head_origin,'OSC_analy.xlsx'),fullfile(path_head_origin,'OSC_diehard.xlsx')};
    Relatioship_feedback_data_sa_osa(deviceObj,SA_obj,OSA_obj,path_head,filespec_excel_OSC,1,label_osc_channel,1,loop_save)%no TDC,Precision_choose:1-16,1-8
end

function app3(hObject, eventdata, handles)
%%----function 2
global deviceObj
global SA_obj
global OSA_obj
global label_osc_channel
global serial_obj
ds_command='0';
ico_command='36';
ds_command=['ds set ',ds_command];
tdc_information_ds=tdc_state_test(hObject, eventdata, handles,ds_command,serial_obj);
write_tdc_information(hObject, eventdata, handles,tdc_information_ds);
tdc_status_slider_Callback(hObject, eventdata, handles);
ico_command=['ds ico ',num2str(ico_command)];
tdc_information_ico=tdc_state_test(hObject, eventdata, handles,ico_command,serial_obj);
write_tdc_information(hObject, eventdata, handles,tdc_information_ico);
tdc_status_slider_Callback(hObject, eventdata, handles);
[~,~,tdc_information]=tdc_command(serial_obj,'ds');
position_1=strfind(tdc_information{2},':')+2;
position_2=strfind(tdc_information{2},'ps')-2;
ds_value_str=tdc_information{2}(position_1:position_2);
ds_temp=floor(str2double(ds_value_str))+2100;
% ds_temp=get_the_str(ds_temp);
ds_temp=get_ordered_str(hObject, eventdata, handles,ds_temp);
position_1=strfind(tdc_information{3},':')+2;
position_2=strfind(tdc_information{3},'GHz')-2;
ico_value_str=tdc_information{3}(position_1:position_2);  
ico_temp=floor(str2double(ico_value_str))+99;
% ico_temp=get_the_str(ico_temp);
ico_temp=get_ordered_str(hObject, eventdata, handles,ico_temp);
time=datestr(now,29);
path_head_origin=fullfile(fullfile('E:\EXP3(tdc,feddbackandosa)',['Experiment3_',time]),['DS_',ds_temp,'_ICO_',ico_temp]);
for loop_save=1:100
    %%-----------------------------
    loop_label=questdlg('是否继续？','操作','Yes','No','Yes');
    if ~strcmp(loop_label,'Yes')
        disp('break');
        break;
    end
    fopen(OSA_obj);
    DC_Power_s=query(OSA_obj,'SPMEASDETECTORDBM100');%100次统计均值
    DC_Power=round(str2double(DC_Power_s(17:end-1)),3);
    disp(['>Loop_times: ',num2str(loop_save)]);
    disp(['>Feedback: ',num2str(DC_Power)]);
    disp('');
    fclose(OSA_obj);
    if loop_save<10
        loop_save_str=['0',num2str(loop_save)];
    else
        loop_save_str=num2str(loop_save);
    end
    path_head=fullfile(path_head_origin,['Feedback_power_',loop_save_str,'(',num2str(DC_Power),')']);
    filespec_excel_OSC={fullfile(path_head_origin,'OSC_analy.xlsx'),fullfile(path_head_origin,'OSC_diehard.xlsx')};
    Relatioship_feedback_data_sa_osa(deviceObj,SA_obj,OSA_obj,path_head,filespec_excel_OSC,1,label_osc_channel,1,loop_save)%no TDC,Precision_choose:1-16,1-8
end



% --- Executes on button press in SA_initial_button.
function SA_initial_button_Callback(hObject, eventdata, handles)
% hObject    handle to SA_initial_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SA_obj
global SA_open_label
SA_open_label=0;
set(handles.SA_initial_text,'BackgroundColor',[1 0 0]);
set(handles.SA_initial_text,'String','NULL');
%%find SA COM
getcom=instrhwinfo('serial');%获取可用串口
com_available=getcom.AvailableSerialPorts;
sa_com='';
if isempty(com_available)
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show('No available COM port!','Information',...
        MessageBoxButtons.OK,MessageBoxIcon.Information);
    return;
else   
    com_available_length=length(com_available);
    for i=1:com_available_length
        % Find a serial port object.
%         obj_sa = instrfind('Type', 'serial', 'Port', com_available{1,i}, 'Tag', '');
        SA_obj=serial(com_available{i,1});
        SA_obj.Timeout=2;%加快验证
        % Create the serial port object if it does not exist
        % otherwise use the object that was found.
        SA_obj=SA_obj(1);
        fopen(SA_obj);
        try
            identity_info = query(SA_obj, '*IDN?');
        catch
            identity_info='no data';
        end
        fclose(SA_obj);
        if strncmp(identity_info,'ADVANTEST,R3182,110401382,E00',25)
           sa_com=com_available{i,1};
           fclose(SA_obj);
           break;
        end      
    end
end
if isempty(sa_com)
    disp('NO suitable Instrument!!');
    return;
end
SA_obj.BaudRate=9600;
SA_obj.Terminator='CR';
SA_obj.Parity='none';
SA_obj.DataBits=8;
SA_obj.StopBits=1;
SA_obj.InputBufferSize=1000000;
SA_obj.OutputBufferSize=1000000;
SA_obj.Timeout=2; 
set(handles.SA_initial_text,'BackgroundColor',[0 0.498 0]);
set(handles.SA_initial_text,'String','OK');
SA_open_label=1;


% --- Executes on button press in SA_rbw_button.
function SA_rbw_button_Callback(hObject, eventdata, handles)
% hObject    handle to SA_rbw_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SA_obj
global SA_open_label
rbw_value_list=[3000000,1000000,300000,100000,30000,10000,3000,1000,300,100,30];
rbw_list_num=get(handles.SA_rbw_popupmenu,'value');
rbw_value=rbw_value_list(rbw_list_num);
if SA_open_label==1
    try
    fopen(SA_obj);
    fprintf(SA_obj,['RB',num2str(rbw_value)]);
    fclose(SA_obj);
    catch        
        SA_open_label=0;
        disp('SA cant be connected!!');
        set(handles.SA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.SA_initial_text,'String','NULL');
        fclose(SA_obj);
    end
end


% --- Executes on button press in SA_vbw_button.
function SA_vbw_button_Callback(hObject, eventdata, handles)
% hObject    handle to SA_vbw_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SA_obj
global SA_open_label
vbw_value_list=[3000000,1000000,300000,100000,30000,10000,3000,1000,300,100,30,10];
vbw_list_num=get(handles.SA_rbw_popupmenu,'value');
vbw_value=vbw_value_list(vbw_list_num);
if SA_open_label==1
    try
    fopen(SA_obj);
    fprintf(SA_obj,['VB',num2str(vbw_value)]);
    fclose(SA_obj);
    catch        
        SA_open_label=0;
        disp('SA cant be connected!!');
        set(handles.SA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.SA_initial_text,'String','NULL');
        fclose(SA_obj);
    end
end


% --- Executes on button press in SA_wave_save_button.
function SA_wave_save_button_Callback(hObject, eventdata, handles)
% hObject    handle to SA_wave_save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SA_obj
global SA_open_label
file_head=get(handles.SA_file_path_head_text,'String');
if ~exist(file_head,'dir')
    mkdir(file_head);
end
t1=clock;
temp_bin_add=get_all_file(file_head,'*.dat');
length_file=length(temp_bin_add);
file_num=get_ordered_str(hObject, eventdata, handles,length_file+1);
file_num_add=get_ordered_str(hObject, eventdata, handles,length_file+2);
set(handles.SA_file_name_text,'String',['File_num(Next): SA_',file_num]);
SA_file_name=['SA_',file_num];
SA_title_name=['SA\_',file_num];
if SA_open_label==1
    try
        fopen(SA_obj);
        Reference_level=str2double(query(SA_obj, 'RL?'));
        DB_div=str2double(query(SA_obj, 'DD?'));%0-10dB,1-5dB,2-2dB,3-1dB
        DB_div_value_list=[10,5,2,1];
        DB_div_value=DB_div_value_list(DB_div+1); 
        info=cell(1,4);
        info{1,1}='REF:';
        info{1,2}=[num2str(Reference_level),' dBm'];
        info{1,3}='DIV:';
        info{1,4}=[num2str(DB_div_value),' dB/div'];
        set(handles.SA_info_text,'String',info);
% for i=1:2
% if i==1
%     fprintf(SA_obj,'FA0');
%     fprintf(SA_obj,'FB1000000000');
%     pause(1);
% else
%     fprintf(SA_obj,'FA5000000000');
%     fprintf(SA_obj,'FB5050000000'); 
%     pause(1);
% end
% fprintf(SA_obj,'RB3000000');%3M**,1M,300k,100k,30k,10k,3k,1k,300,100,30,越小扫的越慢，越大，噪声越小
% fprintf(SA_obj,'VB30000');%3M,1M,300k,100k,30k**,10k,3k,1k,300,100,30,10越小扫的越慢,越大越不精细
%%--save SA file and fig
fprintf(SA_obj,'SI');%single
pause(10);
SA_spectrum_save(SA_obj,file_head,SA_file_name,SA_title_name,3);%1-file,2-fig,3-all
fprintf(SA_obj,'SN');%normal,表示repeat
% pause(0.5);
% end
fclose(SA_obj);
set(handles.SA_file_name_text,'String',['File_num(Next): SA_',file_num_add]);
    catch
        SA_open_label=0;
        disp('SA cant be connected!!');
        set(handles.SA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.SA_initial_text,'String','NULL');
        fclose(SA_obj);
    end
end
time=etime(clock,t1);
set_run_time(hObject, eventdata, handles,time);


% --- Executes on button press in SA_dir_select_button.
function SA_dir_select_button_Callback(hObject, eventdata, handles)
% hObject    handle to SA_dir_select_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
original_path=get(handles.SA_file_path_head_text,'String');
path_head=uigetdir(original_path);
if ~isempty(path_head)&&strcmp(path_head,original_path)~=1
    set(handles.SA_file_path_head_text,'String',path_head);
    %make_folder(hObject, eventdata, handles);
end


function SA_start_frequency_edit_Callback(hObject, eventdata, handles)
% hObject    handle to SA_start_frequency_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start_frequency_str=get(hObject,'String');
start_frequency_temp=get_the_real_value(start_frequency_str);
if isempty(start_frequency_temp)
    start_frequency=str2double(start_frequency_str);
else
    start_frequency=start_frequency_temp(1);
end
stop_frequency_str=get(handles.SA_stop_frequency_edit,'String');
stop_frequency_temp=get_the_real_value(stop_frequency_str);
if isempty(stop_frequency_temp)
    stop_frequency=str2double(stop_frequency_str);
else
    stop_frequency=stop_frequency_temp(1);
end
if isnan(inpchk(start_frequency,[0 stop_frequency],[1,1]))
    set(hObject,'String','0KHz');
else
    output_string=change_the_value_type(start_frequency);
    set(hObject,'String',output_string);
end
% Hints: get(hObject,'String') returns contents of SA_start_frequency_edit as text
%        str2double(get(hObject,'String')) returns contents of SA_start_frequency_edit as a double


% --- Executes during object creation, after setting all properties.
function SA_start_frequency_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SA_start_frequency_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SA_stop_frequency_edit_Callback(hObject, eventdata, handles)
% hObject    handle to SA_stop_frequency_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
start_frequency_str=get(handles.SA_start_frequency_edit,'String');
start_frequency_temp=get_the_real_value(start_frequency_str);
if isempty(start_frequency_temp)
    start_frequency=str2double(start_frequency_str);
else
    start_frequency=start_frequency_temp(1);
end
stop_frequency_str=get(hObject,'String');
stop_frequency_temp=get_the_real_value(stop_frequency_str);
if isempty(stop_frequency_temp)
    stop_frequency=str2double(stop_frequency_str);
else
    stop_frequency=stop_frequency_temp(1);
end
if isnan(inpchk(stop_frequency,[start_frequency 40000000000],[1,1]))
    set(hObject,'String','1MHz');
else
    output_string=change_the_value_type(stop_frequency);
    set(hObject,'String',output_string);
end
% Hints: get(hObject,'String') returns contents of SA_stop_frequency_edit as text
%        str2double(get(hObject,'String')) returns contents of SA_stop_frequency_edit as a double

function output_data=get_the_real_value(input_string)
unit_k=strfind(input_string,'KHz');
unit_m=strfind(input_string,'MHz');
unit_g=strfind(input_string,'GHz');
if ~isempty(unit_k)
    output_data=[str2double(input_string(1:end-3))*1e3,1];
else
    if ~isempty(unit_m)
       output_data=[str2double(input_string(1:end-3))*1e6,2];
    else
        if ~isempty(unit_g)
           output_data=[str2double(input_string(1:end-3))*1e9,3];
        else
           output_data=[];  
        end       
    end
end

function output_string=change_the_value_type(input_data)
if input_data<1e6
    output_string=[num2str(floor(input_data)/1e3),'KHz'];
else
    if input_data<1e9
        output_string=[num2str(floor(input_data)/1e6),'MHz'];
    else
        output_string=[num2str(floor(input_data)/1e9),'GHz'];
    end
end
        

% --- Executes during object creation, after setting all properties.
function SA_stop_frequency_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SA_stop_frequency_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SA_start_frequency_button.
function SA_start_frequency_button_Callback(hObject, eventdata, handles)
% hObject    handle to SA_start_frequency_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SA_obj
global SA_open_label
if SA_open_label==1
    try
    fopen(SA_obj);
    start_frequency_str=get(handles.SA_start_frequency_edit,'String');
    start_frequency_temp=get_the_real_value(start_frequency_str);
    if isempty(start_frequency_temp)
        start_frequency=str2double(start_frequency_str);
    else
        start_frequency=start_frequency_temp(1);
    end
    fprintf(SA_obj,['FA',num2str(start_frequency)]);
    fclose(SA_obj);
    catch        
        SA_open_label=0;
        disp('SA cant be connected!!');
        set(handles.SA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.SA_initial_text,'String','NULL');
        fclose(SA_obj);
    end
end


% --- Executes on button press in SA_stop_frequency_button.
function SA_stop_frequency_button_Callback(hObject, eventdata, handles)
% hObject    handle to SA_stop_frequency_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global SA_obj
global SA_open_label
if SA_open_label==1
    try
    fopen(SA_obj);
    stop_frequency_str=get(handles.SA_stop_frequency_edit,'String');
    stop_frequency_temp=get_the_real_value(stop_frequency_str);
    if isempty(stop_frequency_temp)
        stop_frequency=str2double(stop_frequency_str);
    else
        stop_frequency=stop_frequency_temp(1);
    end
    fprintf(SA_obj,['FB',num2str(stop_frequency)]);
    fclose(SA_obj);
    catch        
        SA_open_label=0;
        disp('SA cant be connected!!');
        set(handles.SA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.SA_initial_text,'String','NULL');
        fclose(SA_obj);
    end
end


% --- Executes on selection change in SA_rbw_popupmenu.
function SA_rbw_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to SA_rbw_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SA_rbw_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SA_rbw_popupmenu


% --- Executes during object creation, after setting all properties.
function SA_rbw_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SA_rbw_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SA_vbw_popupmenu.
function SA_vbw_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to SA_vbw_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SA_vbw_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SA_vbw_popupmenu


% --- Executes during object creation, after setting all properties.
function SA_vbw_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SA_vbw_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OSA_power__button.
function OSA_power__button_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_power__button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OSA_obj
global OSA_open_label
if OSA_open_label==1
    try
        fopen(OSA_obj);
        DC_Power_s=query(OSA_obj,'SPMEASDETECTORDBM100');%100次统计均值
        DC_Power=round(str2double(DC_Power_s(17:end-1)),3);
        set(handles.OSA_power_text,'String',[num2str(DC_Power),' dBm']);
        % disp(fscanf(OSA_obj));%用于清空缓存SP_SINGLE_SWEEP
        fclose(OSA_obj);
    catch
        OSA_open_label=0;
        disp('OSA cant be connected!!');
        set(handles.OSA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.OSA_initial_text,'String','NULL');
        fclose(OSA_obj);
    end
end

% --- Executes on button press in OSA_peaktocenter_button.
function OSA_peaktocenter_button_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_peaktocenter_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OSA_obj
global OSA_open_label
if OSA_open_label==1
    try
        fopen(OSA_obj);
        fprintf(OSA_obj,'SPPKCTR2\n');% peak to center%0-off,1-auto,2-manual%不用于清空缓存SP_SINGLE_SWEEP
        fprintf(OSA_obj, 'SPSWP1');
        disp(fscanf(OSA_obj));%用于清空缓存SP_SINGLE_SWEEP
        OSA_center_s = query(OSA_obj,'SPCTRWL?');
        OSA_center_value = round(str2double(OSA_center_s(8:end-3)),4);
        set(handles.OSA_p2c_text,'String',[num2str(OSA_center_value),' nm']);
        % disp(fscanf(OSA_obj));%用于清空缓存SP_SINGLE_SWEEP
        fclose(OSA_obj);
    catch
        OSA_open_label=0;
        disp('OSA cant be connected!!');
        set(handles.OSA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.OSA_initial_text,'String','NULL');
        fclose(OSA_obj);
    end
end


% --- Executes on button press in OSA_wave_save_button.
function OSA_wave_save_button_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_wave_save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OSA_obj
global OSA_open_label
file_head=get(handles.OSA_file_path_head_text,'String');
if ~exist(file_head,'dir')
    mkdir(file_head);
end
temp_bin_add=get_all_file(file_head,'*.dat');
length_file=length(temp_bin_add);
file_num=get_ordered_str(hObject, eventdata, handles,length_file+1);
file_num_add=get_ordered_str(hObject, eventdata, handles,length_file+2);
set(handles.OSA_file_name_text,'String',['File_num(Next): OSA_',file_num]);
if OSA_open_label==1
    try
    fopen(OSA_obj);
    DC_Power_s=query(OSA_obj,'SPMEASDETECTORDBM100');%100次统计均值
    DC_Power=round(str2double(DC_Power_s(17:end-1)),3);
    fprintf(OSA_obj, 'SPSWP1');
    fscanf(OSA_obj);%用于清空缓存SP_SINGLE_SWEEP
    OSA_center_s = query(OSA_obj,'SPCTRWL?');
    OSA_center_value = round(str2double(OSA_center_s(8:end-3)),4);
    OSA_span_s = query(OSA_obj,'SPSPANWL?');
    OSA_span_value = round(str2double(OSA_span_s(9:end-3)),3);
    info=cell(1,4);
    info{1,1}='Trace: 0';
    info{1,2}=['P: ',num2str(DC_Power),' dBm'];
    info{1,3}=['CW: ',num2str(OSA_center_value),' nm'];
    info{1,4}=['SP: ',num2str(OSA_span_value),' nm'];
    set(handles.OSA_info_text,'String',info);
    %%---file name
    OSA_file_name=['OSA_',file_num,'(',num2str(DC_Power),')_'...
        ,num2str(OSA_center_value),'_',num2str(OSA_span_value)];%OSA+loop+center_frequency+span+DC_power+3dB
    OSA_title_name=['OSA\_',file_num,'(',num2str(DC_Power),')\_'...
        ,num2str(OSA_center_value),'\_',num2str(OSA_span_value)];
    %%--save OSA file and fig
    OSA_spectrum_save(OSA_obj,file_head,OSA_file_name,OSA_title_name,3);%1-file,2-fig,3-all
    fclose(OSA_obj);
    set(handles.OSA_file_name_text,'String',['File_num(Next): OSA_',file_num_add]);
    catch
        OSA_open_label=0;
        disp('OSA cant be connected!!');
        set(handles.OSA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.OSA_initial_text,'String','NULL');
        fclose(OSA_obj);
    end
end

% --- Executes on button press in OSA_file_path_head_button.
function OSA_file_path_head_button_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_file_path_head_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
original_path=get(handles.OSA_file_path_head_text,'String');
path_head=uigetdir(original_path);
if ~isempty(path_head)&&strcmp(path_head,original_path)~=1
    set(handles.OSA_file_path_head_text,'String',path_head);
    %make_folder(hObject, eventdata, handles);
end


function OSA_span_edit_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_span_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
span=str2double(get(hObject,'String'));
if isnan(inpchk(span,[0.08 40],[0.01,0.01]))
    set(hObject,'String','1.6');
else
    set(hObject,'String',num2str(round(span,2)));
end
% Hints: get(hObject,'String') returns contents of OSA_span_edit as text
%        str2double(get(hObject,'String')) returns contents of OSA_span_edit as a double


% --- Executes during object creation, after setting all properties.
function OSA_span_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OSA_span_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OSA_center_wavelength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_center_wavelength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
center_wavelength=str2double(get(hObject,'String'));
if isnan(inpchk(center_wavelength,[1520 1575],[0.001,0.001]))
    set(hObject,'String','1545.2435');
else
    set(hObject,'String',num2str(round(center_wavelength,4)));
end
% Hints: get(hObject,'String') returns contents of OSA_center_wavelength_edit as text
%        str2double(get(hObject,'String')) returns contents of OSA_center_wavelength_edit as a double


% --- Executes during object creation, after setting all properties.
function OSA_center_wavelength_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OSA_center_wavelength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OSA_span_button.
function OSA_span_button_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_span_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OSA_obj
global OSA_open_label
if OSA_open_label==1
    try
        fopen(OSA_obj);
        OSA_bandwidth=str2double(get(handles.OSA_span_edit,'String'));
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
        fclose(OSA_obj);
    catch
        OSA_open_label=0;
        disp('OSA cant be connected!!');
        set(handles.OSA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.OSA_initial_text,'String','NULL');
        fclose(OSA_obj);
    end
end

% --- Executes on button press in OSA_center_wavelength.
function OSA_center_wavelength_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_center_wavelength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OSA_obj
global OSA_open_label
if OSA_open_label==1
    try
        fopen(OSA_obj);
        OSA_center_frequency=str2double(get(handles.OSA_center_wavelength_edit,'String'));
        fprintf(OSA_obj, ['SPCTRWL',num2str(OSA_center_frequency)]);
        disp(fscanf(OSA_obj))%用于清空缓存SP_SPAN_1.60000391965582nm
        % invoke(OSA_obj,'SPCTRWL',num2str(center_frequency));
        OSA_center_s = query(OSA_obj,'SPCTRWL?');
        OSA_center_value = round(str2double(OSA_center_s(8:end-3)),4);
        fprintf(OSA_obj, 'SPSWP1');
        fscanf(OSA_obj);%用于清空缓存SP_SINGLE_SWEEP
        if abs(OSA_center_value-OSA_center_frequency)>0.01
            NET.addAssembly('System.Windows.Forms');
            import System.Windows.Forms.*;
            MessageBox.Show('Fails to set the center wavelength','Error',...
            MessageBoxButtons.OK,MessageBoxIcon.Error);  
            disp('Fails to set the center wavelength');
            fclose(OSA_obj);
            return;
        end       
        fclose(OSA_obj);
    catch
        OSA_open_label=0;
        disp('OSA cant be connected!!');
        set(handles.OSA_initial_text,'BackgroundColor',[1 0 0]);
        set(handles.OSA_initial_text,'String','NULL');
        fclose(OSA_obj);
    end
end

% --- Executes on button press in OSA_initial_button.
function OSA_initial_button_Callback(hObject, eventdata, handles)
% hObject    handle to OSA_initial_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global OSA_obj
global OSA_open_label
OSA_open_label=0;
set(handles.OSA_initial_text,'BackgroundColor',[1 0 0]);
set(handles.OSA_initial_text,'String','NULL');
OSA_obj = instrfind('Type', 'tcpip', 'RemoteHost', '192.168.1.10', 'RemotePort', 8000, 'Tag', '');
% Create the tcpip object if it does not exist
% otherwise use the object that was found.
if isempty(OSA_obj)
    OSA_obj = tcpip('192.168.1.10', 8000);
else
    fclose(OSA_obj);
    OSA_obj = OSA_obj(1);
end
% Configure instrument object, obj1
set(OSA_obj, 'InputBufferSize', 10e6);
set(OSA_obj, 'OutputBufferSize', 3000000);
set(OSA_obj, 'Name', 'TCPIP-192.168.1.10(OSA)');
set(OSA_obj, 'Timeout', 2); 
fopen(OSA_obj); 
OSA_info = query(OSA_obj, 'SPSWPRES1');
if ~strcmp(OSA_info(1:19), 'SP_RESOLUTION_20MHz')
    disp('error device!!');
    fclose(OSA_obj);
    return
end
fclose(OSA_obj);
set(handles.OSA_initial_text,'BackgroundColor',[0 0.498 0]);
set(handles.OSA_initial_text,'String','OK');
OSA_open_label=1;
