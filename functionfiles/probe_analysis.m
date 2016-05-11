function [pb,po,pn,pbp,pop,pnp,pboth,pone,pnone] = probe_analysis(obs,task,file,expN,trialType,grouping)
%% This program analyzes the probe task for individual stim files
%% Example
%%% probe_analysis('ax','difficult','150820_stim01.mat',1,1,1);
%%% probe_analysis('ax','difficult','151102_stim04.mat',2,1,1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% file = '150716_stim01.mat'; (name of stim file)
% expN = 2; (1 or 2)
% trialType = 1; (only valid for expN == 2; all possible options below)
% 1:target-present trials
% 2:target-absent trials 
% 3:all trials
% 4:correct rejection trials
% 5:BOTH probes answered correctly in previous trial
% 6:ONE probe answered correctly in previous trial
% 7:NONE of the probes answered correctly in previous trial
% grouping = 1; (if 1, probes must be exactly correct; if 2, probes must
% match by shape; if 3, probes must match by aperture)

%% Load the data
dir_name = setup_dir();
if expN == 1
    dir_loc = [dir_name '\' obs '\main_' task '\' file];
elseif expN == 2
    dir_loc = [dir_name '\' obs '\target present or absent\main_' task '\' file];
elseif expN == 3
    dir_loc = [dir_name '\' obs '\control exp\' file];
end

load(strrep(dir_loc,'\',filesep))

%% Get Probe data
%%% Probe identity
identity = [1 0;2 0;3 0;4 0;5 0;6 0;7 0;8 0;9 0;10 0;11 0;12 0];

%%% Probe positions
positions = [-16 -13.25 -10.5 -7.75 -5 -2.25 0.5 3.25 6 8.75 11.5 14.25];
%keyboard
exp = getTaskParameters(myscreen,task);

expProbe = task{1}.probeTask;

if expN == 1 || (expN == 2 && trialType == 3) || expN == 3
    theTrials = find(task{1}.randVars.fixBreak == 0);
elseif expN == 2
    if trialType == 1       
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        theTrials2 = find(task{1}.randVars.presence == 1);
        tmp = ismember(theTrials2,theTrials1);
        theTrials = theTrials2(tmp);
    elseif trialType == 2 || trialType == 4
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        theTrials2 = find(task{1}.randVars.presence == 2);
        tmp = ismember(theTrials2,theTrials1);
        theTrials = theTrials2(tmp); 
    else
        theTrials = find(task{1}.randVars.fixBreak == 0);
    end
end

if expN == 2 && trialType == 4
    % find correct rejections
    respondAbsentTrials = find(exp.response == 3); 
    tmp = ismember(respondAbsentTrials,theTrials);
    theTrials = respondAbsentTrials(tmp);
end

%% Revert the order of the list
pboth = NaN(1,1000);
pnone = NaN(1,1000);
pone = NaN(1,1000);

% theTrials contains the trial numbers for the conditions set by the parameters 
index = 1;
for n = theTrials
    if n <= size(expProbe.probeResponse1,2)
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

            cor1 = 0;
            cor2 = 0;
            
            if grouping == 1
                if (reported1(1)==presented1(1))&&((reported1(2)==presented1(2)))...
                        || (reported1(1)==presented2(1))&&((reported1(2)==presented2(2)))
                    cor1 = 1;
                elseif (reported2(1)==presented1(1))&&((reported2(2)==presented1(2)))...
                        || (reported2(1)==presented2(1))&&((reported2(2)==presented2(2)))
                    cor2 = 1;
                else
                    cor1 = 0;
                    cor2 = 0;
                end
                if (reported2(1)==presented1(1))&&((reported2(2)==presented1(2)))...
                        || (reported2(1)==presented2(1))&&((reported2(2)==presented2(2)))
                    cor2 = 1;
                end
            elseif grouping == 2
                for i = 1:3
                    if i == 1
                        min = 1;
                        max = 4;
                    elseif i == 2
                        min = 5;
                        max = 8;
                    else
                        min = 9;
                        max = 12;
                    end
                    match11 = false;
                    match12 = false;
                    if (reported1(1)>=min && reported1(1)<=max)
                        if (presented1(1)>=min && presented1(1)<=max)
                            cor1 = 1;
                            match11 = true;
                        elseif (presented2(1)>=min && presented2(1)<=max)
                            match12 = true;
                            cor1 = 1;
                        end                                            
                    end
                    if (reported2(1)>=min && reported2(1)<=max)
                        if match12 || (~match11&&~match12)
                            if (presented1(1)>=min && presented1(1)<=max)
                                cor2 = 1;
                            end
                        end
                        if match11 || (~match11&&~match12)
                            if (presented2(1)>=min && presented2(1)<=max)
                                cor2 = 1;
                            end                                           
                        end
                    end
                end
            elseif grouping == 3
                for i = 1:4
                    if i == 1
                        x1 = 1;
                        x2 = 5;
                        x3 = 9;
                    elseif i == 2
                        x1 = 2;
                        x2 = 6;
                        x3 = 10;
                    elseif i == 3
                        x1 = 3;
                        x2 = 7;
                        x3 = 11;
                    elseif i == 4
                        x1 = 4;
                        x2 = 8;
                        x3 = 12;
                    end
                    match11 = false;
                    match12 = false;
                    if (reported1(1)==x1 || reported1(1)==x2 || reported1(1)==x3)
                        if (presented1(1)==x1 || presented1(1)==x2 || presented1(1)==x3)
                            cor1 = 1;
                            match11 = true;
                        elseif (presented2(1)==x1 || presented2(1)==x2 || presented2(1)==x3)
                            match12 = true;
                            cor1 = 1;
                        end                                            
                    end
                    if (reported2(1)==x1 || reported2(1)==x2 || reported2(1)==x3)
                        if match12 || (~match11&&~match12)
                            if (presented1(1)==x1 || presented1(1)==x2 || presented1(1)==x3)
                                cor2 = 1;
                            end
                        end
                        if match11 || (~match11&&~match12)
                            if (presented2(1)==x1 || presented2(1)==x2 || presented2(1)==x3)
                                cor2 = 1;
                            end                                           
                        end
                    end
                end
            end
                        
            
            if (cor1 == 1) && (cor2 == 1)
                pboth(index) = 1;pnone(index) = 0;pone(index) = 0;
            elseif ((cor1 == 1) && (cor2 == 0))||((cor1 == 0) && (cor2 == 1))
                pboth(index) = 0;pnone(index) = 0;pone(index) = 1;
            elseif (cor1 == 0) && (cor2 == 0)
                pboth(index) = 0;pnone(index) = 1;pone(index) = 0;
            end
        end       
    end   
    index = index + 1;
end

pboth = pboth(1,1:index-1);
pnone = pnone(1,1:index-1);
pone = pone(1,1:index-1);

pb = NaN(13,200);
po = NaN(13,200);
pn = NaN(13,200);

%%% look at n-1 trials
if trialType == 5 || trialType == 6 || trialType == 7
    theTrials = [];
    if trialType == 5
        trials = pboth;
    elseif trialType == 6
        trials = pone;
    elseif trialType == 7
        trials = pnone;
    end
 
    for i = 2:size(trials,2)
        if trials(1,i-1) == 1
            theTrials = horzcat(theTrials,i);
        end
    end
end
%%%

for delays = unique(exp.randVars.delays)
    delayTrials = exp.randVars.delays(theTrials)==delays;
    tmp = pboth(delayTrials);
    pb(delays,1:size(tmp,2)) = tmp;
    tmp = pone(delayTrials);
    po(delays,1:size(tmp,2)) = tmp;
    tmp = pnone(delayTrials);
    pn(delays,1:size(tmp,2)) = tmp;
end

% pbp = NaN(13,100,12);
% pop = NaN(13,100,12);
% pnp = NaN(13,100,12);

for delays = unique(exp.randVars.delays)
    for pair = unique(exp.randVars.probePairsLoc)
        delaysTrials = exp.randVars.delays(theTrials)==delays;
        pairTrials = exp.randVars.probePairsLoc(theTrials)==pair;
        tmp = pboth(delaysTrials & pairTrials);
        pbp(delays,1:size(tmp,2),pair) = tmp;
        tmp = pone(delaysTrials & pairTrials);
        pop(delays,1:size(tmp,2),pair) = tmp;
        tmp = pnone(delaysTrials & pairTrials);
        pnp(delays,1:size(tmp,2),pair) = tmp;
    end
end
end

