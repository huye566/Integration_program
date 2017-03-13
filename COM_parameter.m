function varargout = COM_parameter(varargin)
% COM_PANE MATLAB code for com_pane.fig
%      COM_PANE, by itself, creates a new COM_PANE or raises the existing
%      singleton*.
%
%      H = COM_PANE returns the handle to a new COM_PANE or the handle to
%      the existing singleton*.
%
%      COM_PANE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COM_PANE.M with the given input arguments.
%
%      COM_PANE('Property','Value',...) creates a new COM_PANE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before COM_parameter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to COM_parameter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help com_pane

% Last Modified by GUIDE v2.5 01-Nov-2016 18:01:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @COM_parameter_OpeningFcn, ...
                   'gui_OutputFcn',  @COM_parameter_OutputFcn, ...
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


% --- Executes just before com_pane is made visible.
function COM_parameter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to com_pane (see VARARGIN)

% Choose default command line output for com_pane
handles.output = hObject;

global serial_obj
global label_open%用于判断com口是否打开
global label_close
label_close=0;
serial_obj=varargin{1};
label_open=varargin{2};

% Update handles structure
guidata(hObject, handles);
uiwait(handles.com_set);


% UIWAIT makes com_pane wait for user response (see UIRESUME)
% uiwait(handles.com_set);


% --- Outputs from this function are returned to the command line.
function varargout = COM_parameter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global serial_obj
global label_open%用于判断com口是否打开
global label_close

varargout{1} =serial_obj ;
varargout{2} =label_open;
if label_close==1
delete(handles.com_set);
end


% --- Executes on button press in serial_button.
function serial_button_Callback(hObject, eventdata, handles)
% hObject    handle to serial_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global label_open
global serial_obj
getcom=instrhwinfo('serial');%获取可用串口
com_available=getcom.AvailableSerialPorts;
if isempty(com_available)==1
    set(handles.confirm_text,'String','NULL');
    set(handles.confirm_text, 'BackgroundColor',[1 0 0]);
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show('No available COM port!','Information',...
        MessageBoxButtons.OK,MessageBoxIcon.Information);
    set(handles.serial_popupmenu,'String','nocom');
    serial_obj='nocom';
    label_open=0;
else
    if length(com_available)<2
        set(handles.serial_popupmenu,'String',com_available);
    else
    com_available_length=length(com_available);
    info='';
    for i=1:com_available_length
       info=[info,com_available{i},char(13,10)'];
    end
    info=[info,'请选择com口'];
    disp('请选择com口');
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show(info,'Information',...
        MessageBoxButtons.OK);
    set(handles.serial_popupmenu,'String',com_available);
    end
end


% --- Executes on button press in confirm_button.
function confirm_button_Callback(hObject, eventdata, handles)
% hObject    handle to confirm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global serial_obj
global label_open
popupmenu_num=zeros(1,9);
serial_information=cell(1,9);
list=get(handles.serial_popupmenu,'String');
if iscell(list)
popupmenu_num(1)=get(handles.serial_popupmenu,'value');
serial_information{1}=list{popupmenu_num(1)};
else
    serial_information{1}=list;
end
list=get(handles.baudrate_popupmenu,'String');
if iscell(list)
popupmenu_num(2)=get(handles.baudrate_popupmenu,'value');
serial_information{2}=list{popupmenu_num(2)};
else
    serial_information{2}=list;
end
list=get(handles.terminator_popupmenu,'String');
if iscell(list)
popupmenu_num(3)=get(handles.terminator_popupmenu,'value');
serial_information{3}=list{popupmenu_num(3)};
else
    serial_information{3}=list;
end
list=get(handles.parity_popupmenu,'String');
if iscell(list)
popupmenu_num(4)=get(handles.parity_popupmenu,'value');
serial_information{4}=list{popupmenu_num(4)};
else
    serial_information{4}=list;
end
list=get(handles.databits_popupmenu,'String');
if iscell(list)
popupmenu_num(5)=get(handles.databits_popupmenu,'value');
serial_information{5}=list{popupmenu_num(5)};
else
    serial_information{5}=list;
end
list=get(handles.stopbits_popupmenu,'String');
if iscell(list)
popupmenu_num(6)=get(handles.stopbits_popupmenu,'value');
serial_information{6}=list{popupmenu_num(6)};
else
    serial_information{6}=list;
end
list=get(handles.inputbuffersize_popupmenu,'String');
if iscell(list)
popupmenu_num(7)=get(handles.inputbuffersize_popupmenu,'value');
serial_information{7}=list{popupmenu_num(7)};
else
    serial_information{7}=list;
end
list=get(handles.outputbuffersize_popupmenu,'String');
if iscell(list)
popupmenu_num(8)=get(handles.outputbuffersize_popupmenu,'value');
serial_information{8}=list{popupmenu_num(8)};
else
    serial_information{8}=list;
end
list=get(handles.timeout_popupmenu,'String');
if iscell(list)
popupmenu_num(9)=get(handles.timeout_popupmenu,'value');
serial_information{9}=list{popupmenu_num(9)};
else
    serial_information{9}=list;
end

getcom=instrhwinfo('serial');%获取可用串口
com_available=getcom.AvailableSerialPorts;
if strcmp(serial_information{1},'nocom')==1
    set(handles.confirm_text,'String','NULL');
    set(handles.confirm_text, 'BackgroundColor',[1 0 0]);
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show(' No available COM!','Information',...
        MessageBoxButtons.OK,MessageBoxIcon.Information);
    label_open=0;
    serial_obj='nocom';
    set(handles.confirm_text,'String','NULL');
    set(handles.confirm_text, 'BackgroundColor',[1 0 0]);
else
    if isempty(com_available)==1
    set(handles.confirm_text,'String','NULL');
    set(handles.confirm_text, 'BackgroundColor',[1 0 0]);
    NET.addAssembly('System.Windows.Forms');
    import System.Windows.Forms.*;
    MessageBox.Show('No available COM port!','Information',...
        MessageBoxButtons.OK,MessageBoxIcon.Information);
    set(handles.popupmenu_serial,'String','nocom');
    label_open=0;
    serial_obj='nocom';
    set(handles.confirm_text,'String','NULL');
    set(handles.confirm_text, 'BackgroundColor',[1 0 0]);
    else
    %打开串口
    serial_obj=serial(serial_information{1});
    serial_obj.BaudRate=floor(str2double(serial_information{2}));
    serial_obj.Terminator=serial_information{3};
    serial_obj.Parity=serial_information{4};
    serial_obj.DataBits=floor(str2double(serial_information{5}));
    serial_obj.StopBits=floor(str2double(serial_information{6}));
    serial_obj.InputBufferSize=floor(str2double(serial_information{7}));
    serial_obj.OutputBufferSize=floor(str2double(serial_information{8}));
    serial_obj.Timeout=floor(str2double(serial_information{9}));
    %fopen(obj);
    fopen(serial_obj);
    try
    fprintf(serial_obj,'ds');
    pause(0.4);
    temp=cell(1,30);
    for i=1:30
        back_data=get(serial_obj,'BytesAvailable');
        %back_data=obj.BytesAvailable;
        if back_data>=1
            temp{i}=fscanf(serial_obj);
        else
            length_data=i-1;
            break;
        end
    end
    fclose(serial_obj);
    temp=temp(1:length_data);
    if ~isempty(strfind(temp,'DS SET'))
    set(handles.confirm_text,'String','NULL');
    set(handles.confirm_text, 'BackgroundColor',[1 0 0]);
    pause(1);
    set(handles.confirm_text,'String','OK');
    set(handles.confirm_text, 'BackgroundColor',[0 0.498 0]);
    label_open=1;
    fid=fopen('.\doc_serial\tdc_information.txt','w');
    fprintf(fid,'Welcome!--made by huye:)!!');
    fprintf(fid,'\r\n');
    info_date=datestr(now,31);
    fprintf(fid,['>>',info_date]);
    fprintf(fid,'\r\n');
    fprintf(fid,['>serial:',serial_information{1}]);
    fprintf(fid,'\r\n');
    fprintf(fid,['>baudrate:',serial_information{2}]);
    fprintf(fid,'\r\n');
    fprintf(fid,['>Terminator:',serial_information{3}]);
    fprintf(fid,'\r\n');
    fprintf(fid,['>parity:',serial_information{4}]);
    fprintf(fid,'\r\n');
    fprintf(fid,['>databits:',serial_information{5}]);
    fprintf(fid,'\r\n');
    fprintf(fid,['>stopbits:',serial_information{6}]);
    fprintf(fid,'\r\n');
    fprintf(fid,['>inputbuffersize:',serial_information{7}]);
    fprintf(fid,'\r\n');
    fprintf(fid,['>outputbuffersize:',serial_information{8}]);
    fprintf(fid,'\r\n');
    fclose(fid);
    else
       label_open=0;
       serial_obj='nocom'; 
       set(handles.confirm_text,'String','NULL');
       set(handles.confirm_text, 'BackgroundColor',[1 0 0]);
       NET.addAssembly('System.Windows.Forms');
        import System.Windows.Forms.*;
        MessageBox.Show('COM port is error1!','Information',...
            MessageBoxButtons.OK,MessageBoxIcon.Information);
    end
    catch
        fclose(serial_obj);
        label_open=0;
        serial_obj='nocom';
        set(handles.confirm_text,'String','NULL');
        set(handles.confirm_text, 'BackgroundColor',[1 0 0]); 
        NET.addAssembly('System.Windows.Forms');
        import System.Windows.Forms.*;
        MessageBox.Show('COM port is error2!','Information',...
            MessageBoxButtons.OK,MessageBoxIcon.Information);
    end
    end
end



% --- Executes on button press in close_button.
function close_button_Callback(hObject, eventdata, handles)
% hObject    handle to close_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.com_set);
global label_close
label_close=1;


% --- Executes on selection change in serial_popupmenu.
function serial_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to serial_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns serial_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from serial_popupmenu


% --- Executes during object creation, after setting all properties.
function serial_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to serial_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in baudrate_popupmenu.
function baudrate_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to baudrate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns baudrate_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from baudrate_popupmenu


% --- Executes during object creation, after setting all properties.
function baudrate_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baudrate_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in terminator_popupmenu.
function terminator_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to terminator_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns terminator_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from terminator_popupmenu


% --- Executes during object creation, after setting all properties.
function terminator_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to terminator_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in parity_popupmenu.
function parity_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to parity_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns parity_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from parity_popupmenu


% --- Executes during object creation, after setting all properties.
function parity_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parity_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in databits_popupmenu.
function databits_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to databits_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns databits_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from databits_popupmenu


% --- Executes during object creation, after setting all properties.
function databits_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to databits_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in stopbits_popupmenu.
function stopbits_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to stopbits_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stopbits_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stopbits_popupmenu


% --- Executes during object creation, after setting all properties.
function stopbits_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stopbits_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in inputbuffersize_popupmenu.
function inputbuffersize_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to inputbuffersize_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns inputbuffersize_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputbuffersize_popupmenu


% --- Executes during object creation, after setting all properties.
function inputbuffersize_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputbuffersize_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in outputbuffersize_popupmenu.
function outputbuffersize_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to outputbuffersize_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns outputbuffersize_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outputbuffersize_popupmenu


% --- Executes during object creation, after setting all properties.
function outputbuffersize_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputbuffersize_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in timeout_popupmenu.
function timeout_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to timeout_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns timeout_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from timeout_popupmenu


% --- Executes during object creation, after setting all properties.
function timeout_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeout_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
