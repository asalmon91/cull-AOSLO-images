function decide( hObject, handles, decision )
%decide changes the decision for an image and its matches, and updates the gui

% Get current image and its matches
mods = get(handles.modality_listbox, 'string');
mod = mods{get(handles.modality_listbox, 'value')};

matches = find(findMatches(handles, handles.fnames{get(handles.current_img_listbox, 'value')}, mod));
decisions_i = strcmp(handles.img_header, 'decisions');
for ii=1:numel(mods)
    handles.imgs{matches(ii), decisions_i} = decision;
end

%% Update Image Options
updateImgOpts(handles, handles.current_indices, get(handles.current_img_listbox, 'value'));

%% Update Progress
updateProgress(handles);

%% Update missing images
if get(handles.raw_cb, 'value')
    updateMissingImgs(handles);
end

%% Update minimontage
if get(handles.align_rb, 'value')
    if ~isfield(handles, 'wires') || handles.wire_vid ~= handles.current_vid
        handles.wires = getMiniMontage(handles);
        handles.wire_vid = handles.current_vid;
    end
    updateMiniMontage(handles);
end

guidata(hObject, handles);

end

