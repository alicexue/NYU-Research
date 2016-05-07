function differences_scatterplot()

dir_name = setup_dir();

easyclr = [255 102 0]/255;
difficultclr = [0 0 204]/255;

%% Get data
[e_sqC1,e_sqC2] = overall_probe_performance(2,2,'easy',1);
[d_sqC1,d_sqC2] = overall_probe_performance(2,2,'difficult',1);
[e_sqP1,e_sqP2,d_sqP1,d_sqP2] = plot_diff_p1p2(2,2,false);

e_diff_sqC = rot90(mean(e_sqC1-e_sqC2,1));
d_diff_sqC = rot90(mean(d_sqC1-d_sqC2,1));

e_diff_sqP = rot90(mean(e_sqP1-e_sqP2,1));
d_diff_sqP = rot90(mean(d_sqP1-d_sqP2,1));

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
h = refline(-1,0);
h.Color = [1 1 1]*0.4;
h = refline(0,0);
h.Color = [0 0 0];
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
h = refline(-1,0);
h.Color = [1 1 1]*0.4;
h = refline(0,0);
h.Color = [0 0 0];
title('Feature')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\difference\p1p2c1c2DiffScatter_SQ_2TA'],'\',filesep));
print ('-dpdf', '-r500',namefig);  

% [h,p,ci,stats] = ttest(e_diff_sqC,e_diff_sqP)
[RHO,PVAL] = corr(e_diff_sqC,e_diff_sqP)

% [h,p,ci,stats] = ttest(d_diff_sqC,d_diff_sqP)
[RHO,PVAL] = corr(d_diff_sqC,d_diff_sqP)


%% Plot bar graphs for c1-c2 and p1-p2 for square configuration
e_diff_sqC = mean(e_sqC1-e_sqC2,2);
d_diff_sqC = mean(d_sqC1-d_sqC2,2);

e_diff_sqP = mean(e_sqP1-e_sqP2,2);
d_diff_sqP = mean(d_sqP1-d_sqP2,2);

tmp = e_sqC1-e_sqC2;
numObs = size(tmp,2);
sem_e_diff_sqC = std(tmp,[],2)./sqrt(numObs);
tmp = d_sqC1-d_sqC2;
sem_d_diff_sqC = std(tmp,[],2)./sqrt(numObs);

tmp = e_sqP1-e_sqP2;
sem_e_diff_sqP = std(tmp,[],2)./sqrt(numObs);
tmp = d_sqP1-d_sqP2;
sem_d_diff_sqP = std(tmp,[],2)./sqrt(numObs);

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
end