function fnames = updateImgOpts( handles, current_imgs, ~ )
%updateImgOpts updates the image list and formats the strings to display decisions

%   current_index: current image index in current_img_listbox
% (todo) make varargin so only 'value' changes

%% Style definitions
style_keep = uistyle('fontcolor', 'w', 'backgroundcolor', 'b');
style_reject = uistyle('fontcolor', 'w', 'backgroundcolor', 'r');
style_undecided = uistyle('fontcolor', 'k', 'backgroundcolor', 'w');
style_current_option = uistyle('fontweight', 'bold', 'horizontalalignment', 'right');
style_other_option = uistyle('fontweight', 'normal', 'horizontalalignment', 'right');

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
% cc = {'kept', 'blue'; 'rejected', 'orange'; 'undecided', 'black'};
% formatted_fnames = cell(size(fnames));
% for ii=1:numel(fnames)
%     formatted_fnames{ii} = sprintf('<HTML><FONT color="%s">%s', ...
%         cc{cellfun(@(x) strcmpi(x, decisions{ii}), cc(:,1)), 2}, ...
%         fnames{ii});
% end

% Update table entries
set(handles.current_img_tbl, 'data', fnames);
% Add color
for ii=1:numel(fnames)
	current_style = style_undecided;
	switch decisions{ii}
		case 'kept'
			current_style = style_keep;
		case 'rejected'
			current_style = style_reject;
		case 'undecided'
			current_style = style_undecided;	
	end
	addStyle(handles.current_img_tbl, current_style, 'row', ii);
	
	if ii == handles.current_option_idx
		addStyle(handles.current_img_tbl, style_current_option, 'row', ii);
	else
		addStyle(handles.current_img_tbl, style_other_option, 'row', ii);
	end
end
% set(handles.current_img_tbl, 'data', fnames, 'value', fnames{current_index});

end

