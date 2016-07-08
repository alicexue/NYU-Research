function [ordered_discri,ordered_detect,ordered_probe] = overall_search_target_location(task,expN,perf)
%% This program analyzes performance or reaction time in the search task for when the target is at each location of the search display
%% Example
%%% overall_search_target_location('difficult',2);

%% Parameters
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)

%% Outputs


%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain perf for each run and concatenate over each run
loc_discri = [];
loc_detect = [];
probe_perf = [];
% sq_perf = [];

dir_name = setup_dir();
files = dir(strrep(dir_name,'\',filesep));
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [p_loc_discri,p_loc_detect,p_probe_loc,~,~,~] = p_search_target_location(obs,task,expN,perf);
        loc_discri = vertcat(loc_discri,p_loc_discri);
        loc_detect = vertcat(loc_detect,p_loc_detect);
        probe_perf = vertcat(probe_perf,p_probe_loc);
    end
end

%%% Put the outputs in order of location for the actual search display
ordered_discri = rot90(horzcat(loc_discri(:,6),loc_discri(:,3),loc_discri(:,7),loc_discri(:,4),loc_discri(:,8),loc_discri(:,1),loc_discri(:,5),loc_discri(:,2)),-1);
ordered_detect = rot90(horzcat(loc_detect(:,6),loc_detect(:,3),loc_detect(:,7),loc_detect(:,4),loc_detect(:,8),loc_detect(:,1),loc_detect(:,5),loc_detect(:,2)),-1);
ordered_probe = rot90(horzcat(probe_perf(:,6),probe_perf(:,3),probe_perf(:,7),probe_perf(:,4),probe_perf(:,8),probe_perf(:,1),probe_perf(:,5),probe_perf(:,2)),-1);

end