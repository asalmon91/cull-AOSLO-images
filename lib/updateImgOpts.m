function fnames = updateImgOpts( handles, current_imgs, current_index )
%updateImgOpts updates the image list and formats the strings to display decisions

%   current_index: current image index in current_img_listbox

% (todo) make varargin so only 'value' changes

%% Sort by sr/ffr, then size, then nframes
imgs = handles.imgs(filterByMod(handles, current_imgs), :);
% Compile a table for sorting
srffr = imgs(:, strcmp(handles.img_header, 'srffr'));
areas = prod(cell2mat([imgs(:, strcmp(handles.img_header, 'ht')), ...
    imgs(:, strcmp(handles.img_header, 'wd'))]), 2);
nframes = imgs(:, strcmp(handles.img_header, 'nframes'));
t = table(srffr, areas, nframes);
% Sort table
[~,I] = sortrows(t, 1:3, 'descend');
imgs = imgs(I,:);
fnames = imgs(:, strcmp(handles.img_header, 'fname'));
decisions = imgs(:, strcmp(handles.img_header, 'decisions'));

% Format strings
cc = {'kept', 'blue'; 'rejected', 'orange'; 'undecided', 'black'};
formatted_fnames = cell(size(fnames));
for ii=1:numel(fnames)
    formatted_fnames{ii} = sprintf('<HTML><FONT color="%s">%s', ...
        cc{cellfun(@(x) strcmpi(x, decisions{ii}), cc(:,1)), 2}, ...
        fnames{ii});
end

% Update list box
set(handles.current_img_listbox, 'string', formatted_fnames, 'value', current_index);

end

