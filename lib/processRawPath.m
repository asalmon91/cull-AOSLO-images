function num_list = processRawPath( avi_dir )
%processRawPath extracts unique video numbers from a dir call to a path with .avi's.
%   A major assumption is that the video number will be the last token before the file extension.
%   Should throw an error if this is not the case

avi_fnames = (struct2cell(avi_dir))';
avi_fnames = avi_fnames(:,1);

nums = cell(size(avi_fnames));
for ii=1:numel(avi_fnames)
    % remove extension
    name = avi_fnames{ii}(1:end-length('.avi'));
    nameparts = strsplit(name, '_');
    nums{ii} = nameparts{end};
end

num_list = str2double(unique(nums));

end

