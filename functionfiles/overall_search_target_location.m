function [ordered_p_discri,ordered_p_detect,ordered_p_probe] = overall_search_target_location(task,expN)
%% This program analyzes performance in the search task for performance when the target is at each location
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
perf_loc_discri = [];
perf_loc_detect = [];
probe_perf = [];
% sq_perf = [];

dir_name = setup_dir();
files = dir(strrep(dir_name,'\',filesep));
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [p_loc_discri,p_loc_detect,p_probe_loc,~,~,~] = p_search_target_location(obs,task,expN);
        perf_loc_discri = vertcat(perf_loc_discri,p_loc_discri);
        perf_loc_detect = vertcat(perf_loc_detect,p_loc_detect);
        probe_perf = vertcat(probe_perf,p_probe_loc);
    end
end

%%% Put the outputs in order of location for the actual search display
ordered_p_discri = rot90(horzcat(perf_loc_discri(:,6),perf_loc_discri(:,3),perf_loc_discri(:,7),perf_loc_discri(:,4),perf_loc_discri(:,8),perf_loc_discri(:,1),perf_loc_discri(:,5),perf_loc_discri(:,2)),-1);
ordered_p_detect = rot90(horzcat(perf_loc_detect(:,6),perf_loc_detect(:,3),perf_loc_detect(:,7),perf_loc_detect(:,4),perf_loc_detect(:,8),perf_loc_detect(:,1),perf_loc_detect(:,5),perf_loc_detect(:,2)),-1);
ordered_p_probe = rot90(horzcat(probe_perf(:,6),probe_perf(:,3),probe_perf(:,7),probe_perf(:,4),probe_perf(:,8),probe_perf(:,1),probe_perf(:,5),probe_perf(:,2)),-1);

end