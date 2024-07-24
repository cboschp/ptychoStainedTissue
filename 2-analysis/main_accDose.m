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