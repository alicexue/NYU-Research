function [pb,po,pn,pbp,pop,pnp,sHemi,dHemi,diag] = probe_analysis(obs,task,file)
%% This program analyzes the probe task

%% Example
%%% probe_analysis('ax', 'difficult','150716_stim01.mat')

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

%% Revert the order of the list
pboth = zeros(1,12);
pnone = zeros(1,12);
pone = zeros(1,12);
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
        
        cor1 = 0;
        cor2 = 0;
        if (reported1(1)==expProbe.probePresented1{n}(1))&&((reported1(2)==expProbe.probePresented1{n}(2)))...
                || (reported1(1)==expProbe.probePresented2{n}(1))&&((reported1(2)==expProbe.probePresented2{n}(2)))
            cor1 = 1;
        elseif (reported2(1)==expProbe.probePresented1{n}(1))&&((reported2(2)==expProbe.probePresented1{n}(2)))...
                || (reported2(1)==expProbe.probePresented2{n}(1))&&((reported2(2)==expProbe.probePresented2{n}(2)))
            cor2 = 1;
        else
            cor1 = 0;
            cor2 = 0;
        end
        if (reported2(1)==expProbe.probePresented1{n}(1))&&((reported2(2)==expProbe.probePresented1{n}(2)))...
                || (reported2(1)==expProbe.probePresented2{n}(1))&&((reported2(2)==expProbe.probePresented2{n}(2)))
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
pb = zeros(15,12);
po = zeros(15,12);
pn = zeros(15,12);

theTrials = find(task{1}.randVars.fixBreak == 0); 
for delays = unique(exp.randVars.delays)
        pb(delays,:) = pboth(exp.randVars.delays(theTrials)==delays);
        po(delays,:) = pone(exp.randVars.delays(theTrials)==delays);
        pn(delays,:) = pnone(exp.randVars.delays(theTrials)==delays);
end

pbp = zeros(15,2,6);
pop = zeros(15,2,6);
pnp = zeros(15,2,6);

theTrials = find(task{1}.randVars.fixBreak == 0); 
for delays = unique(exp.randVars.delays)
    for pair = unique(exp.randVars.probePairsLoc)
        pbp(delays,:,pair) = pboth(exp.randVars.delays(theTrials)==delays & exp.randVars.probePairsLoc(theTrials)==pair);
        pop(delays,:,pair) = pone(exp.randVars.delays(theTrials)==delays & exp.randVars.probePairsLoc(theTrials)==pair);
        pnp(delays,:,pair) = pnone(exp.randVars.delays(theTrials)==delays & exp.randVars.probePairsLoc(theTrials)==pair);
    end
end
% these contain pboth and pnone
sHemi = cat(3,pbp(:,:,1),pbp(:,:,6)); 
diag = cat(3,pbp(:,:,2),pbp(:,:,5));
dHemi = cat(3,pbp(:,:,3),pbp(:,:,4));

sHemi = cat(3,sHemi,pnp(:,:,1));
diag = cat(3,diag,pnp(:,:,2));
dHemi = cat(3,dHemi,pnp(:,:,3));

sHemi = cat(3,sHemi,pnp(:,:,6));
diag = cat(3,diag,pnp(:,:,5));
dHemi = cat(3,dHemi,pnp(:,:,4));

end
