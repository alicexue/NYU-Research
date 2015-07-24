function [perfDelays,rtDelays] = perf1_slope(obs,task,file)
%% Example
% perf1_slope('ax','difficult','150716_stim01.mat')

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150716_stim01.mat';
%% Load data
load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\' file])

%% Transform data
exp = getTaskParameters(myscreen,task);

%% Compute performance for each delay
perfDelays = zeros(15,12);
for n = 1:size(exp.randVars.targetOrientation,2)
    if (exp.randVars.targetOrientation(n) == 1 && exp.response(n) == 1) || (exp.randVars.targetOrientation(n) == 2 && exp.response(n) == 2)
        perf(n) = 1;
    else
        perf(n) = 0;
    end
end

theTrials = find(task{1}.randVars.fixBreak == 0);
for delays = unique(exp.randVars.delays)
    perfDelays(delays,:) = perf(exp.randVars.delays(theTrials)==delays);
end
perfDelays = mean(perfDelays,2); 

%% Compute rt for each delay
rtDelays = zeros(15,12);
for n = 1:size(exp.reactionTime,2)
    rt(n) = exp.reactionTime(:,n);
end

rtIndices = find(~isnan(rt));

for n = 1:size(rtIndices,2)
    rtime(n) = rt(1,rtIndices(1,n));
end

for delays = unique(exp.randVars.delays) 
    tmp2 = exp.randVars.delays(theTrials)==delays;
    a = rtime(tmp2);
    rtDelays(delays,:) = a;
end
end
