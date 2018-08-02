function updateImageData( handles )
%updateImageData Updates the labels near the image space with some paramaters of the image

current_i = strcmp(...
    handles.imgs(:, strcmp(handles.img_header, 'fname')), ... % all fnames
    handles.fnames{get(handles.current_img_listbox, 'value')}); % current fname

set(handles.current_wd, 'string', ...
    sprintf('W: %d', handles.imgs{current_i, strcmp(handles.img_header, 'wd')}));
set(handles.current_ht, 'string', ...
    sprintf('H: %d', handles.imgs{current_i, strcmp(handles.img_header, 'ht')}));
set(handles.current_nframes, 'string', ...
    sprintf('# Frames: %d', handles.imgs{current_i, strcmp(handles.img_header, 'nframes')}));
set(handles.current_cropped, 'string', ...
    sprintf('Cropped: %d', handles.imgs{current_i, strcmp(handles.img_header, 'cropped')}));

end

