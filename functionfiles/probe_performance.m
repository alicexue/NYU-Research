% function [p,pTargetP,pTargetA,perfTargetPairs,perfClicks,perfClickPairs] = probe_performance(obs,task,file,expN,trialType,grouping)
function [p,perfPairs,pTargetP,pTargetA,perfTargetPairs,perfClicks,perfClickPairs] = probe_performance(obs,task,file,expN,trialType,grouping)
%% This program analyzes general performance on the probe task
%% Example
%%% probe_performance('ax','difficult','150820_stim01.mat',1,1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% file = '150716_stim01.mat'; (name of stim file)
% expN = 1; (1 or 2)
% trialType = 1; (only relevant for exp 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials, 4:target-present trials-analyze 
% perf at target and nontarget locations when target is probed, 5:target-present trials where 
% observer discriminates target correctly, 6:target-present trials where 
% observer detects target correctly, 7:target-present trials-analyze perf 
% at non-target locations when the target is not probed, 8: target-present 
% trials - analyze perf at target and non-target locations regardless of whether target is probed or not, 
% 9: same as 8 but when observer detects target correctly)
% grouping = 1; (if 1, probes must be exactly correct; if 2, probes must
% match by shape; if 3, probes must match by aperture)

%% Outputs
% p is a 13x1 matrix for average overall probe performance 
% pTargetP is a 13x1 matrix for average probe performance when the target
% location is probed 
% pTargetA is is a 13x1 matrix for average probe performance when the target
% location is not probed 

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

exp = getTaskParameters(myscreen,task);

expProbe = task{1}.probeTask;

if expN == 1 || (expN == 2 && trialType == 3) || expN == 3
    theTrials = find(task{1}.randVars.fixBreak == 0);
elseif expN == 2
    if trialType == 1 || trialType == 4 || trialType == 5 || trialType == 6 || trialType == 7 || trialType == 8 || trialType == 9   
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

%% Revert the order of the list
perf = NaN(2,size(theTrials,2));

index = 1;
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
        
        if expN~=3
            presence = exp.randVars.presence(n);
            orientation = exp.randVars.targetOrientation(n);
            searchResponse = exp.response(n);            
            if (task{1,1}.randVars.presence(n) == 1 && expProbe.targetPresented{n}(1) == expProbe.probePresented1{n}(3)...
                && expProbe.targetPresented{n}(2) == expProbe.probePresented1{n}(4))...
                || (task{1,1}.randVars.presence(n) == 1 && expProbe.targetPresented{n}(1) == expProbe.probePresented2{n}(3)...
                && expProbe.targetPresented{n}(2) == expProbe.probePresented2{n}(4))
                targetPA(index)=true;
            else 
                targetPA(index)=false;            
            end
            
            if trialType == 4 || trialType == 5 || trialType == 6 || trialType == 7 || trialType == 8 || trialType == 9
                if trialType == 5
                    if (presence == 1 && orientation == 1 && searchResponse == 1) || (presence == 1 && orientation == 2 && searchResponse == 2)
                        correctResponse = true;
                    else
                        correctResponse = false;
                    end
                elseif trialType == 6 || trialType == 9
                    if (presence == 1 && (orientation == 1 || orientation == 2) && (searchResponse == 1 || searchResponse == 2))
                        correctResponse = true;
                    else
                        correctResponse = false;
                    end
                else
                    correctResponse = true; % doesn't matter for trialType == 4, 7, or 8
                end                
                if targetPA(index) == true % if target is probed
                    if trialType == 4 || trialType == 8 || correctResponse == true
                        if (expProbe.targetPresented{n}(1) == expProbe.probePresented1{n}(3)...
                        && expProbe.targetPresented{n}(2) == expProbe.probePresented1{n}(4)) % if probePresented1 is at target location                
                            targetProbePerf(index) = 0;
                            nonTargetProbePerf(index) = 0;
                            if presented1(1)==reported1(1) % if first reported probe matches presented1
                                targetProbePerf(index) = 1;
                                if presented2(1)==reported2(1) 
                                    nonTargetProbePerf(index) = 1;
                                end  
                            elseif presented1(1)==reported2(1) % if second reported probe matches presented1
                                targetProbePerf(index) = 1;
                                if presented2(1)==reported1(1) 
                                    nonTargetProbePerf(index) = 1;
                                end   
                            else
                                if presented2(1)==reported1(1) || presented2(1)==reported2(2) % if probe at non-target location is correct when probe at target location is incorrect
                                    nonTargetProbePerf(index) = 1;
                                end
                            end
                            if presented1(3)==presented2(3) % check if x-coord of probe is same (same hemi)
                                sameHemiTP(index) = targetProbePerf(index);
                                diffHemiTP(index) = NaN;
                                sameHemiTA(index) = nonTargetProbePerf(index);
                                diffHemiTA(index) = NaN;
                            else 
                                sameHemiTP(index) = NaN;
                                diffHemiTP(index) = targetProbePerf(index);
                                sameHemiTA(index) = NaN;
                                diffHemiTA(index) = nonTargetProbePerf(index);
                            end
                        else % if probePresented2 is at target location
                            targetProbePerf(index) = 0;
                            nonTargetProbePerf(index) = 0;
                            if presented2(1)==reported1(1) % if first reported probe matches presented2
                                targetProbePerf(index) = 1;
                                if presented1(1)==reported2(1)
                                    nonTargetProbePerf(index) = 1;
                                end  
                            elseif presented2(1)==reported2(1) % if second reported probe matches presented2
                                targetProbePerf(index) = 1;
                                if presented1(1)==reported1(1)
                                    nonTargetProbePerf(index) = 1;
                                end   
                            else
                                if presented1(1)==reported1(1) || presented1(1)==reported2(2) % if probe at non-target location is correct when probe at target location is incorrect
                                    nonTargetProbePerf(index) = 1;
                                end
                            end
                            if presented1(3)==presented2(3) %%% check if x-coord of probe is same (same hemi)
                                sameHemiTP(index) = targetProbePerf(index);
                                diffHemiTP(index) = NaN;
                                sameHemiTA(index) = nonTargetProbePerf(index);
                                diffHemiTA(index) = NaN;
                            else 
                                sameHemiTP(index) = NaN;
                                diffHemiTP(index) = targetProbePerf(index);
                                sameHemiTA(index) = NaN;
                                diffHemiTA(index) = nonTargetProbePerf(index);
                            end
                        end
                    elseif correctResponse == false % for trialType == 5, 6 and 9(ignore trials where response is incorrect)
                        targetProbePerf(index) = NaN;
                        nonTargetProbePerf(index) = NaN;
                        sameHemiTP(index) = NaN;
                        diffHemiTP(index) = NaN;
                        sameHemiTA(index) = NaN;
                        diffHemiTA(index) = NaN;
                    end
                    if trialType == 7 || trialType == 8 || trialType == 9
                        % all_cor1 and all_cor2 record performance when target is not probed
                       
                        % when trialType == 7 and trialType == 8, 
                        % trials where target is probed are ignored in all_cor1 and all_cor2
                        
                        all_cor1(index) = NaN;
                        all_cor2(index) = NaN;
                    end
                else % if target is not probed
                    if trialType == 7 || trialType == 8 || (trialType == 9 && correctResponse)
                        % in all_cor1 and all_cor2, performance on the
                        % probes is stored (they are arbitrarily assigned
                        % into all_cor1 and all_cor2
                        cor1 = 0;
                        cor2 = 0;     
                        match11 = false;
                        match22 = false;
                        if reported1(1) == presented1(1)
                           cor1 = 1;
                           match11 = true;
                        end
                        if reported2(1) == presented2(1)
                           cor2 = 1;
                           match22 = true;
                        end
                        if ~match11 && ~match22 && reported1(1) == presented2(1)
                            cor1 = 1;
                        end
                        if ~match22 && ~match11 && reported2(1) == presented1(1)
                            cor2 = 1;
                        end
                        all_cor1(index) = cor1;
                        all_cor2(index) = cor2;
                        targetProbePerf(index) = NaN;
                        nonTargetProbePerf(index) = NaN;
                    elseif trialType == 9 && ~correctResponse
                        all_cor1(index) = NaN;
                        all_cor2(index) = NaN;
                        targetProbePerf(index) = NaN;
                        nonTargetProbePerf(index) = NaN;                        
                    else % in all other trialTypes except 7, 8, and 9, trials where target is not probed are ignored
                        targetProbePerf(index) = NaN;
                        nonTargetProbePerf(index) = NaN;
                        sameHemiTP(index) = NaN;
                        diffHemiTP(index) = NaN;
                        sameHemiTA(index) = NaN;
                        diffHemiTA(index) = NaN;                    
                    end
                end
            end
        end
        if trialType == 7 
            % only analyze trials where target is not probed (stored in
            % all_cor1 and all_cor2)
            targetProbePerf = all_cor1;
            nonTargetProbePerf = all_cor2;
        end
        cor1 = 0;
        cor2 = 0;
        if grouping == 1 % probes must match exactly
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
        elseif grouping == 2 % probes must match by shape
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
        elseif grouping == 3 % probes must match by aperture
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
        
        perf(:,index) = vertcat(cor1,cor2);
        
        index = index + 1;
    end   
end

%%% Get probe performance on first click and second click
click1 = [];
click2 = [];
index = 1;
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
        
        match11 = false;
        match12 = false;
        
        if reported1(1) == presented1(1)
            match11 = true;
            click1(index) = 1;
        elseif reported1(1) == presented2(1)
            match12 = true;
            click1(index) = 1;
        else
            click1(index) = 0;
        end
        
        if match11
            if reported2(1) == presented2(1)
                click2(index) = 1;
            else
                click2(index) = 0;
            end
        elseif match12
            if reported2(1) == presented1(1)
                click2(index) = 1;
            else
                click2(index) = 0;
            end
        else
            if reported2(1) == presented1(1)
                click2(index) = 1;
            elseif reported2(1) == presented2(1)
                click2(index) = 1;
            else
                click2(index) = 0;
            end
        end
    end
    index = index + 1;
end

%%%

perfDelays=NaN(13,100);
perfPairs = [];
perfTargetP = [];
perfTargetA = [];
targetProbeP = [];
nonTargetProbeP = [];
targetProbePairP = [];
nonTargetProbePairP = [];
sameHemiPairTP = [];
diffHemiPairTP = [];
sameHemiPairTA = [];
diffHemiPairTA = [];
perfClick1 = [];
perfClick2 = [];

perfTargetPairs = [];
perfTargetPPairs = [];
perfTargetAPairs = [];

if expN == 1 || expN == 2 
    for delays = unique(exp.randVars.delays)
        delayTrials = exp.randVars.delays(theTrials)==delays;
        trialPerf = horzcat(perf(1,delayTrials),perf(2,delayTrials));
        targetPTrials = targetPA & delayTrials;
        targetATrials = ~targetPA & delayTrials;
        tmp = trialPerf;
        perfDelays(delays,1:size(tmp,2)) = tmp;
        perfTargetP(delays) = nanmean(perf(targetPTrials));
        perfTargetA(delays) = nanmean(perf(targetATrials));
        perfClick1(delays,1) = nanmean(click1(delayTrials));
        perfClick2(delays,1) = nanmean(click2(delayTrials));

        if trialType == 4 || trialType == 5 || trialType == 6 || trialType == 7
            targetProbeP(delays) = nanmean(targetProbePerf(delayTrials));
            nonTargetProbeP(delays) = nanmean(nonTargetProbePerf(delayTrials));    
        end
        if trialType == 8 || trialType == 9
            targetProbeP(delays) = nanmean(targetProbePerf(delayTrials));
            nonTargetProbeP(delays) = nanmean(horzcat(nonTargetProbePerf(delayTrials),all_cor1(delayTrials),all_cor2(delayTrials)));    
        end
    end

    perfClick1Pairs = NaN(13,1,12);
    perfClick2Pairs = NaN(13,1,12);
    for delays = unique(exp.randVars.delays)
        for pair = unique(exp.randVars.probePairsLoc)
            delayTrials = exp.randVars.delays(theTrials)==delays;
            pairTrials = exp.randVars.probePairsLoc(theTrials)==pair;
            trialPerf = horzcat(perf(1,delayTrials),perf(2,delayTrials));
%%%%%%%%%%%%%%%%
            delayPairTrials = delayTrials & pairTrials;
            perfPairs(delays,1,pair) = nanmean(perf(delayTrials & pairTrials));
            
            targetPTrials = targetPA & delayTrials & pairTrials;
            targetATrials = ~targetPA & delayTrials & pairTrials;
            perfTargetPPairs(delays,1,pair) = nanmean(perf(targetPTrials));
            perfTargetAPairs(delays,1,pair) = nanmean(perf(targetATrials));
            perfClick1Pairs(delays,1,pair) = nanmean(click1(delayTrials & pairTrials));
            perfClick2Pairs(delays,1,pair) = nanmean(click2(delayTrials & pairTrials));
            
            if trialType == 4 || trialType == 5 || trialType == 6 
                targetProbePairP(delays,1,pair) = nanmean(targetProbePerf(delayTrials & pairTrials));
                nonTargetProbePairP(delays,1,pair) = nanmean(nonTargetProbePerf(delayTrials & pairTrials));
                sameHemiPairTP(delays,1,pair) = nanmean(sameHemiTP(delayTrials & pairTrials));
                diffHemiPairTP(delays,1,pair) = nanmean(diffHemiTP(delayTrials & pairTrials));            
                sameHemiPairTA(delays,1,pair) = nanmean(sameHemiTA(delayTrials & pairTrials));
                diffHemiPairTA(delays,1,pair) = nanmean(diffHemiTA(delayTrials & pairTrials));
            elseif trialType == 7
                % there should be only one set of data - where target is
                % not probed (targetProbePairP and nonTargetProbePairP are
                % the same - both take data from all_cor1 and all_cor2)
                targetProbePairP(delays,1,pair) = nanmean(horzcat(targetProbePerf(delayTrials & pairTrials),nonTargetProbePerf(delayTrials & pairTrials)));
                nonTargetProbePairP(delays,1,pair) = nanmean(horzcat(targetProbePerf(delayTrials & pairTrials),nonTargetProbePerf(delayTrials & pairTrials)));
            elseif trialType == 8 || trialType == 9
                targetProbePairP(delays,1,pair) = nanmean(horzcat(targetProbePerf(delayTrials & pairTrials)));
                nonTargetProbePairP(delays,1,pair) = nanmean(horzcat(nonTargetProbePerf(delayTrials & pairTrials),all_cor1(delayTrials & pairTrials),all_cor2(delayTrials & pairTrials)));
            end
        end
    end
else
    for delays = unique(exp.randVars.delays)
        delayTrials = exp.randVars.delays(theTrials)==delays;
        trialPerf = horzcat(perf(1,delayTrials),perf(2,delayTrials));
        tmp = trialPerf;
        perfDelays(delays,1:size(tmp,2)) = tmp;
        perfClick1(delays,1) = nanmean(click1(delayTrials));
        perfClick2(delays,1) = nanmean(click2(delayTrials));
    end
    
    perfClick1Pairs = NaN(13,1,12);
    perfClick2Pairs = NaN(13,1,12);
    for delays = unique(exp.randVars.delays)
        for pair = unique(exp.randVars.probePairsLoc)
            delayTrials = exp.randVars.delays(theTrials)==delays;
            pairTrials = exp.randVars.probePairsLoc(theTrials)==pair;
            perfClick1Pairs(delays,1,pair) = nanmean(click1(delayTrials & pairTrials));
            perfClick2Pairs(delays,1,pair) = nanmean(click2(delayTrials & pairTrials));
        end
    end
end

p = nanmean(perfDelays,2);
pTargetP = rot90(perfTargetP,-1);
pTargetA = rot90(perfTargetA,-1);    
perfClicks = cat(3,perfClick1,perfClick2);

perfTargetPairs = horzcat(perfTargetPPairs,perfTargetAPairs);
perfClickPairs = horzcat(perfClick1Pairs,perfClick2Pairs);

if trialType == 4 || trialType == 5 || trialType == 6 || trialType == 7 || trialType == 8 || trialType == 9
    pTargetP = targetProbePairP;
    pTargetA = nonTargetProbePairP;
    tmp1 = vertcat(sameHemiPairTP,diffHemiPairTP);
    tmp2 = vertcat(sameHemiPairTA,diffHemiPairTA);
    perfTargetPairs = horzcat(tmp1,tmp2);
end
if trialType == 7 || trialType == 8 || trialType == 9
    perfTargetPairs = NaN(26,2,12);
end
end
