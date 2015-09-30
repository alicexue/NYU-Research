function [pbothPD,ponePD,pnonePD,pbothAD,poneAD,pnoneAD,p1P,p2P,p1A,p2A] = p_probe_target_analysis(obs, task, printFg)
%% Example
%%% p_probe_target_analysis('ax','difficult',false);

%% Parameters
% obs = 'ax';
% task = 'difficult'
% multipleObs = true;

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
pbothP=[];
poneP=[];
pnoneP=[];

pbothA=[];
poneA=[];
pnoneA=[];

pbothPD=[];
ponePD=[];
pnonePD=[];
pbothAD=[];
poneAD=[];
pnoneAD=[];
pbothPDP=[];
pnonePDP=[];
pbothADP=[];
pnoneADP=[];

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task]);  
for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [pbPD,poPD,pnPD,pbAD,poAD,pnAD,pbPDP,pnPDP,pbADP,pnADP] = probe_target_analysis(obs,task,filename);
        
        pbothPD=horzcat(pbothPD,pbPD);
        ponePD=horzcat(ponePD,poPD);
        pnonePD=horzcat(pnonePD,pnPD);
        
        pbothAD=horzcat(pbothAD,pbAD);
        poneAD=horzcat(poneAD,poAD);
        pnoneAD=horzcat(pnoneAD,pnAD);
        
        pbothPDP=horzcat(pbothPDP,pbPDP);
        pnonePDP=horzcat(pnonePDP,pnPDP);
        pbothADP=horzcat(pbothADP,pbADP);
        pnoneADP=horzcat(pnoneADP,pnADP);        
    end
end

%% Averaging across runs 
MpbPD = mean(pbothPD,2);
MpoPD = mean(ponePD,2);
MpnPD = mean(pnonePD,2); 

MpbAD = mean(pbothAD,2);
MpoAD = mean(poneAD,2);
MpnAD = mean(pnoneAD,2);

SpbPD = std(pbothPD,[],2)/sqrt(size(pbothPD,2));
SpoPD = std(ponePD,[],2)/sqrt(size(ponePD,2));
SpnPD = std(pnonePD,[],2)/sqrt(size(pnonePD,2)); 

SpbAD = std(pbothAD,[],2)/sqrt(size(pbothAD,2));
SpoAD = std(poneAD,[],2)/sqrt(size(poneAD,2));
SpnAD = std(pnoneAD,[],2)/sqrt(size(pnoneAD,2));

MpbPD=mean(pbothPD,2);
MpoPD=mean(ponePD,2);
MpnPD=mean(pnonePD,2);
MpbAD=mean(pbothAD,2);
MpoAD=mean(poneAD,2);
MpnAD=mean(pnoneAD,2);
MpbPDP=mean(pbothPDP,2);
MpnPDP=mean(pnonePDP,2);
MpbADP=mean(pbothADP,2);
MpnADP=mean(pnoneADP,2);  

%% Transform pboth and pnone into p1 and p2
[p1P,p2P] = quadratic_analysis(MpbPD,MpnPD);
[p1A,p2A] = quadratic_analysis(MpbAD,MpnAD);

if printFg == true 
    %% Graph p1 p2 when target location is probed
    figure;hold on;
    errorbar(100:30:460,MpbPD,SpbPD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,MpoPD,SpoPD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,MpnPD,SpnPD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])
    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',18,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search - Target Probed (' obs ')'],'FontSize',18,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_TP' '_rawProbs']);
    print ('-djpeg', '-r500',namefig);
    %% Plot p1 and p2 for each probe delay

    figure;hold on;
    plot(100:30:460,p1P,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
    plot(100:30:460,p2P,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])
    
    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    
    ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',18,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])

    title([condition ' Search - Target Probed (' obs ')'],'FontSize',18,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_TP_p1p2']);
    print ('-djpeg', '-r500',namefig); 
    %% Graph p1 p2 when target location is not probed
    figure;hold on;
    errorbar(100:30:460,MpbAD,SpbAD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,MpoAD,SpoAD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,MpnAD,SpnAD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])
    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',18,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search - Target Not Probed (' obs ')'],'FontSize',18,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_TA' '_rawProbs']);
    print ('-djpeg', '-r500',namefig);
    
    %% Plot p1 and p2 for each probe delay
    figure;hold on;
    plot(100:30:460,p1A,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
    plot(100:30:460,p2A,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])
    
    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    
    ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',18,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])

    title([condition ' Search - Target Not Probed (' obs ')'],'FontSize',18,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_TA_p1p2']);
    print ('-djpeg', '-r500',namefig);     

end

