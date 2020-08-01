function im = readDatImg( ffname )
%readDatImg includes support for reading .dat's

[~, ~, img_ext] = fileparts(ffname);
if strcmpi(img_ext, '.dat')
    im = uint8(dlmread(ffname, '\t'));
else
    im = imread(ffname);
	
	if size(im, 3) > 1 % Transparent tif or RGB
		im = im(:,:,1);
	end
end

end

