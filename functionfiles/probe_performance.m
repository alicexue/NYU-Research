function [p,pTargetP,pTargetA] = probe_performance(obs,task,file,expN,present,grouping)
%% This program analyzes general performance on the probe task
%% Example
%%% probe_performance('ax','difficult','150820_stim01.mat',1,1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% file = '150716_stim01.mat'; (name of stim file)
% expN = 1; (1 or 2)
% present = 1; (only relevant for exp 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)

%% Outputs
% p is a 13x1 matrix for average overall probe performance 
% pTargetP is a 13x1 matrix for average probe performance when the target
% location is probed 
% pTargetA is is a 13x1 matrix for average probe performance when the target
% location is not probed 

%% Load the data
if expN == 1
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\' file])
elseif expN == 2
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\target present or absent\main_' task '\' file])
end

%% Get Probe data
%%% Probe identity
identity = [1 0;2 0;3 0;4 0;5 0;6 0;7 0;8 0;9 0;10 0;11 0;12 0];

%%% Probe positions
positions = [-16 -13.25 -10.5 -7.75 -5 -2.25 0.5 3.25 6 8.75 11.5 14.25];

exp = getTaskParameters(myscreen,task);

expProbe = task{1}.probeTask;

if expN == 1 || (expN == 2 && present == 3)
    theTrials = find(task{1}.randVars.fixBreak == 0);
elseif expN == 2
    if present == 1       
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        theTrials2 = find(task{1}.randVars.presence == 1);
        tmp = ismember(theTrials2,theTrials1);
        theTrials = theTrials2(tmp);
    elseif present == 2
        theTrials1 = find(task{1}.randVars.fixBreak == 0);
        theTrials2 = find(task{1}.randVars.presence == 2);
        tmp = ismember(theTrials2,theTrials1);
        theTrials = theTrials2(tmp); 
    end
end

%% Revert the order of the list
perf = NaN(2,size(theTrials,2));

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
                if reported1(1) == presented1(1) 
                    cor1 = 4;
                    match11 = true;
                elseif reported1(1) == presented2(1)
                    cor1 = 4;
                    match12 = true;
                elseif (reported1(1)>=min && reported1(1)<=max)
                    if (presented1(1)>=min && presented1(1)<=max)
                        cor1 = 1;
                        match11 = true;
                    elseif (presented2(1)>=min && presented2(1)<=max)
                        match12 = true;
                        cor1 = 1;
                    end                                            
                end
                if reported2(1) == presented1(1) 
                    cor1 = 4;
                elseif reported2(1) == presented2(1)
                    cor1 = 4;
                elseif (reported2(1)>=min && reported2(1)<=max)
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
                if reported1(1) == presented1(1) 
                    cor1 = 4;
                    match11 = true;
                elseif reported1(1) == presented2(1)
                    cor1 = 4;
                    match12 = true;                
                elseif (reported1(1)==x1 || reported1(1)==x2 || reported1(1)==x3)
                    if (presented1(1)==x1 || presented1(1)==x2 || presented1(1)==x3)
                        cor1 = 1;
                        match11 = true;
                    elseif (presented2(1)==x1 || presented2(1)==x2 || presented2(1)==x3)
                        match12 = true;
                        cor1 = 1;
                    end                                            
                end
                if reported2(1) == presented1(1) 
                    cor1 = 4;
                elseif reported2(1) == presented2(1)
                    cor1 = 4;               
                elseif (reported2(1)==x1 || reported2(1)==x2 || reported2(1)==x3)
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
        
        perf(:,n) = vertcat(cor1,cor2);
        
        if (expProbe.targetPresented{n}(1) == expProbe.probePresented1{n}(3)...
            && expProbe.targetPresented{n}(2) == expProbe.probePresented1{n}(4))...
            || (expProbe.targetPresented{n}(1) == expProbe.probePresented2{n}(3)...
            && expProbe.targetPresented{n}(2) == expProbe.probePresented2{n}(4));

            targetPA(n)=true;
        else 
            targetPA(n)=false;            
        end        
    end   
end

targetPA = logical(targetPA);
targetPA = targetPA(theTrials);

perfDelays=NaN(13,100);
perfTargetP=[];
perfTargetA=[];

for delays = unique(exp.randVars.delays)
    delayTrials = exp.randVars.delays(theTrials)==delays;
    trialPerf = horzcat(perf(1,delayTrials),perf(2,delayTrials));
    targetPTrials = targetPA & delayTrials;
    targetATrials = ~targetPA & delayTrials;
    tmp = trialPerf;
    perfDelays(delays,1:size(tmp,2)) = tmp;
    perfTargetP(delays) = nanmean(perf(targetPTrials));
    perfTargetA(delays) = nanmean(perf(targetATrials));
end
p = nanmean(perfDelays,2);
pTargetP = rot90(perfTargetP,-1);
pTargetA = rot90(perfTargetA,-1);
end

