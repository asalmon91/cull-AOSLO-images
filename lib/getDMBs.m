function dmb_ffnames = getDMBs( handles, imgs )
%getDMBs Summary of this function goes here
%   Detailed explanation goes here

% (todo) optimization idea: check mods of dmb, if only 1, can remove 2/3 of search opts

dmb_dir = dir(fullfile(handles.dmb_path, '*.dmb'));
dmb_dir = struct2cell(dmb_dir)';
dmb_fnames = dmb_dir(:,1);

kept_dmbs = cell(size(imgs, 1), 1);
k=1;
for ii=1:size(imgs, 1)
    for jj=1:size(dmb_fnames, 1)
        if ~isempty(strfind(imgs{ii, strcmp(handles.img_header, 'fname')}, dmb_fnames{jj}(1:end-4)))
            kept_dmbs{k} = dmb_fnames{jj};
            k=k+1;
            break;
        end
    end
end

kept_dmbs(cell2mat(cellfun(@isempty, kept_dmbs, 'uniformoutput', false))) = [];
dmb_ffnames = fullfile(handles.dmb_path, kept_dmbs);

end

