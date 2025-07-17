function fg_corrEMXR(dsT,Tracers,fg,ttl,varargin)

% retreive vars
nTracers = size(dsT.scores_EM,2);

if ~isequal(nTracers,height(Tracers))
    error('ERROR: nTracers is inconsistent between the provided table and cell array.');
end

if nargin>4
    singlePlot = varargin{1};
else
    singlePlot = true;
end

% compute correlations EM2XR
corrEMXR = zeros(1,nTracers);
for i = 1:nTracers
    corrEMXR(i) = corr2(dsT.scores_EM(:,i),dsT.scores_XR(:,i));
end

nRows = height(dsT);
EM2cat = zeros(nRows,nTracers);
XR2cat = zeros(nRows,nTracers);
corrEMXR2cat = zeros(1,nTracers);
for i = 1:nTracers
    EM2cat(:,i) = grp2idx(dsT.EM2cat(:,i));
    XR2cat(:,i) = grp2idx(dsT.XR2cat(:,i));
    corrEMXR2cat(i) = corr2(EM2cat(:,i),XR2cat(:,i));
end

% compute correlations EM2EM
corrEM2EM = zeros(1,nTracers);
% tracersIdx = [2:nTracers 1];
for i = 1:nTracers
    x1 = dsT.scores_EM(:,i);
    x2raw = dsT.scores_EM;
    x2raw(:,i) = [];
    % x2 = dsT.scores_EM(:,tracersIdx(i)); % correlates each tracer's EM score to the score given by the next tracer in the array.
    x2 = mean(x2raw,2); % correlates each tracer's EM score to the average score given by all other tracers.
    corrEM2EM(i) = corr2(x1,x2);
end

% compute correlations XR2XR
corrXR2XR = zeros(1,nTracers);
% tracersIdx = [2:nTracers 1];
for i = 1:nTracers
    x1 = dsT.scores_XR(:,i);
    x2raw = dsT.scores_XR;
    x2raw(:,i) = [];
    % x2 = dsT.scores_EM(:,tracersIdx(i)); % correlates each tracer's EM score to the score given by the next tracer in the array.
    x2 = mean(x2raw,2); % correlates each tracer's EM score to the average score given by all other tracers.
    corrXR2XR(i) = corr2(x1,x2);
end

if singlePlot
    f = figure;
    f.Position(3:4) = fg.size;
end

% plot
plot(corrEMXR,'o');
hold on;
plot(corrEMXR2cat,'x');
plot(corrEM2EM,'*');
plot(corrXR2XR,'dk');

% edit
axis square;
box off;
xmax = nTracers+1;
xlim([0 xmax]);
ylim([0 1]);
ax = gca;
ax.XTick = 1:nTracers;
ax.XTickLabel = Tracers;
% legend({'4 categories','2 categories','EM2EM','XR2XR'},'FontSize',fg.fsAx,'location','best');
ax.FontSize = fg.fsAx;
title(ttl, 'FontSize', fg.fsT);


end