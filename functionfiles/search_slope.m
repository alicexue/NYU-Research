function [rt4,rt8,perf4,perf8] = search_slope(obs,task,file,training)
%% Example
% search_slope('ax','difficult','150827_stim07.mat',false);

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150701_stim05.mat';

%% Load data
if training
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\training\' file])
else 
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\' file])
end

%% Transform data
exp = getTaskParameters(myscreen,task);

%% Compute reaction time according to the set size
% setsize = 4:4:8;

size4 = exp.randVars.setsize==4;
size8 = exp.randVars.setsize==8;

rt4 = nanmedian(exp.reactionTime(size4));
rt8 = nanmedian(exp.reactionTime(size8));

% rt4_sd = nanstd(exp.reactionTime(size4))/sqrt(size(exp.reactionTime(size4),2));
% rt8_sd = nanstd(exp.reactionTime(size8))/sqrt(size(exp.reactionTime(size8),2));

%% Compute performance according to the set size
noFixBreakIndices = find(~isnan(exp.reactionTime));
perf = zeros(1,size(noFixBreakIndices,2));
for n = 1:size(noFixBreakIndices,2)
    tmp = noFixBreakIndices(n);
    orientation = exp.randVars.targetOrientation(tmp);
    response = exp.response(tmp);
    if (orientation == 1 && response == 1) || (orientation == 2 && response == 2)
        perf(n) = 1;
    else
        perf(n) = 0;
    end
    s4(n) = size4(tmp);
    s8(n) = size8(tmp);
end 
   
i4 = 1;
i8 = 1;

for n = 1:size(noFixBreakIndices,2)
    if s4(n)
        perf4(i4) = perf(n);
        i4 = i4 + 1;
    elseif s8(n)
        perf8(i8) = perf(n);
        i8 = i8 + 1;
    end
end

perf4 = mean(perf4);
perf8 = mean(perf8);
end