function [p1P,p2P,p1A,p2A,pbP,pnP,pbA,pnA,p1PS,p2PS,p1AS,p2AS] = overall_probe_target_analysis(task,expN,present,printFg)
%% This function gets p1 and p2 from all observers and averages them
%% Example
%%% overall_probe_target_analysis('difficult',2,1,true);

%% Parameters
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% printFg = false; (if true, prints and saves figures)

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFileName = '1';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\' condition];
    if present == 1
        saveFileName = '_2TP';
    elseif present == 2
        saveFileName = '_2TA';
    elseif present == 3
        saveFileName = '_2';
    end
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
pbP=[];
pnP=[];
poP=[];

pbA=[];
pnA=[];
poA=[]; 

p1P=[];
p2P=[];
p1A=[];
p2A=[];

p1PS=[];
p2PS=[];
p1AS=[];
p2AS=[];

numTrialsP=0;
numTrialsA=0;

numTrialsPS=0;
numTrialsAS=0;

numObs = 0;

files = dir('C:\Users\alice_000\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [pbothP,poneP,pnoneP,pbothA,poneA,pnoneA,P1P,P2P,P1A,P2A,nTrialsP,nTrialsA,p1Ps,p2Ps,p1As,p2As,minTrialsP,minTrialsA] = p_probe_target_analysis(obs,task,expN,present,false); 
        
        if ~isempty(pbothP) 
            pbP=horzcat(pbP,nanmean(pbothP,2));
            pnP=horzcat(pnP,nanmean(pnoneP,2));
            poP=horzcat(poP,nanmean(poneP,2));
            
            pbA=horzcat(pbA,nanmean(pbothA,2));
            pnA=horzcat(pnA,nanmean(pnoneA,2));
            poA=horzcat(poA,nanmean(poneA,2));            

            p1P=horzcat(p1P,P1P);
            p2P=horzcat(p2P,P2P);
            p1A=horzcat(p1A,P1A);
            p2A=horzcat(p2A,P2A);

            p1PS=horzcat(p1PS,p1Ps);
            p2PS=horzcat(p2PS,p2Ps);
            
            p1AS=horzcat(p1AS,p1As);
            p2AS=horzcat(p2AS,p2As);               
            
            numTrialsP = numTrialsP + nTrialsP;
            numTrialsA = numTrialsA + nTrialsA;
            numTrialsPS = numTrialsPS + minTrialsP;
            numTrialsAS = numTrialsAS + minTrialsA;            
            numObs = numObs + 1;
        end
    end
end

MpbP = nanmean(pbP,2);
MpoP = nanmean(poP,2);
MpnP = nanmean(pnP,2);
SpbP = nanstd(pbP,[],2)./sqrt(numObs);
SpoP = nanstd(poP,[],2)./sqrt(numObs);
SpnP = nanstd(pnP,[],2)./sqrt(numObs);

MpbA = nanmean(pbA,2);
MpoA = nanmean(poA,2);
MpnA = nanmean(pnA,2);
SpbA = nanstd(pbA,[],2)./sqrt(numObs);
SpoA = nanstd(poA,[],2)./sqrt(numObs);
SpnA = nanstd(pnA,[],2)./sqrt(numObs);

Mp1P=mean(p1P,2);
Mp2P=mean(p2P,2);
Mp1A=mean(p1A,2);
Mp2A=mean(p2A,2);

Sp1P=std(p1P,[],2)./sqrt(numObs);
Sp2P=std(p2P,[],2)./sqrt(numObs);
Sp1A=std(p1A,[],2)./sqrt(numObs);
Sp2A=std(p2A,[],2)./sqrt(numObs);

Mp1PS=mean(p1PS,2);
Mp2PS=mean(p2PS,2);
Mp1AS=mean(p1AS,2);
Mp2AS=mean(p2AS,2);

Sp1PS=std(p1PS,[],2)./sqrt(numObs);
Sp2PS=std(p2PS,[],2)./sqrt(numObs);
Sp1AS=std(p1AS,[],2)./sqrt(numObs);
Sp2AS=std(p2AS,[],2)./sqrt(numObs);

if printFg
    %% Averaging across runs
    figure;hold on;
    errorbar(100:30:460,MpbP,SpbP,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,MpoP,SpoP,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,MpnP,SpnP,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search - Target Probed' saveFileName],'FontSize',18,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_TP_rawProbs1' saveFileName]);
    print ('-djpeg', '-r500',namefig);
   
    %% Plot p1 and p2 for each probe delay
    figure;hold on;

    errorbar(100:30:460,Mp1P,Sp1P,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    errorbar(100:30:460,Mp2P,Sp2P,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])
    
    title([condition ' Search-Target Probed (n = ' num2str(numObs) ')' saveFileName],'FontSize',18,'Fontname','Ariel')
    % title([condition ' Search-Target Probed-' num2str(numTrialsP) ' Trials'],'FontSize',18,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_TP_p1p21' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Averaging across runs
    figure;hold on;
    errorbar(100:30:460,MpbA,SpbA,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,MpoA,SpoA,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,MpnA,SpnA,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search - Target Not Probed'],'FontSize',18,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_TA_rawProbs1' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Plot p1 and p2 for each probe delay
    figure;hold on;

    errorbar(100:30:460,Mp1A,Sp1A,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    errorbar(100:30:460,Mp2A,Sp2A,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])

    title([condition ' Search-Target Not Probed (n = ' num2str(numObs) ')' saveFileName],'FontSize',18,'Fontname','Ariel')
    % title([condition ' Search-Target Not Probed - ' num2str(numTrialsA) ' Trials'],'FontSize',18,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_TA_p1p21' saveFileName]);
    print ('-djpeg', '-r500',namefig);
    
    %% Plot sampled data figures - target present
    figure;hold on;

    errorbar(100:30:460,Mp1PS,Sp1PS,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    errorbar(100:30:460,Mp2PS,Sp2PS,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])

    title([condition ' Search-Target Probed-' num2str(numTrialsPS) ' Trials/Delay' saveFileName],'FontSize',18,'Fontname','Ariel')
    
    %% Plot sampled data figures - target not present
    figure;hold on;

    errorbar(100:30:460,Mp1AS,Sp1AS,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    errorbar(100:30:460,Mp2AS,Sp2AS,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])

    title([condition ' Search-Target Not Probed-' num2str(numTrialsAS) ' Trials/Delay' saveFileName],'FontSize',18,'Fontname','Ariel')
end
end