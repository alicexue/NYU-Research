function avg_delay_comparison()

[~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,d_sq_TA_P1,d_sq_TA_P2,d_dmd_TA_P1,d_dmd_TA_P2,~,~] = overall_probe_analysis('difficult',2,2,false,false,false,false,false,false,1,true,0.1,0.3,{});
[~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,e_sq_TA_P1,e_sq_TA_P2,e_dmd_TA_P1,e_dmd_TA_P2,~,~] = overall_probe_analysis('easy',2,2,false,false,false,false,false,false,1,true,0.1,0.3,{});

[~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,d_sq_TP_P1,d_sq_TP_P2,d_dmd_TP_P1,d_dmd_TP_P2,~,~] = overall_probe_analysis('difficult',2,1,false,false,false,false,false,false,1,true,0.1,0.3,{});
[~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,e_sq_TP_P1,e_sq_TP_P2,e_dmd_TP_P1,e_dmd_TP_P2,~,~] = overall_probe_analysis('easy',2,1,false,false,false,false,false,false,1,true,0.1,0.3,{});

keyboard



dir_name = setup_dir();

numObs = size(d_sq_TA_P1,2);
d_p1clr = [0 0 204]/255;
d_p2clr = [0 170 255]/255;
e_p1clr = [204 51 0]/255;
e_p2clr = [255 128 0]/255;

figure; hold on;
for i=1:8
    if i == 1
        p1 = d_sq_TA_P1;
        p2 = d_sq_TA_P2;
    elseif i == 2
        p1 = e_sq_TA_P1;
        p2 = e_sq_TA_P2;
    elseif i == 3
        p1 = d_dmd_TA_P1;
        p2 = d_dmd_TA_P2;
    elseif i == 4
        p1 = e_dmd_TA_P1;
        p2 = e_dmd_TA_P2;
    elseif i == 5
        p1 = d_sq_TP_P1;
        p2 = d_sq_TP_P2;
    elseif i == 6
        p1 = e_sq_TP_P1;
        p2 = e_sq_TP_P2;
    elseif i == 7
        p1 = d_dmd_TP_P1;
        p2 = d_dmd_TP_P2;
    elseif i == 8
        p1 = e_dmd_TP_P1;
        p2 = e_dmd_TP_P2;
    end
    m_p1 = mean(mean(p1,2),1);
    m_p2 = mean(mean(p2,2),1);
    s_p1 = std(mean(p1,1),[],2)/sqrt(numObs);
    s_p2 = std(mean(p2,1),[],2)/sqrt(numObs);
    if mod(i,2) == 1
        p1_color = d_p1clr;
        p2_color = d_p2clr;
    else
        p1_color = e_p1clr;
        p2_color = e_p2clr;
    end
    errorbar(i,m_p1,s_p1,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1_color)
    errorbar(i,m_p2,s_p2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2_color)
end
set(gca,'XTick',1:1:8,'XTickLabel',{'sqTA','sqTA','diTA','diTA','sqTP','sqTP','diTP','diTP'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')    
ylim([0 1])
xlim([.5 8.5])
legend('Conjunction P1','Conjunction P2','Feature P1','Feature P2','Location','Best')

title('P1 and P2 Averaged Across Delays')
ylabel('Probe report probability')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\p1p2_avgAcrossDelays'],'\',filesep));
print ('-dpdf', '-r500',namefig);

d_diffclr = [0 108 43]/255;
e_diffclr = [0 190 36]/255;
pvals = [];
figure; hold on;
for i=1:8
    if i == 1
        p1 = d_sq_TA_P1;
        p2 = d_sq_TA_P2;
    elseif i == 2
        p1 = e_sq_TA_P1;
        p2 = e_sq_TA_P2;
    elseif i == 3
        p1 = d_dmd_TA_P1;
        p2 = d_dmd_TA_P2;
    elseif i == 4
        p1 = e_dmd_TA_P1;
        p2 = e_dmd_TA_P2;
    elseif i == 5
        p1 = d_sq_TP_P1;
        p2 = d_sq_TP_P2;
    elseif i == 6
        p1 = e_sq_TP_P1;
        p2 = e_sq_TP_P2;
    elseif i == 7
        p1 = d_dmd_TP_P1;
        p2 = d_dmd_TP_P2;
    elseif i == 8
        p1 = e_dmd_TP_P1;
        p2 = e_dmd_TP_P2;
    end
    m_p1 = mean(mean(p1,2),1);
    m_p2 = mean(mean(p2,2),1);
    m_diff = m_p1 - m_p2;
    s_diff = std(mean(p1-p2,1),[],2)/sqrt(numObs);
    if mod(i,2) == 1
        clr = d_diffclr;
    else
        clr = e_diffclr;
    end
    errorbar(i,m_diff,s_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',clr)
    [~,p] = ttest(rot90(mean(p1,1)),rot90(mean(p2,1)));
    pvals = horzcat(pvals,p);    
end
legend('Conjunction','Feature','Location','Best')
for i=1:size(pvals,2)
    if p < 0.05
       plot(i,-.05,'+','Color',[0 0 0])
    end
end

set(gca,'XTick',1:1:8,'XTickLabel',{'sqTA','sqTA','diTA','diTA','sqTP','sqTP','diTP','diTP'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
set(gca,'YTick',-.2:.2:.4,'FontSize',13,'LineWidth',2','Fontname','Ariel')    
ylim([-.2 .4])
xlim([.5 8.5])
legend('Conjunction','Feature','Location','Best')

title('Difference of P1 and P2 Averaged Across Delays')
ylabel('P1 - P2')

h = refline(0,0);
h.Color = [1 1 1]*0.4;
h.LineStyle = '--';

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\p1p2diff_avgAcrossDelays'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% TTest comparison for F/C
fprintf('SQ TA\n')
[h,p,~,~] = ttest(rot90(mean(d_sq_TA_P1-d_sq_TA_P2,1)),rot90(mean(e_sq_TA_P1-e_sq_TA_P2,1)))

fprintf('DMD TA\n')
[h,p,~,~] = ttest(rot90(mean(d_dmd_TA_P1-d_dmd_TA_P2,1)),rot90(mean(e_dmd_TA_P1-e_dmd_TA_P2,1)))

fprintf('SQ TP\n')
[h,p,~,~] = ttest(rot90(mean(d_sq_TP_P1-d_sq_TP_P2,1)),rot90(mean(e_sq_TP_P1-e_sq_TP_P2,1)))

fprintf('DMD TP\n')
[h,p,~,~] = ttest(rot90(mean(d_dmd_TP_P1-d_dmd_TP_P2,1)),rot90(mean(e_dmd_TP_P1-e_dmd_TP_P2,1)))


%% Compare P1 and P2
[controlP1,controlP2,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~] = overall_probe_analysis('difficult',3,2,false,false,false,false,false,false,1,true,0.1,0.3,{});


d_370P1 = d_sq_TA_P1(10,:);
d_370P2 = d_sq_TA_P2(10,:);
e_370P1 = e_sq_TA_P1(10,:);
e_370P2 = e_sq_TA_P2(10,:);

figure; hold on;
m_d370P1 = mean(d_370P1,2);
m_d370P2 = mean(d_370P2,2);
m_e370P1 = mean(e_370P1,2);
m_e370P2 = mean(e_370P2,2);
m_controlP1 = mean(controlP1,2);
m_controlP2 = mean(controlP2,2);

s_d370P1 = std(d_370P1,[],2)/sqrt(numObs);
s_d370P2 = std(d_370P2,[],2)/sqrt(numObs);
s_e370P1 = std(e_370P1,[],2)/sqrt(numObs);
s_e370P2 = std(e_370P2,[],2)/sqrt(numObs);
s_controlP1 = std(controlP1,[],2)/sqrt(numObs);
s_controlP2 = std(controlP2,[],2)/sqrt(numObs);

errorbar(1,m_d370P1,s_d370P1,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',d_p1clr)
errorbar(1,m_d370P2,s_d370P2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',d_p2clr)
errorbar(2,m_e370P1,s_e370P1,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',e_p1clr)
errorbar(2,m_e370P2,s_e370P2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',e_p2clr)
errorbar(3,m_controlP1(1,1),s_controlP1(1,1),'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
errorbar(3,m_controlP2(1,1),s_controlP2(1,1),'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[80 80 80]/255)

set(gca,'XTick',1:1:3,'XTickLabel',{'Conjunction','Feature','Control'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')    
ylim([0 1])
xlim([.5 3.5])
legend('Conjunction P1','Conjunction P2','Feature P1','Feature P2','Control P1','Control P2','Location','Best')

title('P1 and P2 Comparison')
ylabel('Probe report probability')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\p1p2_main_control_comparison'],'\',filesep));
print ('-dpdf', '-r500',namefig);

fprintf('Conjunction\n')
% [h,p,~,~] = ttest(rot90(d_370P1),rot90(d_370P2))
% [h,p,~,~] = ttest(rot90(d_370P1)-rot90(d_370P2),0,'Tail','right')
[h,p,~,~] = ttest(rot90(d_370P1),rot90(d_370P2),0.05,'right')

fprintf('Feature\n')
% [h,p,~,~] = ttest(rot90(e_370P1),rot90(e_370P2))
% [h,p,~,~] = ttest(rot90(e_370P1)-rot90(e_370P2),0,'Tail','right')
[h,p,~,~] = ttest(rot90(e_370P1),rot90(e_370P2),0.05,'right')

fprintf('Control\n')
% [h,p,~,~] = ttest(controlP1(1,:),controlP2(1,:))
% [h,p,~,~] = ttest(controlP1(1,:)-controlP2(1,:),0,'Tail','right')
[h,p,~,~] = ttest(controlP1(1,:),controlP2(1,:),0.05,'right')

keyboard
end