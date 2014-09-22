function varargout = cosplay(varargin)
% COSPLAY MATLAB code for cosplay.fig
%      COSPLAY, by itself, creates a new COSPLAY or raises the existing
%      singleton*.
%
%      H = COSPLAY returns the handle to a new COSPLAY or the handle to
%      the existing singleton*.
%
%      COSPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COSPLAY.M with the given input arguments.
%
%      COSPLAY('Property','Value',...) creates a new COSPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cosplay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cosplay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cosplay

% Last Modified by GUIDE v2.5 22-Sep-2014 14:55:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cosplay_OpeningFcn, ...
                   'gui_OutputFcn',  @cosplay_OutputFcn, ...
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


% --- Executes just before cosplay is made visible.
function cosplay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cosplay (see VARARGIN)

% Choose default command line output for cosplay

global cosplaySettings moduleData moduleList

cosplay_rules;

if numel(moduleData)==0
moduleData.type=1;
moduleData.sequence='';
moduleData.oligos={};
moduleData.comments='';
end

if numel(moduleList)==0
   moduleList={};
end


refreshGUI(handles);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cosplay wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function refreshGUI(handles)
global moduleData moduleList

% display oligos
buildOligos;

set(handles.tableOligo,'Data',moduleData.oligos');

set(handles.tableModule,'Data',moduleList);

set(handles.popupModule,'Value',moduleData.type);
set(handles.sequence,'String',moduleData.sequence);

function buildOligos
global moduleData cosplaySettings


maxeSeq=min(18,numel(moduleData.sequence));

if maxeSeq~=0
    seq5=moduleData.sequence(1:maxeSeq);
    seq3=moduleData.sequence(end-maxeSeq+1:end);
else
    seq5='';
    seq3='';
end
moduleData.oligos{1}=[lower(cosplaySettings.moduleSeq5{moduleData.type}) ' ' seq5];
moduleData.oligos{2}=[lower(cosplaySettings.moduleSeq3{moduleData.type}) ' ' rc(seq3)];

function strout=rc(str) %reverse complement

lowstr=lower(str);
lowstr=fliplr(lowstr);
s = regexprep(lowstr, 'a', 'T');
s = regexprep(s, 't', 'A');
s = regexprep(s, 'g', 'C');
strout = regexprep(s, 'c', 'G');

% --- Outputs from this function are returned to the command line.
function varargout = cosplay_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in newModule.
function newModule_Callback(hObject, eventdata, handles)
% hObject    handle to newModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sequence_Callback(hObject, eventdata, handles)
% hObject    handle to sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sequence as text
%        str2double(get(hObject,'String')) returns contents of sequence as a double

global moduleData

moduleData.sequence=get(hObject,'String');

refreshGUI(handles);

% --- Executes during object creation, after setting all properties.
function sequence_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveModule.
function saveModule_Callback(hObject, eventdata, handles)
% hObject    handle to saveModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global moduleData moduleList

if numel(moduleList)==0
   cc=0;
else
   cc=size(moduleList,1); 
end

moduleList{cc+1,1}='a';
moduleList{cc+1,2}=moduleData.type;
moduleList{cc+1,3}=moduleData.comments;
moduleList{cc+1,4}=moduleData.sequence;

refreshGUI(handles);

% --- Executes on selection change in popupModule.
function popupModule_Callback(hObject, eventdata, handles)
% hObject    handle to popupModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupModule contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupModule
global moduleData
val=get(hObject,'Value');

moduleData.type=val;

refreshGUI(handles);

% --- Executes during object creation, after setting all properties.
function popupModule_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in newPlasmid.
function newPlasmid_Callback(hObject, eventdata, handles)
% hObject    handle to newPlasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in savePlasmid.
function savePlasmid_Callback(hObject, eventdata, handles)
% hObject    handle to savePlasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in addModule.
function addModule_Callback(hObject, eventdata, handles)
% hObject    handle to addModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exportPlasmid.
function exportPlasmid_Callback(hObject, eventdata, handles)
% hObject    handle to exportPlasmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in analyzeSequence.
function analyzeSequence_Callback(hObject, eventdata, handles)
% hObject    handle to analyzeSequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.messageModule,'String','Your sequence is ok!');
refreshGUI(handles);


% --- Executes when selected cell(s) is changed in tableModule.
function tableModule_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tableModule (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

global moduleList moduleData

if numel(eventdata.Indices)>0
    ind= eventdata.Indices(1);
    
    moduleData.type=moduleList{ind,2};
    moduleData.comments=moduleList{ind,3};
    moduleData.sequence=moduleList{ind,4};
refreshGUI(handles);
end

