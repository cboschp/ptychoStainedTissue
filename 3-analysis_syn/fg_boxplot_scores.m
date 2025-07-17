function fg_boxplot_scores(dsT, fg, ttl, varargin)
% retrieve vars
if nargin>3
    singlePlot = varargin{1};
else
    singlePlot = true;
end

msg = ['n = ' char(num2str(height(dsT)))];

% init variables
if singlePlot
    f = figure;
    f.Position(3:4) = fg.size;
end

% plot
bp = boxplot([dsT.avgXR dsT.avgEM]);
hold on;
% alpha = 0.8; % horizontal displacement of random dots
% x = rand(height(dsT))*alpha;
% plot(x+1-alpha/2, dsT.avgEM, 'ob');
% plot(x+2-alpha/2, dsT.avgXR, 'ob');



% edit
ax = gca;
ylim([0 4])
ax.XTickLabel = {'XR', 'EM'};
ax.YTick = [1 2 3 4];
axis square;
ax.FontSize = fg.fsAx;
box off;
title(ttl, 'FontSize', fg.fsT);
subtitle(msg, 'FontSize',fg.fsAx);

end