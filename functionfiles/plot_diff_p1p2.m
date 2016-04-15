function plot_diff_p1p2(expN,trialType)
%% Example
%%% plot_diff_p1p2(2,2);

[easy_p1,easy_p2,easy_pairs_p1,easy_pairs_p2,easy_pair_p1,easy_pair_p2,easy_SHP1,easy_SHP2,easy_DHP1,easy_DHP2,easy_D1P1,easy_D1P2,easy_D2P1,easy_D2P2,easy_D3P1,easy_D3P2] = overall_probe_analysis('easy',expN,trialType,true,false,false,false,false,false,1,true,0.1,0.3,{});

[difficult_p1,difficult_p2,difficult_pairs_p1,difficult_pairs_p2,difficult_pair_p1,difficult_pair_p2,difficult_SHP1,difficult_SHP2,difficult_DHP1,difficult_DHP2,difficult_D1P1,difficult_D1P2,difficult_D2P1,difficult_D2P2,difficult_D3P1,difficult_D3P2] = overall_probe_analysis('difficult',expN,trialType,true,false,false,false,false,false,1,true,0.1,0.3,{});

numObs = size(easy_p1,2);

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

%% Plot overall p1 - p2 
m_easy = mean(easy_p1 - easy_p2,2);
sem_easy = std(easy_p1 - easy_p2,[],2)./sqrt(numObs);

m_difficult = mean(difficult_p1 - difficult_p2,2);
sem_difficult = std(difficult_p1 - difficult_p2,[],2)./sqrt(numObs);

figure;hold on;
errorbar(100:30:460,m_easy,sem_easy,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
errorbar(100:30:460,m_difficult,sem_difficult,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])

legend('Feature','Conjunction','Location','SouthWest')
           
set(gca,'YTick',-0.6:.2:0.6,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')

ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([-0.6 0.6])
xlim([0 500])

plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

title(['P1 - P2 (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\p1p2diff' saveFileName]);

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
    
    errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    
    set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.8 0.8])
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

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\p1p2diffPAIR1' saveFileName]);
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
    
    errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.8 0.8])
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

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\p1p2diffPAIR2' saveFileName]);
print ('-djpeg', '-r500',namefig); 

%% Plot for each grouped pair
for i = 1:size(easy_pairs_p1,3)
    easy_diff = mean(easy_pairs_p1(:,:,i) - easy_pairs_p2(:,:,i),2);
    sem_easy_diff = std(easy_pairs_p1(:,:,i) - easy_pairs_p2(:,:,i),[],2)./sqrt(numObs);
    difficult_diff = mean(difficult_pairs_p1(:,:,i) - difficult_pairs_p2(:,:,i),2);
    sem_difficult_diff = std(difficult_pairs_p1(:,:,i) - difficult_pairs_p2(:,:,i),[],2)./sqrt(numObs);
    
    figure;hold on;
    errorbar(100:30:460,easy_diff,sem_easy_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
    errorbar(100:30:460,difficult_diff,sem_difficult_diff,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
    
    legend('Feature','Conjunction','Location','SouthEast')

    set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
    ylim([-0.8 0.8])
    xlim([0 500])

    ylabel('P1 - P2','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

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

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFilePairsLoc '\p1p2diff_' name saveFileName]);
    print ('-djpeg', '-r500',namefig);   
end

%% Plot p1 and p2 for same hemifield
figure;
hold on;
easy_d = mean(easy_SHP1-easy_SHP2,2);
easy_s_diff = std(easy_SHP1-easy_SHP2,[],2)/sqrt(numObs);
difficult_d = mean(difficult_SHP1-difficult_SHP2,2);
difficult_s_diff = std(difficult_SHP1-difficult_SHP2,[],2)/sqrt(numObs);

errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
ylim([-0.8 0.8])
xlim([0 500])

ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')

legend('Feature','Conjunction','Location','SouthWest')
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

title('P1 - P2: Same Hemifield','FontSize',14,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\p1p2diffSH' saveFileName]);
print ('-djpeg', '-r500',namefig); 

%% Plot p1 and p2 for different hemifield
figure;
hold on;
easy_d = mean(easy_DHP1-easy_DHP2,2);
easy_s_diff = std(easy_DHP1-easy_DHP2,[],2)/sqrt(numObs);
difficult_d = mean(difficult_DHP1-difficult_DHP2,2);
difficult_s_diff = std(difficult_DHP1-difficult_DHP2,[],2)/sqrt(numObs);

errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
ylim([-0.8 0.8])
xlim([0 500])

legend('Feature','Conjunction','Location','SouthWest')
ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')

plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

title('P1 - P2: Different Hemifield','FontSize',14,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\p1p2diffDH' saveFileName]);
print ('-djpeg', '-r500',namefig); 

%% Plot p1 and p2 for shortest distance
figure;
hold on;
easy_d = mean(easy_D1P1-easy_D1P2,2);
easy_s_diff = std(easy_D1P1-easy_D1P2,[],2)/sqrt(numObs);
difficult_d = mean(difficult_D1P1-difficult_D1P2,2);
difficult_s_diff = std(difficult_D1P1-difficult_D1P2,[],2)/sqrt(numObs);

errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
ylim([-0.8 0.8])
xlim([0 500])

legend('Feature','Conjunction','Location','SouthWest')
ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')

plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

title('P1 - P2: Shortest Distance','FontSize',14,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\p1p2diffD1' saveFileName]);
print ('-djpeg', '-r500',namefig); 

%% Plot p1 and p2 for medium distance
figure;
hold on;
easy_d = mean(easy_D2P1-easy_D2P2,2);
easy_s_diff = std(easy_D2P1-easy_D2P2,[],2)/sqrt(numObs);
difficult_d = mean(difficult_D2P1-difficult_D2P2,2);
difficult_s_diff = std(difficult_D2P1-difficult_D2P2,[],2)/sqrt(numObs);

errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
ylim([-0.8 0.8])
xlim([0 500])

legend('Feature','Conjunction','Location','SouthWest')
ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')

plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

title('P1 - P2: Medium Distance','FontSize',14,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\p1p2diffD2' saveFileName]);
print ('-djpeg', '-r500',namefig); 

%% Plot p1 and p2 for farthest distance
figure;
hold on;
easy_d = mean(easy_D3P1-easy_D3P2,2);
easy_s_diff = std(easy_D3P1-easy_D3P2,[],2)/sqrt(numObs);
difficult_d = mean(difficult_D3P1-difficult_D3P2,2);
difficult_s_diff = std(difficult_D3P1-difficult_D3P2,[],2)/sqrt(numObs);

errorbar(100:30:460,easy_d,easy_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
errorbar(100:30:460,difficult_d,difficult_s_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
ylim([-0.8 0.8])
xlim([0 500])

legend('Feature','Conjunction','Location','SouthWest')
ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')

plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')

title('P1 - P2: Farthest Distance','FontSize',14,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\p1p2diffD3' saveFileName]);
print ('-djpeg', '-r500',namefig); 

end
