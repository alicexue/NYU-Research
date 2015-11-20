function [pbPD,poPD,pnPD,pbAD,poAD,pnAD,pbPDP,pnPDP,pbADP,pnADP,numTrialsP,numTrialsA] = probe_target_analysis(obs,task,file,expN,present)
%% This program analyzes the probe task for the first experiment
%% This analyzes p1 and p2 when the target location matches a probe location, and also when it doesn't match a probe location
%% Example
%%% probe_target_analysis('ax','difficult','150820_stim01.mat',1,1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% file = '150820_stim01.mat'; (name of stim file)

%% Load the data
[pb,po,pn,pbp,pop,pnp,pboth,pone,pnone] = probe_analysis(obs,task,file,expN,present);

if expN == 1
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\' file])
elseif expN == 2
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\target present or absent\main_' task '\' file])
end

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
