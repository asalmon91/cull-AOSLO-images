function updateAreaHist( ax, areas )
%updateAreaHist updates the axis ax with a histogram of areas

axes(ax);
nbins = 20;
histogram(areas, nbins);
xlabel('Area (px^2)');
ylabel('# Images');

end

