function fg_bar_max_accDoseSeries_massLossType(figProps, tomogramT, singlePlot, ttl)
% this function plots the max accumulated dose before mass loss is observed

% init color palette
matlabgreen = [0.4660 0.6740 0.1880];
matlaborange = [0.9290 0.6940 0.1250];
matlabdarkred = [0.6350 0.0780 0.1840];
matlabskyblue = [0.3010 0.7450 0.9330];
grey = [.9 .9 .9];
faceColor = matlabgreen;
edgeColor = 'k';
faceColor_type1 = matlabdarkred;
edgeColor_type1 = matlabdarkred;
edgeColor_doseBoost = matlabskyblue;
faceColor_type2 = matlaborange;
edgeColor_type2 = matlaborange;



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

% add individual doses;
for i = 1:nSamples
    t = tomogramT(tomogramT.tomoSeries==sampleIDs(i) & tomogramT.trackAccDose_series,:);
    xx = i;
    yy = t.dose;
    
    pp = bar(xx,yy,"stacked");
    hold on;
    nbars = length(pp);
    
    for j = 1:nbars
        if t.massLossType(j) == '1'
            disp(['T1: ' char(sampleIDs(i)) ', tomo ' char(t.tomoID(j)) ', wkname_nr ' char(t.wkName_nr{j})]);
            pp(j).FaceColor = faceColor_type1;
            pp(j).EdgeColor = edgeColor_type1;
            pp(j).LineWidth = lw_b;
        elseif t.massLossType(j) == '2'
            disp(['T2: ' char(sampleIDs(i)) ', tomo ' char(t.tomoID(j)) ', wkname_nr ' char(t.wkName_nr{j})]);
            pp(j).FaceColor = faceColor_type2;
            pp(j).EdgeColor = edgeColor_type2;
            pp(j).LineWidth = lw_b;
        else
            pp(j).FaceColor = faceColor;
            pp(j).EdgeColor = edgeColor;
            pp(j).LineWidth = lw_b;
        end

        if t.doseBoostTomogram(j)
            pp(j).EdgeColor = edgeColor_doseBoost;
        end
    end

    
    

end

% add epon limit
yline(eponlimit,'--','epon limit= 6e8 Gy','FontSize', ...
    figProps.fsAx, 'LineWidth',lw, 'Color','b');

% edit
box off;
p(1).FaceColor= [.75 .75 .75];
p(2).FaceColor= 'k';
ax = gca();
xlim([0 nSamples+1]);
ylim([1 1e11]);
ax.YScale = 'log';
ax.YTick = [1 1e5 1e10];
% ax.XTick = 1;
% ax.XTickLabel = 'samples with tracked accDose';
ax.FontSize = figProps.fsAx;
ylabel('accumulated dose (Gy)', 'FontSize', figProps.fsAx);
ax.XTick = 1:nSamples;
ax.XTickLabel = xlabels;
title(ttl,'FontSize',figProps.fsST);


end