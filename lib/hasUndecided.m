function result = hasUndecided( handles, indices )
%hasUndecided checks the images at indices for a decision of undecided

result = any(strcmp(handles.imgs(indices, strcmp(handles.img_header, 'decisions')), 'undecided'));

end

