function fg_boxplot_scores_binned_XR(dsT, fg, ttl, varargin)

% retrieve vars
if nargin>3
    singlePlot = varargin{1};
else
    singlePlot = true;
end

% init variables
if singlePlot
    f = figure;
    f.Position(3:4) = fg.size;
end

% bin the scores
bin1 = round(dsT.avgXR,0)==1;
bin2 = round(dsT.avgXR,0)==2;
bin3 = round(dsT.avgXR,0)==3;
bin4 = round(dsT.avgXR,0)==4;
x1 = dsT.avgEM(bin1);
x2 = dsT.avgEM(bin2);
x3 = dsT.avgEM(bin3);
x4 = dsT.avgEM(bin4);
x = [x1;x2;x3;x4];
g1 = repmat(1,height(x1),1);
g2 = repmat(2,height(x2),1);
g3 = repmat(3,height(x3),1);
g4 = repmat(4,height(x4),1);
g = [g1; g2; g3; g4];

% plot
% boxplot(x,g,'PlotStyle','compact');
boxplot(x,g,'PlotStyle','traditional','Orientation','horizontal');

hold on;

% show text mentioning group sizes;
text(0.5, 1, ['n = ' num2str(height(x1))], ...
    'HorizontalAlignment','center');
text(0.5, 2, ['n = ' num2str(height(x2))], ...
    'HorizontalAlignment','center');
text(0.5, 3, ['n = ' num2str(height(x3))], ...
    'HorizontalAlignment','center');
text(0.5, 4, ['n = ' num2str(height(x4))], ...
    'HorizontalAlignment','center');

% edit
axis square;
box off;
ylim([0 5]);
xlim([0 5]);
xlabel('EM average score');
ylabel('XR consensus');
ax = gca;
ax.XTick = [1 2 3 4];
ax.XTickLabel = {'1','2','3','4'};
ax.YTick = [1 2 3 4];
ax.YTickLabel = {'1','2','3','4'};
ax.FontSize = fg.fsAx;
title(ttl, 'FontSize', fg.fsT);