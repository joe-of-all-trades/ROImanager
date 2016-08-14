function varargout = ROImanager(varargin)
% ROIMANAGER MATLAB code for ROImanager.fig
%      ROIMANAGER, by itself, creates a new ROIMANAGER or raises the existing
%      singleton*.
%
%      H = ROIMANAGER returns the handle to a new ROIMANAGER or the handle to
%      the existing singleton*.
%
%      ROIMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROIMANAGER.M with the given input arguments.
%
%      ROIMANAGER('Property','Value',...) creates a new ROIMANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ROImanager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ROImanager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ROImanager

% Last Modified by GUIDE v2.5 27-Aug-2014 17:36:17
% Version 1.1.0
% Copyright Chaoyuan Yeh 2015
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ROImanager_OpeningFcn, ...
                   'gui_OutputFcn',  @ROImanager_OutputFcn, ...
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

function ROImanager_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.figIdx = chooseFigure;
handles.ROI_name_count = 0;
handles.ROInameList = cell(3,100);
for ii = 1:100
    handles.ROInameList{1,ii} = ['ROI_',sprintf('%03d',ii)];
    handles.ROInameList{2,ii} = ['ROI_',sprintf('%03d',ii)];
    handles.ROInameList{3,ii} = num2str(ii);
end
handles.ROIhandleList = cell(0);
guidata(hObject, handles);

function varargout = ROImanager_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function listbox1_Callback(hObject, eventdata, handles)
handles.selected = get(handles.listbox1,'Value');
guidata(hObject, handles);

function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton1_Callback(hObject, eventdata, handles)
figure(handles.figIdx);
handles.ROI_name_count = handles.ROI_name_count + 1;
handles.ROIhandleList = cat(2,handles.ROIhandleList,handles.ROInameList(:,handles.ROI_name_count));
handles.ROIhandleList{1,size(handles.ROIhandleList,2)} = imfreehand; 
% This is an important concept. The strings stored in a cell array can be
% used as variable names. But once they're used as variable names, they are
% not of the char class anymore and cannot be displayed in the list box.
wait(handles.ROIhandleList{1,size(handles.ROIhandleList,2)});
pos = mean(getPosition(handles.ROIhandleList{1,size(handles.ROIhandleList,2)}),1);
handles.ROIhandleList{3,size(handles.ROIhandleList,2)} = text(pos(1),pos(2),...
    num2str(handles.ROI_name_count),'fontsize',8,'color','g');
set(handles.listbox1,'String',handles.ROIhandleList(2,:)');
guidata(hObject, handles);

function pushbutton2_Callback(hObject, eventdata, handles)
idx = get(handles.listbox1,'Value');
delete(handles.ROIhandleList{1,idx});
delete(handles.ROIhandleList{3,idx});
handles.ROIhandleList(:,idx) = []; 
% This will remove the cell units, not just making it empty. 
% In contrast, handles.ROIhandleList{:,idx} = [] will not remove the cell
% unit but only make it empty.
if idx == size(get(handles.listbox1,'String'),1)
    set(handles.listbox1,'Value',idx-1);
end
if get(handles.listbox1,'Value')==0
    set(handles.listbox1,'Value',1);
end
set(handles.listbox1,'String',handles.ROIhandleList(2,:)');
guidata(hObject, handles);

function pushbutton3_Callback(hObject, eventdata, handles)
assignin('base','ROI_handles',handles.ROIhandleList);
