function htSel = updateHtHist( ax, ht )
%updateAreaHist updates the axis ax with a histogram of areas



% Histogram
axes(ax);
nbins = 20;
h = histogram(ht, nbins);
xlabel('Height (px)', 'fontname', 'arial', 'fontsize', 9);
ylabel('# Images', 'fontname', 'arial', 'fontsize', 9);
xlim([0, h.BinLimits(end)]);
ylim([0, max(h.Values)]);
set(gca, 'fontname', 'arial', 'fontsize', 8, 'tickdir', 'out');

% Slider
htSel = imline(gca, [mean(ht), 0; mean(ht), max(h.Values)]);
setColor(htSel, 'r');
htSel.Deletable = false;
% Constrain movements to xlim and unable to move in y
api = iptgetapi(htSel);
constrainFcn = makeConstrainToRectFcn('imline', get(gca,'xlim'), get(gca,'ylim'));
api.setPositionConstraintFcn(constrainFcn);

end

