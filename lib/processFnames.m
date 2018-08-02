function [imgs, img_header] = processFnames( imgs, handles )
%processFnames extracts important information from the images, e.g., size, ssr/fr, nframes
% (todo) imgs should be objects, not a cell array. Changing this will require changing every other
% module, so this won't happen for a while.

% Create waitbar
wb = waitbar(0, sprintf('Extra space for long file names Reading %s...', imgs{1}));
wb.Children.Title.Interpreter = 'none';
waitbar(0, wb, sprintf('Reading %s...', imgs{1}));

% Build header for image data
if isfield(handles, 'img_header')
    img_header = handles.img_header;
else
    img_header = {'fname', 'path', 'num', 'wd', 'ht', 'nframes', 'cropped', 'srffr', 'decisions'};
end
% Shortcuts to correct columns
path_i      = strcmp(img_header, 'path');
fname_i     = strcmp(img_header, 'fname');
wd_i        = strcmp(img_header, 'wd');
ht_i        = strcmp(img_header, 'ht');
nframes_i   = strcmp(img_header, 'nframes');
cropped_i   = strcmp(img_header, 'cropped');
srffr_i     = strcmp(img_header, 'srffr');
num_i       = strcmp(img_header, 'num');
decision_i  = strcmp(img_header, 'decisions');

% add columns for wd, ht, nframes, cropped, sr/ffr
imgs = [imgs, cell(size(imgs, 1), numel(img_header)-size(imgs, 2))];

for ii=1:size(imgs, 1)
    [~, img_name, img_ext] = fileparts(imgs{ii, fname_i});
    
    % (todo) see if there's a more efficient way of determining dimensions without reading    
    if strcmp(img_ext, '.dat')
        img = readDatImg(fullfile(imgs{ii, path_i}, imgs{ii, fname_i}));
        imgs{ii, wd_i} = size(img, 2);
        imgs{ii, ht_i} = size(img, 1);
    else
        imgdata = imfinfo(fullfile(imgs{ii, path_i}, imgs{ii, fname_i}));
        imgs{ii, wd_i} = imgdata.Width; % wd
        imgs{ii, ht_i} = imgdata.Height; % ht
    end    
    
    % determine video number, nframes, cropped, and sr/ffr
    nameparts = strsplit(img_name, '_');
    % number
    imgs{ii, num_i} = str2double(nameparts{find(strcmp(nameparts, 'ref'))-1});
    % nframes
    imgs{ii, nframes_i} = str2double(nameparts{find(strcmp(nameparts, 'n'))+1});
    % cropped
    imgs{ii, cropped_i} = str2double(nameparts{find(strcmp(nameparts, 'cropped'))+1});
    % sr/ffr
    if any(strcmp(nameparts, 'sr'))
        imgs{ii, srffr_i} = 'sr';
    elseif any(strcmp(nameparts, 'ffr'))
        imgs{ii, srffr_i} = 'ffr';
    end
    imgs{ii, decision_i} = 'undecided';
    
    % Update waitbar
    waitbar(ii/size(imgs, 1), wb, imgs{ii,1});
end

close(wb);

end

