%%%%%%%%%%%
% accDose analysis
%%%%%%%%%%%
% 
% 

%% init params
dirs = init_dirs_massLoss();
fg = init_figOptions_massLoss();

%% load data
load([dirs.matTable filesep 'ptychoStainedTissue_suppMetadata.mat']);

%% useful variables
resins = unique(tT_sorted_series_h.resinID);
nResins = height(resins);

%% include alls series from EPL-3
idx = tT_sorted_series_h.sampleID== 'EPL-3';
tT_allseries = tT_sorted_series_h;
tT_allseries{idx,'trackAccDose_series'} = true(sum(idx),1); % force EPL-3 to have all tomoseries in (regardless of accDose in between)


%% lollipop plots
% plot all tomograms in both layouts
F = figure();
F.Position(3:4) = [500 500];
tiledlayout(2,1);
nexttile(1);
fg_bar_max_accDoseSeries_massLossType(fg,tT_allseries,false,'old style - bars');
nexttile(2);
fg_lollipop_max_accDoseSeries_massLossType(fg,tT_allseries,false,'new style - lollipop');


% figSave([dirs.fg filesep 'radiation_capacity_newLollipopPlots']);

%% accDose plot, all series

F = figure();
F.Position(3:4) = [500 250];

fg_lollipop_max_accDoseSeries_massLossType(fg,tT_allseries,false,'radiation resilience');

% figSave([dirs.fg filesep 'radiation_capacity_lollipop_allResins']);


%% accDose lollipop plot, tiled layout by resinID **figure plots**

F = figure();
F.Position(3:4) = [1200 300];
tiledlayout(1,nResins);

for i = 1:nResins
    nexttile(i);
    % t = tT_sorted_series_h(tT_sorted_series_h.resinID==resins(i),:);
    t = tT_allseries(tT_sorted_series_h.resinID==resins(i),:);
    fg_lollipop_max_accDoseSeries_massLossType(fg,t,false,resins(i));
end

% figSave([dirs.fg filesep 'radiation_capacity_lollipop_resinType2_massLossType']);

%%%%%%

%% Summary of mass loss observations
%
% MassLossType 0: no observable damage
% MassLossType 1: widespread mass loss
% MassLossType 2: spatially constrained radiation damage

% load data (already loaded in this script)
% load([dirs.matTable filesep 'ptychoStainedTissue_suppMetadata.mat']);

% amend trackAccDose Series for EPL-3 (already applied in tT_allseries)
% tT_sorted_series_h{tT_sorted_series_h.sampleID=='EPL-3','trackAccDose_series'}=true(4,1);

%% split table in low (<6e8Gy) and high (>=6e8Gy) accumulated dose tomograms
ttlow = tT_allseries(tT_allseries.accDose_series<6e8,:);
tthigh = tT_allseries(tT_allseries.accDose_series>=6e8,:);

%% resins A&B, low dose regime (accDose_series < 6e8 Gy) 
idxlow = ttlow.massLossType=='1' & ...
    ttlow.trackAccDose_series & ...
    (ttlow.resinID=='A' | ttlow.resinID=='B');
idxlow_all = ttlow.trackAccDose_series & ...
    (ttlow.resinID=='A' | ttlow.resinID=='B');
tomoSeriesAB_low = unique(ttlow.tomoSeries(idxlow_all));
disp(['Resins A&B, MassLossType1 tomo_series with <6e8 Gy accDose: ' ...
    num2str(sum(idxlow)) '/' ...
    num2str(height(tomoSeriesAB_low))]);

%% resins A&B, high dose regime (accDose_series >= 6e8 Gy)
idxhigh = tthigh.massLossType=='1' & ...
    tthigh.trackAccDose_series & ...
    (tthigh.resinID=='A' | tthigh.resinID=='B');
idxhigh_all = tthigh.trackAccDose_series & ...
    (tthigh.resinID=='A' | tthigh.resinID=='B');
tomoSeriesAB_high = unique(tthigh.tomoSeries(idxhigh_all));
disp(['Resins A&B, MassLossType1 tomo_series with >6e8 Gy accDose ' ...
    num2str(height(unique(tthigh.tomoSeries(idxhigh)))) '/' ...
    num2str(height(unique(tthigh.tomoSeries(idxhigh_all))))]);

%% resin E, low dose regime (accDose_series < 6e8 Gy) 
idxlowE = ttlow.massLossType=='1' & ...
    ttlow.trackAccDose_series & ...
    ttlow.resinID=='E';
idxlowE_all = ttlow.trackAccDose_series & ...
    ttlow.resinID=='E';
tomoSeriesE_low = unique(ttlow.tomoSeries(idxlowE_all));
disp(['Resin E, MassLossType1 tomo_series with <6e8 Gy accDose: ' ...
    num2str(sum(idxlowE)) '/' ...
    num2str(height(tomoSeriesE_low))]);


%% resin E, high dose regime (accDose_series >= 6e8 Gy)
idxhighE = tthigh.massLossType=='1' & ...
    tthigh.trackAccDose_series & ...
    tthigh.resinID=='E';
idxhighE_all = tthigh.trackAccDose_series & ... 
    tthigh.resinID=='E';
tomoSeriesAB_high = unique(tthigh.tomoSeries(idxhighE_all));
disp(['Resin E, MassLossType1 tomo_series with >6e8 Gy accDose ' ...
    num2str(height(unique(tthigh.tomoSeries(idxhighE)))) '/' ...
    num2str(height(unique(tthigh.tomoSeries(idxhighE_all))))]);