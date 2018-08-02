function wires = getMiniMontage( handles )
%getMiniMontage registers the selected modality of the loaded images, and returns their wireframes

%% Shortcuts
imgs = handles.loadedImgs(:, get(handles.modality_listbox, 'value'));

% No need to register if only one option
if numel(imgs) == 1
    coords = [0,0, flip(size(imgs{1}))];
    wires{1} = convertCoordsToPatchMatrix(coords);
    return;
end

%% Choose template based on size
% (todo) consider a better method
% Get area of each image
areas = zeros(size(imgs));
for ii=1:numel(imgs)
    areas(ii) = numel(imgs{ii});    
end
[~, area_I] = sort(areas, 'descend');

%% Register images to template from biggest to smallest
% (todo) could move this initialization to a CreateFcn since it'll be the same for all image sets
[optimizer, metric] = imregconfig('monomodal');
% coords: x, y, wd, ht
coords = zeros(numel(imgs), 4);
for ii=1:numel(imgs)
    if ii > 1
        tform = imregtform(imgs{area_I(ii)}, imgs{area_I(1)}, ...
            'translation', optimizer, metric);

        % tform.T(3,1) = dx; tform.T(3,2) = dy
        coords(ii, 1:2) = tform.T(3, 1:2);
    end
    
    coords(ii, 3:4) = flip(size(imgs{area_I(ii)}));
end

%% Return to original order
[~,I]  = sort(area_I);
coords = coords(I,:);

%% Convert to patch-friendly inputs
wires = cell(size(imgs));
for ii=1:numel(imgs)
    wires{ii} = convertCoordsToPatchMatrix(coords(ii, :));
end

end

function p = convertCoordsToPatchMatrix(rc)
    x=rc(1); y=rc(2); wd=rc(3); ht=rc(4);
    
    xx = [x, x+wd-1, x+wd-1, x];
    yy = [y, y, y+ht-1, y+ht-1];
    p = [xx;yy];
end

