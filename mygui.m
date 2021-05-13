function varargout = mygui(varargin)
% See also: GUIDE, GUIDATA, GUIHANDLES
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mygui_OpeningFcn, ...
                   'gui_OutputFcn',  @mygui_OutputFcn, ...
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


% --- Executes just before mygui is made visible.
function mygui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

load ('square_circle.mat')
load ('square.mat')
load ('SheppLogan.mat')
load ('lena.mat')
load ('brain.mat')

handles.square_circle = square_circle;
handles.square = square;
handles.SheppLogan = SheppLogan;
handles.lena = lena;
handles.brain = brain;

sampleImage = handles.square;
handles.sampleImage = sampleImage;

filterval = 1;
handles.filterval = filterval;

axes(handles.axes1);
cla;
imagesc(sampleImage); colormap gray; colorbar;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = mygui_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


% --- Executes on selection change in imageselect.
function imageselect_Callback(hObject, eventdata, handles)

axes(handles.axes1);
cla;

imageSelection = get(handles.imageselect, 'Value');
switch imageSelection
    case 1
        imagesc(handles.square); colormap gray; colorbar;
        sampleImage = handles.square;
    case 2
        imagesc(handles.SheppLogan); colormap gray; colorbar;
        sampleImage = handles.SheppLogan;
    case 3
        imagesc(handles.lena); colormap gray; colorbar;
        sampleImage = handles.lena;
    case 4
        imagesc(handles.brain); colormap gray; colorbar;
        sampleImage = handles.brain;
    case 5
        imagesc(handles.square_circle); colormap gray; colorbar;
        sampleImage = handles.square_circle;
end
handles.sampleImage = sampleImage;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function imageselect_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function beam_number_Callback(hObject, eventdata, handles)

function beam_number_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function angle_Callback(hObject, eventdata, handles)

function angle_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in filter.
function filter_Callback(hObject, eventdata, handles)


filters = get(handles.filter, 'Value');
handles.filterval = filters;

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function filter_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radon.
function radon_Callback(hObject, eventdata, handles)

drawnow;
object = handles.sampleImage;
angle = str2double(get(handles.angle,'String'));
beam_number = str2double(get(handles.beam_number,'String'));

drawnow;
[handles.projection, handles.t] = radongui(object,angle,beam_number, handles);

drawnow;
axes(handles.axes2);
cla;
t = handles.t;
projection = handles.projection;
plot(t,projection); xlabel('t'); ylabel('p_t_h_e_t_a(t)'); title('Projection Result','FontSize',12);
guidata(hObject, handles);


% --- Executes on button press in inverseradon.
function inverseradon_Callback(hObject, eventdata, handles)

object = handles.sampleImage;
beam_number = str2double(get(handles.beam_number,'String'));
number_of_projections = str2double(get(handles.number_of_projections,'String'));

imageS = get(handles.imageselect, 'Value');

drawnow;
[handles.back_proj] = inverseradongui(object, number_of_projections ,beam_number, handles.filterval, handles);

drawnow;
axes(handles.axes2);
cla;
if imageS == 3
    imagesc((mat2gray(handles.back_proj))*256); colormap gray; colorbar; title('Reconstructed Image','FontSize',12);


elseif imageS == 4
    imagesc((mat2gray(handles.back_proj))*215); colormap gray; colorbar; title('Reconstructed Image','FontSize',12);


else
    imagesc((mat2gray(handles.back_proj))); colormap gray; colorbar; title('Reconstructed Image','FontSize',12);
end

function number_of_projections_Callback(hObject, eventdata, handles)

function number_of_projections_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
