function plot_diff_p1p2(expN,trialType,printStats)
%% Example
%%% plot_diff_p1p2(2,2,false);

[easy_p1,easy_p2,easy_pairs_p1,easy_pairs_p2,easy_pair_p1,easy_pair_p2,easy_SHP1,easy_SHP2,easy_DHP1,easy_DHP2,easy_D1P1,easy_D1P2,easy_D2P1,easy_D2P2,easy_D3P1,easy_D3P2] = overall_probe_analysis('easy',expN,trialType,false,false,false,false,false,false,1,true,0.1,0.3,{});

[difficult_p1,difficult_p2,difficult_pairs_p1,difficult_pairs_p2,difficult_pair_p1,difficult_pair_p2,difficult_SHP1,difficult_SHP2,difficult_DHP1,difficult_DHP2,difficult_D1P1,difficult_D1P2,difficult_D2P1,difficult_D2P2,difficult_D3P1,difficult_D3P2] = overall_probe_analysis('difficult',expN,trialType,false,false,false,false,false,false,1,true,0.1,0.3,{});

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
end

% make difference folder

easyclr = [255 148 77]/255;
difficultclr = [77 166 255]/255;

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

[sig] = diff_ttest(easy_p1 - easy_p2,difficult_p1 - difficult_p2,true);
for j=1:size(sig,2)
    if sig(1,j) <= 0.05/13
        plot((j-1)*30+100,-0.10,'*','Color',easyclr)
    elseif sig(1,j) <= 0.05
        plot((j-1)*30+100,-0.10,'+','Color',easyclr)
    end
    if sig(2,j) <= 0.05/13
        plot((j-1)*30+100,-0.15,'*','Color',difficultclr)
    elseif sig(2,j) <= 0.05
        plot((j-1)*30+100,-0.15,'+','Color',difficultclr)
    end        
end

% title('P1 - P2','FontSize',20,'Fontname','Ariel')
title(['P1 - P2 (n = ' num2str(numObs) ') ' titleName],'FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diff' saveFileName],'\',filesep));

print ('-djpeg', '-r500',namefig);  

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
print ('-djpeg', '-r500',namefig);

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
print ('-djpeg', '-r500',namefig); 

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
    set(gca,'YTick',-0.3:.3:0.6,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.3 0.6])
    xlim([0 500])

    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

    [sig] = diff_ttest(easy_diff,difficult_diff,true);
    for j=1:size(sig,2)
        if sig(1,j) <= 0.05/13
            plot((j-1)*30+100,-0.20,'*','Color',easyclr)
        elseif sig(1,j) <= 0.05
            plot((j-1)*30+100,-0.20,'+','Color',easyclr)
        end
        if sig(2,j) <= 0.05/13
            plot((j-1)*30+100,-0.25,'*','Color',difficultclr)
        elseif sig(2,j) <= 0.05
            plot((j-1)*30+100,-0.25,'+','Color',difficultclr)
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

%     title('P1 - P2','FontSize',20,'Fontname','Ariel')
    title(['P1 - P2: Pair ' name ' ' titleName],'FontSize',20,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFilePairsLoc '\p1p2diff_' name saveFileName],'\',filesep));
    print ('-djpeg', '-r500',namefig);   
end

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

[sig] = diff_ttest(easy_SHP1-easy_SHP2,difficult_SHP1-difficult_SHP2,true);
for j=1:size(sig,2)
    if sig(1,j) <= 0.05/13
        plot((j-1)*30+100,-0.10,'*','Color',easyclr)
    elseif sig(1,j) <= 0.05
        plot((j-1)*30+100,-0.10,'+','Color',easyclr)
    end
    if sig(2,j) <= 0.05/13
        plot((j-1)*30+100,-0.15,'*','Color',difficultclr)
    elseif sig(2,j) <= 0.05
        plot((j-1)*30+100,-0.15,'+','Color',difficultclr)
    end        
end

% title('P1 - P2','FontSize',20,'Fontname','Ariel')
title('P1 - P2: Same Hemifield','FontSize',20,'Fontname','Ariel')  

namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffSH' saveFileName],'\',filesep));
print ('-djpeg', '-r500',namefig); 

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

[sig] = diff_ttest(easy_DHP1-easy_DHP2,difficult_DHP1-difficult_DHP2,true);
for j=1:size(sig,2)
    if sig(1,j) <= 0.05/13
        plot((j-1)*30+100,-0.10,'*','Color',easyclr)
    elseif sig(1,j) <= 0.05
        plot((j-1)*30+100,-0.10,'+','Color',easyclr)
    end
    if sig(2,j) <= 0.05/13
        plot((j-1)*30+100,-0.15,'*','Color',difficultclr)
    elseif sig(2,j) <= 0.05
        plot((j-1)*30+100,-0.15,'+','Color',difficultclr)
    end        
end

% title('P1 - P2','FontSize',20,'Fontname','Ariel')
title('P1 - P2: Different Hemifield','FontSize',20,'Fontname','Ariel')  

namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffDH' saveFileName],'\',filesep));
print ('-djpeg', '-r500',namefig); 

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

[sig] = diff_ttest(easy_D1P1-easy_D1P2,difficult_D1P1-difficult_D1P2,true);
for j=1:size(sig,2)
    if sig(1,j) <= 0.05/13
        plot((j-1)*30+100,-0.10,'*','Color',easyclr)
    elseif sig(1,j) <= 0.05
        plot((j-1)*30+100,-0.10,'+','Color',easyclr)
    end
    if sig(2,j) <= 0.05/13
        plot((j-1)*30+100,-0.15,'*','Color',difficultclr)
    elseif sig(2,j) <= 0.05
        plot((j-1)*30+100,-0.15,'+','Color',difficultclr)
    end        
end

% title('P1 - P2','FontSize',20,'Fontname','Ariel')
title('P1 - P2: Shortest Distance','FontSize',20,'Fontname','Ariel')  

namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffD1' saveFileName],'\',filesep));
print ('-djpeg', '-r500',namefig); 

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

[sig] = diff_ttest(easy_D2P1-easy_D2P2,difficult_D2P1-difficult_D2P2,true);
for j=1:size(sig,2)
    if sig(1,j) <= 0.05/13
        plot((j-1)*30+100,-0.10,'*','Color',easyclr)
    elseif sig(1,j) <= 0.05
        plot((j-1)*30+100,-0.10,'+','Color',easyclr)
    end
    if sig(2,j) <= 0.05/13
        plot((j-1)*30+100,-0.15,'*','Color',difficultclr)
    elseif sig(2,j) <= 0.05
        plot((j-1)*30+100,-0.15,'+','Color',difficultclr)
    end        
end

% title('P1 - P2','FontSize',20,'Fontname','Ariel')
title('P1 - P2: Medium Distance','FontSize',20,'Fontname','Ariel')  

namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffD2' saveFileName],'\',filesep));
print ('-djpeg', '-r500',namefig); 

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

[sig] = diff_ttest(easy_D3P1-easy_D3P2,difficult_D3P1-difficult_D3P2,true);
for j=1:size(sig,2)
    if sig(1,j) <= 0.05/13
        plot((j-1)*30+100,-0.10,'*','Color',easyclr)
    elseif sig(1,j) <= 0.05
        plot((j-1)*30+100,-0.10,'+','Color',easyclr)
    end
    if sig(2,j) <= 0.05/13
        plot((j-1)*30+100,-0.15,'*','Color',difficultclr)
    elseif sig(2,j) <= 0.05
        plot((j-1)*30+100,-0.15,'+','Color',difficultclr)
    end        
end

% title('P1 - P2','FontSize',20,'Fontname','Ariel')
title('P1 - P2: Farthest Distance','FontSize',20,'Fontname','Ariel')  

namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diffD3' saveFileName],'\',filesep));
print ('-djpeg', '-r500',namefig); 

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
            data(index+1:index+13,3) = rot90([1,1,1,1,1,1,1,1,1,1,1,1,1]);
            data(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
            index = index + 13;
            data(index+1:index+13,1) = difficult_diff(:,i,pair);
            data(index+1:index+13,2) = rot90(1:13,-1);
            data(index+1:index+13,3) = rot90([2,2,2,2,2,2,2,2,2,2,2,2,2]);
            data(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
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

