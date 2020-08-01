function updateImageSpace( handles )
%updateImageSpace updates the image space with the current image and its secondaries with the same
%scale as the other images for this video

%   imgs:   cell array of m modalities
%   sizes:  kx2 array of sizes of all images for this video

%% Shortcuts
sizes = cell2mat(cellfun(@size, handles.loadedImgs(:,1), 'uniformoutput', false));
ci = handles.current_option_idx;
% strcmp(get(handles.current_img_tbl, 'items'), get(handles.current_img_listbox, 'value'));
% imgs  = handles.loadedImgs(ci, :);

% Determine minimum number of squares to fit number of images
N = (ceil(sqrt(numel(handles.loadedImgs(ci, :)))).^2);
n = sqrt(N);

% Determine bit-depth to set background
% img     = imgs{1}; %#ok<NASGU>
img_class = class(handles.loadedImgs{ci, 1});
% img_class = class(tmp_imgs{1});
% ppty    = whos('img');
% bg      = (2^(ppty.bytes/prod(ppty.size)*8))-1;
bg = 0;


% Determine size of canvas: fit to largest image
mrow = max(sizes(:,1));
mcol = max(sizes(:,2));
% canvas = bg.*ones(n*mrow, n*mcol, ppty.class);
canvas = bg.*ones(n*mrow, n*mcol, img_class);

% Add imgs to canvas
k=1;
for ii=0:n-1
    for jj=0:n-1
        if k > numel(handles.loadedImgs(ci, :))
            continue;
        end
        if ~isempty(handles.loadedImgs{ci, k})
            canvas(...
                ii*mrow+1:ii*mrow+ size(handles.loadedImgs{ci, k}, 1), ...
                jj*mcol+1:jj*mcol+ size(handles.loadedImgs{ci, k}, 2)) = ...
				handles.loadedImgs{ci, k};
            
		else
			canvas(...
                ii*mrow+1:ii*mrow+ size(handles.loadedImgs{ci, k}, 1), ...
                jj*mcol+1:jj*mcol+ size(handles.loadedImgs{ci, k}, 2)) = bg;
%             canvas(...
%                 ii*mrow+1:ii*mrow+ppty.size(1), ...
%                 jj*mcol+1:jj*mcol+ppty.size(2)) = bg.*ones(ppty.size(1), ppty.size(2));
        end
        k=k+1;
    end
end

% Update image space
imshow(canvas, 'parent', handles.img_space)

end






