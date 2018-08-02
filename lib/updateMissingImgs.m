function updateMissingImgs(handles)

% Shortcuts
avi_nums    = handles.avi_nums;
imgs        = handles.imgs;
img_header  = handles.img_header;

% Get image numbers
img_nums    = cell2mat(imgs(:, strcmp(img_header, 'num')));
decisions   = imgs(:, strcmp(img_header, 'decisions'));

% Determine which avi_nums either do not have a corresponding element in img_nums or all img_nums
% were rejected
missingImages = false(size(avi_nums));
[~, I] = setdiff(avi_nums, img_nums);
missingImages(I) = true;
for ii=1:numel(missingImages)
    if missingImages(ii)
        continue;
    end
    
    if all(strcmp(decisions(img_nums == avi_nums(ii)), 'rejected'))
        missingImages(ii) = true;
    end
end

% Update list
set(handles.missing_list, 'string', num2str(avi_nums(missingImages)));

end






