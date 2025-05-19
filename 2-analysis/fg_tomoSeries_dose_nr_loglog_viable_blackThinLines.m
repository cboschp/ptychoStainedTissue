function fg_tomoSeries_dose_nr_loglog_viable_blackThinLines(figProps, dataT, ttl, pltBurnt, pltMassLossType, pltViable, singlePlot, lgnd)
% alter vars
% dataT = dataT(dataT.tomoSeries=="EPL-5_s1",:);
% common vars
dataMarker = 'o';
sz = 50;
szMarker = 5;
% clrMrkBurnt = 'k';
clrMrkBurnt = [.25 .25 .25];
szMrkBurnt = 5;
clrXline = [.5 .5 .5];
matlabgreen = [0.4660 0.6740 0.1880];
matlaborange = [0.9290 0.6940 0.1250];
matlabdarkred = [0.6350 0.0780 0.1840];
matlabskyblue = [0.3010 0.7450 0.9330];
cyan = [0 1 1];
magenta = [1 0 1];
% clrMassLossType = [matlabdarkred; matlaborange];
clrMassLossType = [magenta; cyan];
% yl = [0 120];
% yl = [10 120];
% yl = [20 120];
yl = [35 120];
% xl_dose3D = [0 2.1e9];
% xl_dose3D = [1e7 2.1e9];
xl_dose3D = [1e7 1e10];
% xl_dose3D = [0 5e8];
% xl_dose3D = [0 1e9];
xl_dose2D = [0 2e6];
xl_accDose = [0 2.1e9];
xticks = [1e7 1e8 1e9 1e10];
% yticks = [10 25 50 75 100];
% yticks = [20 40 60 80 100];
yticks = [40 60 80 100];

% set figure properties
if singlePlot
    f = figure();
    f.Position(3:4) = [300 300];
end

% retreive params
if nargin < 4
    pltBurnt = false;
    pltMassLossType = false;
    pltViable = false;
    singlePlot = false;
    lgnd = false;
elseif nargin < 5
    pltMassLossType = false;
    pltViable = false;
    singlePlot = false;
    lgnd = false;
elseif nargin < 8
    lgnd = false;
end

alltSeries = unique(dataT.tomoSeries);
% tsIdxs = contains(string(alltSeries),string(alltSeries));
nTomoSeries = height(alltSeries);

allResins = unique(dataT.resinID);
nResins = height(allResins);

% colors = turbo(nTomoSeries);
% colors = turbo(nResins);
colors = zeros(nResins,3);

% plot only tomograms with either no damage (masslossType0) or non-difuse,
% contained damage compatible with imaging (masslossType2)
if pltViable
    idxViable = dataT.massLossType~='1';
    dataT = dataT(idxViable,:);
end

% plot
for i = 1:nTomoSeries
%     if tsIdxs(i)
        t = dataT(dataT.tomoSeries == alltSeries(i),:);
        if ~isempty(t)
            colorIdx = strfind(allResins,t.resinID(1));
            x = t.dose;
            y = t.resolution_nr;
            loglog(x, y, ...
                '-','color',colors(colorIdx,:),'LineWidth',figProps.lw_thin);
            hold on;
            loglog(x, y, ...
                dataMarker,'MarkerEdgeColor',colors(colorIdx,:),'MarkerFaceColor','k',...
                'LineWidth',figProps.lw,'MarkerSize',szMarker);
        end
%     end

end

% add markers on burned datasets
if pltBurnt
    for i = 1:nTomoSeries
%         if tsIdxs(i)
            t = dataT(dataT.tomoSeries == alltSeries(i),:);
            if ~isempty(t)
                st = t(t.isBurned==true,:);
                colorIdx = strfind(allResins,t.resinID(1));
                if size(st,1)>0
                    x = st.dose;
                    y = st.resolution_nr;
                    loglog(x,y, ...
                        dataMarker,'MarkerEdgeColor',colors(colorIdx,:),...
                        'MarkerFaceColor',clrMrkBurnt,...
                        'MarkerSize', szMrkBurnt);
                end
            end
%         end
    end
end

% label burned datasets with mass loss type color (cyan/magenta)
if pltMassLossType
    for i = 1:nTomoSeries
        t = dataT(dataT.tomoSeries == alltSeries(i),:);
        if ~isempty(t)
            colorIdx = strfind(allResins,t.resinID(1));
            for j = 1:height(t)
                if t.massLossType(j) == '0'
                    inner_color = 'w';
                else
                    massLossType = str2num(char(t.massLossType(j)));
                    inner_color = clrMassLossType(massLossType,:);
                end
                % plot
                x = t.dose(j);
                y = t.resolution_nr(j);
                loglog(x,y, ...
                    dataMarker,'MarkerEdgeColor',colors(colorIdx,:),...
                    'MarkerFaceColor',inner_color,...
                    'MarkerSize', szMrkBurnt);
            end
        end
    end
end

% add legend
% mock plot
pl = cell(nResins,1);
for i = 1:nResins
    x = NaN;
    y = NaN;
    pl{i} = loglog(x,y,...
        [dataMarker '-'],'MarkerSize',szMarker,'LineWidth',figProps.lw,...
        'MarkerFaceColor','w','MarkerEdgeColor',colors(i,:),'Color',colors(i,:));
end
% legend
if lgnd
    lg = legend([pl{:}],allResins,...
        'FontSize',figProps.fsAx, 'Location', 'eastoutside');
    if singlePlot
        f.Position(3) = 2*f.Position(3);
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