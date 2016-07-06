function [perfDelays,rtDelays,perfPairs] = main_slope(obs,task,file,expN,trialType)
%% Example
%%% main_slope('ax','easy','150819_stim05.mat',1,1);

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150716_stim01.mat';
% expN = 1; (1 or 2)
% trialType = 1; (only relevant when expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)

%% Outputs
% perfDelays is a 13x1 matrix for performance in the search task of the
% main experiment
% rtDelays is a 13x1 matrix for reaction time in the search task of the
% main experiment

%% Load data
dir_name = setup_dir();
if expN == 1
    dir_loc = [dir_name '\' obs '\main_' task '\' file];
elseif expN == 2
    dir_loc = [dir_name '\' obs '\target present or absent\main_' task '\' file];
end

load(strrep(dir_loc,'\',filesep))

%% Transform data
exp = getTaskParameters(myscreen,task);
if expN == 1 || (expN == 2 && trialType == 3)
    theTrials = find(task{1}.randVars.fixBreak == 0);
elseif expN == 2
    if trialType == 1 || trialType == 4      
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        theTrials2 = find(task{1}.randVars.presence == 1);
        tmp = ismember(theTrials2,theTrials1);
        theTrials = theTrials2(tmp);
    elseif trialType == 2 
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        theTrials2 = find(task{1}.randVars.presence == 2);
        tmp = ismember(theTrials2,theTrials1);
        theTrials = theTrials2(tmp); 
    end
end

%% Compute rt for each delay
rt = NaN(1,600);
rtDelays = NaN(13,100);

rtTmp = exp.reactionTime;
noFixBreakIndices = find(~isnan(rtTmp));

for n = 1:size(noFixBreakIndices,2)
    rt(n) = rtTmp(noFixBreakIndices(n));
end

for delays = unique(exp.randVars.delays) 
    tmp2 = exp.randVars.delays(theTrials)==delays;
    a = rt(tmp2);
    rtDelays(delays,1:size(a,2)) = a;
end
%% Compute performance for each delay
perfTmp = NaN(1,600);
perfDelays = NaN(13,100);
for n = 1:size(exp.randVars.targetOrientation,2)
    orientation = exp.randVars.targetOrientation(n);
    response = exp.response(n);
    if expN == 1
        if (orientation == 1 && response == 1) || (orientation == 2 && response == 2)
            perfTmp(n) = 1;
        else
            perfTmp(n) = 0;
        end
    elseif expN == 2
        presence = exp.randVars.presence(n);
        if trialType ~=4
            if (orientation == 1 && response == 1) || (orientation == 2 && response == 2) || (presence == 2 && response == 3)
                perfTmp(n) = 1;
            else
                perfTmp(n) = 0;
            end
        elseif trialType == 4 %%% detection of target - target present trials
            if (presence == 1 && (orientation == 1 || 2) && (response == 1 || response == 2)) || (presence == 2 && response == 3)
                perfTmp(n) = 1;
            else
                perfTmp(n) = 0;
            end
        end
    end 
end
perfTmp = perfTmp(1,1:n);

for n = 1:size(noFixBreakIndices,2)
    perf(n) = perfTmp(noFixBreakIndices(n));
end

for delays = unique(exp.randVars.delays)
    tmp = perf(exp.randVars.delays(theTrials)==delays);
    perfDelays(delays,1:size(tmp,2)) = tmp;
end
perfDelays = nanmean(perfDelays,2); 
rtDelays = nanmedian(rtDelays,2);

perfPairs = [];
for delays = unique(exp.randVars.delays)
    for pair = unique(exp.randVars.probePairsLoc)
        delayTrials = exp.randVars.delays(theTrials)==delays;
        pairTrials = exp.randVars.probePairsLoc(theTrials)==pair;
        perfPairs(delays,1,pair) = nanmean(perf(delayTrials & pairTrials));
    end
end
end
