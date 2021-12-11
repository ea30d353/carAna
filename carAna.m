function varargout = carAna(varargin)
% CARANA MATLAB code for carAna.fig
%      CARANA, by itself, creates a new CARANA or raises the existing
%      singleton*.
%
%      H = CARANA returns the handle to a new CARANA or the handle to
%      the existing singleton*.
%
%      CARANA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CARANA.M with the given input arguments.
%
%      CARANA('Property','Value',...) creates a new CARANA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before carAna_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to carAna_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help carAna

% Last Modified by GUIDE v2.5 03-Apr-2021 09:42:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @carAna_OpeningFcn, ...
                   'gui_OutputFcn',  @carAna_OutputFcn, ...
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


% --- Executes just before carAna is made visible.
function carAna_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to carAna (see VARARGIN)

% Choose default command line output for carAna
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes carAna wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global fileDir; fileDir=''; %stp文件路径（全路径）
global filePwd; filePwd=''; %stp文件工作路径
global ifdrawit; ifdrawit=false; %布尔数，判断是否绘图
global xialaValue1; xialaValue1=1; %下拉菜单1的value
global xialaValue2; xialaValue2=1; %下拉菜单2的value
global femnode; femnode = [];
global femelement; femelement = [];
global originShape; originShape = [];
% 以下是有限元计算需要的矩阵
global fixnodes; fixnodes=[];
global pointload; pointload=[];
global young; young=[];
global poiss; poiss=[];
global denss; denss=[];
global thick; thick=[];
%位移
global udisp; udisp=[];



% --- Outputs from this function are returned to the command line.
function varargout = carAna_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_4_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ifdrawit;
global femnode;
global femelement;
[name,dir,index]=uigetfile({'*.stp';'*.step'},'选择模型文件');  %打开文件对话框。index表示判断打开文件还是点击取消
if index~=0    %如果选择打开文件
str=[dir,name];  %字符串拼接
% warndlg(str, '文件全路径');%内容，标题
py.gMeshTools.meshit(str, dir); %看见这句话报错配置好matlab-python环境
if ifdrawit == true
    cla reset;
end
[femNode, femEle] = readMesh([dir, 't20.inp']);
plotMesh(femNode, femEle, 0);
femnode = femNode;
femelement = femEle;
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global femnode;
global femelement;
global fixnodes;
global pointload;
global young;
global poiss;
global denss;
global thick;

global xialaValue2;

global udisp;
udisp = shellsolver(femnode, femelement, fixnodes, pointload, young, poiss, denss, thick);

PlotFieldonMesh(femnode, femelement,udisp, xialaValue2);

maxUX = max(abs(udisp(1:5:end)));
maxUY = max(abs(udisp(2:5:end)));
maxUZ = max(abs(udisp(3:5:end)));
set(handles.text2, 'String', ['x方向最大位移：', num2str(maxUX), newline, ...
                              'y方向最大位移：', num2str(maxUY), newline, ...
                              'z方向最大位移：', num2str(maxUZ)])




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla reset;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global xialaValue2;
xialaValue2 = get(hObject, 'Value');


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global femnode;
global femelement;
global udisp;
global xialaValue2;
PlotFieldonMesh(femnode, femelement,udisp, xialaValue2);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xialaValue1;
global femnode;
global femelement;
global originShape;
shapePoint=load('./DataFiles/shapePoint.dat');
originShape = femnode(shapePoint,:);
switch xialaValue1
    case 1
        femnode(shapePoint,:) = originShape;
    case 2
        for i=1:1:size(originShape, 1)
            originShape(i,:) = originShape(1,:) + (i-1) * (originShape(end,:) - originShape(1,:)) ./ (size(originShape, 1) - 1);
        end
        femnode(shapePoint,:) = originShape;
    case 3
        for i=1:1:size(originShape, 1)
            originShape(i,:) = originShape(1,:) + ((i-1)+5e-3*i^2) * (originShape(end,:) - originShape(1,:)) ./ (size(originShape, 1) - 1);
        end
        femnode(shapePoint,:) = originShape;
    case 4
        for i=1:1:size(originShape, 1)
            originShape(i,:) = originShape(1,:) + ((i-1)+1e-4*i^3) * (originShape(end,:) - originShape(1,:)) ./ (size(originShape, 1) - 1);
        end
        femnode(shapePoint,:) = originShape;
end
plotMesh(femnode, femelement, 0);




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fixnodes; fixnodes=[];
global pointload; pointload=[];
global young; young=[];
global poiss; poiss=[];
global denss; denss=[];
global thick; thick=[];
[name,dir,index]=uigetfile({'*.m';},'选择前处理文件');  %打开文件对话框。index表示判断打开文件还是点击取消
if index~=0    %如果选择打开文件
str=[dir,name];  %字符串拼接
% warndlg(str, '文件全路径');%内容，标题
eval(['cd ', dir])
eval(['[fixnodes, pointload, young, poiss, denss, thick] = ', name(1:1:end-2) ,'();'])
end


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
global xialaValue1;
xialaValue1 = get(hObject, 'Value');


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
