function fg_lollipop_max_accDoseSeries_massLossType(figProps, tomogramT, singlePlot, ttl)
% this function plots the max accumulated dose before mass loss is observed

% init color palette
matlabgreen = [0.4660 0.6740 0.1880];
matlaborange = [0.9290 0.6940 0.1250];
matlabdarkred = [0.6350 0.0780 0.1840];
matlabskyblue = [0.3010 0.7450 0.9330];
light_grey = [.9 .9 .9];
mid_grey = [.5 .5 .5];
dark_grey = [.3 .3 .3];
% faceColor = matlabgreen;
faceColor = 'w';
edgeColor = 'k';
cyan = [0 1 1];
magenta = [1 0 1];
% clrMassLossType = [matlabdarkred; matlaborange];
clrMassLossType = [magenta; cyan];
% faceColor_type1 = matlabdarkred;
% edgeColor_type1 = matlabdarkred;
faceColor_type1 = clrMassLossType(1,:);
edgeColor_type1 = 'k';
edgeColor_doseBoost = matlabskyblue;
% faceColor_type2 = matlaborange;
% edgeColor_type2 = matlaborange;
faceColor_type2 = clrMassLossType(2,:);
edgeColor_type2 = 'k';
tomoseriesLine_color = mid_grey;
tomoseriesLine_w = 5;
% init limits
% y_lims = [1 1e10];
y_lims = [1e7 1e11];
% y_ticks = [1 1e5 1e10];
y_ticks = [1e7 1e9 1e11];



% generate data
sampleIDs = unique(tomogramT.tomoSeries);
nSamples = height(sampleIDs);
maxAccDoseNotBurned = zeros(nSamples,1);
maxAccDose = zeros(nSamples,1);

for i = 1:nSamples
    t = tomogramT(tomogramT.tomoSeries==sampleIDs(i) & tomogramT.trackAccDose_series,:);
    tt = t(~t.isBurned,:);
    if ~isempty(tt)
        maxAccDoseNotBurned(i) = max(tt.accDose_series);
    else
        maxAccDoseNotBurned(i) = 0;
    end
    
    if ~isempty(t) 
        maxAccDose(i) = max(t.accDose_series);
    else
        maxAccDose(i) = 0;
    end
end


% generate variables
x = 1:nSamples;
y1 = maxAccDoseNotBurned;
y2 = maxAccDose-y1;
y = [y1 y2];

xlabels = string(sampleIDs);


% set figure properties
if singlePlot
    f = figure();
    f.Position(3:4) = [500 300];
end

% hardcoded vars
lw = 2;
lw_b = 1;
ms = 10;
eponlimit = 6e8;

% plot

% add epon limit
yline(eponlimit,'--','epon limit= 6e8 Gy','FontSize', ...
    figProps.fsAx, 'LineWidth',lw, 'Color','b','LabelHorizontalAlignment','left');
hold on;

% add individual doses;
for i = 1:nSamples
    t = tomogramT(tomogramT.tomoSeries==sampleIDs(i) & tomogramT.trackAccDose_series,:);
    xx = i;
    % yy = t.dose;
    yy = t.accDose_series;
    
    pp = plot([i i],[1 maxAccDose(i)],'-', ...
        'LineWidth',tomoseriesLine_w,'Color',tomoseriesLine_color);
    hold on;
    nTomos = height(t);
    
    for j = 1:nTomos
        this_LineWidth = lw_b;
        if t.massLossType(j) == '1'
            disp(['T1: ' char(sampleIDs(i)) ', tomo ' char(t.tomoID(j)) ', wkname_nr ' char(t.wkName_nr{j})]);
            this_FaceColor = faceColor_type1;
            this_EdgeColor = edgeColor_type1;
        elseif t.massLossType(j) == '2'
            disp(['T2: ' char(sampleIDs(i)) ', tomo ' char(t.tomoID(j)) ', wkname_nr ' char(t.wkName_nr{j})]);
            this_FaceColor = faceColor_type2;
            this_EdgeColor = edgeColor_type2;
        else
            this_FaceColor = faceColor;
            this_EdgeColor = edgeColor;
        end

        if t.doseBoostTomogram(j)
            this_EdgeColor = edgeColor_doseBoost;
        end

        ppp = plot(i,yy(j),'o', ...
            'MarkerSize',ms, 'LineWidth', this_LineWidth, ...
            'MarkerEdgeColor',this_EdgeColor,'MarkerFaceColor',this_FaceColor);

    end  

end

% edit
box off;
% p(1).FaceColor= [.75 .75 .75];
% p(2).FaceColor= 'k';
ax = gca();
xlim([0 nSamples+1]);
ylim(y_lims);
ax.YScale = 'log';
ax.YTick = y_ticks;
% ax.XTick = 1;
% ax.XTickLabel = 'samples with tracked accDose';
ax.FontSize = figProps.fsAx;
ylabel('accumulated dose (Gy)', 'FontSize', figProps.fsAx);
ax.XTick = 1:nSamples;
ax.XTickLabel = xlabels;
ax.XTickLabelRotation = 45;
set(gca,"TickLabelInterpreter",'none');
title(ttl,'FontSize',figProps.fsST);


end