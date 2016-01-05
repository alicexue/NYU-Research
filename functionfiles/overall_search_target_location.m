function [ordered_m_p_discri,ordered_m_p_detect,ordered_p_discri,ordered_p_detect,ordered_p_probe,ordered_m_p_probe] = overall_search_target_location(task,expN)
%% This program analyzes performance in the search task for performance when the target is at each location
%% Example
%%% overall_search_target_location('difficult',2);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% printFg = false; (if true, prints and saves figures

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

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [p_loc_discri,p_loc_detect,p_probe_loc] = p_search_target_location(obs,task,expN);
        perf_loc_discri = vertcat(perf_loc_discri,p_loc_discri);
        perf_loc_detect = vertcat(perf_loc_detect,p_loc_detect);
        probe_perf = vertcat(probe_perf,p_probe_loc);
    end
end

m_p_discri = nanmean(perf_loc_discri,1);
m_p_detect = nanmean(perf_loc_detect,1);
m_p_probe = nanmean(probe_perf,1);

%%% Put the outputs in order of location for the actual search display
ordered_p_discri = rot90(horzcat(perf_loc_discri(:,6),perf_loc_discri(:,3),perf_loc_discri(:,7),perf_loc_discri(:,4),perf_loc_discri(:,8),perf_loc_discri(:,1),perf_loc_discri(:,5),perf_loc_discri(:,2)),-1);
ordered_p_detect = rot90(horzcat(perf_loc_detect(:,6),perf_loc_detect(:,3),perf_loc_detect(:,7),perf_loc_detect(:,4),perf_loc_detect(:,8),perf_loc_detect(:,1),perf_loc_detect(:,5),perf_loc_detect(:,2)),-1);
ordered_p_probe = rot90(horzcat(probe_perf(:,6),probe_perf(:,3),probe_perf(:,7),probe_perf(:,4),probe_perf(:,8),probe_perf(:,1),probe_perf(:,5),probe_perf(:,2)),-1);

ordered_m_p_discri = mean(ordered_p_discri,2);
ordered_m_p_detect = mean(ordered_p_detect,2);
ordered_m_p_probe = mean(ordered_p_probe,2);

end