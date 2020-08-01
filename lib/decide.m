function decide( handles, decision )
%decide changes the decision for an image and its matches, and updates the gui

% Get current image and its matches
% mods = get(handles.modality_listbox, 'string');
mod = handles.modality_listbox.Value;

current_options = handles.current_img_tbl.Data;
current_selection = current_options{handles.current_option_idx};

matches = find(findMatches(handles, current_selection, mod));
decisions_i = strcmp(handles.img_header, 'decisions');
for ii=1:numel(matches)
    handles.imgs{matches(ii), decisions_i} = decision;
end

%% Update Image Options
updateImgOpts(handles, handles.current_indices, current_selection);

%% Update Progress
updateProgress(handles);

%% Update missing images
if ~isempty(handles.raw_path)
    updateMissingImgs(handles);
end

%% Update minimontage
if strcmpi(handles.align_switch.Value, 'on')
    if ~isfield(handles, 'wires') || handles.wire_vid ~= handles.current_vid
        handles.wires = getMiniMontage(handles);
        handles.wire_vid = handles.current_vid;
    end
    updateMiniMontage(handles);
end

% guidata(hObject, handles);

end

