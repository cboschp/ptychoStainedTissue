function fg_boxplot_scores_binned(dsT, fg, ttl, varargin)

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
bin1 = round(dsT.avgEM,0)==1;
bin2 = round(dsT.avgEM,0)==2;
bin3 = round(dsT.avgEM,0)==3;
bin4 = round(dsT.avgEM,0)==4;
x1 = dsT.avgXR(bin1);
x2 = dsT.avgXR(bin2);
x3 = dsT.avgXR(bin3);
x4 = dsT.avgXR(bin4);
x = [x1;x2;x3;x4];
g1 = repmat(1,height(x1),1);
g2 = repmat(2,height(x2),1);
g3 = repmat(3,height(x3),1);
g4 = repmat(4,height(x4),1);
g = [g1; g2; g3; g4];

% plot
% boxplot(x,g,'PlotStyle','compact');
boxplot(x,g,'PlotStyle','traditional');

hold on;

% show text mentioning group sizes;
text(1, 0.5, ['n = ' num2str(height(x1))], ...
    'HorizontalAlignment','center');
text(2, 0.5, ['n = ' num2str(height(x2))], ...
    'HorizontalAlignment','center');
text(3, 0.5, ['n = ' num2str(height(x3))], ...
    'HorizontalAlignment','center');
text(4, 0.5, ['n = ' num2str(height(x4))], ...
    'HorizontalAlignment','center');

% edit
axis square;
box off;
ylim([0 4]);
% xlim([0 5]);
xlabel('EM consensus');
ylabel('XR average score');
ax = gca;
ax.XTick = [1 2 3 4];
ax.XTickLabel = {'1','2','3','4'};
ax.YTick = [1 2 3 4];
ax.YTickLabel = {'1','2','3','4'};
ax.FontSize = fg.fsAx;
title(ttl, 'FontSize', fg.fsT);