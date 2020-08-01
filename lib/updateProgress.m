function updateProgress( handles )
%updateProgress Summary of this function goes here
%   Detailed explanation goes here

% shortcuts
imgs        = handles.imgs;
img_header  = handles.img_header;

% Determine total progress
total_progress = numel(find(~strcmp(imgs(:, strcmp(img_header, 'decisions')), 'undecided'))) / ...
    size(imgs, 1) * 100;
set(handles.prog_title, 'text', sprintf('Progress: %3.1f%s', total_progress, '%'));

% For all unique video numbers, figure out the proportion not undecided to total
[nums, ~, I] = unique(cell2mat(imgs(:, strcmp(img_header, 'num'))));

prog_strings = cell(size(nums));
for ii=1:numel(nums)
    prog_strings{ii} = sprintf('%d: %3.1f%s', ...
        nums(ii), ...
        numel(find(~strcmp(imgs(I==ii, strcmp(img_header, 'decisions')), 'undecided'))) / ...
        numel(find(I==ii)) * 100, ...
        '%');
end
% Pop out any with 100%
prog_strings(~cellfun(@isempty, strfind(prog_strings, '100.0%'))) = [];

% Update progress list
set(handles.prog_list, 'items', prog_strings);

end

