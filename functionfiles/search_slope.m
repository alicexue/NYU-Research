function [rt4,rt8,perf4,perf8] = search_slope(obs,task,file,expN,trialType,configuration,training)
%% Example
%%% search_slope('ax','difficult','150827_stim07.mat',1,1,3,false);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% file = '150701_stim05.mat'; (name of stim file)
% expN = 1; (1 or 2)
% trialType = 1; (only relevant for expN == 2; 1:target-present trials - discrimination,
% 2:target-absent trials, 3:all trials - detection)
% configuration = 1; (1: all trials regardless of search configuration; 2:
% square configuration; 3: diamond configuration)
% i.e. targetDiagonal == 3 or 4; if 2, uses diamond trials, if 3, all
% trials regardless of search configuration)
% training = false; (if true, uses stim files inside of training folder -
% only in exp 1

%% Outputs
% rt4 is the median rt for trials in file with set size 4 (double)
% rt8 is the median rt for trials in file with set size 8 (double)
% perf4 is average performance for trials in file with set size 4 (double)
% perf8 is average performance for trials in file with set size 8 (double)

%% Load data
if expN == 1
    if training
        load(['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' task '\training\' file])
    else 
        load(['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' task '\' file])
    end
elseif expN == 2
    load(['C:\Users\alice_000\Documents\MATLAB\data\' obs '\target present or absent\' task '\' file])
end

%% Transform data
exp = getTaskParameters(myscreen,task);

%% Compute reaction time according to the set size
% setsize = 4:4:8;

if expN == 1 || (expN == 2 && trialType == 3)
    size4 = exp.randVars.setsize==4;
    size8 = exp.randVars.setsize==8;
elseif expN == 2
    if trialType == 1
        size4 = exp.randVars.setsize == 4 & exp.randVars.presence == 1;
        size8 = exp.randVars.setsize == 8 & exp.randVars.presence == 1;
    elseif trialType == 2
        size4 = exp.randVars.setsize == 4 & exp.randVars.presence == 2;
        size8 = exp.randVars.setsize == 8 & exp.randVars.presence == 2;
    end
end

config = true(size(size4));
if configuration == 2
    config = exp.randVars.targetDiagonal == 3 | exp.randVars.targetDiagonal == 4;
elseif configuration == 3
    config = exp.randVars.targetDiagonal == 1 | exp.randVars.targetDiagonal == 2;
end

rt4 = nanmedian(exp.reactionTime(size4 & config));
rt8 = nanmedian(exp.reactionTime(size8 & config));

%% Compute performance according to the set size
noFixBreakIndices = find(task{1}.randVars.fixBreak == 0);
perf = NaN(1,size(noFixBreakIndices,2));
for n = 1:size(noFixBreakIndices,2)
    tmp = noFixBreakIndices(n);
    orientation = exp.randVars.targetOrientation(tmp);
    response = exp.response(tmp);
    if expN == 1
        if (orientation == 1 && response == 1) || (orientation == 2 && response == 2) && config(tmp);   
            perf(n) = 1;
        elseif config(tmp) == false
            perf(n) = NaN;
        else
            perf(n) = 0;
        end
    elseif expN == 2
        if trialType == 1 || trialType == 2
            presence = exp.randVars.presence(tmp);
            if (presence == 1 && orientation == 1 && response == 1) || (presence == 1 && orientation == 2 && response == 2) || (presence == 2 && response == 3) && config(tmp)
                perf(n) = 1;
            elseif config(tmp) == false
                perf(n) = NaN;
            else
                perf(n) = 0;
            end
        else
            presence = exp.randVars.presence(tmp);
            if (presence == 1 && orientation == 1 && response == 1) || (presence == 1 && orientation == 2 && response == 2) || (presence == 1 && orientation == 1 && response == 2)  || (presence == 1 && orientation == 2 && response == 1) || (presence == 2 && response == 3) && config(tmp)
                perf(n) = 1;
            elseif config(tmp) == false
                perf(n) = NaN;
            else
                perf(n) = 0;
            end       
        end
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
    end
    if s8(n)
        perf8(i8) = perf(n);
        i8 = i8 + 1;
    end
end
perf4 = nanmean(perf4);
perf8 = nanmean(perf8);
end