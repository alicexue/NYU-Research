function [sqClick1,sqClick2] = overall_probe_performance(expN,trialType,task,grouping,printFg)
%% This function averages the general performance on the probe task across observers
%% Example
%%% overall_probe_performance(2,2,'difficult',1,true);

%% Parameters
% expN = 1; (1 or 2) 3: control (for control, plot performance of choice 1
% and choice 2)
% trialType = 1; (only relevant for exp 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials, 4:target-present trials-analyze 
% perf at target and nontarget locations when target is probed, 5:target-present trials where 
% observer discriminates target correctly, 6:target-present trials where 
% observer detects target correctly, 7:target-present trials-analyze perf 
% at non-target locations when the target is not probed, 8: target-present 
% trials - analyze perf at target and non-target locations regardless of whether target is probed or not, 
% 9: same as 8 but when observer detects target correctly)
% task = 'difficult'; ('easy' or 'difficult')
% grouping = 1; (if 1, probes must be exactly correct; if 2, probes must
% match by shape; if 3, probes must match by aperture)

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

TPclr = [0 128 42]/255;
TAclr = [153 0 77]/255;

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFileName = '1';
    titleName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\' condition];
    if trialType == 1 || trialType == 4
        saveFileName = '_2TP';
        titleName = 'TP';
    elseif trialType == 2
        saveFileName = '_2TA';
        titleName = 'TA';
    elseif trialType == 3
        saveFileName = '_2';
        titleName = '';
    elseif trialType == 5
        saveFileName = '_2Discri';
        titleName = 'TP Discri';
    elseif trialType == 6
        saveFileName = '_2Detect';
        titleName = 'TP Detect';
    elseif trialType == 7
        saveFileName = '_NotProbed';
        titleName = 'Target Not Probed';
    elseif trialType == 8
        saveFileName = '_CompareProbeTargetLoc';
        titleName = 'Compare Probe and Target Location';
    elseif trialType == 9
        saveFileName = '_CompareProbeTargetLocDetect';
        titleName = 'Compare Probe and Target Location, Detect Correctly';
    end
elseif expN == 3
    saveFileLoc = '\control exp\';
    saveFileName = '';
    titleName = '';
end

if grouping == 2 || grouping == 3
    saveFileName = [saveFileName '_' num2str(grouping)];
end

if grouping == 1
    groupTypeName = '';
    ymin = 0;
elseif grouping == 2
    groupTypeName = 'Shape ';
    ymin = 20;
elseif grouping == 3
    groupTypeName = 'Aperture ';
    ymin = 20;
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
perfDelays=[];
perfTP=[];
perfTA=[];
perfTP_Pair=[];
perfTA_Pair=[];
perfClicks=[];
perfClicks1P=[];
perfClicks2P=[];
numObs = 0;

dir_name = setup_dir();
files = dir(strrep(dir_name,'\',filesep));  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2) && ~strcmp(obs(1,1),'.')
        [perf,pTP,pTA,pTP_Pair,pTA_Pair,pClicks,pClicksP] = p_probe_performance(obs,task,expN,trialType,false,grouping);
        if ~isnan(perf) 
            perfDelays = horzcat(perfDelays,perf);
            perfTP = horzcat(perfTP,pTP);
            perfTA = horzcat(perfTA,pTA);
            perfTP_Pair = horzcat(perfTP_Pair,pTP_Pair);
            perfTA_Pair = horzcat(perfTA_Pair,pTA_Pair);
            perfClicks = horzcat(perfClicks,pClicks);
            perfClicks1P = horzcat(perfClicks1P,pClicksP(:,1,:));
            perfClicks2P = horzcat(perfClicks2P,pClicksP(:,2,:));
            numObs = numObs + 1;
        end
    end
end

if trialType~=4 && trialType~=5 && trialType~=6 && trialType~=7 && trialType~=8
    MpD = nanmean(perfDelays,2);
    SpD = std(perfDelays,[],2)./sqrt(numObs);

    MpTP = nanmean(perfTP,2);
    SpTP = std(perfTP,[],2)./sqrt(numObs);
    MpTA = nanmean(perfTA,2);
    SpTA = std(perfTA,[],2)./sqrt(numObs);

    if expN ~= 3
        MpTPsq = nanmean(perfTP_Pair(:,:,1:6),3);
        SpTPsq = std(MpTPsq,[],2)./sqrt(numObs);
        MpTAsq = nanmean(perfTA_Pair(:,:,1:6),3);
        SpTAsq = std(MpTAsq,[],2)./sqrt(numObs);    
        MpTPsq = nanmean(MpTPsq,2);
        MpTAsq = nanmean(MpTAsq,2);
    end
    
    MperfClicks = nanmean(perfClicks,2);
    MpClick1 = MperfClicks(:,:,1);
    MpClick2 = MperfClicks(:,:,2);
    SpClick1 = std(perfClicks(:,:,1),[],2)./sqrt(numObs);
    SpClick2 = std(perfClicks(:,:,2),[],2)./sqrt(numObs);

    sqClick1 = nanmean(perfClicks1P(:,:,1:6),3);
    sqClick2 = nanmean(perfClicks2P(:,:,1:6),3);

    SsqClick1 = std(sqClick1,[],2)./sqrt(numObs);
    SsqClick2 = std(sqClick2,[],2)./sqrt(numObs);

    MsqClick1 = nanmean(sqClick1,2);
    MsqClick2 = nanmean(sqClick2,2);
end

if printFg && expN~=3 && trialType ~= 4 && trialType ~= 5 && trialType ~= 6 && trialType ~= 7 && trialType ~=8 && trialType ~= 9
    %% Plot average across observers
    figure; hold on;
    avgPerf = NaN(1,numObs);
    for i=1:numObs  
        plot(100:30:460,perfDelays(:,i),'-o','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',6)
        avgPerf(1,i) = nanmean(perfDelays(:,i));    
    end
    errorbar(100:30:460,MpD,SpD,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    for i=1:numObs
        ColOrd = get(gca,'ColorOrder');    

        [m,n] = size(ColOrd);
        ColRow = rem(i,m);
        if ColRow == 0
          ColRow = m;
        end
        % Get the color
        Col = ColOrd(ColRow,:);    

        line([0 500],[avgPerf(1,i) avgPerf(1,i)],'Color',Col)

    end

    % legend_obs = cell(numObs,1);
    % for i=1:numObs
    %     legend_obs{i} = ['obs ' num2str(i)];
    % end
    % legend_obs{numObs+1} = 'average';
    % legend(legend_obs,'Location','SouthWest')

    ylim([ymin 1])
    xlim([0 500])

    set(gca,'YTick', ymin:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Probe Performance'],'FontSize',18)

    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    if grouping == 1
        chance = 1/12;
    elseif grouping == 2
        chance = 33.3;
    elseif grouping == 3
        chance = 25;
    end 

    plot([0 500],[chance chance],'Color',[0 0 0],'LineStyle','--')

    namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerf' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    % Check for outliers
    %    avgAcrossDelays = nanmean(MpD);
    %    z_score = std(mean(perfDelays,1));
    %    avgAcrossDelays + 2*z_score
    %    avgAcrossDelays - 2*z_score
    %    nanmean(perfDelays,1)

    %%% Plot average across observers - target loc probed
    %figure; hold on;
    %for i=1:numObs
    %    plot(100:30:460,perfTP(:,i),'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8)
    %end
    %errorbar(100:30:460,MpTP,SpTP,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    % 
    %legend_obs = cell(numObs,1);
    %for i=1:numObs
    %    legend_obs{i} = ['obs ' num2str(i)];
    %end
    %legend_obs{numObs+1} = 'average';
    %legend(legend_obs,'Location','NorthWest')
    %
    %ylim([0 1])
    %xlim([0 500])
    %set(gca,'YTick', 0:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    % 
    %title([condition ' Perf-target loc probed'],'FontSize',18)
    %xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    %ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
    %
    %plot([0 500],[1/12 1/12],'Color',[0 0 0],'LineStyle','--')
    % 
    %namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfTP' saveFileName],'\',filesep));
    %print ('-dpdf', '-r500',namefig);
    
    %%% Plot average across observers - target loc not probed
    %figure; hold on;
    %for i=1:numObs
    %    plot(100:30:460,perfTA(:,i),'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8)
    %end   
    %errorbar(100:30:460,MpTA,SpTA,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    %
    %legend_obs = cell(numObs,1);
    %for i=1:numObs
    %    legend_obs{i} = ['obs ' num2str(i)];
    %end
    %legend_obs{numObs+1} = 'average';
    %legend(legend_obs,'Location','NorthWest')
    %
    %ylim([0 1])
    %xlim([0 500])
    %set(gca,'YTick', 0:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %
    %title([condition ' Perf-target loc not probed'],'FontSize',18)
    %xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    %ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
    %
    %plot([0 500],[1/12 1/12],'Color',[0 0 0],'LineStyle','--')
    %
    %namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfTA' saveFileName],'\',filesep));
    %print ('-dpdf', '-r500',namefig);

    %%% Plot probe performance for target loc probed and target loc not probed
    %figure; hold on;
    %errorbar(100:30:460,MpTP,SpTP,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TPclr)
    %errorbar(100:30:460,MpTA,SpTA,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TAclr)
    %
    %legend('Probe at Target Location','Probe at Non-Target Location')
    %
    %ylim([0 1])
    %xlim([0 500])
    %set(gca,'YTick', 0:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %
    %title([condition ' Performance'],'FontSize',18)
    %xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    %ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
    %
    %plot([0 500],[1/12 1/12],'Color',[0 0 0],'LineStyle','--')
    % 
    %namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfTargetAnalysis' saveFileName],'\',filesep));
    %print ('-dpdf', '-r500',namefig);
    
    %%% Plot difference in probe performance for target loc probed and target loc not probed
    %diff_sem = std(perfTP - perfTA,[],2)./sqrt(numObs);    
    %figure; hold on;
    %errorbar(100:30:460,MpTP-MpTA,diff_sem,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    %
    %[sig] = diff_ttest(cat(3,perfTP,perfTA),false);
    %for i=1:size(sig,1)
    %    for j=1:size(sig,3)
    %        y = -0.10;
    %        if sig(i,1,j) <= 0.05/13
    %            plot((i-1)*30+100,y,'*','Color',[0 0 0])
    %        elseif sig(i,1,j) <= 0.05
    %            plot((i-1)*30+100,y,'+','Color',[0 0 0])
    %        end
    %    end
    %end
    %
    %ylim([-.2 .2])
    %xlim([0 500])
    %set(gca,'YTick', -.2:.1:.2,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %
    %title([condition ' Performance'],'FontSize',18)
    %xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    %ylabel('Performance Difference','FontSize',15,'Fontname','Ariel')  
    %
    %plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
    %
    %namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfDiffTargetAnalysis' saveFileName],'\',filesep));
    %print ('-dpdf', '-r500',namefig);
    
    %mPerf = nanmean(perfDelays,1)    

    %% SQUARE
    %%%% Square - Plot probe performance for target loc probed and target loc not probed
    %figure; hold on;
    %errorbar(100:30:460,MpTPsq,SpTPsq,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TPclr)
    %errorbar(100:30:460,MpTAsq,SpTAsq,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TAclr)
    %
    %legend('Probe at Target Location','Probe at Non-Target Location')
    % 
    %ylim([0 1])
    %xlim([0 500])
    %set(gca,'YTick', 0:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    % 
    %title([condition ' Performance'],'FontSize',18)
    %xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    %ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
    %
    %plot([0 500],[1/12 1/12],'Color',[0 0 0],'LineStyle','--')
    %
    %namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfTargetAnalysis_SQ' saveFileName],'\',filesep));
    %print ('-dpdf', '-r500',namefig);  
    
    
    %%%% Square - Plot difference in probe performance for target loc probed and target loc not probed
    %diff_sem = std(nanmean(perfTP_Pair(:,:,1:6),3) - nanmean(perfTA_Pair(:,:,1:6),3),[],2)./sqrt(numObs);    
    %figure; hold on;
    %errorbar(100:30:460,MpTPsq-MpTAsq,diff_sem,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    % 
    %[sig] = diff_ttest(cat(3,nanmean(perfTP_Pair(:,:,1:6),3),nanmean(perfTA_Pair(:,:,1:6),3)),false);
    %for i=1:size(sig,1)
    %    for j=1:size(sig,3)
    %        y = -0.18;
    %        if sig(i,1,j) <= 0.05/13
    %            plot((i-1)*30+100,y,'*','Color',[0 0 0])
    %        elseif sig(i,1,j) <= 0.05
    %            plot((i-1)*30+100,y,'+','Color',[0 0 0])
    %        end
    %    end
    %end
    %
    %ylim([-.2 .2])
    %xlim([0 500])
    %set(gca,'YTick', -.2:.1:.2,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    %
    %title([condition ' Performance'],'FontSize',18)
    %xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    %ylabel('Performance Difference','FontSize',15,'Fontname','Ariel')  
    %
    %plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
    %
    %namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfDiffTargetAnalysis_SQ' saveFileName],'\',filesep));
    %print ('-dpdf', '-r500',namefig);
    
    
    % if grouping == 2 || grouping == 3
    %     mPerf = nanmean(perfDelays,2);
    %     q = rot90(mPerf);
    %     imagesc(q)
    % end    

    %% Plot C1 and C2
    figure;hold on;
    errorbar(100:30:460,MpClick1,SpClick1,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color','r')
    errorbar(100:30:460,MpClick2,SpClick2,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color','b')
    legend('click 1','click 2')
    ylim([ymin 1])
    xlim([0 500])

    set(gca,'YTick', ymin:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Probe Performance'],'FontSize',18)

    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
    namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfClick' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    %% Plot C1 and C2 for square
    figure;hold on;
    errorbar(100:30:460,MsqClick1,SsqClick1,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color','r')
    errorbar(100:30:460,MsqClick2,SsqClick2,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color','b')
    legend('click 1','click 2')
    ylim([ymin 1])
    xlim([0 500])

    set(gca,'YTick', ymin:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Probe Performance on Square'],'FontSize',18)

    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    figure;hold on;
    for i = 1:size(sqClick1,2)
        plot(100:30:460,sqClick1(:,i)-sqClick2(:,i))
    end

    xlim([0 500])
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')

    title([condition ' Probe Performance on Square'],'FontSize',18)

    namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfClick_SQ' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);
end

if printFg && expN==3     
    figure;
    hold on
    bar(1,MpD(1),.5,'FaceColor',[0 0 0])
    errorbar(1,MpD(1),SpD(1),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',0:1:2,'XTickLabel',{'','observers',''},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([0 2])
    ylim([0 1])
    ylabel('Probe Report Accuracy')
    title('Control Exp')
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\probePerfBar'],'\',filesep));
    print ('-dpdf', '-r500',namefig); 
    
    figure;
    hold on
    bar(1,MpClick1(1),.5,'FaceColor',[0 0 0])
    bar(2,MpClick2(1),.5,'FaceColor',[0 0 0])
    errorbar(1,MpClick1(1),SpClick1(1),'.','Color',[0 0 0])
    errorbar(2,MpClick2(1),SpClick1(1),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',1:1:2,'XTickLabel',{'Choice 1','Choice 2'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([0 3])
    ylim([0 1])
    ylabel('Percent Correct')
    title('Control Exp')
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\c1c2Bar'],'\',filesep));
    print ('-dpdf', '-r500',namefig); 
end

if expN~= 3 && trialType == 4 || trialType == 5 || trialType == 6 || trialType == 7 || trialType == 8 || trialType == 9
    MpTPsq = nanmean(perfTP(:,:,1:6),3);
    SpTPsq = nanstd(MpTPsq,[],2)./sqrt(numObs);
    MpTAsq = nanmean(perfTA(:,:,1:6),3);
    SpTAsq = nanstd(MpTAsq,[],2)./sqrt(numObs);
    
    MpTPsq = nanmean(MpTPsq,2);
    MpTAsq = nanmean(MpTAsq,2);
    
    sameHemiTargetLoc = perfTP_Pair(1:13,:,:);
    sameHemiNonTargetLoc = perfTA_Pair(1:13,:,:);
    diffHemiTargetLoc = perfTP_Pair(14:26,:,:);
    diffHemiNonTargetLoc = perfTA_Pair(14:26,:,:);

    m_SH_TL_sq = nanmean(sameHemiTargetLoc(:,:,1:6),3);
    m_SH_nTL_sq = nanmean(sameHemiNonTargetLoc(:,:,1:6),3);
    m_DH_TL_sq = nanmean(diffHemiTargetLoc(:,:,1:6),3);
    m_DH_nTL_sq = nanmean(diffHemiNonTargetLoc(:,:,1:6),3);
    
    s_SH_TL_sq = nanstd(m_SH_TL_sq,[],2)./sqrt(numObs);
    s_SH_nTL_sq = nanstd(m_SH_nTL_sq,[],2)./sqrt(numObs);
    s_DH_TL_sq = nanstd(m_DH_TL_sq,[],2)./sqrt(numObs);
    s_DH_nTL_sq = nanstd(m_DH_nTL_sq,[],2)./sqrt(numObs);
    
    m_SH_TL_sq = nanmean(m_SH_TL_sq,2);
    m_SH_nTL_sq = nanmean(m_SH_nTL_sq,2);
    m_DH_TL_sq = nanmean(m_DH_TL_sq,2);
    m_DH_nTL_sq = nanmean(m_DH_nTL_sq,2);

    %% Plot average across observers - target loc probed and not probed
    if trialType == 7
        TPclr = [0 0 0];
        TAclr = [0 0 0];
    end
    
    figure; hold on;
    errorbar(100:30:460,MpTPsq,SpTPsq,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TPclr)
    errorbar(100:30:460,MpTAsq,SpTAsq,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TAclr)
    
    if trialType ~= 7
        legend('Probe at Target Location','Probe at Non-target Location')
    end
    
    ylim([0 1])
    xlim([0 500])
    set(gca,'YTick', 0:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    
    title([condition ' Perf SQ'],'FontSize',18)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
    
    plot([0 500],[1/12 1/12],'Color',[0 0 0],'LineStyle','--')
    
    plot(50,mean(MpTPsq,1),'s','Color',TPclr,'LineWidth',2,'MarkerSize',8)
    plot(50,mean(MpTAsq,1),'s','Color',TAclr,'LineWidth',2,'MarkerSize',8)
    
    [sig] = diff_ttest(cat(3,nanmean(perfTP(:,:,1:6),3),nanmean(perfTA(:,:,1:6),3)),false);
    newAlpha = 0.05/13;
%     newAlpha = (sum(sig<0.05)/13)*0.05;
    for i=1:size(sig,1)
        for j=1:size(sig,3)
            y = 0.15;
            if sig(i,1,j) <= newAlpha
                plot((i-1)*30+100,y,'*','Color',[0 0 0])
            elseif sig(i,1,j) <= 0.05
                plot((i-1)*30+100,y,'+','Color',[0 0 0])
            end
        end
    end  
%     newAlpha = (sum(sig<0.05)/13)*0.05;
%     for i=1:size(sig,1)
%         for j=1:size(sig,3)
%             y = 0.15;
%             if sig(i,1,j) <= newAlpha
%                 plot((i-1)*30+100,y,'+','Color',[0 0 0])
%             end
%         end
%     end    

    namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerf_TargetLocAnalysis_SQ' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);
    
    data = zeros(numObs*13*2,4);
    index = 0;
    pTP_SQ = nanmean(perfTP(:,:,1:6),3);
    pTA_SQ = nanmean(perfTA(:,:,1:6),3);
    for i = 1:numObs
        data(index+1:index+13,1) = pTP_SQ(:,i);
        data(index+1:index+13,2) = rot90(1:13,-1);
        data(index+1:index+13,3) = ones(13,1);
        data(index+1:index+13,4) = ones(13,1)*i;
        index = index + 13;
        data(index+1:index+13,1) = pTA_SQ(:,i);
        data(index+1:index+13,2) = rot90(1:13,-1);
        data(index+1:index+13,3) = ones(13,1)*2;
        data(index+1:index+13,4) = ones(13,1)*i;
        index = index + 13;
    end
    RMAOV2(data);     

    if trialType ~= 7 
        %% Plot difference    
        sem_diff = nanstd(nanmean(perfTP(:,:,1:6),3)-nanmean(perfTA(:,:,1:6),3),[],2)./sqrt(numObs);
        figure; hold on;
        errorbar(100:30:460,MpTPsq-MpTAsq,sem_diff,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

        [sig] = diff_ttest(cat(3,nanmean(perfTP(:,:,1:6),3),nanmean(perfTA(:,:,1:6),3)),false);
        newAlpha = 0.05/13;
%         newAlpha = (sum(sig<0.05)/13)*0.05;
        for i=1:size(sig,1)
            for j=1:size(sig,3)
                y = -0.10;
                if sig(i,1,j) <= newAlpha
                    plot((i-1)*30+100,y,'*','Color',[0 0 0])
                elseif sig(i,1,j) <= 0.05
                    plot((i-1)*30+100,y,'+','Color',[0 0 0])
                end
            end
        end
%         newAlpha = (sum(sig<0.05)/13)*0.05;
%         for i=1:size(sig,1)
%             for j=1:size(sig,3)
%                 y = -0.10;
%                 if sig(i,1,j) <= newAlpha
%                     plot((i-1)*30+100,y,'+','Color',[0 0 0])
%                 end
%             end
%         end

        ylim([-.2 .3])
        xlim([0 500])
        set(gca,'YTick', -.2:.1:.5,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

        title([condition ' Performance SQ'],'FontSize',18)
        xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
        ylabel('Performance Difference','FontSize',15,'Fontname','Ariel')  

        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

        namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfDiff_TargetLocAnalysis_SQ' saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);        
    end
    if trialType ~= 7 && trialType ~=9
%         fft_p1_p2(nanmean(perfTP(:,:,1:6),3),nanmean(perfTA(:,:,1:6),3),[],expN,trialType,task,['_probePerf_SQ_TPTA' saveFileName]);
% 
%         name = 'square_TL';
% 
%         pA = nanmean(perfTP(:,:,1:6),3);
%         pB = nanmean(perfTA(:,:,1:6),3);
% 
%         subj_pA = [];
%         subj_pB = [];
% 
%         for i=1:numObs
%            if ~isnan(mean(pA(:,i)))
%                subj_pA = horzcat(subj_pA,pA(:,i));
%                subj_pB = horzcat(subj_pB,pB(:,i));
%            end
%         end
%         boot_analysis
% 
%         a_p1 = subj_pA;
%         a_p2 = subj_pB;
%         fftAnalysis   
% 
%         size(subj_pA,2)
    end
    %%
    
%     figure; hold on;
%     errorbar(100:30:460,m_SH_TL_sq,s_SH_TL_sq,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TPclr)
%     errorbar(100:30:460,m_SH_nTL_sq,s_SH_nTL_sq,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TAclr)
%     
%     legend('Probe at Target Location','Probe at Non-target Location SH')
%     ylim([ymin 1])
%     xlim([0 500])
% 
%     set(gca,'YTick', ymin:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
%     set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
% 
%     title([condition ' Probe Performance - Square - SH'],'FontSize',18)
% 
%     xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
%     ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
% 
%     namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfSH_SQ' saveFileName],'\',filesep));
%     print ('-dpdf', '-r500',namefig);
%     
%     fft_p1_p2(nanmean(sameHemiTargetLoc(:,:,1:6),3),nanmean(sameHemiNonTargetLoc(:,:,1:6),3),[],expN,trialType,task,['_probePerf_SQ_SH_TL' saveFileName]);
%     
%     %%
%     figure; hold on;
%     errorbar(100:30:460,m_DH_TL_sq,s_DH_TL_sq,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TPclr)
%     errorbar(100:30:460,m_DH_nTL_sq,s_DH_nTL_sq,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',TAclr)
%     
%     legend('Probe at Target Location','Probe at Non-target Location - DH')
%     ylim([ymin 1])
%     xlim([0 500])
% 
%     set(gca,'YTick', ymin:.2:1,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
%     set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
% 
%     title([condition ' Probe Performance - Square - DH'],'FontSize',18)
% 
%     xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
%     ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
% 
%     namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfDH_SQ' saveFileName],'\',filesep));
%     print ('-dpdf', '-r500',namefig);  
% 
%     
%     %% Difference
%     sem_diff = nanstd(nanmean(sameHemiTargetLoc(:,:,1:6),3)-nanmean(sameHemiNonTargetLoc(:,:,1:6),3),[],2)./sqrt(numObs);
%     figure; hold on;
%     errorbar(100:30:460,m_SH_TL_sq-m_SH_nTL_sq,sem_diff,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
%    
%     [sig] = diff_ttest(cat(3,nanmean(sameHemiTargetLoc(:,:,1:6),3),nanmean(sameHemiNonTargetLoc(:,:,1:6),3)),false);
%     for i=1:size(sig,1)
%         for j=1:size(sig,3)
%             y = -0.10;
%             if sig(i,1,j) <= 0.05/13
%                 plot((i-1)*30+100,y,'*','Color',[0 0 0])
%             elseif sig(i,1,j) <= 0.05
%                 plot((i-1)*30+100,y,'+','Color',[0 0 0])
%             end
%         end
%     end
%     
%     ylim([-.2 .5])
%     xlim([0 500])
%     set(gca,'YTick', -.2:.1:.5,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
%     set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
%     
%     title([condition ' Performance SH'],'FontSize',18)
%     xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
%     ylabel('Performance Difference','FontSize',15,'Fontname','Ariel')  
%     
%     plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
% 
%     namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfDiffSH_SQ' saveFileName],'\',filesep));
%     print ('-dpdf', '-r500',namefig);
%     
%     %%
%     sem_diff = nanstd(nanmean(diffHemiTargetLoc(:,:,1:6),3)-nanmean(diffHemiNonTargetLoc(:,:,1:6),3),[],2)./sqrt(numObs);
%     figure; hold on;
%     errorbar(100:30:460,m_DH_TL_sq-m_DH_nTL_sq,sem_diff,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
%   
%     [sig] = diff_ttest(cat(3,nanmean(diffHemiTargetLoc(:,:,1:6),3),nanmean(diffHemiNonTargetLoc(:,:,1:6),3)),false);
%     for i=1:size(sig,1)
%         for j=1:size(sig,3)
%             y = -0.10;
%             if sig(i,1,j) <= 0.05/13
%                 plot((i-1)*30+100,y,'*','Color',[0 0 0])
%             elseif sig(i,1,j) <= 0.05
%                 plot((i-1)*30+100,y,'+','Color',[0 0 0])
%             end
%         end
%     end
%     
%     ylim([-.2 .5])
%     xlim([0 500])
%     set(gca,'YTick', -.2:.1:.5,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
%     set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
%     
%     title([condition ' Performance DH'],'FontSize',18)
%     xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
%     ylabel('Performance Difference','FontSize',15,'Fontname','Ariel')  
%     
%     plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
% 
%     namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfDiffDH_SQ' saveFileName],'\',filesep));
%     print ('-dpdf', '-r500',namefig);   
%     
%     fft_p1_p2(nanmean(diffHemiTargetLoc(:,:,1:6),3),nanmean(diffHemiNonTargetLoc(:,:,1:6),3),[],expN,trialType,task,['_probePerf_SQ_DH_TL' saveFileName]);   
end  
end