function differences_scatterplot(expN)

dir_name = setup_dir();

easyclr = [255 102 0]/255;
difficultclr = [0 0 204]/255;

%% Get data
[e_sqC1,e_sqC2] = overall_probe_performance(expN,2,'easy',1,false);
[d_sqC1,d_sqC2] = overall_probe_performance(expN,2,'difficult',1,false);
[e_sqP1,e_sqP2,d_sqP1,d_sqP2] = plot_diff_p1p2(expN,2,false);

e_diff_sqC = rot90(nanmean(e_sqC1-e_sqC2,1));
d_diff_sqC = rot90(nanmean(d_sqC1-d_sqC2,1));

e_diff_sqP = rot90(nanmean(e_sqP1-e_sqP2,1));
d_diff_sqP = rot90(nanmean(d_sqP1-d_sqP2,1));

if expN==2
    %% Plot scatterplot of c1-c2 v. p1-p2 for square configuration
    figure; hold on;
    subplot(1,2,1);
    scatter(d_diff_sqC,d_diff_sqP,'MarkerEdgeColor',difficultclr)
    xlim([0 0.6])
    ylim([-0.6 0.6])
    set(gca,'XTick',0:.2:.6,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    set(gca,'YTick',-.6:.2:.6,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    h = refline(1,0);
    h.Color = [1 1 1]*0.4;
    h.LineStyle = '--';
    h = refline(-1,0);
    h.Color = [1 1 1]*0.4;
    h.LineStyle = '--';
    h = refline(0,0);
    h.Color = [0 0 0];
    h.LineStyle = '--';
    title('Conjunction')
    xlabel('Choice 1 - Choice 2')
    ylabel('P1 - P2')

    hold on;
    subplot(1,2,2);
    scatter(e_diff_sqC,e_diff_sqP,'MarkerEdgeColor',easyclr)
    xlim([0 0.6])
    ylim([-0.6 0.6])
    set(gca,'XTick',0:.2:.6,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    set(gca,'YTick',-.6:.2:.6,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    h = refline(1,0);
    h.Color = [1 1 1]*0.4;
    h.LineStyle = '--';
    h = refline(-1,0);
    h.Color = [1 1 1]*0.4;
    h.LineStyle = '--';
    h = refline(0,0);
    h.Color = [0 0 0];
    h.LineStyle = '--';
    title('Feature')
    namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\difference\p1p2c1c2DiffScatter_SQ_2TA'],'\',filesep));
    print ('-dpdf', '-r500',namefig);   
elseif expN == 3
    %% Plot scatterplot of c1-c2 v. p1-p2 for control exp
    figure; hold on;
    scatter(d_diff_sqC,d_diff_sqP,'MarkerEdgeColor','r')
    xlim([0 .6])
    ylim([-0.6 0.6])
    set(gca,'XTick',0:.2:.6,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    set(gca,'YTick',-.6:.2:.6,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    h = refline(1,0);
    h.Color = [1 1 1]*0.4;
    h.LineStyle = '--';
    h = refline(0,0);
    h.Color = [0 0 0];
    title('Control Exp')
    xlabel('Choice 1 - Choice 2')
    ylabel('P1 - P2')
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2c1c2DiffScatter'],'\',filesep));
    print ('-dpdf', '-r500',namefig);  
    keyboard
end

% [h,p,ci,stats] = ttest(e_diff_sqC,e_diff_sqP)
[RHO,PVAL] = corr(e_diff_sqC,e_diff_sqP)

% [h,p,ci,stats] = ttest(d_diff_sqC,d_diff_sqP)
[RHO,PVAL] = corr(d_diff_sqC,d_diff_sqP)


%% Plot bar graphs for c1-c2 and p1-p2 for square configuration
e_diff_sqC = nanmean(e_sqC1-e_sqC2,2);
d_diff_sqC = nanmean(d_sqC1-d_sqC2,2);

e_diff_sqP = nanmean(e_sqP1-e_sqP2,2);
d_diff_sqP = nanmean(d_sqP1-d_sqP2,2);

tmp = e_sqC1-e_sqC2;
numObs = size(tmp,2);
sem_e_diff_sqC = std(tmp,[],2)./sqrt(numObs);
tmp = d_sqC1-d_sqC2;
sem_d_diff_sqC = std(tmp,[],2)./sqrt(numObs);

tmp = e_sqP1-e_sqP2;
sem_e_diff_sqP = std(tmp,[],2)./sqrt(numObs);
tmp = d_sqP1-d_sqP2;
sem_d_diff_sqP = std(tmp,[],2)./sqrt(numObs);


if expN~=3
    figure; 
    subplot(1,4,1)
    hold on
    bar(2,d_diff_sqC(3),1,'FaceColor',difficultclr)
    bar(4,e_diff_sqC(3),1,'FaceColor',easyclr)
    errorbar(2,d_diff_sqC(3),sem_d_diff_sqC(3),'.','Color',[0 0 0])
    errorbar(4,e_diff_sqC(3),sem_e_diff_sqC(3),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',2:2:4,'XTickLabel',{'C','F'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.1:.3,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    ylabel('Choice 1 - Choice 2')
    xlim([0 6])
    ylim([0 0.3])
    title('160ms')

    subplot(1,4,2)
    hold on
    bar(2,d_diff_sqP(3),1,'FaceColor',difficultclr)
    bar(4,e_diff_sqP(3),1,'FaceColor',easyclr)
    errorbar(2,d_diff_sqP(3),sem_d_diff_sqP(3),'.','Color',[0 0 0])
    errorbar(4,e_diff_sqP(3),sem_e_diff_sqP(3),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',2:2:4,'XTickLabel',{'C','F'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.15:.45,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([0 6])
    ylim([0 0.45])
    ylabel('P1 - P2')

    subplot(1,4,3)
    hold on
    bar(2,d_diff_sqC(6),1,'FaceColor',difficultclr)
    bar(4,e_diff_sqC(6),1,'FaceColor',easyclr)
    errorbar(2,d_diff_sqC(6),sem_d_diff_sqC(6),'.','Color',[0 0 0])
    errorbar(4,e_diff_sqC(6),sem_e_diff_sqC(6),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',2:2:4,'XTickLabel',{'C','F'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.1:.3,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([0 6])
    ylim([0 0.3])
    ylabel('Choice 1 - Choice 2')
    title('250ms')

    subplot(1,4,4)
    hold on
    bar(2,d_diff_sqP(6),1,'FaceColor',difficultclr)
    bar(4,e_diff_sqP(6),1,'FaceColor',easyclr)
    errorbar(2,d_diff_sqP(6),sem_d_diff_sqP(6),'.','Color',[0 0 0])
    errorbar(4,e_diff_sqP(6),sem_e_diff_sqP(6),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',2:2:4,'XTickLabel',{'C','F'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.15:.45,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    ylabel('P1 - P2')
    xlim([0 6])
    ylim([0 0.45])
    namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\difference\p1p2c1c2DiffBar_SQ_2TA'],'\',filesep));
    print ('-dpdf', '-r500',namefig);  
else
    figure; 
    subplot(1,2,1)
    hold on
    bar(2,nanmean(d_diff_sqC),1,'FaceColor',difficultclr)
    errorbar(2,nanmean(d_diff_sqC),nanmean(sem_d_diff_sqC),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',1:2:3,'XTickLabel',{'','observers',''},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.1:.3,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    ylabel('Choice 1 - Choice 2')
    xlim([1 3])
    ylim([0 0.3])
    title('Control Exp')

    subplot(1,2,2)
    hold on
    bar(2,nanmean(d_diff_sqP),1,'FaceColor',difficultclr)
    errorbar(2,nanmean(d_diff_sqP),nanmean(sem_d_diff_sqP),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',1:2:3,'XTickLabel',{'','observers',''},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',-.45:.15:.45,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([1 3])
    ylim([-0.45 0.45])
    ylabel('P1 - P2')
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2c1c2DiffBar'],'\',filesep));
    print ('-dpdf', '-r500',namefig); 
end


keyboard
end