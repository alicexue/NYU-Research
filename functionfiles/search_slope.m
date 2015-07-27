function [rt4,rt8,perf4,perf8] = search_slope(obs,task,file)
%% Example
% search_slope('ax','difficult','150701_stim05.mat')

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150701_stim05.mat';

%% Load data
load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\' file])

%% Transform data
exp = getTaskParameters(myscreen,task);

%% Compute reaction time according to the set size
% setsize = 4:4:8;

size4 = exp.randVars.setsize==4;
size8 = exp.randVars.setsize==8;

rt4 = nanmean(exp.reactionTime(size4));
rt8 = nanmean(exp.reactionTime(size8));

% rt4_sd = nanstd(exp.reactionTime(size4))/sqrt(size(exp.reactionTime(size4),2));
% rt8_sd = nanstd(exp.reactionTime(size8))/sqrt(size(exp.reactionTime(size8),2));

%% Compute performance according to the set size
for n = 1:size(exp.randVars.targetOrientation,2)
    orientation = exp.randVars.targetOrientation(n);
    response = exp.response(n);
    if (orientation == 1 && response == 1) || (orientation == 2 && response == 2)
        perf(n) = 1;
    else
        perf(n) = 0;
    end
end

perf4 = mean(perf(size4));
perf8 = mean(perf(size8));

end