function updateImageData( handles )
%updateImageData Updates the labels near the image space with some paramaters of the image

% current_i = strcmp(...
%     handles.imgs(:, strcmp(handles.img_header, 'fname')), ... % all fnames
%     get(handles.current_img_listbox, 'value')); % current fname

current_option = handles.current_img_tbl.Data{handles.current_option_idx};
current_i = strcmp(...
    handles.imgs(:, strcmp(handles.img_header, 'fname')), ... % all fnames
    current_option); % current fname


set(handles.current_wd, 'text', ...
    sprintf('W: %d', handles.imgs{current_i, strcmp(handles.img_header, 'wd')}));
set(handles.current_ht, 'text', ...
    sprintf('H: %d', handles.imgs{current_i, strcmp(handles.img_header, 'ht')}));
set(handles.current_nframes, 'text', ...
    sprintf('# Frames: %d', handles.imgs{current_i, strcmp(handles.img_header, 'nframes')}));
set(handles.current_cropped, 'text', ...
    sprintf('Cropped: %d', handles.imgs{current_i, strcmp(handles.img_header, 'cropped')}));

end

