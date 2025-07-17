function cf = fg_plotconfusion4cat(dsT, fg, ttl, varargin)
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

% plot
cf = plotconfusion(dsT.EM4cat, dsT.XR4cat);
% title(ttl,'FontSize',fg.fsT);

% edit
cf.Position(3:4) = fg.size;
end