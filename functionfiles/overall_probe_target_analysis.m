function [Mp1P,Mp2P,Mp1A,Mp2A] = overall_probe_target_analysis(task)
%% This function gets p1 and p2 from all observers and averages them
%% Example
%%% overall_probe_target_analysis('difficult');

%% Parameters
% task = 'difficult'
% printFg = false;

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
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

numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [pbothP,poneP,pnoneP,pbothA,poneA,pnoneA,P1P,P2P,P1A,P2A] = p_probe_target_analysis(obs,task,false); 

        if ~isempty(pbothP) 
            pbP=horzcat(pbP,pbothP);
            pnP=horzcat(pnP,pnoneP);
            poP=horzcat(poP,poneP);
            
            pbA=horzcat(pbA,pbothA);
            pnA=horzcat(pnA,pnoneA);
            poA=horzcat(poA,poneA);

            p1P=horzcat(p1P,P1P);
            p2P=horzcat(p2P,P2P);
            p1A=horzcat(p1A,P1A);
            p2A=horzcat(p2A,P2A);
            numObs = numObs + 1;
        end
    end
end

Sp1P=std(p1P,[],2)/sqrt(numObs);
Sp2P=std(p2P,[],2)/sqrt(numObs);

Sp1A=std(p1A,[],2)/sqrt(numObs);
Sp2A=std(p2A,[],2)/sqrt(numObs);

Mp1P1=mean(p1P,2);
Mp2P1=mean(p2P,2);
Mp1A1=mean(p1A,2);
Mp2A1=mean(p2A,2);

%% Averaging across runs
MpbP = mean(pbP,2);
MpoP = mean(poP,2);
MpnP = mean(pnP,2);
SpbP = std(pbP,[],2)./sqrt(numObs);
SpoP = std(poP,[],2)./sqrt(numObs);
SpnP = std(pnP,[],2)./sqrt(numObs);

figure;hold on;
errorbar(100:30:460,MpbP,SpbP,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
errorbar(100:30:460,MpoP,SpoP,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
errorbar(100:30:460,MpnP,SpnP,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

legend('PBoth','POne','PNone')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([0 1])

title([condition ' Search - Target Probed'],'FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_TP_rawProbs']);
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

title([condition ' Search - Target Probed'],'FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_TP_p1p2']);
print ('-djpeg', '-r500',namefig);

%% Averaging across runs
MpbA = mean(pbA,2);
MpoA = mean(poA,2);
MpnA = mean(pnA,2);
SpbA = std(pbA,[],2)./sqrt(numObs);
SpoA = std(poA,[],2)./sqrt(numObs);
SpnA = std(pnA,[],2)./sqrt(numObs);

figure;hold on;
errorbar(100:30:460,MpbA,SpbA,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
errorbar(100:30:460,MpoA,SpoA,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
errorbar(100:30:460,MpnA,SpnA,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

legend('PBoth','POne','PNone')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([0 1])

title([condition ' Search - Target Not Probed'],'FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_TA_rawProbs']);
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

title([condition ' Search - Target Not Probed'],'FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_TA_p1p2']);
print ('-djpeg', '-r500',namefig);

end