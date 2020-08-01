function I = sortByMod( handles, imgs )
%sortByMod sorts the cell array imgs by the list of modalities in the modality listbox

mods = get(handles.modality_listbox, 'items');
fname_i = strcmp(handles.img_header, 'fname');

order = zeros(size(imgs, 1), 1);
for ii=1:numel(mods)
    order(~cellfun(@isempty, strfind(imgs(:, fname_i), mods{ii}))) = ii;
end
[~, I] = sort(order);

end

