function varargout = spikesort_muxi_gui(varargin)
% SPIKESORT_MUXI_GUI MATLAB code for spikesort_muxi_gui.fig
%      SPIKESORT_MUXI_GUI, by itself, creates a new SPIKESORT_MUXI_GUI or raises the existing
%      singleton*.
%
%      H = SPIKESORT_MUXI_GUI returns the handle to a new SPIKESORT_MUXI_GUI or the handle to
%      the existing singleton*.
%
%      SPIKESORT_MUXI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPIKESORT_MUXI_GUI.M with the given input arguments.
%
%      SPIKESORT_MUXI_GUI('Property','Value',...) creates a new SPIKESORT_MUXI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before spikesort_muxi_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to spikesort_muxi_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help spikesort_muxi_gui

% Last Modified by GUIDE v2.5 22-Jan-2013 17:36:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @spikesort_muxi_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @spikesort_muxi_gui_OutputFcn, ...
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


% --- Executes just before spikesort_muxi_gui is made visible.
function spikesort_muxi_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to spikesort_muxi_gui (see VARARGIN)

% Choose default command line output for spikesort_muxi_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes spikesort_muxi_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%*****GET DEFAULTS FOR PARAMETERS*****

pt = get(handles.pt,'string');
bc = get(handles.bc,'string');
bc0 = get(handles.bc0,'string');
bc1 = get(handles.bc1,'string');
lar = get(handles.lar,'string');
tt0= get(handles.tt0,'string');
tt1 = get(handles.tt1,'string');
tt2 = get(handles.tt2,'string');
dt0 = get(handles.dt0,'string');
dt1 = get(handles.dt1,'string');
dz0 = get(handles.dz0,'string');
dz1 = get(handles.dz1,'string');
dz2 = get(handles.dz2,'string');
dz3 = get(handles.dz3,'string');
zo = get(handles.zo,'string');
sdm = get(handles.sdm,'string');
ma = get(handles.ma,'string');
dsd = get(handles.dsd,'string');
sr = get(handles.sr,'string');
bp0 = get(handles.bp0,'string');
bp1 = get(handles.bp1,'string');
np = get(handles.np,'string');
csd = get(handles.csd,'string');
mcsd = get(handles.mcsd,'string');
acsd = get(handles.acsd,'string');
dsdf = get(handles.dsdf,'string');
omsdf = get(handles.omsdf,'string');
mbf = get(handles.mbf,'string');
mbi = get(handles.mbi,'string');
auq = get(handles.auq,'string');
msu = get(handles.msu,'string');
avc = get(handles.avc,'string');
global pt bc bc0 bc1 lar tt0 tt1 tt2 dt0 dt1 dz0 dz1 dz2 dz3...
    zo sdm ma dsd sr bp0 bp1 np csd mcsd acsd dsdf omsdf mbf mbi auq...
    msu avc
grl = get(handles.grl,'value');
gts = get(handles.gts,'value');
gtlp = get(handles.gtlp,'value');
et = get(handles.et,'value');
pls = get(handles.pls,'value');
sl = get(handles.sl,'value');
musd = get(handles.musd,'value');
tm = get(handles.tm,'value');
clm = get(handles.clm,'value');
pc = get(handles.pc,'value');
stc = get(handles.stc,'value');
sca = get(handles.sca,'value');
global grl gts gtlp et pls sl musd tm clm pc stc sca

% --- Outputs from this function are returned to the command line.
function varargout = spikesort_muxi_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function omsdf_Callback(hObject, eventdata, handles)
% hObject    handle to omsdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of omsdf as text
%        str2double(get(hObject,'String')) returns contents of omsdf as a double


% --- Executes during object creation, after setting all properties.
function omsdf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to omsdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ma_Callback(hObject, eventdata, handles)
% hObject    handle to ma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ma as text
%        str2double(get(hObject,'String')) returns contents of ma as a double


% --- Executes during object creation, after setting all properties.
function ma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startfromscratch.
function startfromscratch_Callback(hObject, eventdata, handles)
% hObject    handle to startfromscratch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of startfromscratch
if get(handles.startfromscratch,'value')==0
    set(handles.gs,'value',0)
    set(handles.gla,'value',0)
    set(handles.mst,'value',0)
    set(handles.mot,'value',0)
    set(handles.rtm,'value',0)
    set(handles.gpu,'value',0)
    set(handles.gfu,'value',0)
    set(handles.psm,'value',0)
    set(handles.guq,'value',0)
    set(handles.pwp,'value',0)
    set(handles.checkall,'enable','inactive')
    set(handles.pushbutton3,'enable','inactive')
    set(handles.gs,'enable','inactive')
    set(handles.gla,'enable','inactive')
    set(handles.mst,'enable','inactive')
    set(handles.mot,'enable','inactive')
    set(handles.rtm,'enable','inactive')
    set(handles.gpu,'enable','inactive')
    set(handles.gfu,'enable','inactive')
    set(handles.psm,'enable','inactive')
    set(handles.guq,'enable','inactive')
    set(handles.pwp,'enable','inactive')
else
    set(handles.gs,'value',1)
    set(handles.gla,'value',1)
    set(handles.mst,'value',1)
    set(handles.mot,'value',1)
    set(handles.rtm,'value',1)
    set(handles.gpu,'value',1)
    set(handles.gfu,'value',1)
    set(handles.psm,'value',1)
    set(handles.guq,'value',1)
    set(handles.pwp,'value',1)
    set(handles.checkall,'enable','on')
    set(handles.pushbutton3,'enable','on')
    set(handles.gs,'enable','on')
    set(handles.gla,'enable','on')
    set(handles.mst,'enable','on')
    set(handles.mot,'enable','on')
    set(handles.rtm,'enable','on')
    set(handles.gpu,'enable','on')
    set(handles.gfu,'enable','on')
    set(handles.psm,'enable','on')
    set(handles.guq,'enable','on')
    set(handles.pwp,'enable','on')
end


function pt_Callback(hObject, eventdata, handles)
% hObject    handle to pt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pt as text
%        str2double(get(hObject,'String')) returns contents of pt as a double


% --- Executes during object creation, after setting all properties.
function pt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bc_Callback(hObject, eventdata, handles)
% hObject    handle to bc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bc as text
%        str2double(get(hObject,'String')) returns contents of bc as a double


% --- Executes during object creation, after setting all properties.
function bc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bc0_Callback(hObject, eventdata, handles)
% hObject    handle to bc0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bc0 as text
%        str2double(get(hObject,'String')) returns contents of bc0 as a double


% --- Executes during object creation, after setting all properties.
function bc0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bc0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bc1_Callback(hObject, eventdata, handles)
% hObject    handle to bc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bc1 as text
%        str2double(get(hObject,'String')) returns contents of bc1 as a double


% --- Executes during object creation, after setting all properties.
function bc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lar_Callback(hObject, eventdata, handles)
% hObject    handle to lar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lar as text
%        str2double(get(hObject,'String')) returns contents of lar as a double


% --- Executes during object creation, after setting all properties.
function lar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tt0_Callback(hObject, eventdata, handles)
% hObject    handle to tt0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tt0 as text
%        str2double(get(hObject,'String')) returns contents of tt0 as a double


% --- Executes during object creation, after setting all properties.
function tt0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tt0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tt1_Callback(hObject, eventdata, handles)
% hObject    handle to tt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tt1 as text
%        str2double(get(hObject,'String')) returns contents of tt1 as a double


% --- Executes during object creation, after setting all properties.
function tt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tt2_Callback(hObject, eventdata, handles)
% hObject    handle to tt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tt2 as text
%        str2double(get(hObject,'String')) returns contents of tt2 as a double


% --- Executes during object creation, after setting all properties.
function tt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dt0_Callback(hObject, eventdata, handles)
% hObject    handle to dt0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt0 as text
%        str2double(get(hObject,'String')) returns contents of dt0 as a double


% --- Executes during object creation, after setting all properties.
function dt0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dt1_Callback(hObject, eventdata, handles)
% hObject    handle to dt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt1 as text
%        str2double(get(hObject,'String')) returns contents of dt1 as a double


% --- Executes during object creation, after setting all properties.
function dt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dz0_Callback(hObject, eventdata, handles)
% hObject    handle to dz0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dz0 as text
%        str2double(get(hObject,'String')) returns contents of dz0 as a double


% --- Executes during object creation, after setting all properties.
function dz0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dz0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dz1_Callback(hObject, eventdata, handles)
% hObject    handle to dz1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dz1 as text
%        str2double(get(hObject,'String')) returns contents of dz1 as a double


% --- Executes during object creation, after setting all properties.
function dz1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dz1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dz2_Callback(hObject, eventdata, handles)
% hObject    handle to dz2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dz2 as text
%        str2double(get(hObject,'String')) returns contents of dz2 as a double


% --- Executes during object creation, after setting all properties.
function dz2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dz2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dz3_Callback(hObject, eventdata, handles)
% hObject    handle to dz3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dz3 as text
%        str2double(get(hObject,'String')) returns contents of dz3 as a double


% --- Executes during object creation, after setting all properties.
function dz3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dz3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zo_Callback(hObject, eventdata, handles)
% hObject    handle to zo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zo as text
%        str2double(get(hObject,'String')) returns contents of zo as a double


% --- Executes during object creation, after setting all properties.
function zo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sdm_Callback(hObject, eventdata, handles)
% hObject    handle to sdm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sdm as text
%        str2double(get(hObject,'String')) returns contents of sdm as a double


% --- Executes during object creation, after setting all properties.
function sdm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sdm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dsd_Callback(hObject, eventdata, handles)
% hObject    handle to dsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dsd as text
%        str2double(get(hObject,'String')) returns contents of dsd as a double


% --- Executes during object creation, after setting all properties.
function dsd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sr_Callback(hObject, eventdata, handles)
% hObject    handle to sr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sr as text
%        str2double(get(hObject,'String')) returns contents of sr as a double


% --- Executes during object creation, after setting all properties.
function sr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bp0_Callback(hObject, eventdata, handles)
% hObject    handle to bp0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bp0 as text
%        str2double(get(hObject,'String')) returns contents of bp0 as a double


% --- Executes during object creation, after setting all properties.
function bp0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bp0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bp1_Callback(hObject, eventdata, handles)
% hObject    handle to bp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bp1 as text
%        str2double(get(hObject,'String')) returns contents of bp1 as a double


% --- Executes during object creation, after setting all properties.
function bp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function np_Callback(hObject, eventdata, handles)
% hObject    handle to np (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of np as text
%        str2double(get(hObject,'String')) returns contents of np as a double


% --- Executes during object creation, after setting all properties.
function np_CreateFcn(hObject, eventdata, handles)
% hObject    handle to np (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function csd_Callback(hObject, eventdata, handles)
% hObject    handle to csd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of csd as text
%        str2double(get(hObject,'String')) returns contents of csd as a double


% --- Executes during object creation, after setting all properties.
function csd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to csd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mcsd_Callback(hObject, eventdata, handles)
% hObject    handle to mcsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mcsd as text
%        str2double(get(hObject,'String')) returns contents of mcsd as a double


% --- Executes during object creation, after setting all properties.
function mcsd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mcsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function acsd_Callback(hObject, eventdata, handles)
% hObject    handle to acsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of acsd as text
%        str2double(get(hObject,'String')) returns contents of acsd as a double


% --- Executes during object creation, after setting all properties.
function acsd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acsd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dsdf_Callback(hObject, eventdata, handles)
% hObject    handle to dsdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dsdf as text
%        str2double(get(hObject,'String')) returns contents of dsdf as a double


% --- Executes during object creation, after setting all properties.
function dsdf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dsdf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mbf_Callback(hObject, eventdata, handles)
% hObject    handle to mbf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mbf as text
%        str2double(get(hObject,'String')) returns contents of mbf as a double


% --- Executes during object creation, after setting all properties.
function mbf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mbf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mbi_Callback(hObject, eventdata, handles)
% hObject    handle to mbi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mbi as text
%        str2double(get(hObject,'String')) returns contents of mbi as a double


% --- Executes during object creation, after setting all properties.
function mbi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mbi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function auq_Callback(hObject, eventdata, handles)
% hObject    handle to auq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auq as text
%        str2double(get(hObject,'String')) returns contents of auq as a double


% --- Executes during object creation, after setting all properties.
function auq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function msu_Callback(hObject, eventdata, handles)
% hObject    handle to msu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msu as text
%        str2double(get(hObject,'String')) returns contents of msu as a double


% --- Executes during object creation, after setting all properties.
function msu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function avc_Callback(hObject, eventdata, handles)
% hObject    handle to avc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of avc as text
%        str2double(get(hObject,'String')) returns contents of avc as a double


% --- Executes during object creation, after setting all properties.
function avc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to avc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%**************GET PARAMETER VARIABLES****************
probetype= get(handles.pt, 'String');                    
%probe type.  see get_probegeometry for definitions.  

bc = get(handles.bc, 'String');  %ENTER BAD CHANNELS IN WITH SPACES IN BETWEEN EX: 1 22 4 33 2. WORKS ASSUMING MAX 2 DIGIT NUMBERS.
%Get array of doubles from bc
bcarray = [];
for i = 1:length(bc)
    num = str2double(bc(i)); %num is the current index
    
    %account for range issues at extremes
    if i<length(bc)
        right = str2double(bc(i+1));
    else
        right = NaN;
    end
    
    if i>1
        left = str2double(bc(i-1));
    else
        left = NaN;
    end
    
    if isnan(num)==0  %if selected index is a number
        if isnan(right)==0 %if index to the right is a number
            temp = num*10 + right; %then you know it's a two digit number
            bcarray(length(bcarray)+1) = temp; %add to array
        elseif isnan(left)==1 %if the index to the left and right is NaN
            bcarray(length(bcarray)+1) = num; %add selected index to array
        end
    end 
end

badchannels= bcarray;                     
%ok to leave empty. specifies the faulty channels on the probe.
backgroundchans1=[str2double(get(handles.bc0,'String')):str2double(get(handles.bc1,'String'))];            
%default=[]. ok to leave empty. the channels in the current set are not used.  badchannels are removed from this list.

laser_artifact_removal=(get(handles.lar, 'String'));

trainingtrials=[str2double(get(handles.tt0, 'String')):str2double(get(handles.tt1, 'String')):str2double(get(handles.tt2, 'String'))];             
%default=[20:-1:1]. can go backwards but not fully tested. used by make_seed_templates. setting the upper limit to more trials than exist is ok.

dotrials=[str2double(get(handles.dt0, 'String')):str2double(get(handles.dt1, 'String'))];                  
%used by run_template_matching.  setting the upper limit to more trials than exist is ok.
depthzones=[str2double(get(handles.dz0, 'String')):str2double(get(handles.dz1, 'String')):str2double(get(handles.dz2, 'String')) str2double(get(handles.dz3, 'String'))];       
%distance from tip of probe. units in microns. use in make_channelsets. if want entire shaft use depthzones=[0 10000]; don't forget 0 & 10000 if want ends of probe. badchannels are removed.
zoneoverlap=str2double(get(handles.zo, 'String'));                     
%default=25; re-use some channels in more than one set to account for overlap of spike EC fields.
                                    
spikedetectionmethod= str2double(get(handles.sdm, 'String'));             
%1=use fixed amplitude threshold set by minamplitude.  2=use threshold based on detectstdev*noise level.                                        
minamplitude= str2double(get(handles.ma, 'String'));                    
%default=37; can also leave empty and will calculate in make_seed_templates, but tends to be overestimate in high-spiking areas.   spike detection threshold, if use spikedetectionmethod=1.                                                                                                      
detectstdev=str2double(get(handles.dsd, 'String'));                   
%default=12.5 (time above noise percentile range).  spike detection threshold, if use spikedetectionmethod=2.

samplingrate=str2double(get(handles.sr, 'String'));                 
%default=25000 Hz. Used to use 1/44.8e-6 (~22 kHz) pre-2012.  
f_low=str2double(get(handles.bp0, 'String'));                          
%default=500.  bandpass filter, low frequency. 
f_high=str2double(get(handles.bp1, 'String'));                        
%default=6000. bandpass filter, high frequency.
n=str2double(get(handles.np, 'String'));                                
%default=3.    number of poles butterworth filter

clusterstdev=str2double(get(handles.csd, 'String'));                     
%default=8. used in make_seed_templates.  Higher values produce fewer clusters.  Note that spikes larger/smaller than minamplitude are assigned bigger/smaller value of clusterstdev.
mergeclusterstdev=str2double(get(handles.mcsd, 'String'));                
%default=5. used in prune_templates & prune_penult_times
allcluststdev=[str2double(get(handles.acsd, 'String'))];                  
%default=[8]. used in run_template_matching. can use multiple values e.g. [6 8 10]. can be combined with subtract_templates='y'. note: values don't proportionally alter number of 'good' units.

discardSDfactor=str2double(get(handles.dsdf, 'String'));                  
%default=4. used in get_final_units. minimum ratio of Vpp to s.d. to qualify as a unit. higher values disqualifies more units.
origmergeSDfactor=str2double(get(handles.omsdf, 'String'));              
%default=1 to 3 (2). used in get_final_units. higher values merge more units.
%mergeSDfactor used to be 2 until Dec. 8 2012, when it was set to 1.5. On
%Dec 29 2012 it was set back to 2.

minburstfraction=str2double(get(handles.mbf, 'String')); 
maxburstisi=str2double(get(handles.mbi, 'String'));                   
%default=0.08 sec. used in get_final_units.

runAutoUnitQuality=get(handles.auq, 'String');             
%default is 's' (semi-automatic). 'a'=automatic. 'n'=no. 'd'=demo mode that shows results for each unit.
final_minspikesperunit=str2double(get(handles.msu, 'String'));         
%default=100; used in get_final_units & auto_unit_quality. minimum number of spikes required for a unit to be scored >3.
autoVoltageCutoff=str2double(get(handles.avc, 'String'));               
%default=65 uV; used in auto_unit_quality.  minimum voltage required for a unit to be scored >3.


%***************Module Execution****************
make_savedir;                       %asks user for raw data directory & makes savedir in corresponding \data analysis\ directory.

if get(handles.startfromscratch, 'Value')==1  %If startfromscratch = y
    %RUN FROM SCRATCH MODULES
    
    if get(handles.gs, 'Value')==1
        get_stimuli                 %extracts stimulus event (cue, solenoid & lick,..) times and saves in stimuli folder in data analysis. note: this program may be run separately from spikesort_muxi.
    end
    
    if get(handles.gla, 'Value')==1
        get_laserartifacts          %optional: collects mean laser-induced artifact for every good channel, and subtracts this from raw data before doing any spike collection. note: artifact removal is not perfect.
    end
    
    if get(handles.mst,'Value')==1
        make_seed_templates         %creates templates from 'seed' sets of channels (usually nearest neighbors). stores as sortspikes_seti.mat
    end
    
    if get(handles.mot,'Value')==1
        make_orig_templates         %final selection of unique templates.
    end
    
    if get(handles.rtm,'Value')==1
        run_template_matching       %matches data to templates on each set of channels. can use multiple values for allcluststdev and can do template subtraction from data.
    end
    
    if get(handles.gpu,'Value')==1
        get_penultimate_units       %does some light merging of units in their sets, and collects waveforms across all channels on a shaft.
    end
    
    if get(handles.gfu,'Value')==1
        get_final_units             %discards units if they fail SD test, and merges similar units based on SD of waveforms across all channels. bad units are called 'badunits', and merged units are in 'mergeclusts'
    end
    
    if get(handles.psm,'Value')==1
        plot_summary_muxi           %plots waveforms, isi, psth for each unit and stores figures in \units\. also gets wavespecs.
    end
    
    if get(handles.guq,'Value')==1
        get_unitquality             %assigns score of 1, 2, or 3 to each unit.
    end
    
    if get(handles.pwp,'Value')==1
        plot_width_position         %plots spike width, and location of units based on highest amplitude channel and COF model. 
    end
    
end

%RUN FROM FILES MODULES

if get(handles.grl,'Value')==1
    get_raw_LFP                     %extracts the unfiltered, downsampled signal for every channel. Used in LFP analysis. 
end

if get(handles.gts,'value')==1
    get_triggedspectra              %gets event-triggered power spectral density for each trial and channel. 
end

if get(handles.gtlp,'value')==1
    get_triggedLFPpower             %gets event-triggered LFP power in the specified LFP frequency band.
end

if get(handles.et,'value')==1
    event_triggered                 %aligns unit activity to selected events & makes plots.
end

if get(handles.pls,'value')==1
    plot_LFPstack                   %plots depth stack of event-triggered LFP for selected trials. contains additional plot settings inside subroutine script.
end

if get(handles.sl,'value')==1
    spike_LFP                        %obtains average LFP signal triggered on peaks, and plots the triggered LFP and PSTH vs depth. triggered on a reference channel.   
end

if get(handles.musd,'value')==1
    get_multiunit                    %multiunit spike detection.
end

if get(handles.tm,'value')==1
    triggered_multiunit              %event-triggered multiunit depth stacks. need stimuli file.
end

if get(handles.clm,'value')==1
    cue_lick_multiephys              %cues (olfactory, visual, etc), lickometer & multiunit ephys analysis.
end

if get(handles.pc,'value')==1
    pairwise_correlation             %cross-correlation between all pairs of units.
end

if get(handles.stc,'value')==1
    source_target_correlations       %average cross-correlation between groups of units in target and source locations.
end

if get(handles.sca,'value')==1
    spike_coherence_analysis         %calculates pairwise correlation (coincidence index) vs time, and coherence vs time & interneuronal distance.
end

% --- Executes on button press in gs.
function gs_Callback(hObject, eventdata, handles)
% hObject    handle to gs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gs


% --- Executes on button press in gla.
function gla_Callback(hObject, eventdata, handles)
% hObject    handle to gla (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gla


% --- Executes on button press in mst.
function mst_Callback(hObject, eventdata, handles)
% hObject    handle to mst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mst


% --- Executes on button press in mot.
function mot_Callback(hObject, eventdata, handles)
% hObject    handle to mot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mot


% --- Executes on button press in rtm.
function rtm_Callback(hObject, eventdata, handles)
% hObject    handle to rtm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rtm


% --- Executes on button press in gpu.
function gpu_Callback(hObject, eventdata, handles)
% hObject    handle to gpu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gpu


% --- Executes on button press in gfu.
function gfu_Callback(hObject, eventdata, handles)
% hObject    handle to gfu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gfu


% --- Executes on button press in psm.
function psm_Callback(hObject, eventdata, handles)
% hObject    handle to psm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of psm


% --- Executes on button press in guq.
function guq_Callback(hObject, eventdata, handles)
% hObject    handle to guq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of guq


% --- Executes on button press in pwp.
function pwp_Callback(hObject, eventdata, handles)
% hObject    handle to pwp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pwp


% --- Executes on button press in checkall.
function checkall_Callback(hObject, eventdata, handles)
% hObject    handle to checkall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.gs,'value',1)
set(handles.gla,'value',1)
set(handles.mst,'value',1)
set(handles.mot,'value',1)
set(handles.rtm,'value',1)
set(handles.gpu,'value',1)
set(handles.gfu,'value',1)
set(handles.psm,'value',1)
set(handles.guq,'value',1)
set(handles.pwp,'value',1)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.gs,'value',0)
set(handles.gla,'value',0)
set(handles.mst,'value',0)
set(handles.mot,'value',0)
set(handles.rtm,'value',0)
set(handles.gpu,'value',0)
set(handles.gfu,'value',0)
set(handles.psm,'value',0)
set(handles.guq,'value',0)
set(handles.pwp,'value',0)


% --- Executes on button press in grl.
function grl_Callback(hObject, eventdata, handles)
% hObject    handle to grl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of grl


% --- Executes on button press in gts.
function gts_Callback(hObject, eventdata, handles)
% hObject    handle to gts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gts


% --- Executes on button press in et.
function et_Callback(hObject, eventdata, handles)
% hObject    handle to et (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of et


% --- Executes on button press in pls.
function pls_Callback(hObject, eventdata, handles)
% hObject    handle to pls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pls


% --- Executes on button press in sl.
function sl_Callback(hObject, eventdata, handles)
% hObject    handle to sl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sl


% --- Executes on button press in musd.
function musd_Callback(hObject, eventdata, handles)
% hObject    handle to musd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of musd


% --- Executes on button press in tm.
function tm_Callback(hObject, eventdata, handles)
% hObject    handle to tm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tm


% --- Executes on button press in clm.
function clm_Callback(hObject, eventdata, handles)
% hObject    handle to clm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of clm


% --- Executes on button press in stc.
function stc_Callback(hObject, eventdata, handles)
% hObject    handle to stc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stc


% --- Executes on button press in sca.
function sca_Callback(hObject, eventdata, handles)
% hObject    handle to sca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sca


% --- Executes on button press in pc.
function pc_Callback(hObject, eventdata, handles)
% hObject    handle to pc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pc


% --- Executes on button press in check1.
function check1_Callback(hObject, eventdata, handles)
% hObject    handle to check1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.grl,'value',1)
set(handles.gts,'value',1)
set(handles.et,'value',1)
set(handles.pls,'value',1)
set(handles.sl,'value',1)
set(handles.musd,'value',1)
set(handles.tm,'value',1)
set(handles.clm,'value',1)
set(handles.pc,'value',1)
set(handles.stc,'value',1)
set(handles.sca,'value',1)
set(handles.gtlp,'value',1)


% --- Executes on button press in check2.
function check2_Callback(hObject, eventdata, handles)
% hObject    handle to check2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.grl,'value',0)
set(handles.gts,'value',0)
set(handles.et,'value',0)
set(handles.pls,'value',0)
set(handles.sl,'value',0)
set(handles.musd,'value',0)
set(handles.tm,'value',0)
set(handles.clm,'value',0)
set(handles.pc,'value',0)
set(handles.stc,'value',0)
set(handles.sca,'value',0)
set(handles.gtlp,'value',0)

% --- Executes on button press in defaults.
function defaults_Callback(hObject, eventdata, handles)
% hObject    handle to defaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global grl gts gtlp et pls sl musd tm clm pc stc sca
set(handles.grl,'value',grl)
set(handles.gts,'value',gts)
set(handles.gtlp,'value',gtlp)
set(handles.et,'value',et)
set(handles.pls,'value',pls)
set(handles.sl,'value',sl)
set(handles.musd,'value',musd)
set(handles.tm,'value',tm)
set(handles.clm,'value',clm)
set(handles.pc,'value',pc)
set(handles.stc,'value',stc)
set(handles.sca,'value',sca)


% --- Executes on button press in gtlp.
function gtlp_Callback(hObject, eventdata, handles)
% hObject    handle to gtlp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gtlp


% --- Executes on button press in parameterdefault.
function parameterdefault_Callback(hObject, eventdata, handles)
% hObject    handle to parameterdefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pt bc bc0 bc1 lar tt0 tt1 tt2 dt0 dt1 dz0 dz1 dz2 dz3...
    zo sdm ma dsd sr bp0 bp1 np csd mcsd acsd dsdf omsdf mbf mbi auq...
    msu avc
set(handles.pt,'string',pt);
set(handles.bc,'string',bc);
set(handles.bc0,'string',bc0);
set(handles.bc1,'string',bc1);
set(handles.lar,'string',lar);
set(handles.tt0,'string',tt0);
set(handles.tt1,'string',tt1);
set(handles.tt2,'string',tt2);
set(handles.dt0,'string',dt0);
set(handles.dt1,'string',dt1);
set(handles.dz0,'string',dz0);
set(handles.dz1,'string',dz1);
set(handles.dz2,'string',dz2);
set(handles.dz3,'string',dz3);
set(handles.zo,'string',zo);
set(handles.sdm,'string',sdm);
set(handles.ma,'string',ma);
set(handles.dsd,'string',dsd);
set(handles.sr,'string',sr);
set(handles.bp0,'string',bp0);
set(handles.bp1,'string',bp1);
set(handles.np,'string',np);
set(handles.csd,'string',csd);
set(handles.mcsd,'string',mcsd);
set(handles.acsd,'string',acsd);
set(handles.dsdf,'string',dsdf);
set(handles.omsdf,'string',omsdf);
set(handles.mbf,'string',mbf);
set(handles.mbi,'string',mbi);
set(handles.auq,'string',auq);
set(handles.msu,'string',msu);
set(handles.avc,'string',avc);


