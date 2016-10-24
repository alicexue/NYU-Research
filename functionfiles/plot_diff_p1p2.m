function [easy_squareP1,easy_squareP2,difficult_squareP1,difficult_squareP2] = plot_diff_p1p2(expN,trialType,printStats)
% Example
%% plot_diff_p1p2(2,2,false);

[easy_p1,easy_p2,easy_pairs_p1,easy_pairs_p2,easy_pair_p1,easy_pair_p2,easy_SHP1,easy_SHP2,easy_DHP1,easy_DHP2,easy_D1P1,easy_D1P2,easy_D2P1,easy_D2P2,easy_D3P1,easy_D3P2,~,easy_squareP1,easy_squareP2,easy_diamondP1,easy_diamondP2,easy_1346P1,easy_1346P2] = overall_probe_analysis('easy',expN,trialType,false,false,true,false,false,false,1,true,0.1,0.3,{});

[difficult_p1,difficult_p2,difficult_pairs_p1,difficult_pairs_p2,difficult_pair_p1,difficult_pair_p2,difficult_SHP1,difficult_SHP2,difficult_DHP1,difficult_DHP2,difficult_D1P1,difficult_D1P2,difficult_D2P1,difficult_D2P2,difficult_D3P1,difficult_D3P2,~,difficult_squareP1,difficult_squareP2,difficult_diamondP1,difficult_diamondP2,difficult_1346P1,difficult_1346P2] = overall_probe_analysis('difficult',expN,trialType,false,false,true,false,false,false,1,true,0.1,0.3,{});

numObs = size(easy_p1,2);

dir_name = setup_dir();
if expN == 1
    saveFileName = '';
    titleName = '';
elseif expN == 2
    saveFileLoc = '\target present or absent\difference';
    saveFilePairsLoc = '\target present or absent\difference';
    if trialType == 1
        titleName = 'TP';
        saveFileName = '_2TP';
    elseif trialType == 2
        titleName = 'TA';
        saveFileName = '_2TA';
    elseif trialType == 3
        titleName = '';
        saveFileName = '_2';
    elseif trialType == 4
        titleName = 'CR';
        saveFileName = '_2CR';
    elseif trialType == 5
        titleName = 'prevPB';
        saveFileName = '_2PB';
    elseif trialType == 6
        titleName = 'prevPO';
        saveFileName = '_2PO';
    elseif trialType == 7
        titleName = 'prevPN';
        saveFileName = '_2PN';
    end
elseif expN == 3
    saveFileLoc = '\control exp';
    saveFilePairsLoc = '\control exp';
    titleName = '';
    saveFileName = '';
end

% make difference folder

easyclr = [255 148 77]/255;
difficultclr = [77 166 255]/255;

printFg = true;
if printFg
    %% Plot overall p1 - p2 
    m_easy = mean(easy_p1 - easy_p2,2);
    sem_easy = std(easy_p1 - easy_p2,[],2)./sqrt(numObs);

    m_difficult = mean(difficult_p1 - difficult_p2,2);
    sem_difficult = std(difficult_p1 - difficult_p2,[],2)./sqrt(numObs);

    figure;hold on;
    errorbar(100:30:460,m_easy,sem_easy,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
    errorbar(100:30:460,m_difficult,sem_difficult,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)

    legend('Feature','Conjunction','Location','NorthWest')

    set(gca,'YTick',-0.2:.2:0.4,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')

    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([-0.2 0.4])
    xlim([0 500])

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

    [sig] = diff_ttest(cat(3,easy_p1 - easy_p2,difficult_p1 - difficult_p2),true);
    for i=1:size(sig,1)
        for j=1:size(sig,3)
            if j == 1
                clr = easyclr;
                y = -0.10;
            else
                clr = difficultclr;
                y = -0.15;
            end
            if sig(i,1,j) <= 0.05/13
                plot((i-1)*30+100,y,'*','Color',clr)
            elseif sig(i,1,j) <= 0.05
                plot((i-1)*30+100,y,'+','Color',clr)
            end
        end
    end

    title(['P1 - P2 (n = ' num2str(numObs) ') ' titleName],'FontSize',20,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diff' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig); 

    %% Plot p1-p2 for square configuration 
    m_easy = mean(easy_squareP1 - easy_squareP2,2);
    sem_easy = std(easy_squareP1 - easy_squareP2,[],2)./sqrt(numObs);

    m_difficult = mean(difficult_squareP1 - difficult_squareP2,2);
    sem_difficult = std(difficult_squareP1 - difficult_squareP2,[],2)./sqrt(numObs);

    figure;hold on;
    errorbar(100:30:460,m_easy,sem_easy,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
    errorbar(100:30:460,m_difficult,sem_difficult,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)

    legend('Feature','Conjunction','Location','NorthWest')

    set(gca,'YTick',-0.2:.2:0.6,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')

    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([-0.2 0.6])
    xlim([0 500])

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

    [sig] = diff_ttest(cat(3,easy_p1 - easy_p2,difficult_p1 - difficult_p2),true);
    for i=1:size(sig,1)
        for j=1:size(sig,3)
            if j == 1
                clr = easyclr;
                y = -0.10;
            else
                clr = difficultclr;
                y = -0.15;
            end
            if sig(i,1,j) <= 0.05/13
                plot((i-1)*30+100,y,'*','Color',clr)
            elseif sig(i,1,j) <= 0.05
                plot((i-1)*30+100,y,'+','Color',clr)
            end
        end
    end

    title(['P1 - P2 Square Configuration (n = ' num2str(numObs) ') ' titleName],'FontSize',20,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffSQ' saveFileName],'\',filesep));

    print ('-dpdf', '-r500',namefig);  

    %% Plot P1-P2 scatterplot for square configuration 
    figure; hold on;
    scatter(mean(easy_squareP1 - easy_squareP2,1),mean(difficult_squareP1 - difficult_squareP2,1))
    set(gca,'XTick',-.3:.1:.6,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'YTick',-.3:.1:.6,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    xlim([-.3 .6])
    ylim([-.3 .6])
    xlabel('Feature','FontSize',20,'Fontname','Ariel')
    ylabel('Conjunction','FontSize',18,'Fontname','Ariel')
    h = refline(1,0);
    h.Color = [1 1 1]*0.4;
    title('P1 - P2 per observer (Square, TA)')
    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffSQ_SCATTERPLOT' saveFileName],'\',filesep));    
    print ('-dpdf', '-r500',namefig);    

    keyboard
    %% Bar graphs for square
    barGraph(easy_squareP1,easy_squareP2,'easy','SQ',dir_name,saveFileLoc,saveFileName);

    barGraph(difficult_squareP1,difficult_squareP2,'difficult','SQ',dir_name,saveFileLoc,saveFileName);

    %% RMAOV2 on F/C and grouped delays
    numObs = size(easy_squareP1,2);
    diff = easy_squareP1 - easy_squareP2;
    easy = cat(1,rot90(mean(diff(1:4,:),1),-1),rot90(mean(diff(5:8,:),1),-1),rot90(mean(diff(9:12,:),1),-1));
    diff = difficult_squareP1 - difficult_squareP2;
    difficult = cat(1,rot90(mean(diff(1:4,:),1),-1),rot90(mean(diff(5:8,:),1),-1),rot90(mean(diff(9:12,:),1),-1));
    data = [];
    data(:,1) = cat(1,easy,difficult);
    data(:,2) = cat(1,ones(size(easy,1),1),ones(size(easy,1),1)*2);

    tmp2 = ones(numObs,1);
    tmp = cat(1,tmp2,tmp2*2,tmp2*3);
    data(:,3) = cat(1,tmp,tmp);
    tmp = [];
    for i = 1:2*3
        tmp = cat(1,tmp,rot90(1:16,-1));
    end
    data(:,4) = tmp;
    RMAOV2(data);  

    %% RMAOV1 on Feature and Conjunction
    barGraphRMAOV1(easy_squareP1,easy_squareP2);

    barGraphRMAOV1(difficult_squareP1,difficult_squareP2);

    %% Plot p1 and p2 for each pair - square configuration
    figure;
    for numPair = 1:size(easy_pair_p1,3)/2
        subplot(2,3,numPair)
        hold on;

        easy_d = mean(easy_pair_p1(:,:,numPair)-easy_pair_p2(:,:,numPair),2);
        easy_s_diff = std(easy_pair_p1(:,:,numPair)-easy_pair_p2(:,:,numPair),[],2)/sqrt(numObs);
        difficult_d = mean(difficult_pair_p1(:,:,numPair)-difficult_pair_p2(:,:,numPair),2);
        difficult_s_diff = std(difficult_pair_p1(:,:,numPair)-difficult_pair_p2(:,:,numPair),[],2)/sqrt(numObs);

        errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
        errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)

        set(gca,'YTick',-0.4:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        ylim([-0.4 0.8])
        xlim([0 500])

        if numPair == 1 || numPair == 4
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

        title(['PAIR n' num2str(numPair)],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffPAIR1' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    %% Plot p1 and p2 for each pair - diamond configuration
    figure;
    for numPair = 1:size(easy_pair_p1,3)/2
        subplot(2,3,numPair)
        hold on;
        easy_d = mean(easy_pair_p1(:,:,numPair+6)-easy_pair_p2(:,:,numPair+6),2);
        easy_s_diff = std(easy_pair_p1(:,:,numPair+6)-easy_pair_p2(:,:,numPair+6),[],2)/sqrt(numObs);
        difficult_d = mean(difficult_pair_p1(:,:,numPair+6)-difficult_pair_p2(:,:,numPair+6),2);
        difficult_s_diff = std(difficult_pair_p1(:,:,numPair+6)-difficult_pair_p2(:,:,numPair+6),[],2)/sqrt(numObs);

        errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
        errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)
        set(gca,'YTick',-0.4:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        ylim([-0.4 0.8])
        xlim([0 500])

        if numPair == 1 || numPair == 4
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

        title(['PAIR n' num2str(numPair+6)],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffPAIR2' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig); 

    %% Plot for each grouped pair
    for i = 1:size(easy_pairs_p1,3)
        easy_diff = easy_pairs_p1(:,:,i) - easy_pairs_p2(:,:,i);
        sem_easy_diff = std(easy_pairs_p1(:,:,i) - easy_pairs_p2(:,:,i),[],2)./sqrt(numObs);
        difficult_diff = difficult_pairs_p1(:,:,i) - difficult_pairs_p2(:,:,i);
        sem_difficult_diff = std(difficult_pairs_p1(:,:,i) - difficult_pairs_p2(:,:,i),[],2)./sqrt(numObs);

        figure;hold on;
        errorbar(100:30:460,mean(easy_diff,2),sem_easy_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
        errorbar(100:30:460,mean(difficult_diff,2),sem_difficult_diff,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)

        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

        if i == 3
            legend('Feature','Conjunction','Location','NorthWest')
        end
        set(gca,'YTick',-0.4:.2:0.6,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
        ylim([-0.4 0.6])
        xlim([0 500])

        ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

        [sig] = diff_ttest(cat(3,easy_diff,difficult_diff),true);
        for delay=1:size(sig,1)
            for j=1:size(sig,3)
                if j == 1
                    clr = easyclr;
                    y = -0.20;
                else
                    clr = difficultclr;
                    y = -0.25;
                end
                if sig(delay,1,j) <= 0.05/13
                    plot((delay-1)*30+100,y,'*','Color',clr)
                elseif sig(delay,1,j) <= 0.05
                    plot((delay-1)*30+100,y,'+','Color',clr)
                end
            end
        end

        if i == 1
            name = '7';
        elseif i == 2
            name = '12';
        elseif i == 3
            name = '1 and 6';
        elseif i == 4
            name = '2 and 5';     
        elseif i == 5
            name = '3 and 4';
        elseif i == 6
            name = '8 and 10';                 
        elseif i == 7
            name = '9 and 11';   
        end

        title(['P1 - P2: Pair ' name ' ' titleName],'FontSize',20,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFilePairsLoc '\p1p2diff_' name saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);   

        barGraph(easy_pairs_p1(:,:,i),easy_pairs_p2(:,:,i),'easy',name,dir_name,saveFileLoc,saveFileName);
        barGraph(difficult_pairs_p1(:,:,i),difficult_pairs_p2(:,:,i),'difficult',name,dir_name,saveFileLoc,saveFileName);
    end

    %% Graph pairs 1, 3, 4, 6 (not diagonals on the square)
    barGraph(easy_1346P1,easy_1346P2,'easy','1346',dir_name,saveFileLoc,saveFileName);
    barGraph(difficult_1346P1,difficult_1346P2,'difficult','1346',dir_name,saveFileLoc,saveFileName);


    %% Plot p1 and p2 for same hemifield
    figure;
    hold on;
    easy_d = mean(easy_SHP1-easy_SHP2,2);
    easy_s_diff = std(easy_SHP1-easy_SHP2,[],2)/sqrt(numObs);
    difficult_d = mean(difficult_SHP1-difficult_SHP2,2);
    difficult_s_diff = std(difficult_SHP1-difficult_SHP2,[],2)/sqrt(numObs);

    errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
    errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)
    set(gca,'YTick',-0.4:.4:0.8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.4 0.8])
    xlim([0 500])

    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

    legend('Feature','Conjunction','Location','NorthWest')
    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

    [sig] = diff_ttest(cat(3,easy_SHP1-easy_SHP2,difficult_SHP1-difficult_SHP2),true);
    for i=1:size(sig,1)
        for j=1:size(sig,3)
            if j == 1
                clr = easyclr;
                y = -0.10;
            else
                clr = difficultclr;
                y = -0.15;
            end
            if sig(i,1,j) <= 0.05/13
                plot((i-1)*30+100,y,'*','Color',clr)
            elseif sig(i,1,j) <= 0.05
                plot((i-1)*30+100,y,'+','Color',clr)
            end
        end
    end

    title('P1 - P2: Same Hemifield','FontSize',20,'Fontname','Ariel')  

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffSH' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig); 

    %% Plot p1 and p2 for different hemifield
    figure;
    hold on;
    easy_d = mean(easy_DHP1-easy_DHP2,2);
    easy_s_diff = std(easy_DHP1-easy_DHP2,[],2)/sqrt(numObs);
    difficult_d = mean(difficult_DHP1-difficult_DHP2,2);
    difficult_s_diff = std(difficult_DHP1-difficult_DHP2,[],2)/sqrt(numObs);

    errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
    errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)
    set(gca,'YTick',-0.4:.4:0.8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.4 0.8])
    xlim([0 500])

    legend('Feature','Conjunction','Location','NorthWest')
    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

    [sig] = diff_ttest(cat(3,easy_DHP1-easy_DHP2,difficult_DHP1-difficult_DHP2),true);
    for i=1:size(sig,1)
        for j=1:size(sig,3)
            if j == 1
                clr = easyclr;
                y = -0.10;
            else
                clr = difficultclr;
                y = -0.15;
            end
            if sig(i,1,j) <= 0.05/13
                plot((i-1)*30+100,y,'*','Color',clr)
            elseif sig(i,1,j) <= 0.05
                plot((i-1)*30+100,y,'+','Color',clr)
            end
        end
    end

    title('P1 - P2: Different Hemifield','FontSize',20,'Fontname','Ariel')  

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffDH' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig); 

    %% Plot p1 and p2 for shortest distance
    figure;
    hold on;
    easy_d = mean(easy_D1P1-easy_D1P2,2);
    easy_s_diff = std(easy_D1P1-easy_D1P2,[],2)/sqrt(numObs);
    difficult_d = mean(difficult_D1P1-difficult_D1P2,2);
    difficult_s_diff = std(difficult_D1P1-difficult_D1P2,[],2)/sqrt(numObs);

    errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
    errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)
    set(gca,'YTick',-0.4:.4:0.8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.4 0.8])
    xlim([0 500])

    legend('Feature','Conjunction','Location','NorthWest')
    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

    [sig] = diff_ttest(cat(3,easy_D1P1-easy_D1P2,difficult_D1P1-difficult_D1P2),true);
    for i=1:size(sig,1)
        for j=1:size(sig,3)
            if j == 1
                clr = easyclr;
                y = -0.10;
            else
                clr = difficultclr;
                y = -0.15;
            end
            if sig(i,1,j) <= 0.05/13
                plot((i-1)*30+100,y,'*','Color',clr)
            elseif sig(i,1,j) <= 0.05
                plot((i-1)*30+100,y,'+','Color',clr)
            end
        end
    end

    title('P1 - P2: Shortest Distance','FontSize',20,'Fontname','Ariel')  

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffD1' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig); 

    %% Plot p1 and p2 for medium distance
    figure;
    hold on;
    easy_d = mean(easy_D2P1-easy_D2P2,2);
    easy_s_diff = std(easy_D2P1-easy_D2P2,[],2)/sqrt(numObs);
    difficult_d = mean(difficult_D2P1-difficult_D2P2,2);
    difficult_s_diff = std(difficult_D2P1-difficult_D2P2,[],2)/sqrt(numObs);

    errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
    errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)
    set(gca,'YTick',-0.4:.4:0.8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.4 0.8])
    xlim([0 500])

    legend('Feature','Conjunction','Location','NorthWest')
    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

    [sig] = diff_ttest(cat(3,easy_D2P1-easy_D2P2,difficult_D2P1-difficult_D2P2),true);
    for i=1:size(sig,1)
        for j=1:size(sig,3)
            if j == 1
                clr = easyclr;
                y = -0.10;
            else
                clr = difficultclr;
                y = -0.15;
            end
            if sig(i,1,j) <= 0.05/13
                plot((i-1)*30+100,y,'*','Color',clr)
            elseif sig(i,1,j) <= 0.05
                plot((i-1)*30+100,y,'+','Color',clr)
            end
        end
    end

    title('P1 - P2: Medium Distance','FontSize',20,'Fontname','Ariel')  

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffD2' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig); 

    %% Plot p1 and p2 for farthest distance
    figure;
    hold on;
    easy_d = mean(easy_D3P1-easy_D3P2,2);
    easy_s_diff = std(easy_D3P1-easy_D3P2,[],2)/sqrt(numObs);
    difficult_d = mean(difficult_D3P1-difficult_D3P2,2);
    difficult_s_diff = std(difficult_D3P1-difficult_D3P2,[],2)/sqrt(numObs);

    errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)
    errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)
    set(gca,'YTick',-0.4:.4:0.8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.4 0.8])
    xlim([0 500])

    legend('Feature','Conjunction','Location','NorthWest')
    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

    [sig] = diff_ttest(cat(3,easy_D3P1-easy_D3P2,difficult_D3P1-difficult_D3P2),true);
    for i=1:size(sig,1)
        for j=1:size(sig,3)
            if j == 1
                clr = easyclr;
                y = -0.10;
            else
                clr = difficultclr;
                y = -0.15;
            end
            if sig(i,1,j) <= 0.05/13
                plot((i-1)*30+100,y,'*','Color',clr)
            elseif sig(i,1,j) <= 0.05
                plot((i-1)*30+100,y,'+','Color',clr)
            end
        end
    end

    title('P1 - P2: Farthest Distance','FontSize',20,'Fontname','Ariel')  

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffD3' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig); 
end

%% Conducts ANOVA on P1 - P2 for Grouped Pairs
if printStats
    easy_diff = easy_pairs_p1 - easy_pairs_p2;
    difficult_diff = difficult_pairs_p1 - difficult_pairs_p2;
    for pair=1:size(easy_diff,3)
        data = zeros(numObs*13*2,4);
        index = 0;
        for i = 1:numObs
            data(index+1:index+13,1) = easy_diff(:,i,pair);
            data(index+1:index+13,2) = rot90(1:13,-1);
            data(index+1:index+13,3) = ones(13,1);
            data(index+1:index+13,4) = ones(13,1)*i;
            index = index + 13;
            data(index+1:index+13,1) = difficult_diff(:,i,pair);
            data(index+1:index+13,2) = rot90(1:13,-1);
            data(index+1:index+13,3) = ones(13,1)*2;
            data(index+1:index+13,4) = ones(13,1)*i;
            index = index + 13;
        end
        fprintf('------------------------------------------------------\n')
        if pair == 1
            name = '7';
        elseif pair == 2
            name = '12';
        elseif pair == 3
            name = '1 and 6';
        elseif pair == 4
            name = '2 and 5';            
        elseif pair == 5
            name = '3 and 4';
        elseif pair == 6
            name = '8 and 10';                 
        elseif pair == 7
            name = '9 and 11';   
        end
        fprintf(['PAIR ' name '\n'])

        RMAOV2(data);     
    end
end
end

function barGraph(P1,P2,task,name,dir_name,saveFileLoc,saveFileName)
if strcmp(task,'difficult')
    condition = 'Conjunction';
    clr = [77 166 255]/255;
else 
    condition = 'Feature';
    clr = [255 148 77]/255;
end
figure;hold on;
x = 1:3;
diff = P1 - P2;
group1 = mean(diff(1:4,:),1);
group2 = mean(diff(5:8,:),1);
group3 = mean(diff(9:12,:),1);
y = [mean(group1,2),mean(group2,2),mean(group3,2)];
sem = [std(group1,[],2),std(group2,[],2),std(group3,[],2)]./sqrt(size(diff,2));

bar(x,y,0.5,'FaceColor',clr)
errorbar(y,sem,'.','Color',[0 0 0])

[sig] = diff_ttest(cat(3,group1,group2,group3),true);
for i=1:size(sig,1)
    for j=1:size(sig,3)
        if sig(i,1,j) <= 0.05/6
            plot(j,.40,'*','Color',[0 0 0])
        elseif sig(i,1,j) <= 0.05/3
            plot(j,.40,'x','Color',[0 0 0])
        elseif sig(i,1,j) <= 0.05
            plot(j,.40,'+','Color',[0 0 0])
        end
    end
end

set(gca,'YTick',0:.15:.45,'FontSize',15,'LineWidth',2','Fontname','Ariel')
ylabel('P1 - P2','FontSize',15,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
title([condition ' ' name ' P1 - P2'],'FontSize',15,'Fontname','Ariel')
ylim([0 .45])
set(gca,'XTick',1:1:3,'XTickLabel',{'100-190','210-270','300-390'},'FontSize',15,'LineWidth',2,'Fontname','Ariel')
namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\' condition '_p1p2diffBar' name saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

fprintf('------------------------------------------------------------------------\n')
fprintf(['PAIR ' name '\n'])
barGraphRMAOV1(P1,P2);
end

function barGraphRMAOV1(P1,P2)
%%% graphs grouped pairs
diff = P1 - P2;
dataColumnOne = cat(1,rot90(mean(diff(1:4,:),1),-1),rot90(mean(diff(5:8,:),1),-1),rot90(mean(diff(9:12,:),1),-1));
numObs = size(P1,2);
data = [];
data(:,1) = dataColumnOne;
tmp2 = ones(numObs,1);
tmp = cat(1,tmp2,tmp2*2,tmp2*3);
data(:,2) = tmp;
tmp = [];
for i = 1:3
    tmp = cat(1,tmp,rot90(1:16,-1));
end
data(:,3) = tmp;
RMAOV1(data);   
end

