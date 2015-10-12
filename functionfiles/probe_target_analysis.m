function [pbPD,poPD,pnPD,pbAD,poAD,pnAD,pbPDP,pnPDP,pbADP,pnADP,numTrialsP,numTrialsA] = probe_target_analysis(obs,task,file)
%% This program analyzes the probe task 
%% This analyzes p1 and p2 when the target location matches a probe location, and also when it doesn't match a probe location
%% Example
%%% probe_target_analysis('ax', 'difficult','150820_stim01.mat');

%% Parameters
% obs = 'ax';
% task = 'difficult';
% file = '150820_stim01.mat';

%% Load the data
[pb,po,pn,pbp,pop,pnp,pboth,pone,pnone] = probe_analysis(obs,task,file);

load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\' file])

exp = getTaskParameters(myscreen,task);

expProbe = task{1}.probeTask;

theTrials = find(task{1}.randVars.fixBreak == 0);

nTrials = size(theTrials,2);

targetPA=[];

for n = theTrials
    if (expProbe.targetPresented{n}(1) == expProbe.probePresented1{n}(3)...
        && expProbe.targetPresented{n}(2) == expProbe.probePresented1{n}(4))...
        || (expProbe.targetPresented{n}(1) == expProbe.probePresented2{n}(3)...
        && expProbe.targetPresented{n}(2) == expProbe.probePresented2{n}(4));

        targetPA(n)=true;
    else 
        targetPA(n)=false;            
    end
end

numTrialsP = 0;
for i=1:size(targetPA,2)
    if targetPA(i)==1
        numTrialsP = numTrialsP+1;
    end
end
numTrialsA = nTrials - numTrialsP;

targetPA = logical(targetPA);
targetPA = targetPA(theTrials);

pboth=pboth(theTrials);
pnone=pnone(theTrials);
pone=pone(theTrials);

% pbPD=[];
% pnPD=[];
% poPD=[];
% 
% pbAD=[];
% pnAD=[];
% poAD=[];  

pbPD=NaN(13,50);
pnPD=NaN(13,50);
poPD=NaN(13,50);

pbAD=NaN(13,50);
pnAD=NaN(13,50);
poAD=NaN(13,50); 

for delays = unique(exp.randVars.delays)
    delayTrials = exp.randVars.delays(theTrials)==delays;
    targetPTrials = targetPA & delayTrials;
    targetATrials = ~targetPA & delayTrials;
    
    pbP=pboth(targetPTrials);
    pbPD(delays,1:size(pbP,2)) = pbP;
    pnP=pnone(targetPTrials);
    pnPD(delays,1:size(pnP,2)) = pnP;
    poP=pone(targetPTrials);
    poPD(delays,1:size(poP,2)) = poP;
    pbA=pboth(targetATrials);
    pbAD(delays,1:size(pbA,2)) = pbA;
    pnA=pnone(targetATrials);
    pnAD(delays,1:size(pnA,2)) = pnA;
    poA=pone(targetATrials);
    poAD(delays,1:size(poA,2)) = poA;
      
%     pbPD(delays,1) = pboth(targetPTrials);
%     pnPD(delays,1) = pnone(targetPTrials);
%     poPD(delays,1) = pone(targetPTrials);
%     pbAD(delays,1) = pboth(targetATrials);
%     pnAD(delays,1) = pnone(targetATrials);
%     poAD(delays,1) = pone(targetATrials);      
    
    
%     pbPD(delays,1) = mean(pboth(targetPTrials));
%     pnPD(delays,1) = mean(pnone(targetPTrials));
%     poPD(delays,1) = mean(pone(targetPTrials));
%     pbAD(delays,1) = mean(pboth(targetATrials));
%     pnAD(delays,1) = mean(pnone(targetATrials));
%     poAD(delays,1) = mean(pone(targetATrials));    
end

for delays = unique(exp.randVars.delays)
    for pair = unique(exp.randVars.probePairsLoc)
        pairTrials = exp.randVars.probePairsLoc(theTrials)==pair;    
        targetPDPTrials = targetPA & delayTrials & pairTrials;
        targetADPTrials = ~targetPA & delayTrials & pairTrials;        

        pbPDP(delays,pair) = mean(pboth(targetPDPTrials));
        pnPDP(delays,pair) = mean(pnone(targetPDPTrials));
        poPDP(delays,pair) = mean(pone(targetPDPTrials));
        pbADP(delays,pair) = mean(pboth(targetADPTrials));
        pnADP(delays,pair) = mean(pnone(targetADPTrials));
        poADP(delays,pair) = mean(pone(targetADPTrials));    

    end
end
end
