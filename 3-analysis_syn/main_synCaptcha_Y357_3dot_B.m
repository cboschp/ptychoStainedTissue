% Y357_3dot_synCaptcha_analysis
% 
% This scripts ingests the matlab-formatted table and performs the
% classification analysis.
% 
% vRepo
%%%%%%%

%% init vars
dirs = init_dirs_captcha();
fg = init_figOptions_captcha();

%% load data
load([dirs.matTable filesep 'synCaptcha_matTables_Y357_3dot_B.mat']);

%% review number of entries and valid entries
msg1 = ['Total number of entries: ' num2str(height(EMXR))];
msg2 = ['Number of EM valid entries: ' num2str(sum(EMXR.EMscored))];
msg3 = ['Number of XR valid entries: ' num2str(sum(EMXR.XRscored))];
msg4 = ['Number of joint EM&XR valid entries: ' num2str(sum(EMXR.EMXRscored))];
fprintf(['\n' msg1 '\n' msg2 '\n' msg3 '\n' msg4 '\n']);

%% Extract most stringent table for analysis 
% (all tasks traced by all 5 tracers in both EM and XR)
EMXRv = getSubTable(EMXR, EMXR.EMXRscored);

%% boxplot vote average 
fg_boxplot_scores(EMXRv, fg, 'assigned categories');
% figSave([dirs.fg filesep 'Y357_3dot_B_boxplot_scores']);

%% confusion plots
% fg_confusionchart(EMXRv, fg, 'confusion chart');
c = fg_plotconfusion(EMXRv, fg, 'same with plotconfusion');
% figSave([dirs.fg filesep 'Y357_3dot_B_plotconfusion_2cats']);

%% more confusion - 4-way
c2 = fg_plotconfusion4cat(EMXRv, fg, '4 categories');
% figSave([dirs.fg filesep 'Y357_3dot_B_plotconfusion_4cats']);

%% binned boxplot
% boxplot of amount of binned average responses
% this is somewhat similar to plotting for every task, response in XR =
% f(EM), but binning makes more sense since score ranges are discrete.
fg_boxplot_scores_binned(EMXRv, fg, ['scores, n = ' num2str(height(EMXRv))]);
% figSave([dirs.fg filesep 'Y357_3dot_B_boxplot_scores_binned']);

%% binned boxplot, reverse
% boxplot of amount of binned XR average responses
% this is somewhat similar to plotting for every task, response in EM =
% f(XR), but binning makes more sense since score ranges are discrete. 
fg_boxplot_scores_binned_XR(EMXRv, fg, ['scores, n = ' num2str(height(EMXRv))]);
% figSave([dirs.fg filesep 'Y357_3dot_B_boxplot_scores_binned_XR']);

%% corr responses per tracer (EM,XR)
fg_corrEMXR(EMXRv,tracers,fg,['corr2(EM,XR) per tracer, n = ' num2str(height(EMXRv))]);
% figSave([dirs.fg filesep 'Y357_3dot_B_correlationEMXR_scores']);
% figSave([dirs.fg filesep 'Y357_3dot_B_correlationEMXR_scores_nolegend']);

%% Export csv of scores
% writetable(EMXRv,[dirs.output filesep 'EMXRv_3dot_B.txt']);
