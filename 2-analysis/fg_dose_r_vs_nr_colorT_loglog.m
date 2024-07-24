function fg_dose_r_vs_nr_colorT_loglog(figProps, dataT, smpIDs, pltBurnt, ttl, singlePlot, allcolorArr)
% this function plots all traces with the same color regardless of
% sampleID.

% common vars
sz = 50;
szMarker = 10;
clrMrkBurnt = 'k';
szMrkBurnt = 10;
clrXline = [.5 .5 .5];
% yl = [0 120];
% yl = [20 120];
yl = [35 120];
% xl_dose3D = [0 2.1e9];
% xl_dose3D = [0 5e8];
xl_dose3D = [1e7 2.1e9];
% xl_dose3D = [0 1e9];
xl_dose2D = [0 2e6];
xl_accDose = [0 2.1e9];
xticks = [1e7 1e8 1e9];
% yticks = [20 40 60 80 100];
yticks = [40 60 80 100];

% set figure properties
if singlePlot
    f = figure();
    f.Position(3:4) = [300 300];
end

% retreive params
if nargin < 3
    smpIDs = categories(dataT.sampleID);
    pltBurnt = false;
    pltXline = false;
elseif nargin < 4
    pltBurnt = false;
end

allSmpIDs = categories(dataT.sampleID);
smpIdxs = contains(allSmpIDs,smpIDs);
nSampleIDs = length(categories(dataT.sampleID));


% colors = turbo(nSampleIDs);
% tracecolor = [.75 .75 .75];
tracecolor = 'k';
for i = 1:nSampleIDs
    if smpIdxs(i)
        t = dataT(dataT.sampleID == allSmpIDs{i},:);
        loglog(t.dose, t.resolution_nr, ...
            '--','color',tracecolor,'LineWidth',figProps.lw);
        hold on;
        loglog(t.dose, t.resolution_r, ...
            '-','color',tracecolor,'LineWidth',figProps.lw);
    end

end

% replotting above with colorcoding for dose
for i = 1:nSampleIDs
    if smpIdxs(i)
        t = dataT(dataT.sampleID == allSmpIDs{i},:);

        for j = 1:height(t) % element-by-element
            loglog(t.dose(j), t.resolution_nr(j), ...
                'o','MarkerEdgeColor',allcolorArr(t.colorIdx(j),:), ...
                'MarkerFaceColor','w',...
                'LineWidth',figProps.lw);
            hold on;
            loglog(t.dose(j), t.resolution_r(j), ...
                'o','MarkerEdgeColor',allcolorArr(t.colorIdx(j),:), ...
                'MarkerFaceColor','w',...
                'LineWidth',figProps.lw);
        end
    end

end

% add markers on burned datasets
if pltBurnt
    for i = 1:nSampleIDs
        if smpIdxs(i)
            t = dataT(dataT.sampleID == allSmpIDs{i},:);
            st = t(t.isBurned==true,:);
            if size(st,1)>0
                loglog(st.dose, st.resolution_nr, ...
                    's','color',clrMrkBurnt, 'MarkerSize', szMrkBurnt);
                loglog(st.dose, st.resolution_r, ...
                    's','color',clrMrkBurnt, 'MarkerSize', szMrkBurnt);
            end
        end
    end
end

% edits
xlabel('dose (Gy)');
ylabel('resolution (nm)');
ax = gca;
ax.XTick = xticks;
ax.YTick = yticks;
ax.FontSize = figProps.fsAx;
title(ttl,'FontSize',figProps.fsST);
axis square;
xlim(xl_dose3D);
ylim(yl);
box off;

end