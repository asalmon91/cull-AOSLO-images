function keep( handles )
%keep changes the images decision to kept and updates the gui

% Get current image and its matches
mods = get(handles.modality_listbox, 'string');
mod = mods{get(handles.modality_listbox, 'value')};

handles.imgs(findMatches(handles, handles.fnames{get(handles.current_img_listbox, 'value')}, mod), ...
    strcmp(handles.img_header, 'decisions')) = 'kept';

%% Update Image Options
updateImgOpts(handles, handles.current_indices, get(handles.current_img_listbox, 'value'));

%% Update Progress
updateProgress(handles);

%% Update missing images
if get(handles.raw_cb, 'value')
    updateMissingImgs(handles);
end

%% Update minimontage
if get(handles.align_cb, 'value')
    if ~isfield(handles, 'wires') || handles.wire_vid ~= handles.current_vid
        handles.wires = getMiniMontage(handles);
        handles.wire_vid = handles.current_vid;
    end
    updateMiniMontage(handles);
end

%% Update guidata
guidata(hObject, handles);

end

