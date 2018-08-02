function loadedImgs = loadImgs( handles, fnames )
%loadImgs reads the images described by fnames, finds the other modalities, and places them in a
%cell array (loadedImgs)

% shortcut
path_i = strcmp(handles.img_header, 'path');
fname_i = strcmp(handles.img_header, 'fname');

% get mod
mods = get(handles.modality_listbox, 'string');
mod  = mods{get(handles.modality_listbox, 'value')};

loadedImgs = cell(numel(fnames), numel(mods));
for ii=1:numel(fnames)
    matches = handles.imgs(findMatches(handles, fnames{ii}, mod), :);
    matches = matches(sortByMod(handles, matches), :);
%     matches = matches([2,3,1], :); % for testing
    for jj=1:size(matches, 1)
        loadedImgs{ii, jj} = readDatImg(fullfile(matches{jj, path_i}, matches{jj, fname_i}));
    end
end

end

