function varargout = cull_images(varargin)
% CULL_IMAGES MATLAB code for cull_images.fig
%      CULL_IMAGES, by itself, creates a new CULL_IMAGES or raises the existing
%      singleton*.
%
%      H = CULL_IMAGES returns the handle to a new CULL_IMAGES or the handle to
%      the existing singleton*.
%
%      CULL_IMAGES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CULL_IMAGES.M with the given input arguments.
%
%      CULL_IMAGES('Property','Value',...) creates a new CULL_IMAGES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cull_images_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cull_images_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cull_images

% Last Modified by GUIDE v2.5 11-Jan-2019 16:24:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cull_images_OpeningFcn, ...
                   'gui_OutputFcn',  @cull_images_OutputFcn, ...
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


% --- Executes just before cull_images is made visible.
function cull_images_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cull_images (see VARARGIN)

% Choose default command line output for cull_images
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

addpath(fullfile('.','lib'));
% UIWAIT makes cull_images wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cull_images_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_menu_Callback(hObject, eventdata, handles)
% hObject    handle to file_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function modalities_menu_Callback(hObject, eventdata, handles)
% hObject    handle to modalities_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function shortcuts_menu_Callback(hObject, eventdata, handles)
% hObject    handle to shortcuts_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(...
    {sprintf('Keep: %c', char(8594));
    sprintf('Reject: %c', char(8592));
    sprintf('Next option: %c', char(8595));
    sprintf('Previous option: %c', char(8593));
    'Next Video: N';
    'Previous Video: P'}, ...
    'Shortcuts', 'help');


% --------------------------------------------------------------------
function mod_edit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to mod_edit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extra_spaces    = 3;
curr_mod_ls     = get(handles.modality_listbox, 'string');
def_ans         = [curr_mod_ls; cellstr(strings(extra_spaces,1))];
dlg_title       = 'Add or remove modalities to cull';
n_lines         = [ones(size(def_ans)), ones(size(def_ans)).*(6*length('split_det'))];
prompt          = cellstr([repmat('modality ',size(def_ans,1),1), ...
    num2str((1:size(def_ans,1))')]);

re = inputdlg(prompt, dlg_title, n_lines, def_ans);
re(cellfun(@isempty, re)) = []; % remove empty elements

if isempty(re)
    return;
end

% Update handles with new modality list
set(handles.modality_listbox, 'string', re);
guidata(hObject, handles);


% --------------------------------------------------------------------
function images_menu_Callback(hObject, eventdata, handles)
% hObject    handle to images_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exts = {'*.tif', 'tif'; '*.dat', 'dat'};
def_path = '.';
if isfield(handles, 'img_path')
    def_path = handles.img_path;
end
[img_fnames, handles.img_path] = uigetfile(exts, 'Load images', def_path, 'multiselect', 'on');
if isnumeric(img_fnames)
    return;
elseif ~iscell(img_fnames)
    img_fnames = {img_fnames};
end
img_fnames = img_fnames';

imgs = [img_fnames, cellstr(repmat(handles.img_path, size(img_fnames, 1), 1))];

%% Process files, extract useful information
[imgs, handles.img_header] = processFnames(imgs, handles);

% If imgs already exists, then this is an attempt to add new images.
% (todo): handle the case where "non-unique" images are added. Add only if date modified is later.
if isfield(handles, 'imgs') 
    imgs = [handles.imgs; imgs];
end
handles.imgs = imgs;

%% Update height histogram for batch editing
% (todo) handle situation where more images are added
handles.slider_h = updateHtHist(handles.area_hist, ...
    cell2mat(imgs(:, strcmp(handles.img_header,'ht'))));
pos = getPosition(handles.slider_h);
set(handles.min_ht_txt, 'string', num2str(round(pos(1))));
addNewPositionCallback(handles.slider_h, ...
    @(pos) set(handles.min_ht_txt, 'string', num2str(round(pos(1)))));

% Update other GUI elements
updateProgress(handles);
set(handles.prog_list, 'enable', 'on');
if isfield(handles, 'avi_nums')
    updateMissingImgs(handles);
end

% Once the image are loaded, can start culling
set(handles.min_wd_txt,         'enable', 'on');
set(handles.min_ht_txt,         'enable', 'on');
set(handles.min_nframes_txt,    'enable', 'on');
set(handles.batch_go_btn,       'enable', 'on');
set(handles.start_btn,          'enable', 'on');

% Update handles with img_path and imgs
guidata(hObject, handles);


% --------------------------------------------------------------------
function raw_menu_Callback(hObject, eventdata, handles)
% hObject    handle to raw_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
def_path = '.';
if isfield(handles, 'img_path') 
    def_path = handles.img_path;
end
raw_path = uigetdir(def_path, 'Set path to .avi''s');
if isnumeric(raw_path)
    return;
end

% Get .avi's
avi_dir = dir(fullfile(raw_path, '*.avi'));
if isempty(avi_dir)
    msgbox('No .avi''s found!','File not found', 'error')
    return;
end

% Process videos to get a list of unique video numbers
handles.avi_nums = processRawPath(avi_dir);

set(handles.missing_list, 'enable', 'on');
set(handles.raw_cb, 'value', true);

% Update missing images list if images and videos are input
if isfield(handles, 'imgs')
    updateMissingImgs(handles)
end

% Update handles with raw_path
handles.raw_path = raw_path;
guidata(hObject, handles);


% --------------------------------------------------------------------
function dmb_menu_Callback(hObject, eventdata, handles)
% hObject    handle to dmb_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
def_path = '.';
if isfield(handles, 'raw_path')
    def_path = handles.raw_path;
elseif isfield(handles, 'img_path')
    def_path = handles.img_path;
end
dmb_path = uigetdir(def_path, 'Set path to .dmb''s');
if isnumeric(dmb_path)
    return;
end
set(handles.dmb_cb, 'value', true);

% Update handles with dmb_path
handles.dmb_path = dmb_path;
guidata(hObject, handles);


% --------------------------------------------------------------------
function output_menu_Callback(hObject, eventdata, handles)
% hObject    handle to output_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function images_path_txt_Callback(hObject, eventdata, handles)
% hObject    handle to images_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of images_path_txt as text
%        str2double(get(hObject,'String')) returns contents of images_path_txt as a double


% --- Executes during object creation, after setting all properties.
function images_path_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to images_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function output_path_txt_Callback(hObject, eventdata, handles)
% hObject    handle to output_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_path_txt as text
%        str2double(get(hObject,'String')) returns contents of output_path_txt as a double


% --- Executes during object creation, after setting all properties.
function output_path_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function raw_path_txt_Callback(hObject, eventdata, handles)
% hObject    handle to raw_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of raw_path_txt as text
%        str2double(get(hObject,'String')) returns contents of raw_path_txt as a double


% --- Executes during object creation, after setting all properties.
function raw_path_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to raw_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function other_imgs_path_txt_Callback(hObject, eventdata, handles)
% hObject    handle to other_imgs_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of other_imgs_path_txt as text
%        str2double(get(hObject,'String')) returns contents of other_imgs_path_txt as a double


% --- Executes during object creation, after setting all properties.
function other_imgs_path_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to other_imgs_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dmb_path_txt_Callback(hObject, eventdata, handles)
% hObject    handle to dmb_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dmb_path_txt as text
%        str2double(get(hObject,'String')) returns contents of dmb_path_txt as a double


% --- Executes during object creation, after setting all properties.
function dmb_path_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dmb_path_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in modality_listbox.
function modality_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to modality_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns modality_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modality_listbox


% --- Executes during object creation, after setting all properties.
function modality_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modality_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in current_img_listbox.
function current_img_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to current_img_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns current_img_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from current_img_listbox

%% Update image space
updateImageSpace(handles);

%% Update image data
updateImageData(handles);

%% Update minimontage
if get(handles.align_rb, 'value')
    if ~isfield(handles, 'wires') || handles.wire_vid ~= handles.current_vid
        handles.wires = getMiniMontage(handles);
        handles.wire_vid = handles.current_vid;
    end
    updateMiniMontage(handles);
end


% --- Executes during object creation, after setting all properties.
function current_img_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to current_img_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in missing_list.
function missing_list_Callback(hObject, eventdata, handles)
% hObject    handle to missing_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns missing_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from missing_list


% --- Executes during object creation, after setting all properties.
function missing_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to missing_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function min_wd_txt_Callback(hObject, eventdata, handles)
% hObject    handle to min_wd_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_wd_txt as text
%        str2double(get(hObject,'String')) returns contents of min_wd_txt as a double


% --- Executes during object creation, after setting all properties.
function min_wd_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_wd_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_ht_txt_Callback(hObject, eventdata, handles)
% hObject    handle to min_ht_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_ht_txt as text
%        str2double(get(hObject,'String')) returns contents of min_ht_txt as a double

% (todo) validate input, handle errors

% Update slider position
new_pos = getPosition(handles.slider_h);
new_pos(:,1) = repmat(str2double(get(hObject,'String')), 2, 1);
setPosition(handles.slider_h, new_pos);


% --- Executes during object creation, after setting all properties.
function min_ht_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_ht_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_nframes_txt_Callback(hObject, eventdata, handles)
% hObject    handle to min_nframes_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_nframes_txt as text
%        str2double(get(hObject,'String')) returns contents of min_nframes_txt as a double


% --- Executes during object creation, after setting all properties.
function min_nframes_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_nframes_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function min_cropped_txt_Callback(hObject, eventdata, handles)
% hObject    handle to min_cropped_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_cropped_txt as text
%        str2double(get(hObject,'String')) returns contents of min_cropped_txt as a double


% --- Executes during object creation, after setting all properties.
function min_cropped_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_cropped_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in batch_go_btn.
function batch_go_btn_Callback(hObject, eventdata, handles)
% hObject    handle to batch_go_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

min_ht      = str2double(get(handles.min_ht_txt, 'string'));
min_wd      = str2double(get(handles.min_wd_txt, 'string'));
min_frames  = str2double(get(handles.min_nframes_txt, 'string'));
min_cropped = get(handles.crop1_cb, 'value'); % by default

% shortcuts
imgs = handles.imgs;
img_header = handles.img_header;

hts     = cell2mat(imgs(:, strcmpi(img_header, 'ht')));
wds     = cell2mat(imgs(:, strcmpi(img_header, 'wd')));
nframes = cell2mat(imgs(:, strcmpi(img_header, 'nframes')));
cropped = cell2mat(imgs(:, strcmpi(img_header, 'cropped')));

% First overwrite all decisions with undecided to facilitate multiple batch attempts
% Don't worry, this button will be disabled when the user hits start, so they won't be able to undo
% any of their progress during individual culling
imgs(:, strcmp(handles.img_header, 'decisions')) = ...
    cellstr(repmat('undecided', size(imgs, 1), 1));

% Then figure out which ones are rejected by the new criteria
rejected = hts < min_ht | wds < min_wd | ...
    nframes < min_frames | cropped <= min_cropped;

imgs(rejected, strcmp(handles.img_header, 'decisions')) = ...
    cellstr(repmat('rejected', numel(find(rejected)), 1));
handles.imgs = imgs;

% Update other GUI elements
updateProgress(handles);
% (todo) activate updateHtHist(), but that will require changing its input to varargin
% updateHtHist()
if isfield(handles, 'avi_nums')
    updateMissingImgs(handles);
end

% Update guidata
guidata(hObject, handles);


% --- Executes on button press in keep_btn.
function keep_btn_Callback(hObject, eventdata, handles)
% hObject    handle to keep_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
decide(hObject, handles, 'kept');


% --- Executes on button press in reject_btn.
function reject_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reject_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
decide(hObject, handles, 'rejected');


% --- Executes on button press in finish_btn.
function finish_btn_Callback(hObject, eventdata, handles)
% hObject    handle to finish_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if numel kept == 0
if ~any(strcmp(handles.imgs(:, strcmp(handles.img_header, 'decisions')), 'kept'))
    return;
end
% Get output path
handles.out_path = uigetdir(handles.img_path, 'Select output directory');
if isnumeric(handles.out_path)
    return;
end

kept_imgs = handles.imgs(...
    strcmp(handles.imgs(:, strcmp(handles.img_header, 'decisions')), 'kept'), :);

% Create waitbar
wb = waitbar(0, sprintf('Extra space for long file names Copying %s...', kept_imgs{1,1}));
wb.Children.Title.Interpreter = 'none';
waitbar(0, wb, sprintf('Copying %s...', kept_imgs{1}));

for ii=1:size(kept_imgs, 1)
    waitbar(ii/size(kept_imgs, 1), wb, ...
        sprintf('Copying %s...', kept_imgs{ii, strcmp(handles.img_header, 'fname')}));
    
    % If kept image is a .dat, should read and write to out_path
    [img_path, img_name, img_ext] = fileparts(...
        fullfile(kept_imgs{ii, strcmp(handles.img_header, 'path')}, ...
        kept_imgs{ii, strcmp(handles.img_header, 'fname')}));
    
    if strcmp(img_ext, '.dat')
        imwrite(readDatImg(fullfile(img_path, [img_name, img_ext])), ...
            fullfile(handles.out_path, [img_name, '_dat.tif']));
    else
        copyfile(fullfile(img_path, [img_name, img_ext]), ...
            fullfile(handles.out_path, [img_name, img_ext]));
    end
end

% Output .dmb's too
if get(handles.dmb_cb, 'value')
    dmbs = getDMBs(handles, kept_imgs);
    out_dmb_path = fullfile(handles.out_path, 'kept_dmb_files');
    mkdir(out_dmb_path);
    
    for ii=1:size(dmbs, 1)
        [~, dmb_name, dmb_ext] = fileparts(dmbs{ii});
        copyfile(dmbs{ii}, fullfile(out_dmb_path, [dmb_name, dmb_ext]));
        
        waitbar(ii/size(dmbs, 1), wb, sprintf('Copying %s...', [dmb_name, dmb_ext]));
    end
end


close(wb);
close(gcf);

% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.started = true;

% Should not be able to do batch culling 
set(handles.batch_go_btn,       'enable', 'off');
set(handles.min_wd_txt,         'enable', 'off');
set(handles.min_ht_txt,         'enable', 'off');
set(handles.min_nframes_txt,    'enable', 'off');
set(handles.mod_edit_menu,      'enable', 'off');
delete(handles.slider_h);

% Can start culling individual images
set(handles.current_img_listbox, 'enable', 'on');
set(handles.prev_btn,   'enable', 'on');
set(handles.next_btn,   'enable', 'on');
set(handles.keep_btn,   'enable', 'on');
set(handles.reject_btn, 'enable', 'on');
set(handles.finish_btn, 'enable', 'on');

% Use next button callback with 0 current video
handles.current_vid = -1;
guidata(hObject, handles);
next_btn_Callback(hObject, eventdata, handles);


% --- Executes on button press in next_btn.
function next_btn_Callback(hObject, eventdata, handles)
% hObject    handle to next_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Find video after current video which has undecided images
nums = unique(cell2mat(handles.imgs(:, strcmp(handles.img_header, 'num'))));
if find(nums == handles.current_vid) == numel(nums)
    return;
elseif handles.current_vid < 0 % find first video
    srch = 1:numel(nums);
else
    srch = find(nums == handles.current_vid)+1:numel(nums);
end

reached_end = true;
for ii=srch
    handles.current_indices = cell2mat(handles.imgs(:, strcmp(handles.img_header, 'num'))) == ...
        nums(ii);
    if hasUndecided(handles, handles.current_indices)
        handles.current_vid = nums(ii);
        reached_end = false;
        break;
    end
end
if reached_end
    return;
end

%% Update everything
handles.fnames = updateImgOpts(handles, handles.current_indices, 1);
handles.loadedImgs = loadImgs(handles, handles.fnames);
updateImageSpace(handles);
updateImageData(handles);

if get(handles.align_rb, 'value')
    handles.wires = getMiniMontage(handles);
    handles.wire_vid = handles.current_vid;
    updateMiniMontage(handles);
end

%% Update guidata
guidata(hObject, handles);


% --- Executes on button press in prev_btn.
function prev_btn_Callback(hObject, eventdata, handles)
% hObject    handle to prev_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Find video before current video
nums = unique(cell2mat(handles.imgs(:, strcmp(handles.img_header, 'num'))));
if handles.current_vid == nums(1)
    return;
else
    handles.current_vid = nums(find(nums == handles.current_vid)-1);
end
handles.current_indices = cell2mat(handles.imgs(:, strcmp(handles.img_header, 'num'))) == ...
    handles.current_vid;

% Update everything
handles.fnames = updateImgOpts(handles, handles.current_indices, 1);
handles.loadedImgs = loadImgs(handles, handles.fnames);
updateImageSpace(handles);
updateImageData(handles);

if get(handles.align_rb, 'value')
    handles.wires = getMiniMontage(handles);
    handles.wire_vid = handles.current_vid;
    updateMiniMontage(handles);
end

guidata(hObject, handles);

% --- Executes on selection change in prog_list.
function prog_list_Callback(hObject, eventdata, handles)
% hObject    handle to prog_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns prog_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from prog_list

if isfield(handles, 'started')
    prog_string = get(hObject, 'string');
    entry = prog_string{get(hObject, 'value')};
    num = str2double(entry(1:strfind(entry, ':')-1));
    
    % Set current video to selected video
    handles.current_vid = num;
    handles.current_indices = cell2mat(handles.imgs(:, strcmp(handles.img_header, 'num'))) == num;
    
    % Update everything
    handles.fnames = updateImgOpts(handles, handles.current_indices, 1);
    handles.loadedImgs = loadImgs(handles, handles.fnames);
    updateImageSpace(handles);
    
    if get(handles.align_rb, 'value')
        if ~isfield(handles, 'wires') || handles.wire_vid ~= handles.current_vid
            handles.wires = getMiniMontage(handles);
            handles.wire_vid = handles.current_vid;
        end
        updateMiniMontage(handles);
    end
    
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function prog_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prog_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function instructions_menu_Callback(hObject, eventdata, handles)
% hObject    handle to instructions_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in raw_cb.
function raw_cb_Callback(hObject, eventdata, handles)
% hObject    handle to raw_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of raw_cb


% --- Executes on button press in dmb_cb.
function dmb_cb_Callback(hObject, eventdata, handles)
% hObject    handle to dmb_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dmb_cb


% --------------------------------------------------------------------
function out_menu_Callback(hObject, eventdata, handles)
% hObject    handle to out_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
def_path = '.';
if isfield(handles, 'img_path') 
    def_path = handles.img_path;
end
out_path = uigetdir(def_path, 'Set output path');
if isnumeric(out_path)
    return;
end

% Update checkbox
set(handles.out_cb, 'value', true);

% Update handles with raw_path
handles.out_path = out_path;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function align_rb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to align_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in align_rb.
function align_rb_Callback(hObject, eventdata, handles) %#ok<*INUSL>
% hObject    handle to align_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of align_rb
if get(hObject, 'value') && isfield(handles, 'loadedImgs')
    if ~isfield(handles, 'wires') || handles.wire_vid ~= handles.current_vid
        handles.wires = getMiniMontage(handles);
        handles.wire_vid = handles.current_vid;
    end
    updateMiniMontage(handles);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function mini_montage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mini_montage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function img_space_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function area_hist_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to area_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'loadedImgs')
    return;
end
switch eventdata.Key
    case 'n'
        next_btn_Callback(hObject, eventdata, handles);
    case 'p'
        prev_btn_Callback(hObject, eventdata, handles);
    case 'uparrow' % see previous option
        try % skip if the current focus is a listbox
            if strcmp(get(gco, 'style'), 'listbox')
                return
            end
        catch
        end
        orig = get(handles.current_img_listbox, 'value');
        found = false;
        while get(handles.current_img_listbox, 'value') > 1
            set(handles.current_img_listbox, 'value', get(handles.current_img_listbox, 'value')-1);
            % skip rejected
            current_i = strcmp(...
                handles.imgs(:, strcmp(handles.img_header, 'fname')), ...
                handles.fnames{get(handles.current_img_listbox, 'value')});
            if ~strcmp(handles.imgs{current_i, strcmp(handles.img_header, 'decisions')}, 'rejected')
                found = true;
                break;
            end
        end
        if ~found
            set(handles.current_img_listbox, 'value', orig);
            return
        end
        % Update gui with new image option
        current_img_listbox_Callback(hObject, eventdata, handles)
        
    case 'downarrow' % see next option
        try % skip if the current focus is a listbox
            if strcmp(get(gco, 'style'), 'listbox')
                return
            end
        catch
        end
        orig = get(handles.current_img_listbox, 'value');
        found = false;
        while get(handles.current_img_listbox, 'value') < ...
                numel(get(handles.current_img_listbox, 'string'))
            set(handles.current_img_listbox, 'value', get(handles.current_img_listbox, 'value')+1);
            % skip rejected
            current_i = strcmp(...
                handles.imgs(:, strcmp(handles.img_header, 'fname')), ...
                handles.fnames{get(handles.current_img_listbox, 'value')});
            if ~strcmp(handles.imgs{current_i, strcmp(handles.img_header, 'decisions')}, 'rejected')
                found = true;
                break;
            end
        end
        if ~found
            set(handles.current_img_listbox, 'value', orig);
            return
        end
        % Update gui with new image option
        current_img_listbox_Callback(hObject, eventdata, handles)
        
    case 'rightarrow' % change current decision to 'kept'
        decide(hObject, handles, 'kept');
        
    case 'leftarrow' % change current decision to 'rejected'
        if ~isempty(eventdata.Modifier)
            return;
        end
        decide(hObject, handles, 'rejected');
end


% --- Executes during object creation, after setting all properties.
function keep_btn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keep_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'tooltip', char(8594))


% --- Executes during object creation, after setting all properties.
function reject_btn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reject_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'tooltip', char(8592))


% --- Executes on button press in crop1_cb.
function crop1_cb_Callback(hObject, eventdata, handles)
% hObject    handle to crop1_cb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of crop1_cb
