function updateImageSpace( handles )
%updateImageSpace updates the image space with the current image and its secondaries with the same
%scale as the other images for this video

%   imgs:   cell array of m modalities
%   sizes:  kx2 array of sizes of all images for this video

%% Shortcuts
sizes = cell2mat(cellfun(@size, handles.loadedImgs(:,1), 'uniformoutput', false));
imgs  = handles.loadedImgs(get(handles.current_img_listbox, 'value'), :);

% Determine minimum number of squares to fit number of images
N = (ceil(sqrt(numel(imgs))).^2);
n = sqrt(N);

% Determine bit-depth to set background
img     = imgs{1}; %#ok<NASGU>
ppty    = whos('img');
bg      = (2^(ppty.bytes/prod(ppty.size)*8))-1;

% Determine size of canvas: fit to largest image
mrow = max(sizes(:,1));
mcol = max(sizes(:,2));
canvas = bg.*ones(n*mrow, n*mcol, ppty.class);

% Add imgs to canvas
k=1;
for ii=0:n-1
    for jj=0:n-1
        if k>numel(imgs)
            continue;
        end
        if ~isempty(imgs{k})
            canvas(...
                ii*mrow+1:ii*mrow+ppty.size(1), ...
                jj*mcol+1:jj*mcol+ppty.size(2)) = imgs{k};
            
        else
            canvas(...
                ii*mrow+1:ii*mrow+ppty.size(1), ...
                jj*mcol+1:jj*mcol+ppty.size(2)) = bg.*ones(ppty.size(1), ppty.size(2));
        end
        k=k+1;
    end
end

% Update image space
axes(handles.img_space)
cla;
imshow(canvas)

end






