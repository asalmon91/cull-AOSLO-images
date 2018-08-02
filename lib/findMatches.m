function matches = findMatches( handles, fname, mod )
%findMatches finds the other fnames that match fname if you replace the modality

fname_i = strcmp(handles.img_header, 'fname');

a = strrep(fname, mod, '*');
a_lt = a(1:strfind(a,'*')-1);
a_rt = a(strfind(a,'*')+1:end);
matches = all(~cell2mat(cellfun(@isempty, ...
    [strfind(handles.imgs(:, fname_i), a_lt), strfind(handles.imgs(:, fname_i), a_rt)], ...
    'uniformoutput', false)), 2);

end

