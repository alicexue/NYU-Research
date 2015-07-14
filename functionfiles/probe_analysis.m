function [pb,po,pn,pbp,pop,pnp] = probe_analysis(date,obs,block_tocheck)
%% This program allows the analysis of the probe task


%% Some parameters

% block_tocheck = 1;
% date = '141009';
% obs = 'ho';
% title_task = 'Difficult';

%% Load the data
if block_tocheck < 10
    load(['/Users/hyunjinoh/Desktop/Jane/MATLAB/data/' obs '/' date '_stim0' num2str(block_tocheck) '.mat'])
elseif block_tocheck >= 10
    load(['/Users/hyunjinoh/Desktop/Jane/MATLAB/data/' obs '/' date '_stim0' num2str(block_tocheck) '.mat'])
end

%% Get Probe data
%%% Probe identity
identity = [1 0;2 0;3 0;4 0;5 0;6 0;7 0;8 0;9 0;10 0;11 0;12 0];

%%% Probe positions
positions = [-16 -13.25 -10.5 -7.75 -5 -2.25 0.5 3.25 6 8.75 11.5 14.25];

exp = getTaskParameters(myscreen,task);


expProbe = task{1}.probeTask;

theTrials = find(task{1}.randVars.fixBreak == 0);

for n=theTrials
    %% Revert the order of the list
    if ~isempty(expProbe.probeResponse1{n})
        idx1 = find(positions == expProbe.probeResponse1{n});
        idx2 = find(positions == expProbe.probeResponse2{n});
        for a = 1:12
            if idx1 == 1;idx1 = 12;
            elseif idx1 == 2;idx1 = 11;
            elseif idx1 == 3;idx1 = 10;
            elseif idx1 == 4;idx1 = 9;
            elseif idx1 == 5;idx1 = 8;
            elseif idx1 == 6;idx1 = 7;
            elseif idx1 == 7;idx1 = 6;
            elseif idx1 == 8;idx1 = 5;
            elseif idx1 == 9;idx1 = 4;
            elseif idx1 == 10;idx1 = 3;
            elseif idx1 == 11;idx1 = 2;
            elseif idx1 == 12;idx1 = 1;
            end
            if idx2 == 1;idx2 = 12;
            elseif idx2 == 2;idx2 = 11;
            elseif idx2 == 3;idx2 = 10;
            elseif idx2 == 4;idx2 = 9;
            elseif idx2 == 5;idx2 = 8;
            elseif idx2 == 6;idx2 = 7;
            elseif idx2 == 7;idx2 = 6;
            elseif idx2 == 8;idx2 = 5;
            elseif idx2 == 9;idx2 = 4;
            elseif idx2 == 10;idx2 = 3;
            elseif idx2 == 11;idx2 = 2;
            elseif idx2 == 12;idx2 = 1;
            end
        end
        
        selected_idx1 = find(expProbe.list{n}==idx1);
        selected_idx2 = find(expProbe.list{n}==idx2);
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
        
    else
        
    end
    
end

pb = [];
po = [];
pn = [];
theTrials = find(task{1}.randVars.fixBreak == 0);
for delays = unique(exp.randVars.delays)
        pb(delays,:) = pboth(exp.randVars.delays(theTrials)==delays);
        po(delays,:) = pone(exp.randVars.delays(theTrials)==delays);
        pn(delays,:) = pnone(exp.randVars.delays(theTrials)==delays);
end


pbp = [];
pop = [];
pnp = [];
theTrials = find(task{1}.randVars.fixBreak == 0);
for delays = unique(exp.randVars.delays)
    for pair = unique(exp.randVars.probePairsLoc)
        pbp(delays,:,pair) = pboth(exp.randVars.delays(theTrials)==delays & exp.randVars.probePairsLoc(theTrials)==pair);
        pop(delays,:,pair) = pone(exp.randVars.delays(theTrials)==delays & exp.randVars.probePairsLoc(theTrials)==pair);
        pnp(delays,:,pair) = pnone(exp.randVars.delays(theTrials)==delays & exp.randVars.probePairsLoc(theTrials)==pair);
    end
end

%%
% ntrialPerCond = size(pb,2);
% 
% pbs = std(pb,[],2)./sqrt(ntrialPerCond);
% pns = std(pn,[],2)./sqrt(ntrialPerCond);
% pos = std(po,[],2)./sqrt(ntrialPerCond);
% figure;hold on;
% 
% errorbar(30:30:450,mean(pb,2)*100,pbs*100,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
% errorbar(30:30:450,mean(po,2)*100,pos*100,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])
% errorbar(30:30:450,mean(pn,2)*100,pns*100,'bo-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.35 .47 .89])
% 
% legend('pboth','pone','pnone')
% 
% set(gca,'YTick',0:20:100)
% ylabel('Percent correct','FontSize',12)
% xlabel('Time from search array onset [ms]','FontSize',12)
% ylim([-.2 100])
% 
% title([title_task ' search (' obs ')'],'FontSize',14)

% namefig=sprintf([title_task '_' obs '_' num2str(block_tocheck)]);
% print ('-djpeg', '-r500',namefig);


