function updateMinHtTxt( pos, handles )
%getX returns the first element of pos (2x2 matrix returned from getPosition('imline'))

set(handles.min_ht_txt, 'string', num2str(pos(1)));

end

