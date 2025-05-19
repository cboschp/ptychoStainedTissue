%%%%%%%%%%%
% mass loss measurements
%%%%%%%%%%%
% calcs run on central 2um of all non-rigid reconstructions
% harmonized reconstruction tables

%% init params
dirs = init_dirs_analysis();
fg = init_figOptions_analysis();

%% load data
load([dirs.matTable filesep 'ptychoStainedTissue_suppMetadata.mat']);

%% useful variables
resins = unique(tT_sorted_series_h.resinID);
nResins = height(resins);
tomoSeries = unique(tT_sorted_series_h.tomoSeries);
nTomoSeries = height(tomoSeries);

% keep an index on EPL3
idxEPL3 = tT_sorted_series_h.sampleID== 'EPL-3';


%% make a fit for all resins
% masslossType0 = no mass loss
% masslossType1 = diffuse, spread
% masslossType2 = non-diffuse, contained (compatible with imaging)
t = tT_sorted_series_h(~tT_sorted_series_h.doseBoostTomogram,:);
tidx0 = t.massLossType=="0"; 
tidx2 = t.massLossType=="2"; 
tidx = tidx0 | tidx2;

x = t.dose(tidx);
y = t.resolution_nr(tidx);

% fit a power law function (linear in the log-log plot)
fitobject = fit(x,y,'power1');

% calculate prediction intervals

xint = linspace(min(x),max(x),100)';
yint = fitobject.a .* xint .^ fitobject.b;
CIF = predint(fitobject,xint,0.95,'functional');
CIO = predint(fitobject,xint,0.95,'observation');
% Observation bounds are wider than functional bounds because they measure the uncertainty of predicting the fitted curve plus the random variation in the new observation. 
% Non-simultaneous bounds (default) are for individual elements of x; simultaneous bounds are for all elements of x.
% --> observation,non-simultaneous

%% make a fit to a 4th power function
% assumption: resolution is proportional to the fourth power of dose
% r = a / d^(1/4);
% such as to obtain resolution_end -> resolution_init/2, 
% one needs dose_end = dose_init*2^4 = dose_init*16
%%%%% 

[fitresult_power4, gof_power4] = createFit_power4(x,y);
confint_power4 = confint(fitresult_power4);

% and make a fit 
yint_p4 = fitresult_power4.a./xint.^(1/4);

% % make a fit for the confidence intervals: % not used
% cint_p4_low = confint_power4(1)./xint.^(1/4);
% cint_p4_high = confint_power4(2)./xint.^(1/4);

% Get predicted intervals with this new fit % used in figure
CIO_p4 = predint(fitresult_power4,xint,0.95,'observation');
% Observation bounds are wider than functional bounds because they measure the uncertainty of predicting the fitted curve plus the random variation in the new observation. 
% Non-simultaneous bounds (default) are for individual elements of x; simultaneous bounds are for all elements of x.
% --> observation,non-simultaneous


%% plot all resins dose-res and pred intervals **figure plot**
% 
% F = figure();
% F.Position(3:4) = fg.sz;
% 
% patch([xint; flip(xint)], [CIO(:,1); flip(CIO(:,2))], ...
%     'b','FaceAlpha',0.1,'EdgeColor','none');
% hold on;
% plot(xint,yint,'-','color',[.75 .75 .75],'LineWidth',4);
% ax = gca();
% ax.XScale = 'log';
% ax.YScale = 'log';
% 
% fg_tomoSeries_dose_nr_loglog_blackLines(fg,tT_sorted_series_h,'dose-resolution',false,true,false,false);

% % save figure
% % figSave([dirs.fg filesep 'dose_resolution_predint']);

%% plot resins one by one with all-resins pred interval ** figure plot **
% 
% F = figure();
% F.Position(3:4) = fg.sz .* [nResins 1];
% tiledlayout(1,nResins);
% for i = 1:nResins
%     t = tT_sorted_series_h(tT_sorted_series_h.resinID==resins(i),:);
%     tt = t(t.doseBoostTomogram==false,:); % resolution wasn't measured in doseBoost tomograms, different imaging regime.
%     nexttile(i);
%     patch([xint; flip(xint)], [CIO(:,1); flip(CIO(:,2))], ...
%     'b','FaceAlpha',0.1,'EdgeColor','none');
%     hold on;
%     plot(xint,yint,'-','color',[.75 .75 .75],'LineWidth',4);
%     ax = gca();
%     ax.XScale = 'log';
%     ax.YScale = 'log';
%     fg_tomoSeries_dose_nr_loglog_blackLines(fg,tt,resins(i),false,true,false,false);
% end

% % save figure
% % figSave([dirs.fg filesep 'dose_resolution_allResins2_predint']);


%% plot all resins dose-res and fitted power 4 & confidence intervals **figure plot**

F = figure();
F.Position(3:4) = fg.sz;

% patch([xint; flip(xint)], [cint_p4_low; flip(cint_p4_high)], ...
%     'b','FaceAlpha',0.1,'EdgeColor','none');
patch([xint; flip(xint)], [CIO_p4(:,1); flip(CIO_p4(:,2))], ...
    'b','FaceAlpha',0.1,'EdgeColor','none');
hold on;
plot(xint,yint_p4,'-','color',[.75 .75 .75],'LineWidth',4);
ax = gca();
ax.XScale = 'log';
ax.YScale = 'log';

fg_tomoSeries_dose_nr_loglog_blackLines(fg,tT_sorted_series_h,'dose-resolution',false,true,false,false);

% save figure
% figSave([dirs.fg filesep 'dose_resolution_fitp4_predint']);

%% plot viable data points, all resins, dose-res and fitted power 4 & confidence intervals **figure plot**

F = figure();
F.Position(3:4) = fg.sz;

% patch([xint; flip(xint)], [cint_p4_low; flip(cint_p4_high)], ...
%     'b','FaceAlpha',0.1,'EdgeColor','none');
patch([xint; flip(xint)], [CIO_p4(:,1); flip(CIO_p4(:,2))], ...
    'b','FaceAlpha',0.1,'EdgeColor','none');
hold on;
plot(xint,yint_p4,'-','color',[.75 .75 .75],'LineWidth',4);
ax = gca();
ax.XScale = 'log';
ax.YScale = 'log';

fg_tomoSeries_dose_nr_loglog_viable_blackThinLines(fg,tT_sorted_series_h,'dose-resolution, viable',false,false,true,false,false);
% save figure
figSave([dirs.fg filesep 'dose_resolution_fitp4_predint_viable']);

% same plot, displaying massLossType color coding:
fg_tomoSeries_dose_nr_loglog_viable_blackThinLines(fg,tT_sorted_series_h,'dose-resolution, viable',false,true,true,false,false);
% save figure
figSave([dirs.fg filesep 'dose_resolution_fitp4_predint_viable_massLossType']);

% same plot, including massLossType==1 (non-viable & viable)
fg_tomoSeries_dose_nr_loglog_viable_blackThinLines(fg,tT_sorted_series_h,'dose-resolution',false,true,false,false,false);
% save figure
figSave([dirs.fg filesep 'dose_resolution_fitp4_predint_allpts_massLossType']);


%% plot resins one by one with all-resins p4 fit and pred interval ** figure plot **

F = figure();
F.Position(3:4) = fg.sz .* [nResins 1];
tiledlayout(1,nResins);
for i = 1:nResins
    t = tT_sorted_series_h(tT_sorted_series_h.resinID==resins(i),:);
    tt = t(t.doseBoostTomogram==false,:); % resolution wasn't measured in doseBoost tomograms, different imaging regime.
    nexttile(i);
    patch([xint; flip(xint)], [CIO_p4(:,1); flip(CIO_p4(:,2))], ...
    'b','FaceAlpha',0.1,'EdgeColor','none');
    hold on;
    plot(xint,yint_p4,'-','color',[.75 .75 .75],'LineWidth',4);
    ax = gca();
    ax.XScale = 'log';
    ax.YScale = 'log';
    fg_tomoSeries_dose_nr_loglog_blackLines(fg,tt,resins(i),false,true,false,false);
end

% save figure
% figSave([dirs.fg filesep 'dose_resolution_allResins_fitp4_predint']);

%% plot viable data points, all resins one by one with all-resins p4 fit and pred interval ** figure plot **

F = figure();
F.Position(3:4) = fg.sz .* [nResins 1];
tiledlayout(1,nResins);
for i = 1:nResins
    t = tT_sorted_series_h(tT_sorted_series_h.resinID==resins(i),:);
    tt = t(t.doseBoostTomogram==false,:); % resolution wasn't measured in doseBoost tomograms, different imaging regime.
    nexttile(i);
    patch([xint; flip(xint)], [CIO_p4(:,1); flip(CIO_p4(:,2))], ...
    'b','FaceAlpha',0.1,'EdgeColor','none');
    hold on;
    plot(xint,yint_p4,'-','color',[.75 .75 .75],'LineWidth',4);
    ax = gca();
    ax.XScale = 'log';
    ax.YScale = 'log';
    % select one plotting option:
    % a) *default* without massLossType colorcoding:
    fg_tomoSeries_dose_nr_loglog_viable_blackThinLines(fg,tt,resins(i),false,false,true,false,false);
    % b) with massLossType colorcoding:
    % fg_tomoSeries_dose_nr_loglog_viable_blackThinLines(fg,tt,resins(i),false,true,true,false,false);
    % c) same, including massLossType==1 (viable & non-viable)
    % fg_tomoSeries_dose_nr_loglog_viable_blackThinLines(fg,tt,resins(i),false,true,false,false,false);
end

% save figure (select file name according to plotting option)
figSave([dirs.fg filesep 'dose_resolution_allResins_fitp4_predint_viable']); % *default*
% figSave([dirs.fg filesep 'dose_resolution_allResins_fitp4_predint_viable_massLossType']);
% figSave([dirs.fg filesep 'dose_resolution_allResins_fitp4_predint_allpts_massLossType']);


%% plot dose-resolution for EPL-1 with the predint ** figure plot **
% preparing the data table
nDatasets = height(tT_sorted_series_h);
allcolors = turbo(200); % number of colours to use and colormap
allvalues = 0:5e6:1e9-1; % dynamic range of doses in Grays to be mapped in this figure
dsVal = zeros(nDatasets,1);
dsIdx = zeros(nDatasets,1);
for i = 1:nDatasets
    [dsVal(i), dsIdx(i)] = min(abs(allvalues-tT_sorted_series_h.dose(i)));
end
tT_sorted_series_h.colorIdx = dsIdx;

t = tT_sorted_series_h(tT_sorted_series_h.sampleID=='EPL-1',:);

% plot
F = figure();
F.Position(3:4) = [200 200];

patch([xint; flip(xint)], [CIO_p4(:,1); flip(CIO_p4(:,2))], ...
'b','FaceAlpha',0.1,'EdgeColor','none');
hold on;
plot(xint,yint_p4,'-','color',[.75 .75 .75],'LineWidth',4);
ax = gca();
ax.XScale = 'log';
ax.YScale = 'log';

hold on;
fg_dose_r_vs_nr_colorT_loglog(fg, t, "EPL-1", true, ...
    'dose-resolution',false, allcolors);

% save figure
% figSave([dirs.fg filesep 'dose_resolution_EPL1_r_nr_fitp4_predint']);


%%%%%%