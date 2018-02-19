function varargout = BodeTransferFunctionIdentify(varargin)
% BODETRANSFERFUNCTIONIDENTIFY MATLAB code for BodeTransferFunctionIdentify.fig
%      BODETRANSFERFUNCTIONIDENTIFY, by itself, creates a new BODETRANSFERFUNCTIONIDENTIFY or raises the existing
%      singleton*.
%
%      H = BODETRANSFERFUNCTIONIDENTIFY returns the handle to a new BODETRANSFERFUNCTIONIDENTIFY or the handle to
%      the existing singleton*.
%
%      BODETRANSFERFUNCTIONIDENTIFY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BODETRANSFERFUNCTIONIDENTIFY.M with the given input arguments.
%
%      BODETRANSFERFUNCTIONIDENTIFY('Property','Value',...) creates a new BODETRANSFERFUNCTIONIDENTIFY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BodeTransferFunctionIdentify_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BodeTransferFunctionIdentify_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BodeTransferFunctionIdentify

% Last Modified by GUIDE v2.5 17-Apr-2016 22:08:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BodeTransferFunctionIdentify_OpeningFcn, ...
                   'gui_OutputFcn',  @BodeTransferFunctionIdentify_OutputFcn, ...
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


% --- Executes just before BodeTransferFunctionIdentify is made visible.
function BodeTransferFunctionIdentify_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BodeTransferFunctionIdentify (see VARARGIN)

% Choose default command line output for BodeTransferFunctionIdentify
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BodeTransferFunctionIdentify wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BodeTransferFunctionIdentify_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
{'*.m;*.fig;*.mat;*.slx;*.mdl',...
 'MATLAB Files (*.m,*.fig,*.mat,*.slx,*.mdl)';
   '*.m',  'Code files (*.m)'; ...
   '*.fig','Figures (*.fig)'; ...
   '*.mat','MAT-files (*.mat)'; ...
   '*.mdl;*.slx','Models (*.slx, *.mdl)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file');

% S=strcat(pathname,filename);
k     = openfig(filename); hold on;
h     = findobj(k,'type','line');
xdata = get(h,'Xdata');
ydata = get(h,'Ydata');

M     = length(xdata);
s =tf('s');
tf1    = 1;
j = 1;
for n=2:M
    if xdata(n-1)~=xdata(n);
     deltX(n)  = log10(xdata(n))-log10(xdata(n-1))
     deltY(n)  = ydata(n)-ydata(n-1)
     diffY(j)  = deltY(n)/deltX(n) 
     freq(j) = xdata(n)
     j = j+1;
    end   
end
ch_slope = zeros(1,length(diffY));
for n = 2:length(diffY)
    ch_slope(n) = diffY(n)-diffY(n-1)
end
for n = 2:length(diffY)
         if(ch_slope(n)>0)
             index(n)=checkslope(ch_slope(n));
         elseif(ch_slope(n)<0)
             index(n)=checkslope(ch_slope(n));
         end
      if(ch_slope(n)>0&&index(n)~=0)
         tf1 = tf1*(s+freq(n-1))^index(n);
      elseif(ch_slope(n)<0&&index(n)~=0)
         tf1 = tf1/(s+freq(n-1))^index(n);
      end 
end
if diffY~=0
dc_value = dcgain(tf1);
K = 10^(ydata(1)/20)/dc_value;
else K = 10^(ydata(1)/20)
end

TransferFunction = K*tf1;
T=evalc('TransferFunction');
set(handles.text3,'String',T);
set(handles.text3,'Visible','On');
