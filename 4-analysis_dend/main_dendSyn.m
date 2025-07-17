% dendritic-centric analysis of synapse detection

%% intialise variables
dirs = init_dirs_dend;
fg = init_figOptions_dend;

%% load data
load([dirs.datasets_local filesep 'synDendrite_matTables.mat']);

%% boxplot synapse detection rates
fg_TP_dendrite(dendT.TP, dendT.FP, dendT.FN,'synapses in dendrites',fg);

figSaveName = 'synDendrite_detectionRates';
figPath = strcat([dirs.fg filesep figSaveName]);
% figSave(figPath);
