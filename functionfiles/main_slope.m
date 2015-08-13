function [perfDelays,rtDelays] = main_slope(obs,task,file)
%% Example
% main_slope('ax','difficult','150716_stim01.mat');

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150716_stim01.mat';

%% Load data
load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\' file])

%% Transform data
exp = getTaskParameters(myscreen,task);
theTrials = find(task{1}.randVars.fixBreak == 0);

%% Compute performance for each delay
perf = zeros(1,600);
perfDelays = zeros(13,24);
for n = 1:size(exp.randVars.targetOrientation,2)
    orientation = exp.randVars.targetOrientation(n);
    response = exp.response(n);
    if (orientation == 1 && response == 1) || (orientation == 2 && response == 2)
        perf(n) = 1;
    else
        perf(n) = 0;
    end
end
perf = perf(1,1:n);

for delays = unique(exp.randVars.delays)
    perfDelays(delays,:) = perf(exp.randVars.delays(theTrials)==delays);
end
perfDelays = mean(perfDelays,2); 

%% Compute rt for each delay
rt = zeros(1,600);
rtDelays = zeros(13,24);

rtTmp = exp.reactionTime;
rtIndices = find(~isnan(rtTmp));

for n = 1:size(rtIndices,2)
    rt(n) = rtTmp(rtIndices(n));
end

for delays = unique(exp.randVars.delays) 
    tmp2 = exp.randVars.delays(theTrials)==delays;
    a = rt(tmp2);
    rtDelays(delays,:) = a;
end
end
