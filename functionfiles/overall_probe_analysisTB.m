function overall_probe_analysisTB(task, printFg)
%% This function graphs the probe analysis for probes on the top and on the bottom
%% Example
%%% overall_probe_analysisTB('difficult',true);

%% Parameters
% task = 'difficult'
% printFg = true;

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
ANDp1TB=[];
ANDp2TB=[];

ORp1TB=[];
ORp2TB=[];

TOPp1=[];
TOPp2=[];

BOTTOMp1=[];
BOTTOMp2=[];

ANDp1LR=[];
ANDp2LR=[];

ORp1LR=[];
ORp2LR=[];

LEFTp1=[];
LEFTp2=[];

RIGHTp1=[];
RIGHTp2=[];

numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [p1ANDtb,p2ANDtb,p1ORtb,p2ORtb,p1TOP,p2TOP,p1BOTTOM,p2BOTTOM,p1ANDlr,p2ANDlr,p1ORlr,p2ORlr,p1LEFT,p2LEFT,p1RIGHT,p2RIGHT] = p_probe_analysisTB(obs,task,true); 
        
        if ~isempty(p1ANDtb) 
            ANDp1TB = horzcat(ANDp1TB,p1ANDtb);
            ANDp2TB = horzcat(ANDp2TB,p2ANDtb);
            ORp1TB = horzcat(ORp1TB,p1ORtb);
            ORp2TB = horzcat(ORp2TB,p2ORtb);       
            TOPp1 = horzcat(TOPp1,p1TOP);
            TOPp2 = horzcat(TOPp2,p2TOP);
            BOTTOMp1 = horzcat(BOTTOMp1,p1BOTTOM);
            BOTTOMp2 = horzcat(BOTTOMp2,p2BOTTOM);    
            
            ANDp1LR = horzcat(ANDp1LR,p1ANDlr);
            ANDp2LR = horzcat(ANDp2LR,p2ANDlr);
            ORp1LR = horzcat(ORp1LR,p1ORlr);
            ORp2LR = horzcat(ORp2LR,p2ORlr);       
            LEFTp1 = horzcat(LEFTp1,p1LEFT);
            LEFTp2 = horzcat(LEFTp2,p2LEFT);
            RIGHTp1 = horzcat(RIGHTp1,p1RIGHT);
            RIGHTp2 = horzcat(RIGHTp2,p2RIGHT);              
            numObs = numObs + 1; 
        end
    end
end
if printFg == true
    %% Graph TOP AND BOTTOM, TOP OR BOTTOM
    figure; hold on;
    for i = 1:2
        if i == 1
            t1 = ANDp1TB;
            t2 = ANDp2TB;
        elseif i == 2
            t1 = ORp1TB;
            t2 = ORp2TB;
        end    
        
        s_t1 = std(t1,[],2)./sqrt(numObs);
        s_t2 = std(t2,[],2)./sqrt(numObs);

        t1 = mean(t1,2);
        t2 = mean(t2,2);

        subplot(1,2,i)
        hold on;
        errorbar(100:30:460,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(100:30:460,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15]) 

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])

        if i == 1 
            title([condition ' - Top and Bottom'],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title([condition ' - Top or Bottom'],'FontSize',14,'Fontname','Ariel')
        end 

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_p1p2TB1']);
    print ('-djpeg', '-r500',namefig);
    
    %% Graph TOP and BOTTOM separately
    figure; hold on;
    for i = 1:2
        if i == 1
            t1 = TOPp1;
            t2 = TOPp2;
        elseif i == 2
            t1 = BOTTOMp1;
            t2 = BOTTOMp2;
        end    
        
        s_t1 = std(t1,[],2)./sqrt(numObs);
        s_t2 = std(t2,[],2)./sqrt(numObs);

        t1 = mean(mean(t1,2),3);
        t2 = mean(mean(t2,2),3);

        subplot(1,2,i)
        hold on;
        errorbar(100:30:460,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(100:30:460,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15]) 

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])

        if i == 1 
            title([condition ' - Top'],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title([condition ' - Bottom'],'FontSize',14,'Fontname','Ariel')
        end 

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_p1p2TB2']);
    print ('-djpeg', '-r500',namefig);    

    %% Graph LEFT AND RIGHT, LEFT OR RIGHT
    figure; hold on;
    for i = 1:2
        if i == 1
            t1 = ANDp1LR;
            t2 = ANDp2LR;
        elseif i == 2
            t1 = ORp1LR;
            t2 = ORp2LR;
        end    
        
        s_t1 = std(t1,[],2)./sqrt(numObs);
        s_t2 = std(t2,[],2)./sqrt(numObs);

        t1 = mean(t1,2);
        t2 = mean(t2,2);

        subplot(1,2,i)
        hold on;
        errorbar(100:30:460,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(100:30:460,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15]) 

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])

        if i == 1 
            title([condition ' - Left and Right'],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title([condition ' - Left or Right'],'FontSize',14,'Fontname','Ariel')
        end 

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_p1p2LR1']);
    print ('-djpeg', '-r500',namefig);
    
    %% Graph LEFT and RIGHT separately
    figure; hold on;
    for i = 1:2
        if i == 1
            t1 = LEFTp1;
            t2 = LEFTp2;
        elseif i == 2
            t1 = RIGHTp1;
            t2 = RIGHTp2;
        end    
        
        s_t1 = std(t1,[],2)./sqrt(numObs);
        s_t2 = std(t2,[],2)./sqrt(numObs);

        t1 = mean(mean(t1,2),3);
        t2 = mean(mean(t2,2),3);

        subplot(1,2,i)
        hold on;
        errorbar(100:30:460,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(100:30:460,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15]) 

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])

        if i == 1 
            title([condition ' - Left'],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title([condition ' - Right'],'FontSize',14,'Fontname','Ariel')
        end 

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_p1p2LR2']);
    print ('-djpeg', '-r500',namefig);       
    
end
end

