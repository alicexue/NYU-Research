function [m_perf_discri,m_perf_detect,m_probe_perf,all_chi2,all_p,pairs_perf_loc] = p_search_target_location(obs,task,expN)
%% This program analyzes performance in the search task for performance when the target is at each location
%% Example
%%% p_search_target_location('ax','difficult',2);

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
search_perf_loc_discri = [];
search_perf_loc_detect = [];
probe_perf_loc = [];

pairs_perf_loc = [];
pairs_indices = [];

if expN == 1
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\main_', task]);  
elseif expN == 2
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\target present or absent\main_', task]);  
end

for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL > 4 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [search_p_loc_detect,search_p_loc_discri,m_probe_locations_perf,pairs_p_loc,pairs_idc] = search_target_location(obs,task,filename,expN);
        search_perf_loc_discri = vertcat(search_perf_loc_discri,search_p_loc_discri);
        search_perf_loc_detect = vertcat(search_perf_loc_detect,search_p_loc_detect);
        probe_perf_loc = vertcat(probe_perf_loc,m_probe_locations_perf);
        
        pairs_perf_loc = [pairs_perf_loc;pairs_p_loc];
        pairs_indices = [pairs_indices;pairs_idc];
    end
end

m_perf_discri = nanmean(search_perf_loc_discri,1);
m_perf_detect = nanmean(search_perf_loc_detect,1);
m_probe_perf = nanmean(probe_perf_loc,1);

all_chi2 = [];
all_p = [];
if ~isempty(pairs_perf_loc)
    for i=1:size(pairs_perf_loc,3) 
        [tbl,chi2,p] = crosstab(pairs_perf_loc(:,1,i),pairs_perf_loc(:,2,i));
        all_chi2(i) = chi2;
        all_p(i) = p;
    end
end
end