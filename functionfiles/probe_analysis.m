function [pb,po,pn,pbp,pop,pnp] = probe_analysis(obs,task,file)
%% This program analyzes the probe task

%% Example
%%% probe_analysis('ax', 'difficult','150716_stim01.mat');

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150716_stim01.mat';

%% Load the data
load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\' file])

%% Get Probe data
%%% Probe identity
identity = [1 0;2 0;3 0;4 0;5 0;6 0;7 0;8 0;9 0;10 0;11 0;12 0];

%%% Probe positions
positions = [-16 -13.25 -10.5 -7.75 -5 -2.25 0.5 3.25 6 8.75 11.5 14.25];

exp = getTaskParameters(myscreen,task);

expProbe = task{1}.probeTask;

theTrials = find(task{1}.randVars.fixBreak == 0);

nTrials = size(theTrials,2);

%% Revert the order of the list
pboth = zeros(1,500);
pnone = zeros(1,500);
pone = zeros(1,500);

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
        
        cor1 = 0;
        cor2 = 0;
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
        
        if (cor1 == 1) && (cor2 == 1)
            pboth(n) = 1;pnone(n) = 0;pone(n) = 0;
        elseif ((cor1 == 1) && (cor2 == 0))||((cor1 == 0) && (cor2 == 1))
            pboth(n) = 0;pnone(n) = 0;pone(n) = 1;
        elseif (cor1 == 0) && (cor2 == 0)
            pboth(n) = 0;pnone(n) = 1;pone(n) = 0;
        end       
    end   
end
pboth = pboth(1,1:n);
pnone = pnone(1,1:n);
pone = pone(1,1:n);

t = nTrials/13;
pb = zeros(13,t);
po = zeros(13,t);
pn = zeros(13,t);

theTrials = task{1}.randVars.fixBreak == 0; 
for delays = unique(exp.randVars.delays)
    delayTrials = exp.randVars.delays(theTrials)==delays;
    pb(delays,:) = pboth(delayTrials);
    po(delays,:) = pone(delayTrials);
    pn(delays,:) = pnone(delayTrials);
end
t = t/12;
pbp = zeros(13,t,12);
pop = zeros(13,t,12);
pnp = zeros(13,t,12);

theTrials = find(task{1}.randVars.fixBreak == 0); 
for delays = unique(exp.randVars.delays)
    for pair = unique(exp.randVars.probePairsLoc)
        delaysTrials = exp.randVars.delays(theTrials)==delays;
        pairTrials = exp.randVars.probePairsLoc(theTrials)==pair;
        pbp(delays,:,pair) = pboth(delaysTrials & pairTrials);
        pop(delays,:,pair) = pone(delaysTrials & pairTrials);
        pnp(delays,:,pair) = pnone(delaysTrials & pairTrials);
    end
end
end
