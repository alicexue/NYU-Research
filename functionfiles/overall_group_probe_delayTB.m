function overall_group_probe_delayTB(task,expN,present,delaysPerGroup,printFg,observers)
%% This function graphs the probe analysis for probes presented on the top, bottom, left, and right
%% Example
%%% overall_group_probe_delayTB('difficult',2,1,2,true,{'ax','ld'});

%% Parameters
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% delaysPerGroup must be a factor of 12
% printFg = true; (if true, prints and saves figures)
% observers is a cell of the initials of all observers (if empty, all 

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFileName = '';
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
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.') && (ismember(obs,observers) || isempty(observers))
        [p1ANDtb,p2ANDtb,p1ORtb,p2ORtb,p1TOP,p2TOP,p1BOTTOM,p2BOTTOM,p1ANDlr,p2ANDlr,p1ORlr,p2ORlr,p1LEFT,p2LEFT,p1RIGHT,p2RIGHT] = p_group_probe_delayTB(obs,task,expN,present,delaysPerGroup,false); 
        
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

nGroups = 12/delaysPerGroup;
groupN = 1;
x_axis_labels=cell(nGroups,1);
for i = 1:nGroups
    x_axis_labels{i} = [num2str((groupN)*30 + 70) '-' num2str((groupN+delaysPerGroup-1)*30 + 70)];
    groupN = groupN + delaysPerGroup; 
end

plotIndex = 300/(nGroups-1);

if printFg == true
    %% Establish x-axis labels 
    nGroups = 12/delaysPerGroup;
    if mod(delaysPerGroup,2) == 0
        tmpIndex = int16(nGroups/2)+1;
    else
        tmpIndex = int16((nGroups+1)/2);
    end
    index = 300/(nGroups-1)*(tmpIndex-1);     
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
        
        s_t1 = nanstd(t1,[],2)./sqrt(numObs);
        s_t2 = nanstd(t2,[],2)./sqrt(numObs);

        t1 = nanmean(t1,2);
        t2 = nanmean(t2,2);

        subplot(1,2,i)
        hold on;
        errorbar(30:plotIndex:330,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(30:plotIndex:330,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15]) 

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 350])

        if i == 1 
            title([condition ' - Top and Bottom' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Top or Bottom (n = ' num2str(numObs) ')' saveFileName],'FontSize',14,'Fontname','Ariel')
        end 

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2TB1G' saveFileName]);
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
        
        s_t1 = nanstd(t1,[],2)./sqrt(numObs);
        s_t2 = nanstd(t2,[],2)./sqrt(numObs);

        t1 = nanmean(nanmean(t1,2),3);
        t2 = nanmean(nanmean(t2,2),3);

        subplot(1,2,i)
        hold on;
        errorbar(30:plotIndex:330,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(30:plotIndex:330,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15]) 

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 350])

        if i == 1 
            title([condition ' - Top' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Bottom (n = ' num2str(numObs) ')' saveFileName],'FontSize',14,'Fontname','Ariel')
        end 

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2TB2G' saveFileName]);
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
        
        s_t1 = nanstd(t1,[],2)./sqrt(numObs);
        s_t2 = nanstd(t2,[],2)./sqrt(numObs);

        t1 = nanmean(t1,2);
        t2 = nanmean(t2,2);

        subplot(1,2,i)
        hold on;
        errorbar(30:plotIndex:330,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(30:plotIndex:330,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15]) 

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 350])

        if i == 1 
            title([condition ' - Left and Right' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Left or Right (n = ' num2str(numObs) ')' saveFileName],'FontSize',14,'Fontname','Ariel')
        end 

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2LR1G' saveFileName]);
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
        
        s_t1 = nanstd(t1,[],2)./sqrt(numObs);
        s_t2 = nanstd(t2,[],2)./sqrt(numObs);

        t1 = nanmean(nanmean(t1,2),3);
        t2 = nanmean(nanmean(t2,2),3);

        subplot(1,2,i)
        hold on;
        errorbar(30:plotIndex:330,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(30:plotIndex:330,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15]) 

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 350])

        if i == 1 
            title([condition ' - Left' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Right (n = ' num2str(numObs) ')' saveFileName],'FontSize',14,'Fontname','Ariel')
        end 

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2LR2G' saveFileName]);
    print ('-djpeg', '-r500',namefig);       
    
end
end

