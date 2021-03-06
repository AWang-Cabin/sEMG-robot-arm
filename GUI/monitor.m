function varargout = monitor(varargin)
% MONITOR MATLAB code for monitor.fig
%      MONITOR, by itself, creates a new MONITOR or raises the existing
%      singleton*.
%
%      H = MONITOR returns the handle to a new MONITOR or the handle to
%      the existing singleton*.
%
%      MONITOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MONITOR.M with the given input arguments.
%
%      MONITOR('Property','Value',...) creates a new MONITOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before monitor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to monitor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help monitor

% Last Modified by GUIDE v2.5 19-Apr-2020 21:09:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @monitor_OpeningFcn, ...
    'gui_OutputFcn',  @monitor_OutputFcn, ...
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


% --- Executes just before monitor is made visible.
function monitor_OpeningFcn(hObject, eventdata, handles, varargin)
% �����ʼ������
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to monitor (see VARARGIN)


% Choose default command line output for monitor
handles.output = hObject;
global flag;
flag=0;
h=timer;   %���ö�ʱ��
handles.he=h;   %������
%set(handles.he,'ExecutionMode','singleShot');  %��ʱ��ִֻ��һ�Σ���һ��ʱ��
set(handles.he,'ExecutionMode','fixedRate');   %��ʱ����ѭ��ִ�У�ѭ����ʱ��
set(handles.he,'Period',1);    %��ʱ������ʱ��� 1��
set(handles.he,'TimerFcn',{@disptime,handles});  %��ʱ������ʱ�ᴥ�� TimerFcn ��������ʱ����(TimerFcn)�����û��Զ���ĺ���(disptime����)
start(handles.he);   %������ʱ��
%% �����ʼ��
axes(handles.axes12);
imshow(imread('gui/neu.jpg'));
axes(handles.axes3);
imshow(imread('gui/relax1.jpg'));
axes(handles.axes4);
imshow(imread('gui/open1.jpg'));
axes(handles.axes5);
imshow(imread('gui/index1.jpg'));
axes(handles.axes6);
imshow(imread('gui/grasp1.jpg'));
axes(handles.axes7);
imshow(imread('gui/middle1.jpg'));
axes(handles.axes7);
set(handles.edit1,'string','����','foregroundcolor',[0,0,0]);

%% ��ʼ��arduino
global a ;
fclose(instrfind); % �ر��Ѵ򿪵Ĵ���
a=arduino('com3');

astatus=1;
if astatus
    set(handles.edit2,'string','����','foregroundcolor',[0,0,0]);
    pause(1);
    set(handles.edit3,'string','����','foregroundcolor',[0,0,0]);
end
servoAttach(a,7);servoAttach(a,8);servoAttach(a,9);
servoAttach(a,10);servoAttach(a,11);% ���ӻ�е��
servoWrite(a,7,40);servoWrite(a,8,140);servoWrite(a,9,140);
servoWrite(a,10,140);servoWrite(a,11,40);% ��ʼ����е��

%% Update handles structure
guidata(hObject, handles);

% UIWAIT makes monitor wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% �Զ���ĺ�������edit�ؼ������ݸĳɵ�ǰʱ�䡣��ʱ������ʱ�ᴥ���ú���
function disptime(hObject, eventdata, handles)
% ����ʱ����ʾ����
set(handles.edit5,'String',datestr(now));   % ��edit5�ؼ������ݸĳɵ�ǰʱ��

% --- Outputs from this function are returned to the command line.
function varargout = monitor_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startbutton.
function startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic

% ���ó�������״̬
global flag a;

set(handles.startbutton,'backgroundcolor',[0.53,0.94,0.42]);

%% ����ѵ���õķ���ģ�Ͷ�δ֪���ݽ���Ԥ��
model=libsvmload('D:/MATLAB2019/Workspace/sEMG/v3.0/copymodel.model',27);% ���ط���ģ��
sr=load('D:/MATLAB2019/Workspace/sEMG/v3.0/rule.mat');%���ع�һ������
st=load('moni.mat');
nr=fieldnames(sr);
rule=getfield(sr,char(nr));
test=getfield(st,char(fieldnames(st)));

%���û�����˼�룬��ȡһ��ʱ�䴰length_t,��������Сdelta_t,��λms
length_t=100;
delta_t=20;
m=1; % ���ߴ���

xx=0;
for i=1:delta_t:size(test,1)
    % ����ѭ������
    if i+length_t>size(test,1)
        break;
    elseif flag==1
        waitforbuttonpress; % ��ͣ
    end
    drawnow();% ��֪ȫ�ֱ����仯
    
    result(m)=g_testemg(model,rule,test,i,length_t);% ������
    
    v1=get(handles.sleft,'value');
    v2=get(handles.sright,'value');
    if v1==1
        % ����Ԥ����ͼ20*length(result)
        if mod(m,10)==0
            axes(handles.axes1);
            stairs(0.20*(m-10):0.20:0.20*(m-1),result(m-9:m),'r.','markersize',20);
            pause(0.001);% ˢ��ͼ��
            set(gca,'ytick',0:1:4);% ����y�Ჽ��
            axis([0.01*xx 0.01*(xx+2000) 0 4]);% ���������᷶Χ
            set(gca,'yticklabel',{'relax','open','middle','index','grasp'});
            xlabel('t/s');
            hold on;
            grid on;
        end
    end
    % ���ӻ���ʾ   
    if v2==1
        % ����ԭʼ����ͼ
        axes(handles.axes2);
        x=(i:i+delta_t); % ����x��
        plot(0.01*x,test(i:i+delta_t,2),'b');
        axis([0.01*xx 0.01*(xx+2000) -0.7 0.5]);
        xlabel('t/s');
        pause(0.001);% ˢ��ͼ��
        hold on;
        grid on;
    end
    
    if xx+2000-i<50
        xx=xx+50;% ������ʾ
    end
    
    if mod(m,6)==0
        axes(handles.axes8);
        switch result(m)
            case 0
                servoWrite(a,7,40);servoWrite(a,8,140);servoWrite(a,9,140);
                servoWrite(a,10,140);servoWrite(a,11,40);  % ���ƻ�е��
                set(handles.edit6,'string','����');   % ��ʾʶ����
                imshow(imread('gui/relax.jpg'));
            case 1
                servoWrite(a,7,0);servoWrite(a,8,180);servoWrite(a,9,180);
                servoWrite(a,10,180);servoWrite(a,11,0);
                set(handles.edit6,'string','����');
                imshow(imread('gui/open.jpg'));
            case 3
                servoWrite(a,7,100);servoWrite(a,8,100);servoWrite(a,9,180);
                servoWrite(a,10,180);servoWrite(a,11,0);
                set(handles.edit6,'string','��ʳָ');
                imshow(imread('gui/index.jpg'));
            case 4
                servoWrite(a,7,100);servoWrite(a,8,100);servoWrite(a,9,80);
                servoWrite(a,10,80);servoWrite(a,11,100);
                set(handles.edit6,'string','��ȭ');
                imshow(imread('gui/grasp.jpg'));
            case 2
                servoWrite(a,7,100);servoWrite(a,8,180);servoWrite(a,9,80);
                servoWrite(a,10,180);servoWrite(a,11,0);
                set(handles.edit6,'string','����ָ');
                imshow(imread('gui/middle.jpg'));
        end
    end
    m=m+1;
end


% Hint: get(hObject,'Value') returns toggle state of startbutton

function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ���ó�������״̬
global flag a;

set(handles.startbutton,'backgroundcolor',[0.53,0.94,0.42]);

%����ѵ���õķ���ģ�Ͷ�δ֪���ݽ���Ԥ��
model=libsvmload('D:/MATLAB2019/Workspace/copymodel.model',27);% ���ط���ģ��
sr=load('D:/MATLAB2019/Workspace/sEMG/v3.0/rule.mat');%���ع�һ������
st=load('moni.mat');
nr=fieldnames(sr);
rule=getfield(sr,char(nr));
test=getfield(st,char(fieldnames(st)));

%���û�����˼�룬��ȡһ��ʱ�䴰length_t,��������Сdelta_t,��λms
length_t=100;
delta_t=20;
m=1; % ���ߴ���

xx=0;
for i=1:delta_t:size(test,1)
    % ����ѭ������
    if i+length_t>size(test,1)
        break;
    elseif flag==1
        waitforbuttonpress; % ��ͣ
    end
    drawnow();% ��֪ȫ�ֱ����仯
    
    result(m)=g_testemg(model,rule,test,i,length_t);% ������
    
    v1=get(handles.sleft,'value');
    v2=get(handles.sright,'value');
    if v1==1
        % ����Ԥ����ͼ20*length(result)
        if mod(m,10)==0
            axes(handles.axes1);
            stairs(20*(m-10):20:20*(m-1),result(m-9:m),'r.','markersize',20);
            pause(0.001);% ˢ��ͼ��
            set(gca,'ytick',0:1:6);% ����y�Ჽ��
            axis([xx xx+2000 0 6]);% ���������᷶Χ
            hold on;
            grid on;
        end
        
    end
    if v2==1
        % ����ԭʼ����ͼ
        axes(handles.axes2);
        x=(i:i+delta_t); % ����x��
        plot(x,test(i:i+delta_t,2),'b');
        axis([xx xx+2000 -0.7 0.5]);
        pause(0.001);% ˢ��ͼ��
        hold on;
        grid on;
    end
    if xx+2000-i<50
        xx=xx+50;% ������ʾ
    end
    
    % ��ʾ������
    axes(handles.axes8);
    
    switch result(m)
        case 0
            servoWrite(a,7,40);servoWrite(a,8,140);servoWrite(a,9,140);
            servoWrite(a,10,140);servoWrite(a,11,40);% ���ƻ�е��
            set(handles.edit6,'string','����');
            imshow(imread('gui/relax.jpg'));
        case 1
            servoWrite(a,7,0);servoWrite(a,8,180);servoWrite(a,9,180);
            servoWrite(a,10,180);servoWrite(a,11,0);
            set(handles.edit6,'string','����');
            imshow(imread('gui/open.jpg'));
        case 3
            servoWrite(a,7,100);servoWrite(a,8,100);servoWrite(a,9,180);
            servoWrite(a,10,180);servoWrite(a,11,0);
            set(handles.edit6,'string','��ʳָ');
            imshow(imread('gui/index.jpg'));
        case 4
            servoWrite(a,7,100);servoWrite(a,8,100);servoWrite(a,9,80);
            servoWrite(a,10,80);servoWrite(a,11,100);
            set(handles.edit6,'string','��ȭ');
            imshow(imread('gui/grasp.jpg'));
        case 2
            servoWrite(a,7,100);servoWrite(a,8,180);servoWrite(a,9,80);
            servoWrite(a,10,180);servoWrite(a,11,0);
            set(handles.edit6,'string','����ָ');
            imshow(imread('gui/middle.jpg'));
    end
    m=m+1;
end

% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% ���ó�����ͣ״̬
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global flag;
flag=1;
set(handles.togglebutton2,'backgroundcolor','r');
set(handles.pushbutton1,'backgroundcolor',[0.94 0.94 0.94]);

% --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4

% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4



% --- Executes during object creation, after setting all properties.
function axes5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes5


% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes6

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% �˵�������
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpdlg('������ѧ������ѧԺ���Ʊ��� By ��һŵ','System Info');



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ���ó�����ͣ״̬
global flag;
flag=1;
set(handles.togglebutton2,'backgroundcolor','r');
set(handles.pushbutton1,'backgroundcolor',[0.94 0.94 0.94]);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag;
flag=0;
set(handles.togglebutton2,'backgroundcolor',[0.94 0.94 0.94]);
set(handles.pushbutton1,'backgroundcolor',[0.53,0.94,0.42]);


% --- Executes on button press in sleft.
function sleft_Callback(hObject, eventdata, handles)
% show left ��ť
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v1=get(handles.sleft,'value');
switch v1
    case 1
        set(handles.sleft,'backgroundcolor',[0.53,0.94,0.42]);
    case 0
        set(handles.sleft,'backgroundcolor',[0.94 0.94 0.94]);
end


% --- Executes on button press in sright.
function sright_Callback(hObject, eventdata, handles)
% show right��ť
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v2=get(handles.sright,'value');
switch v2
    case 1
        set(handles.sright,'backgroundcolor',[0.53,0.94,0.42]);
    case 0
        set(handles.sright,'backgroundcolor',[0.94 0.94 0.94]);
end


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag;
flag=0;
set(handles.togglebutton2,'backgroundcolor',[0.94 0.94 0.94]);
set(handles.pushbutton1,'backgroundcolor',[0.53,0.94,0.42]);
