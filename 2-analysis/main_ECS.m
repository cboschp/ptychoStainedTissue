%%%%%%%%%%%
% Extracellular space
%%%%%%%%%%%
% Summary of extracellular space assessement

%% load data
dirs = init_dirs_analysis();
fg = init_figOptions_analysis();
ecsT=readtable([dirs.datasets_local filesep 'Y357_3dot_FIBSEM_ECS.csv']);

%% extract summary
ECS_avg = mean(ecsT.ECS_fraction);
ECS_std = std2(ecsT.ECS_fraction);
ECS_stderr = ECS_std ./ sqrt(height(ecsT));

%% display summary 
disp('ECS fraction:');
disp(ECS_avg);
disp('standard error:');
disp(ECS_stderr);