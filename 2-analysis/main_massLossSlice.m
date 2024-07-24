%%%%%%%%%%%
% mass loss measurements across slices
%%%%%%%%%%%
% calcs run on 4 columns stretching all slices of all non-rigid reconstructions
% harmonized reconstruction tables

%% init params
dirs = init_dirs_massLoss();
fg = init_figOptions_massLoss();

%% load data
load([dirs.matTable filesep 'ptychoStainedTissue_suppMetadata.mat']);

%% useful variables
resins = unique(tT_sorted_series_h.resinID);
nResins = height(resins);
nTomograms = height(tT_sorted_series_h);
tomoSeries = unique(tT_sorted_series_h.tomoSeries);
nTomoSeries = height(tomoSeries);

%% amend trackAccDose Series for EPL-3

tT_sorted_series_h{tT_sorted_series_h.sampleID=='EPL-3','trackAccDose_series'}=true(4,1);


%% plot individual traces normalised to the first trace: CX-1_s1; Y357_1dot_s1
seriesOfInterest = {'CX-1_s1';'Y357_1dot_s1'};

F = figure();
F.Position(3:4) = fg.sz.*[2.5 1];
tiledlayout(1,2);
nexttile(1);

fg_massLoss_seriesID_quadSlices(tT_sorted_series_h,seriesOfInterest(1),'nonrigid', ...
    seriesOfInterest(1),'k','tomogram',false,true,false,fg);
ylim([0.8 1.2]);
xlim([-10e3 10e3]);
ax = gca();
ax.XTick = [-5e3, 0, 5e3];
ax.XTickLabel = {'-5 µm','0','5 µm'};

nexttile(2);
fg_massLoss_seriesID_quadSlices(tT_sorted_series_h,seriesOfInterest(2),'nonrigid', ...
    seriesOfInterest(2),'k','tomogram',false,true,false,fg);
ylim([0.8 1.2]);
xlim([-5e3 5e3]);
ax = gca();
ax.XTick = [-5e3, 0, 5e3];
ax.XTickLabel = {'-5 µm','0','5 µm'};

sgtitle('Mass distribution across z axis','FontSize',fg.fsT,'interpreter','none');


fgttl = 'mass_change_twoDatasets';
% figSave([dirs.fg filesep fgttl]);


%% plot individual traces normalised to the first trace for the figure: CX-1_s1; Y357_1dot_s1
seriesOfInterest = {'CX-1_s1';'Y357_1dot_s1'};

fg_massLoss_seriesID_quadSlices(tT_sorted_series_h,seriesOfInterest(1),'nonrigid', ...
    seriesOfInterest(1),'k','tomogram',false,true,true,fg);
ylim([0.8 1.2]);
xlim([-5e3 5e3]);
ax = gca();
ax.XTick = [-5e3, 0, 5e3];
ax.XTickLabel = {'-5 µm','0','5 µm'};

fgttl = ['mass_change_accDoseSeries_' seriesOfInterest{1}];
figSave([dirs.fg filesep fgttl]);

fg_massLoss_seriesID_quadSlices(tT_sorted_series_h,seriesOfInterest(2),'nonrigid', ...
    seriesOfInterest(2),'k','tomogram',false,true,true,fg);
ylim([0.8 1.2]);
xlim([-5e3 5e3]);
ax = gca();
ax.XTick = [-5e3, 0, 5e3];
ax.XTickLabel = {'-5 µm','0','5 µm'};

fgttl = ['mass_change_accDoseSeries_' seriesOfInterest{2}];
% figSave([dirs.fg filesep fgttl]);

%% all tomograms, grouped by resin, norm to first trace, for the figure
for i = 1:nResins
    F = figure();
    t = tT_sorted_series_h(tT_sorted_series_h.resinID == resins(i),:);
    tmpSeries = unique(t.tomoSeries);
    ntmpSeries = height(tmpSeries);
    nrows = ceil(ntmpSeries/4);
    ncols = 4;
    F.Position(3:4) = [fg.sz(1)*ncols fg.sz(1)*nrows];
    tiledlayout(nrows,ncols);
    for j = 1:ntmpSeries
        nexttile(j);
        fg_massLoss_seriesID_quadSlices(t,tmpSeries(j),'nonrigid',...
            tmpSeries(j),'k','tomogram',false,true,false,fg);
    end
    sgtitle(['Resin ' char(resins(i))],'FontSize',fg.fsT);

    % save figure
    fgttl = ['mass_slice_accDoseSeries_tomogram_resin_' char(resins(i))];
    % figSave([dirs.fg filesep fgttl]);
end

%% all tomograms, grouped by resin, norm to baseline, for the figure
for i = 1:nResins
    F = figure();
    t = tT_sorted_series_h(tT_sorted_series_h.resinID == resins(i),:);
    tmpSeries = unique(t.tomoSeries);
    ntmpSeries = height(tmpSeries);
    nrows = ceil(ntmpSeries/4);
    ncols = 4;
    F.Position(3:4) = [fg.sz(1)*ncols fg.sz(1)*nrows];
    tiledlayout(nrows,ncols);
    for j = 1:ntmpSeries
        nexttile(j);
        fg_massLoss_seriesID_quadSlices(t,tmpSeries(j),'nonrigid',...
            tmpSeries(j),'k','top',false,true,false,fg);
    end
    sgtitle(['Resin ' char(resins(i))],'FontSize',fg.fsT);

    % save figure
    fgttl = ['mass_slice_accDoseSeries_top_resin_' char(resins(i))];
    % figSave([dirs.fg filesep fgttl]);
end



%%%%%%%