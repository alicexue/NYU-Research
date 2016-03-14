function [search_perf_loc_detect,search_perf_loc_discri,m_probe_locations_perf,pairs_perf_loc,pairs_indices] = search_target_location(obs,task,file,expN)
%% This program analyzes performance in the search and probe tasks for performance when the target is at each location
%% Example
%%% search_target_location('ax','easy','151104_stim03.mat',2);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% file = '150716_stim01.mat'; (name of stim file)
% expN = 1; (1 or 2)

%% Outputs

%% Load the data
if expN == 1
    load(['C:\Users\alice_000\Documents\MATLAB\data\' obs '\main_' task '\' file])
elseif expN == 2
    load(['C:\Users\alice_000\Documents\MATLAB\data\' obs '\target present or absent\main_' task '\' file])
end

%% Get Search Display Data

%%% Stimulus locations
%locations = [[-5.656854249492381 5.656854249492381];[5.656854249492381 5.656854249492381];[5.656854249492381 -5.656854249492381];[-5.656854249492381 -5.656854249492381];[0 8];[8 0];[0 -8];[-8 0]];
locations = [[-6 6];[6 6];[6 -6];[-6 -6];[0 8];[8 0];[0 -8];[-8 0]];
exp = getTaskParameters(myscreen,task);

expProbe = task{1}.probeTask;
 
theTrials_detect = find(task{1}.randVars.fixBreak == 0);

if expN == 2    
    theTrials1 = find(task{1}.randVars.fixBreak == 0);
    theTrials2 = find(task{1}.randVars.presence == 1);
    tmp = ismember(theTrials2,theTrials1);
    theTrials_discri = theTrials2(tmp);
end

%% Revert the order of the list
search_perf_loc_detect = NaN(1000,8);
search_perf_detect = NaN(100,2);

i = 1;

if expN == 1
    for n = theTrials_detect
        location = find(int16(expProbe.targetPresented{n}(1)) == locations(:,1) & int16(expProbe.targetPresented{n}(2)) == locations(:,2));
        search_perf_detect(i,1) = location;
        if ~isnan(exp.response(n))
            if exp.randVars.targetOrientation(n) == exp.response(n)
                search_perf_detect(i,2) = 1;
            else
                search_perf_detect(i,2) = 0;
            end
        else
            search_perf_detect(i,2) = NaN;
        end

        i = i + 1;
    end
else
    for n = theTrials_detect
        location = find(int16(expProbe.targetPresented{n}(1)) == locations(:,1) & int16(expProbe.targetPresented{n}(2)) == locations(:,2));
        search_perf_detect(i,1) = location;
        presence = exp.randVars.presence(n);
        orientation = exp.randVars.targetOrientation(n);
        if ~isnan(exp.response(n))
            if (presence == 1 && (orientation == 1 || orientation == 2) && (exp.response(n) == 1 || exp.response(n) == 2)) || (presence == 2 && exp.response(n) == 3)
                search_perf_detect(i,2) = 1;
            else
                search_perf_detect(i,2) = 0;
            end
        else
            search_perf_detect(i,2) = NaN;
        end
        i = i + 1;
    end
end

search_perf_detect = search_perf_detect(1:i-1,:);


search_perf_loc_discri = NaN(1000,8);
search_perf_discri = NaN(100,2);    

i = 1;
for n = theTrials_discri
    location = find(int16(expProbe.targetPresented{n}(1)) == locations(:,1) & int16(expProbe.targetPresented{n}(2)) == locations(:,2));
    search_perf_discri(i,1) = location;
    if ~isnan(exp.response(n))
        if exp.randVars.targetOrientation(n) == exp.response(n)
            search_perf_discri(i,2) = 1;
        else
            search_perf_discri(i,2) = 0;
        end
    else
        search_perf_discri(i,2) = NaN;
    end
   
    i = i + 1;
end

search_perf_discri = search_perf_discri(1:i-1,:);

for i = 1:8
    location_i_trials_detect = find(search_perf_detect(:,1) == i);
    location_i_trials_discri = find(search_perf_discri(:,1) == i);
    n = 1;
    for q = 1:size(location_i_trials_detect,1)
        trial = location_i_trials_detect(q,1);
        search_perf_loc_detect(n,i) = search_perf_detect(trial,2);
        n = n + 1;
    end
    
    n = 1;
    for q = 1:size(location_i_trials_discri,1)
        trial = location_i_trials_discri(q,1);
        search_perf_loc_discri(n,i) = search_perf_discri(trial,2);
        n = n + 1;
    end

end

%% Get probe data
%%% Probe identity
identity = [1 0;2 0;3 0;4 0;5 0;6 0;7 0;8 0;9 0;10 0;11 0;12 0];

%%% Probe positions
positions = [-16 -13.25 -10.5 -7.75 -5 -2.25 0.5 3.25 6 8.75 11.5 14.25];

theTrials = find(task{1}.randVars.fixBreak == 0);
probe_perf = NaN(1000,2);

q = 1;
for n = theTrials
    if ~isempty(expProbe.probeResponse1{n})
        idx1 = find(positions == expProbe.probeResponse1{n});
        idx2 = find(positions == expProbe.probeResponse2{n});
        i = 11;
        for a = 1:12
            idx1 = idx1 + i;
            idx2 = idx2 + i;
            i = i - 2;
        end
        
        selected_idx1 = expProbe.list{n}==idx1;
        selected_idx2 = expProbe.list{n}==idx2;
        reported1 = identity(selected_idx1,:);
        reported2 = identity(selected_idx2,:);
        presented1 = expProbe.probePresented1{n};
        presented2 = expProbe.probePresented2{n};
        
        location = find(int16(presented1(3)) == locations(:,1) & int16(presented1(4)) == locations(:,2));
        probe_perf(q,1) = location;        
        location = find(int16(presented2(3)) == locations(:,1) & int16(presented2(4)) == locations(:,2));
        probe_perf(q+1,1) = location;        
        
        cor1 = 0;
        cor2 = 0;
        
        correct_reported = 0;
        
        if presented1(1)==reported1(1)
            cor1 = 1;
            correct_reported = 1;
        elseif presented1(1)==reported2(1)
            cor1 = 1;
            correct_reported = 2;
        end
        if correct_reported==0
            if presented2(1)==reported1(1)||presented2(1)==reported2(1)
                cor2 = 1;
            end
        elseif correct_reported==1
            if presented2(1)==reported2(1)
                cor2 = 1;
            end
        elseif correct_reported==2
            if presented2(1)==reported1(1)
                cor2 = 1;
            end
        end
  
        probe_perf(q,2) = cor1;     
        probe_perf(q+1,2) = cor2;     
        q = q + 2;
    end   
end
probe_perf = probe_perf(1:q-1,:);

for i = 1:8
    location_i_trials_probe = find(probe_perf(:,1) == i);
    n = 1;
    for q = 1:size(location_i_trials_probe,1)
        trial = location_i_trials_probe(q,1);
        probe_loc_perf(n,i) = probe_perf(trial,2);
        n = n + 1;
    end
end

m_probe_locations_perf = nanmean(probe_loc_perf,1);
m_perf_locations_discri = nanmean(search_perf_loc_discri,1);
m_perf_locations_detect = nanmean(search_perf_loc_detect,1);

% probe_perf_trials = NaN(size(probe_perf,1)/2,2);
% for i = 1:size(probe_perf,1)/2 
%     trial_idx = i * 2 - 1;
%     probe_perf_trials(i,1) = probe_perf(trial_idx,2);
%     probe_perf_trials(i,2) = probe_perf(trial_idx+1,2);
% 
% end
% 

% the third dimension of pairs_perf_loc is for each pair
% for each pair, the first column refers to the location that is
% numerically lower that the second (refer to the diagram of each pair and
% the numerical location for each probe location)
pairs_perf_loc = [];
pairs_indices = [];

for pair = unique(exp.randVars.probePairsLoc)
    pairTrials = exp.randVars.probePairsLoc(theTrials)==pair;
    perf_tmp = NaN(80,2);
    idx_tmp = NaN(80,1);
    tmpidx = 1;
    for i = 1:size(pairTrials,2);
        if pairTrials(1,i) == true
            trialidx = i * 2 - 1;
            tmp1 = probe_perf(trialidx,2);  
            tmp2 = probe_perf(trialidx+1,2);
            if probe_perf(trialidx,1) > probe_perf(trialidx+1,1)
                tmp1 = tmp2;
                tmp2 = probe_perf(trialidx,2);
            end
            perf_tmp(tmpidx,1) = tmp1;    
            perf_tmp(tmpidx,2) = tmp2;
            idx_tmp(tmpidx) = i;
            tmpidx = tmpidx + 1;
        end
    end
%     keyboard
%     perf_tmp = perf_tmp(1:tmpidx-1,:);
%     idx_tmp = idx_tmp(1:tmpidx-1,:);
    pairs_perf_loc(:,:,pair) = perf_tmp;
    pairs_indices(:,1,pair) = idx_tmp;
end

% all_chi2 = [];
% all_p = [];
% for i=1:size(pairs_perf_loc,3) 
%     [tbl,chi2,p] = crosstab(pairs_perf_loc(:,1,i),pairs_perf_loc(:,2,i));
%     all_chi2(i) = chi2;
%     all_p(i) = p;
% end
end

