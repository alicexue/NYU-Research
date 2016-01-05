function [all_p1,all_p2] = overall_group_probe_delay(task,expN,present,delaysPerGroup,printFg,printStats,grouping,absDiff,cMin,cMax,observers)
%% This function graphs raw probabilities and p1 & p2 for overall, pairs, and hemifields across all observers
%% Example
%%% [all_p1,all_p2] = overall_group_probe_delay('difficult',2,2,2,true,false,1,true,0.1,0.3,{'ax','ld'});

%% Parameters
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2) 
% present = 1; (only valid for expN == 2; 1:target-present trials, 2:target-absent trials, 3:all trials)
% printFg = false; (if true, prints and saves the figures)
% printStats = false; (if true, conducts ANOVA on overall p1 p2 data
% observers is a cell of the observers' initials. if empty, then all
% observers' data are plotted

%% Outputs
% all_p1 and all_p2 are matrices for the p1 and p2 values for all observers
% (i.e. for 3 observers, a 13x3 matrix for p1 and p2)

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFileName = '';
    titleName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\' condition];
    if present == 1
        saveFileName = '_2TP';
        titleName = 'TP';
    elseif present == 2
        saveFileName = '_2TA';
        titleName = 'TA';
    elseif present == 3
        saveFileName = '_2';
        titleName = '';
    end
end

%% Obtain pboth, pone and pnone for each observer and concatenate over observer
pboth=[];
pone=[];
pnone=[];

pair_p1=[];
pair_p2=[];

SH_p1=[];
DH_p1=[];
di_p1=[];
si1_p1=[];
si2_p1=[];
diD_p1=[];

SH_p2=[];
DH_p2=[];
di_p2=[];
si1_p2=[];
si2_p2=[];
diD_p2=[];

all_p1=[];
all_p2=[];

P1_C2=[];
P2_C2=[];

numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.') && (ismember(obs,observers) || isempty(observers))
        [P1,P2,pb,po,pn,pbp,pnp,SH,DH,di,si1,si2,diD] = p_group_probe_delay(obs,task,expN,present,delaysPerGroup,false,grouping); 
        if ~isempty(P1)            
            all_p1 = horzcat(all_p1,P1);
            all_p2 = horzcat(all_p2,P2);

            pboth = horzcat(pboth,pb);
            pone = horzcat(pone,po);
            pnone = horzcat(pnone,pn); 

            [tmpP1,tmpP2] = quadratic_analysis(pbp,pnp);
            pair_p1 = horzcat(pair_p1,tmpP1);
            pair_p2 = horzcat(pair_p2,tmpP2);            

            [tmpP1,tmpP2] = quadratic_analysis(SH(:,1),SH(:,2));
            SH_p1 = horzcat(SH_p1,tmpP1);
            SH_p2 = horzcat(SH_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(DH(:,1),DH(:,2));
            DH_p1 = horzcat(DH_p1,tmpP1);
            DH_p2 = horzcat(DH_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(di(:,1),di(:,2));
            di_p1 = horzcat(di_p1,tmpP1);
            di_p2 = horzcat(di_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(si1(:,1),si1(:,2));
            si1_p1 = horzcat(si1_p1,tmpP1);
            si1_p2 = horzcat(si1_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(si2(:,1),si2(:,2));
            si2_p1 = horzcat(si2_p1,tmpP1);
            si2_p2 = horzcat(si2_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(diD(:,1),diD(:,2));
            diD_p1 = horzcat(diD_p1,tmpP1);
            diD_p2 = horzcat(diD_p2,tmpP2);            

            numObs = numObs + 1;
        end
    end
end

dpg = num2str(delaysPerGroup);

nGroups = 12/delaysPerGroup;
groupN = 1;
x_axis_labels=cell(nGroups,1);
for i = 1:nGroups
    x_axis_labels{i} = [num2str((groupN)*30 + 70) '-' num2str((groupN+delaysPerGroup-1)*30 + 70)];
    groupN = groupN + delaysPerGroup; 
end

plotIndex = 300/(nGroups-1);

Mpb = nanmean(pboth,2);
Mpo = nanmean(pone,2);
Mpn = nanmean(pnone,2);
Spb = nanstd(pboth,[],2)./sqrt(numObs);
Spo = nanstd(pone,[],2)./sqrt(numObs);
Spn = nanstd(pnone,[],2)./sqrt(numObs);

Sp1 = nanstd(all_p1,[],2)./sqrt(numObs);
Sp2 = nanstd(all_p2,[],2)./sqrt(numObs);

m_p1=nanmean(all_p1,2);
m_p2=nanmean(all_p2,2);

s_pair_p1=nanstd(pair_p1,[],2)/sqrt(numObs);
s_pair_p2=nanstd(pair_p2,[],2)/sqrt(numObs);

pair_p1=nanmean(pair_p1,2);
pair_p2=nanmean(pair_p2,2);

if printFg 
    %% Averaging across runs
    figure;hold on;
    errorbar(30:plotIndex:330,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(30:plotIndex:330,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(30:plotIndex:330,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])
    
    set(gca,'XTick',30:plotIndex:330,'XTickLabel',x_axis_labels,'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    xlim([0 350])
    
    title([condition ' Search (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_rawProbsG' saveFileName]);
    
    print ('-djpeg', '-r500',namefig);
    %% Plot p1 and p2 for each probe delay    
    figure;hold on;

    errorbar(30:plotIndex:330,m_p1,Sp1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    errorbar(30:plotIndex:330,m_p2,Sp2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',30:plotIndex:330,'XTickLabel',x_axis_labels,'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    xlim([0 350])
    
    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2G' saveFileName]);

    print ('-djpeg', '-r500',namefig);
    %% Establish x-axis labels 
    nGroups = 12/delaysPerGroup;
    if mod(delaysPerGroup,2) == 0
        tmpIndex = int16(nGroups/2)+1;
    else
        tmpIndex = int16((nGroups+1)/2);
    end
    index = 300/(nGroups-1)*(tmpIndex-1);     
    %% Plot p1 and p2 for each pair - square configuration
    figure;
    for numPair = 1:size(pair_p1,3)/2
        subplot(2,3,numPair)
        hold on;

        errorbar(30:plotIndex:330,pair_p1(:,:,numPair),s_pair_p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(30:plotIndex:330,pair_p2(:,:,numPair),s_pair_p2(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')
        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',10,'LineWidth',2','Fontname','Ariel')
        ylim([0 1.0])
        xlim([0 350])

        if numPair == 1 || numPair == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        title(['PAIR n' num2str(numPair)],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2PAIR1G' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Plot p1 and p2 for each pair - diamond configuration
    figure;
    for numPair = 1:size(pair_p1,3)/2
        subplot(2,3,numPair)
        hold on;

        errorbar(30:plotIndex:330,pair_p1(:,:,numPair+6),s_pair_p1(:,:,numPair+6),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(30:plotIndex:330,pair_p2(:,:,numPair+6),s_pair_p2(:,:,numPair+6),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')
        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',10,'LineWidth',2','Fontname','Ariel')
        ylim([0 1.0])
        xlim([0 350])

        if numPair == 1 || numPair == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        title(['PAIR n' num2str(numPair+6)],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2PAIR2G' saveFileName]);
    print ('-djpeg', '-r500',namefig);  

    %% Graph same/different hemifields and diagonals for square configuration
    figure; hold on;
    for i = 1:3
        if i == 1
            t1 = SH_p1;
            t2 = SH_p2;
        elseif i == 2
            t1 = DH_p1;
            t2 = DH_p2;
        elseif i == 3
            t1 = di_p1;
            t2 = di_p2;
        end    

        s_t1 = nanstd(t1,[],2)/sqrt(numObs);
        s_t2 = nanstd(t2,[],2)/sqrt(numObs);

        t1 = nanmean(t1,2);
        t2 = nanmean(t2,2);

        subplot(1,3,i)
        hold on;

        errorbar(30:plotIndex:330,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(30:plotIndex:330,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',10,'LineWidth',2','Fontname','Ariel')
        ylim([0 1.0])
        xlim([0 350])
        
        if i == 1           
            title('Same Hemifield','FontSize',14,'Fontname','Ariel')  
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
        elseif i == 2
            title('Different Hemifield','FontSize',14,'Fontname','Ariel')  
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 3
            title('Square Diagonals','FontSize',14,'Fontname','Ariel')
        end    
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2HemiDiagSG' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Graph same/different hemifields and diagonals for diamond configuration
    figure; hold on;
    for i = 1:3
        if i == 1
            t1 = si1_p1;
            t2 = si1_p2;
        elseif i == 2
            t1 = si2_p1;
            t2 = si2_p2;
        elseif i == 3
            t1 = diD_p1;
            t2 = diD_p2;
        end    

        s_t1 = nanstd(t1,[],2)/sqrt(numObs);
        s_t2 = nanstd(t2,[],2)/sqrt(numObs);

        t1 = nanmean(t1,2);
        t2 = nanmean(t2,2);

        subplot(1,3,i)
        hold on;

        errorbar(30:plotIndex:330,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(30:plotIndex:330,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',10,'LineWidth',2','Fontname','Ariel')
        ylim([0 1.0])
        xlim([0 350])
        
        if i == 1 || i == 2
            title(['Diamond Sides n' num2str(i)],'FontSize',14,'Fontname','Ariel')
        elseif i == 3
            title(['Diamond Diagonals n' num2str(i)],'FontSize',14,'Fontname','Ariel')
        end

        if i == 1
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
        elseif i == 2
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2HemiDiagDG' saveFileName]);
    print ('-djpeg', '-r500',namefig);
end

%% Conducts ANOVA on P1 and P2
if printStats
%     p1p2 = zeros(numObs*13*2,4);
%     index = 0;
%     for i = 1:numObs
%         p1p2(index+1:index+13,1) = all_p1(:,i);
%         p1p2(index+1:index+13,2) = rot90([13,12,11,10,9,8,7,6,5,4,3,2,1]);
%         p1p2(index+1:index+13,3) = rot90([1,1,1,1,1,1,1,1,1,1,1,1,1]);
%         p1p2(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
%         index = index + 13;
%         p1p2(index+1:index+13,1) = all_p2(:,i);
%         p1p2(index+1:index+13,2) = rot90([13,12,11,10,9,8,7,6,5,4,3,2,1]);
%         p1p2(index+1:index+13,3) = rot90([2,2,2,2,2,2,2,2,2,2,2,2,2]);
%         p1p2(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
%         index = index + 13;
%     end
%     RMAOV2(p1p2);    
end

%% Bar graphs for PBOTH, PNONE, and PONE. Note that the graph is not saved.
% figure;hold on;
% y = [];
% x = 1:numObs;
% for i = 1:numObs
%     y = [y;mean(pboth(:,i)),mean(pone(:,i)),mean(pnone(:,i))];
% end
% b = bar(x,y);
% set(gca,'YTick',0:.2:1,'FontSize',15,'LineWidth',2','Fontname','Ariel')
% ylabel('Percent correct','FontSize',15,'Fontname','Ariel')
% xlabel('Observer','FontSize',15,'Fontname','Ariel')
% title([condition ' Probe Performance' saveFileName],'FontSize',15,'Fontname','Ariel')
% ylim([0 1])
% set(gca,'XTick',1:1:numObs,'FontSize',15,'LineWidth',2','Fontname','Ariel')
% legend('PBoth','POne','PNone')

%% Plot colormap for all pairs across all delays
figure; hold on;
all_diff = pair_p1 - pair_p2;
d = [];
for i = 1:size(all_diff,3)
    d(i,:) = all_diff(:,:,i);
end
diff = flipud(d);
if absDiff
    diff = abs(diff);
end
imagesc(diff,[cMin cMax]);
colorbar
xlim([0.5 nGroups+0.5])
ylim([0.5 12.5])
set(gca,'YTick',1:1:12,'YTickLabel',{'12','11','10','9','8','7','6','5','4','3','2','1'})
set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
ylabel('Pair Number','FontSize',10,'Fontname','Ariel')
xlabel('Time from Search Array Onset [ms]','FontSize',10,'Fontname','Ariel')
title([condition ' P1 - P2 ' titleName],'FontSize',15,'Fontname','Ariel')
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_Overall' dpg saveFileName]);
print ('-djpeg', '-r500',namefig);

% %% Plot colormap of all pairs averaged across all delays
% % diff = mean(diff,2);
% % imagesc(diff,[cMin cMax]);
% % colorbar
% % ylim([0.5 12.5])
% % set(gca,'YTick',1:1:12,'YTickLabel',{'12','11','10','9','8','7','6','5','4','3','2','1'})
% % set(gca,'XTickLabel',{'','',''})
% % ylabel('Pair Number','FontSize',10,'Fontname','Ariel')
% % xlabel('Averaged Across Delays','FontSize',10,'Fontname','Ariel')
% % title([condition ' P1 - P2 ' titleName],'FontSize',15,'Fontname','Ariel')
% % namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_OverallAvg' dpg saveFileName]);
% % print ('-djpeg', '-r500',namefig);
% 
% %% Plot Performance Field groupings for all delays
% figure; hold on;
% group1 = mean(vertcat(d(8,:),d(9,:),d(10,:),d(11,:)),1);
% group2 = mean(vertcat(d(7,:),d(12,:)),1);
% group3 = mean(vertcat(d(1,:),d(2,:),d(3,:),d(4,:),d(5,:),d(6,:)),1);
% groups = vertcat(group1,group2,group3);
% if absDiff
%     groups = abs(groups);
% end
% imagesc(flipud(groups),[cMin cMax]);
% colorbar
% xlim([0.5 nGroups+0.5])
% ylim([0.5 3.5])
% set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
% set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
% title([condition ' P1 - P2 (Performance Field) ' titleName],'FontSize',15,'Fontname','Ariel')
% namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_PerfField' dpg saveFileName]);
% print ('-djpeg', '-r500',namefig);
% 
% %% Plot Performance Field groupings averaged across delays
% % figure; hold on;
% % groups = mean(groups,2);
% % imagesc(flipud(groups),[cMin cMax]);
% % colorbar
% % ylim([0.5 3.5])
% % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
% % set(gca,'XTickLabel',{'','',''})
% % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% % xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
% % title([condition ' P1 - P2 (Performance Field) ' titleName],'FontSize',15,'Fontname','Ariel')
% % namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_PerfFieldAvg' dpg saveFileName]);
% % print ('-djpeg', '-r500',namefig);
% 
% %% Plot Hemifield groupings across all delays
% figure; hold on;
% group1 = mean(vertcat(d(2,:),d(3,:),d(4,:),d(5,:),d(7,:)),1);
% group2 = mean(vertcat(d(8,:),d(9,:),d(10,:),d(11,:),d(12,:)),1);
% group3 = mean(vertcat(d(1,:),d(6,:)),1);
% groups = vertcat(group1,group2,group3);
% if absDiff
%     groups = abs(groups);
% end
% imagesc(flipud(groups),[cMin cMax]);
% colorbar
% xlim([0.5 nGroups+0.5])
% ylim([0.5 3.5])
% set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
% set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
% title([condition ' P1 - P2 (Hemifield) ' titleName],'FontSize',15,'Fontname','Ariel')
% namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_Hemifield' dpg saveFileName]);
% print ('-djpeg', '-r500',namefig);
% 
% %% Plot Hemifield groupings averaged across delays
% % figure; hold on;
% % groups = mean(groups,2);
% % imagesc(flipud(groups),[cMin cMax]);
% % colorbar
% % ylim([0.5 3.5])
% % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
% % set(gca,'XTickLabel',{'','',''})
% % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% % xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
% % title([condition ' P1 - P2 (Hemifield) ' titleName],'FontSize',15,'Fontname','Ariel')
% % namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_HemifieldAvg' dpg saveFileName]);
% % print ('-djpeg', '-r500',namefig);
% % 
% % 
% % %% Plot colormap for Distance groupings across all delays
% % figure; hold on;
% % group1 = mean(vertcat(d(2,:),d(5,:),d(7,:),d(12,:)),1);
% % group2 = mean(vertcat(d(1,:),d(3,:),d(4,:),d(6,:)),1);
% % group3 = mean(vertcat(d(8,:),d(9,:),d(10,:),d(11,:)),1);
% % groups = vertcat(group1,group2,group3);
% % if absDiff
% %     groups = abs(groups);
% % end
% % imagesc(flipud(groups),[cMin cMax]);
% % colorbar
% % xlim([0.5 nGroups+0.5])
% % ylim([0.5 3.5])
% % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
% % set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% % xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
% % title([condition ' P1 - P2 (Distance) ' titleName],'FontSize',15,'Fontname','Ariel')
% % namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_Distance' dpg saveFileName]);
% % print ('-djpeg', '-r500',namefig);
% % 
% % %% Plot colormap for Distance groupings averaged across all delays
% % % figure; hold on;
% % % groups = mean(groups,2);
% % % imagesc(flipud(groups),[cMin cMax]);
% % % colorbar
% % % ylim([0.5 3.5])
% % % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
% % % set(gca,'XTickLabel',{'','',''})
% % % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% % % xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
% % % title([condition ' P1 - P2 (Distance) ' titleName],'FontSize',15,'Fontname','Ariel')
% % % namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_DistanceAvg' dpg saveFileName]);
% % % print ('-djpeg', '-r500',namefig);
% 
% %% Plot colormap for Configuration groupings for each delay
% figure; hold on;
% group1 = mean(vertcat(d(1,:),d(2,:),d(3,:),d(4,:),d(5,:),d(6,:)),1);
% group2 = mean(vertcat(d(7,:),d(8,:),d(9,:),d(10,:),d(11,:),d(12,:)),1);
% groups = vertcat(group1,group2);
% if absDiff
%     groups = abs(groups);
% end
% imagesc(flipud(groups),[cMin cMax]);
% colorbar
% xlim([0.5 nGroups+0.5])
% ylim([0.5 2.5])
% set(gca,'YTick',1:1:3,'YTickLabel',{'Diamond','Square'})
% set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
% title([condition ' P1 - P2 (Configuration) ' titleName],'FontSize',15,'Fontname','Ariel')
% namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_Config' dpg saveFileName]);
% print ('-djpeg', '-r500',namefig);
% 
% %% Plot colormap for Configuration groups averaged across delays
% % figure; hold on;
% % groups = mean(groups,2);
% % imagesc(flipud(groups),[cMin cMax]);
% % colorbar
% % ylim([0.5 2.5])
% % set(gca,'YTick',1:1:3,'YTickLabel',{'Diamond','Square'})
% % set(gca,'XTickLabel',{'','',''})
% % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% % xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
% % title([condition ' P1 - P2 (Configuration) ' titleName],'FontSize',15,'Fontname','Ariel')
% % namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_ConfigAvg' dpg saveFileName]);
% % print ('-djpeg', '-r500',namefig);
% 
% %% Plot colormap for Configuration groupings for each delay
% figure; hold on;
% group1 = mean(vertcat(d(1,:),d(6,:)),1);
% group2 = mean(vertcat(d(3,:),d(4,:)),1);
% group3 = mean(vertcat(d(2,:),d(5,:)),1);
% group4 = mean(vertcat(d(8,:),d(10,:)),1);
% group5 = mean(vertcat(d(9,:),d(11,:)),1);
% group6 = mean(vertcat(d(7,:),d(12,:)),1);
% groups = vertcat(group1,group2,group3,group4,group5,group6);
% if absDiff
%     groups = abs(groups);
% end
% imagesc(flipud(groups),[cMin cMax]);
% colorbar
% xlim([0.5 nGroups+0.5])
% ylim([0.5 6.5])
% set(gca,'YTick',1:1:6,'YTickLabel',{'6','5','4','3','2','1'})
% set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
% title([condition ' P1 - P2 (Configuration) ' titleName],'FontSize',15,'Fontname','Ariel')
% namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_Config' dpg saveFileName]);
% print ('-djpeg', '-r500',namefig);
% 
% %% Plot colormap for Configuration groups averaged across delays
% % figure; hold on;
% % groups = mean(groups,2);
% % imagesc(flipud(groups),[cMin cMax]);
% % colorbar
% % ylim([0.5 6.5])
% % set(gca,'YTick',1:1:6,'YTickLabel',{'6','5','4','3','2','1'})
% % set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% % xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
% % title([condition ' P1 - P2 (Configuration) ' titleName],'FontSize',15,'Fontname','Ariel')
% % namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_ConfigAvg' dpg saveFileName]);
% % print ('-djpeg', '-r500',namefig);

% %% Plot colormap for square configuration for each delay
% figure; hold on;
% group1 = mean(vertcat(d(1,:),d(6,:)),1);
% group2 = mean(vertcat(d(3,:),d(4,:)),1);
% group3 = mean(vertcat(d(2,:),d(5,:)),1);
% groups = vertcat(group1,group2,group3);
% if absDiff
%     groups = abs(groups);
% end
% imagesc(flipud(groups),[cMin cMax]);
% colorbar
% xlim([0.5 nGroups+0.5])
% ylim([0.5 3.5])
% set(gca,'YTick',1:1:3,'YTickLabel',{'2 and 5','3 and 4','1 and 6'})
% set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% ylabel('Pairs','FontSize',12,'Fontname','Ariel')
% xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
% title([condition ' P1 - P2 (Square) ' titleName],'FontSize',15,'Fontname','Ariel')
% namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_Square' dpg saveFileName]);
% print ('-djpeg', '-r500',namefig);

%% Plot colormap for square configuration averaged across delays
% figure; hold on;
% groups = mean(groups,2);
% imagesc(flipud(groups),[cMin cMax]);
% colorbar
% ylim([0.5 3.5])
% set(gca,'YTick',1:1:3,'YTickLabel',{'2 and 5','3 and 4','1 and 6'})
% set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% ylabel('Grouping','FontSize',12,'Fontname','Ariel')
% xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
% title([condition ' P1 - P2 (Square) ' titleName],'FontSize',15,'Fontname','Ariel')
% namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_SquareAvg' dpg saveFileName]);
% print ('-djpeg', '-r500',namefig);

%% Plot colormap for diamond configuration for each delay
figure; hold on;
group1 = mean(d(7,:),1);
group2 = mean(d(12,:),1);
groups = vertcat(group1,group2);
if absDiff
    groups = abs(groups);
end
imagesc(flipud(groups),[cMin cMax]);
colorbar
xlim([0.5 nGroups+0.5])
ylim([0.5 2.5])
set(gca,'YTick',1:1:2,'YTickLabel',{'12','7'})
set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
ylabel('Pairs','FontSize',12,'Fontname','Ariel')
xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
title([condition ' P1 - P2 (Diamond) ' titleName],'FontSize',15,'Fontname','Ariel')
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_Diamond' dpg saveFileName]);
print ('-djpeg', '-r500',namefig);

%% Plot colormap for diamond configuration averaged across delays
% figure; hold on;
% groups = mean(groups,2);
% imagesc(flipud(groups),[cMin cMax]);
% colorbar
% ylim([0.5 2.5])
% set(gca,'YTick',1:1:2,'YTickLabel',{'12','7'})
% set(gca,'XTick',1:1:13,'XTickLabel',x_axis_labels)
% ylabel('Pairs','FontSize',12,'Fontname','Ariel')
% xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
% title([condition ' P1 - P2 (Diamond) ' titleName],'FontSize',15,'Fontname','Ariel')
% namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc '_DiamondAvg' dpg saveFileName]);
% print ('-djpeg', '-r500',namefig);

end

