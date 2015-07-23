function [rt4,rt8,perf4,perf8] = search_slope(date,obs,block_tocheck,task)
%% Example
% search_slope('150709','ax',5,'difficult')

%% Load data

if block_tocheck < 10
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\' date '_stim0' num2str(block_tocheck) '.mat'])
else
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\' date '_stim' num2str(block_tocheck) '.mat'])
end

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
    if (exp.randVars.targetOrientation(n) == 1 && exp.response(n) == 1) || (exp.randVars.targetOrientation(n) == 2 && exp.response(n) == 2)
        perf(n) = 1;
    else
        perf(n) = 0;
    end
end

perf4 = mean(perf(size4));
perf8 = mean(perf(size8));

end