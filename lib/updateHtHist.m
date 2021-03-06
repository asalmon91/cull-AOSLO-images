function [max_ht, suggest_thr, roi] = updateHtHist( ax, ht )
%updateAreaHist updates the axis ax with a histogram of heights

% axes(ax);

max_ht = max(ht);
suggest_thr = mean(ht) - std(ht);

nbins = 20;
h = histogram(ht, nbins, 'parent', ax);
% xlabel('Height (px)', 'fontname', 'arial', 'fontsize', 9);
% ylabel('# Images', 'fontname', 'arial', 'fontsize', 9);
% xlim([0, h.BinLimits(end)]);
% ylim([0, max(h.Values)]);
set(ax, 'fontname', 'arial', 'fontsize', 8, 'tickdir', 'out', ...
	'xlim', [0, h.BinLimits(end)], 'ylim', [0, max(h.Values)]);
ax.XLabel.String = 'Height (px)';
ax.YLabel.String = '# Images';

ax.Toolbar.Visible = 'off';
disableDefaultInteractivity(ax)

roi = images.roi.Rectangle(ax, 'position', [-1, -1, 1+suggest_thr, 1+max_ht], ...
	'color', 'r', 'deletable', false, 'InteractionsAllowed', 'none');

% Slider
% htSel = imline(gca, [mean(ht), 0; mean(ht), max(h.Values)]);
% setColor(htSel, 'r');
% htSel.Deletable = false;
% Constrain movements to xlim and unable to move in y
% api = iptgetapi(htSel);
% constrainFcn = makeConstrainToRectFcn('imline', get(gca,'xlim'), get(gca,'ylim'));
% api.setPositionConstraintFcn(constrainFcn);

end

