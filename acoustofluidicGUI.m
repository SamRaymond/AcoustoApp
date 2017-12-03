function varargout = acoustofluidicGUI(varargin)
global nodes parameters particles
% ACOUSTOFLUIDICGUI MATLAB code for acoustofluidicGUI.fig
%      ACOUSTOFLUIDICGUI, by itself, creates a new ACOUSTOFLUIDICGUI or raises the existing
%      singleton*.
%
%      H = ACOUSTOFLUIDICGUI returns the handle to a new ACOUSTOFLUIDICGUI or the handle to
%      the existing singleton*.
%
%      ACOUSTOFLUIDICGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACOUSTOFLUIDICGUI.M with the given input arguments.
%
%      ACOUSTOFLUIDICGUI('Property','Value',...) creates a new ACOUSTOFLUIDICGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before acoustofluidicGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to acoustofluidicGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help acoustofluidicGUI

% Last Modified by GUIDE v2.5 02-Dec-2017 23:05:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @acoustofluidicGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @acoustofluidicGUI_OutputFcn, ...
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


% --- Executes just before acoustofluidicGUI is made visible.
function acoustofluidicGUI_OpeningFcn(hObject, eventdata, handles, varargin)
global nodes parameters particles
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to acoustofluidicGUI (see VARARGIN)
% Choose default command line output for acoustofluidicGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes acoustofluidicGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = acoustofluidicGUI_OutputFcn(hObject, eventdata, handles) 
global nodes parameters particles
varargout{1} = handles.output;


% --- Executes on button press in StartSimulation.
function StartSimulation_Callback(hObject, eventdata, handles)
global nodes parameters particles
handles.run = 1;
guidata(hObject,handles);
handles = guidata(hObject);
t = 0.0;
while ((t < parameters.Tmax) && (handles.run))
        t = t + parameters.dt;
        clear netForcePlot xplot yplot
        runSimulation();
        hold off
        if(parameters.specialField ==0)
        xplot = reshape(nodes(:,2),parameters.ny+1,parameters.nx+1);
        yplot = reshape(nodes(:,3),parameters.ny+1,parameters.nx+1);
        %netForcePlot = abs(reshape(nodes(:,7),parameters.ny+1,parameters.nx+1) + reshape(nodes(:,8),parameters.ny+1,parameters.nx+1));
        netForcePlot = sqrt((reshape(nodes(:,7),parameters.ny+1,parameters.nx+1)).^2+(reshape(nodes(:,8),parameters.ny+1,parameters.nx+1)).^2);
        h = pcolor(xplot,yplot,netForcePlot);
        xlim([2.*parameters.dx parameters.Lx])
        ylim([2.*parameters.dy parameters.Ly])
        set(h,'EdgeColor', 'none');
        hObject = h;
        hold on
        end
        plot(particles(:,1),particles(:,2),'o','LineWidth',2,'MarkerEdgeColor','k','MarkerSize',2);
        xlim([2.*parameters.dx parameters.Lx])
        ylim([2.*parameters.dy parameters.Ly])
        drawnow
        handles = guidata(hObject);
end


% --- Executes on button press in selection_NonLinearDrag.
function selection_NonLinearDrag_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set nonlinear drag on
if(get(hObject,'Value')==1)
    parameters.nonlinearDrag= true;
end
if(get(hObject,'Value')==0)
    parameters.nonlinearDrag= false;
end



function ParticleRadius_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set the particle radius
parameters.radius = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function ParticleRadius_CreateFcn(hObject, eventdata, handles)
global nodes parameters particles
% hObject    handle to ParticleRadius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
global nodes parameters particles
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1

% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
global nodes parameters particles
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hObject = pcolor([0,1],[0,1],[0,0;0,0]);xlim([0 1]);ylim([0,1]);hold off;
set(handles.GenerateParticles,'Enable','on');
clear parameters nodes particles


% --- Executes on button press in GenerateAcousticField.
function GenerateAcousticField_Callback(hObject, eventdata, handles)
global nodes parameters particles
% hObject    handle to GenerateAcousticField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initializeNodes();
if parameters.specialField == 0
[field,x,y] = plotAcousticField();
hold off
h = pcolor(y,x,field);
        xlim([2.*parameters.dx parameters.Lx])
        ylim([2.*parameters.dy parameters.Ly])
set(h, 'EdgeColor', 'none');
hObject = h;hold on;
else
[field,x,y] = plot6336Field();
end


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



function Manual_Frequency_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Manually entered Frequency
parameters.frequency = str2double(get(hObject,'String'));
parameters.PressureMap = 'Manual';
% Hints: get(hObject,'String') returns contents of Manual_Frequency as text
%        str2double(get(hObject,'String')) returns contents of Manual_Frequency as a double


% --- Executes during object creation, after setting all properties.
function Manual_Frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Manual_Frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumberOfParticles_Callback(hObject, eventdata, handles)
global nodes parameters particles
parameters.numParticles = str2double(get(hObject,'String'));
set(handles.ParticleRadius,'String','1e-6');
% Hints: get(hObject,'String') returns contents of NumberOfParticles as text
%        str2double(get(hObject,'String')) returns contents of NumberOfParticles as a double


% --- Executes during object creation, after setting all properties.
function NumberOfParticles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberOfParticles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GenerateParticles.
function GenerateParticles_Callback(hObject, eventdata, handles)
global nodes parameters particles
% hObject    handle to GenerateParticles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'Enable','off');
initializeParticles();
hObject = plot(particles(:,1),particles(:,2),'o','LineWidth',2,'MarkerEdgeColor','k','MarkerSize',2);hold off;



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Width_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set the domain width
parameters.Lx = str2double(get(hObject,'String'));
% hObject    handle to Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Width as text
%        str2double(get(hObject,'String')) returns contents of Width as a double


% --- Executes during object creation, after setting all properties.
function Width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Length_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set the Length for the domain
parameters.Ly =str2double(get(hObject,'String'));
% hObject    handle to Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Length as text
%        str2double(get(hObject,'String')) returns contents of Length as a double


% --- Executes during object creation, after setting all properties.
function Length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Length (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dx_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set the dx value
parameters.dx = str2double(get(hObject,'String'));
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx as text
%        str2double(get(hObject,'String')) returns contents of dx as a double


% --- Executes during object creation, after setting all properties.
function dx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dy_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set the  dy value
parameters.dy = str2double(get(hObject,'String'));
% hObject    handle to dy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dy as text
%        str2double(get(hObject,'String')) returns contents of dy as a double


% --- Executes during object creation, after setting all properties.
function dy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tmax_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% set tmax
parameters.Tmax = str2double(get(hObject,'String'));
% hObject    handle to Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tmax as text
%        str2double(get(hObject,'String')) returns contents of Tmax as a double


% --- Executes during object creation, after setting all properties.
function Tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dt_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% set dt
parameters.dt = str2double(get(hObject,'String'));
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double


% --- Executes during object creation, after setting all properties.
function dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over StartSimulation.
function StartSimulation_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to StartSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PressureField_6336.
function PressureField_6336_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Pressure Field for the 6.336 Logo
parameters.specialField = 1;
global parameters nodes particles
parameters.cases = 4;
set(handles.Width,'String','10');
parameters.Lx = 20;
set(handles.Length,'String','5');
parameters.Ly = 5;
set(handles.dx,'String','0.075');
parameters.dx = 0.075;
set(handles.dy,'String','0.075');
parameters.dy = 0.075;
parameters.frequency = 9;
set(handles.Tmax,'String','0.01');
parameters.Tmax = 0.1;
set(handles.dt,'String','0.001');
parameters.dt = 0.001;
parameters.numParticles = 50000;
set(handles.NumberOfParticles,'String','50000');
parameters.radius = 50000;
set(handles.ParticleRadius,'String','1e-6');

% hObject    handle to PressureField_6336 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PressureField_6336


% --- Executes on button press in Case_3.
function Case_3_Callback(hObject, eventdata, handles)
global parameters nodes particles
parameters.cases = 3;
set(handles.Width,'String','5');
parameters.Lx = 5;
set(handles.Length,'String','5');
parameters.Ly = 5;
set(handles.dx,'String','0.1');
parameters.dx = 0.1;
set(handles.dy,'String','0.1');
parameters.dy = 0.1;
parameters.frequency = 2.55;
set(handles.Tmax,'String','1');
parameters.Tmax = 5;
set(handles.dt,'String','0.01');
parameters.dt = 0.01;
parameters.numParticles = 1000;
set(handles.NumberOfParticles,'String','1000');
parameters.radius = 1e-6;
set(handles.ParticleRadius,'String','1e-6');
% hObject    handle to Case_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Case_3


% --- Executes on button press in PressureField_Manual.
function PressureField_Manual_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Manual Pressure Field
% hObject    handle to PressureField_Manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PressureField_Manual


% --- Executes on button press in selection_LU.
function selection_LU_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set the LU solver
parameters.PPESolver = 1;
% hObject    handle to selection_LU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of selection_LU


% --- Executes on button press in selection_GCR.
function selection_GCR_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set the GCR Solver
parameters.PPESolver = 2;
% hObject    handle to selection_GCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of selection_GCR


% --- Executes on button press in selection_BackSlash.
function selection_BackSlash_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% Set the backslash solver
parameters.PPESolver = 0;
% hObject    handle to selection_BackSlash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of selection_BackSlash


% --- Executes on button press in explicitSolver.
function explicitSolver_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% set solver to explicit
parameters.TimeIntegrator = 0;
% hObject    handle to explicitSolver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of explicitSolver


% --- Executes on button press in SemiImplicitSolver.
function SemiImplicitSolver_Callback(hObject, eventdata, handles)
global nodes parameters particles
%% set solver to semi-implicit
parameters.TimeIntegrator = 1;
% hObject    handle to SemiImplicitSolver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SemiImplicitSolver


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
global parameters nodes particles
handles.run = 0;
guidata(hObject, handles);
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function manualSource_Callback(hObject, eventdata, handles)
% hObject    handle to manualSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manualSource as text
%        str2double(get(hObject,'String')) returns contents of manualSource as a double


% --- Executes during object creation, after setting all properties.
function manualSource_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manualSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Case_1.
function Case_1_Callback(hObject, eventdata, handles)
global parameters nodes particles
parameters.cases = 1;
set(handles.Width,'String','5');
parameters.Lx = 5;
set(handles.Length,'String','2.5');
parameters.Ly = 2.5;
set(handles.dx,'String','0.1');
parameters.dx = 0.1;
set(handles.dy,'String','0.1');
parameters.dy = 0.1;
parameters.frequency = 5;
set(handles.Tmax,'String','5');
parameters.Tmax = 5;
set(handles.dt,'String','0.01');
parameters.dt = 0.01;
parameters.numParticles = 1000;
set(handles.NumberOfParticles,'String','1000');
parameters.radius = 1e-6;
set(handles.ParticleRadius,'String','1e-6');
% hObject    handle to Case_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Case_1


% --- Executes on button press in Case_2.
function Case_2_Callback(hObject, eventdata, handles)
global parameters nodes particles
parameters.cases = 2;
set(handles.Width,'String','20');
parameters.Lx = 20;
set(handles.Length,'String','5');
parameters.Ly = 5;
set(handles.dx,'String','0.2');
parameters.dx = 0.2;
set(handles.dy,'String','0.2');
parameters.dy = 0.2;
parameters.frequency = 9;
set(handles.Tmax,'String','0.1');
parameters.Tmax = 0.1;
set(handles.dt,'String','0.001');
parameters.dt = 0.001;
parameters.numParticles = 1000;
set(handles.NumberOfParticles,'String','1000');
parameters.radius = 1e-6;
set(handles.ParticleRadius,'String','1e-6');
% hObject    handle to Case_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of Case_2


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over selection_LU.
