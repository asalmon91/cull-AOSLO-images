function [ new_indices ] = filterByMod( handles, indices )
%filterByMod reduces indices to only the current modality selected

% mods    = get(handles.modality_listbox, 'items');
mod     = get(handles.modality_listbox, 'value');

fnames  = handles.imgs(:, strcmp(handles.img_header, 'fname'));
new_indices = indices & contains(fnames, mod);

end

