function varargout = QQPlot(varargin)
% QQPLOT M-file for QQPlot.fig
%      QQPLOT, by itself, creates a new QQPLOT or raises the existing
%      singleton*.
%
%      H = QQPLOT returns the handle to a new QQPLOT or the handle to
%      the existing singleton*.
%
%      QQPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QQPLOT.M with the given input arguments.
%
%      QQPLOT('Property','Value',...) creates a new QQPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QQPlot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QQPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QQPlot

% Last Modified by GUIDE v2.5 09-Oct-2021 12:30:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QQPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @QQPlot_OutputFcn, ...
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


% --- Executes just before QQPlot is made visible.
function QQPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QQPlot (see VARARGIN)

% Choose default command line output for QQPlot
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes QQPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = QQPlot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_masuk.
function pushbutton_masuk_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_masuk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[namafile direktori]=uigetfile('*.xls','Ambil Data');
M=xlsread([namafile],-1);
set(handles.tabeldata,'Data',M);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_hitung.
function pushbutton_hitung_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_hitung (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=get(handles.tabeldata,'Data');
A=cov(data);
invers=inv(A);
B=mean(data);
Y=[(data(:,1)-B(1,1)),(data(:,2)-B(1,2))];
Y2=Y';
y=[sort(diag(Y(1:(length(data)),:)*invers*Y2(:,1:(length(data)))))];
yy=[diag(Y(1:(length(data)),:)*invers*Y2(:,1:(length(data))))];
x=(chi2inv(((1:(length(data)))-0.5)/(length(data)),2))';
xx=chi2inv(((1:(length(data)))-0.5)/(length(data)),2);
matrik=[yy,x];
namafile='Hasil.xls';
data2=xlswrite(namafile,matrik,1,'A1');
data3=csvread('Hasil.csv');
set(handles.tabelhasil,'Data',data3);

aa=y-(mean(y));
bb=(xx-(mean(xx)))';
r=sum(aa.*bb)./sqrt((sum(aa.^2)).*(sum(bb.^2)));
set(handles.edit_r,'string',r);

if max(matrik(:,2))>=max(matrik(:,1));
    x1=0:(max(x));
    y1=0:(max(x));
else
    x1=0:(max(yy));
    y1=0:(max(yy));
end
handles.x=x;
handles.y=y;
axes(handles.axes_qqplot);
    plot(x,y,'ro',x1,y1,'-b');
    ylim([0 max(y+1)]);
    xlim([0 max(x+1)]);
    xlabel('Quantile');
    ylabel('Mahalanobis');
    title('QQ Plot');
    grid on
    
rtabel=1.0063-(0.6118/(length(data)))+(1.3505/(length(data))^2)-(0.1288/sqrt(length(data)));
if r>=rtabel;
    set(handles.edit_hasil,'string','Data berdistribusi normal');
else
    set(handles.edit_hasil,'string','Data tidak berdistribusi normal');
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

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

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tabeldata, 'Data', {});
set(handles.tabelhasil, 'Data', {});
set(handles.edit_r, 'String',{});
set(handles.edit_hasil, 'String',{});
axes(handles.axes_qqplot);
cla reset;

function edit_hasil_Callback(hObject, eventdata, handles)
% hObject    handle to edit_hasil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_hasil as text
%        str2double(get(hObject,'String')) returns contents of edit_hasil as a double

% --- Executes during object creation, after setting all properties.
function edit_hasil_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_hasil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
