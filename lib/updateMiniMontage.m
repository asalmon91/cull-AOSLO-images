function updateMiniMontage( handles )
%updateMiniMontage updates the minimontage every time the video or current image is changed
%   (todo) consider devising a method to make wires and img_data varargin, where only current_img
%   needs to be input
%   Outline color based on SR or FFR
%   Transparent face color only for current_img (this is a string which should match one element of
%   wires(:,1)
%   ax: axes to update
%   wires: an mx2 cell array where wires(:,1) are the fullfile names, wires(:,2) are 2x4 matrices
%   containing patch-friendly inputs, e.g., wires{1,2}(1,:) is the xdata, wires{1,2}(2,:) is the
%   ydata
%   img_data is a mx2 cell array containing the SR/FFR and kept/rejected information for each image

%% Shortcuts
wires = handles.wires;
img_data = handles.imgs(filterByMod(handles, handles.current_indices), ...
    [find(strcmp(handles.img_header, 'srffr')), ...
    find(strcmp(handles.img_header, 'decisions'))]);
current_img = get(handles.current_img_listbox, 'value');

%% Set axes
axes(handles.mini_montage);
cla; % clear axes

%% Draw patches
for ii=1:size(wires, 1)
    % Set edge color, sr: blue; ffr: red.
    if strcmpi(img_data{ii,1}, 'sr')
        ec = 'b';
    else
        ec = 'r';
    end
    
    % Set face color, current_img: black; else: none.
    if ii == current_img
        fc = 'b';
    else
        fc = 'none';
    end
    
    % Set linestyle and linewidth, kept: solid, 1.5; rejected: broken, .5; undecided: solid, .5.
    switch img_data{ii,2}
        case 'kept'
            ls = '-';
            lw = 1.5;
        case 'rejected'
            ls = '--';
            lw = 0.5;
        case 'undecided'
            ls = '-';
            lw = 0.5;
    end
    
    % Draw patch
    patch('xdata', wires{ii}(1,:), 'ydata', wires{ii}(2,:), ...
        'facecolor', fc, ...
        'edgecolor', ec, ...
        'facealpha', 0.35, ...
        'linestyle', ls, ...
        'linewidth', lw ...
        );
end

end

