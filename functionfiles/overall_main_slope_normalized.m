function overall_main_slope_normalized()
%% Get data
dir_name = setup_dir();
[easy_tp_rt,easy_tp_p,easy_tp_pairs] = overall_main_slope('easy',2,1,false);
[easy_ta_rt,easy_ta_p,easy_cr_pairs] = overall_main_slope('easy',2,2,false);
[difficult_tp_rt,difficult_tp_p,difficult_tp_pairs] = overall_main_slope('difficult',2,1,false);
[difficult_ta_rt,difficult_ta_p,difficult_cr_pairs] = overall_main_slope('difficult',2,2,false);

[~,easy_tpD_p,~] = overall_main_slope('easy',2,4,false);
[~,difficult_tpD_p,~] = overall_main_slope('difficult',2,4,false);

[~,~,easy_pairs] = overall_main_slope('easy',2,3,false);
[~,~,difficult_pairs] = overall_main_slope('difficult',2,3,false);

%% Set line colors
easyclrTP = [255 191 0]/255;
difficultclrTP = [51 153 255]/255;
easyclrTA = [255 102 0]/255;
difficultclrTA = [0 0 204]/255;
easyclr = [204 41 0]/255;
difficultclr = [0 128 128]/255;

%% Normalize data
numObs = size(easy_tp_rt,2);
for obs=1:numObs
    e_tp_rt(:,obs) = normalize(easy_tp_rt,obs);
    e_tp_p(:,obs) = normalize(easy_tp_p,obs);
    e_ta_rt(:,obs) = normalize(easy_ta_rt,obs);
    e_ta_p(:,obs) = normalize(easy_ta_p,obs);
    d_tp_rt(:,obs) = normalize(difficult_tp_rt,obs);
    d_tp_p(:,obs) = normalize(difficult_tp_p,obs);
    d_ta_rt(:,obs) = normalize(difficult_ta_rt,obs);
    d_ta_p(:,obs) = normalize(difficult_ta_p,obs);    
end

s_e_tp_rt = std(e_tp_rt,[],2)/sqrt(numObs);
s_e_tp_p = std(e_tp_p,[],2)/sqrt(numObs);
s_e_ta_rt = std(e_ta_rt,[],2)/sqrt(numObs);
s_e_ta_p = std(e_ta_p,[],2)/sqrt(numObs);
s_d_tp_rt = std(d_tp_rt,[],2)/sqrt(numObs);
s_d_tp_p = std(d_tp_p,[],2)/sqrt(numObs);
s_d_ta_rt = std(d_ta_rt,[],2)/sqrt(numObs);
s_d_ta_p = std(d_ta_p,[],2)/sqrt(numObs);

e_tp_rt = mean(e_tp_rt,2);
e_tp_p = mean(e_tp_p,2);
e_ta_rt = mean(e_ta_rt,2);
e_ta_p = mean(e_ta_p,2);
d_tp_rt = mean(d_tp_rt,2);
d_tp_p = mean(d_tp_p,2);
d_ta_rt = mean(d_ta_rt,2);
d_ta_p = mean(d_ta_p,2);

%% Without normalizing
s_easy_tp_rt = std(easy_tp_rt,[],2)/sqrt(numObs);
s_easy_tp_p = std(easy_tp_p,[],2)/sqrt(numObs);
s_easy_ta_rt = std(easy_ta_rt,[],2)/sqrt(numObs);
s_easy_ta_p = std(easy_ta_p,[],2)/sqrt(numObs);
s_difficult_tp_rt = std(difficult_tp_rt,[],2)/sqrt(numObs);
s_difficult_tp_p = std(difficult_tp_p,[],2)/sqrt(numObs);
s_difficult_ta_rt = std(difficult_ta_rt,[],2)/sqrt(numObs);
s_difficult_ta_p = std(difficult_ta_p,[],2)/sqrt(numObs);

m_easy_tp_rt = mean(easy_tp_rt,2);
m_easy_tp_p = mean(easy_tp_p,2);
m_easy_ta_rt = mean(easy_ta_rt,2);
m_easy_ta_p = mean(easy_ta_p,2);
m_difficult_tp_rt = mean(difficult_tp_rt,2);
m_difficult_tp_p = mean(difficult_tp_p,2);
m_difficult_ta_rt = mean(difficult_ta_rt,2);
m_difficult_ta_p = mean(difficult_ta_p,2);

s_easy_tpD_p = std(easy_tpD_p,[],2)/sqrt(numObs);
s_difficult_tpD_p = std(difficult_tpD_p,[],2)/sqrt(numObs);
m_easy_tpD_p = mean(easy_tpD_p,2);
m_difficult_tpD_p = mean(difficult_tpD_p,2);

%% Plot rt for TA   
figure;hold on;

errorbar(100:30:460,m_easy_ta_rt*1000,s_easy_ta_rt*1000,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTA)
errorbar(100:30:460,m_difficult_ta_rt*1000,s_difficult_ta_rt*1000,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTA)

legend('Feature','Conjunction','Location','SouthWest')

ylim([0 1000])
set(gca,'YTick', 0:200:1000,'FontSize',15,'LineWidth',2,'Fontname','Ariel')   
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('RT [ms]','FontSize',20,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
xlim([0 500])

title('Main Search Reaction Time','FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\rtDelays'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Plot performance for TA   
figure;hold on;

errorbar(100:30:460,m_easy_ta_p*100,s_easy_ta_p*100,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTA)
errorbar(100:30:460,m_difficult_ta_p*100,s_difficult_ta_p*100,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTA)

legend('Feature','Conjunction','Location','SouthWest')

set(gca,'YTick',50:10:100,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([50 100])
xlim([0 500])
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
title('Main Search Performance','FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\perfDelays'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% RMAOV2 on TA RT
numObs = size(easy_ta_rt,2);
data = zeros(numObs*13*2,4);
index = 0;
fprintf('------------------------------------------------------\n')
fprintf('TARGET ABSENT - REACTION TIME\n')
for i = 1:numObs
    data(index+1:index+13,1) = easy_ta_rt(:,i);
    data(index+1:index+13,2) = rot90(1:13,-1);
    data(index+1:index+13,3) = ones(13,1);
    data(index+1:index+13,4) = ones(13,1)*i;
    index = index + 13;
    data(index+1:index+13,1) = difficult_ta_rt(:,i);
    data(index+1:index+13,2) = rot90(1:13,-1);
    data(index+1:index+13,3) = ones(13,1)*2;
    data(index+1:index+13,4) = ones(13,1)*i;
    index = index + 13;
end
RMAOV2(data);  

data = zeros(numObs*13*2,4);
index = 0;
fprintf('------------------------------------------------------\n')
fprintf('TARGET ABSENT - PERFORMANCE\n')
for i = 1:numObs
    data(index+1:index+13,1) = easy_ta_p(:,i);
    data(index+1:index+13,2) = rot90(1:13,-1);
    data(index+1:index+13,3) = ones(13,1);
    data(index+1:index+13,4) = ones(13,1)*i;
    index = index + 13;
    data(index+1:index+13,1) = difficult_ta_p(:,i);
    data(index+1:index+13,2) = rot90(1:13,-1);
    data(index+1:index+13,3) = ones(13,1)*2;
    data(index+1:index+13,4) = ones(13,1)*i;
    index = index + 13;
end
RMAOV2(data);  

%% Scatter plot for each individual observer (different color for each obs)
% figure; hold on;
% for i=1:size(easy_ta_rt,2)
%     scatter(easy_ta_rt(:,i),easy_tp_rt(:,i))
%     scatter(difficult_ta_rt(:,i),difficult_tp_rt(:,i))
% end
% h = refline(1,0);
% h.Color = [1 1 1]*0.4;

e_scatter_rt_x = [];
e_scatter_rt_y = [];
e_scatter_p_x = [];
e_scatter_p_y = [];
d_scatter_rt_x = [];
d_scatter_rt_y = [];
d_scatter_p_x = [];
d_scatter_p_y = [];

for i=1:size(easy_ta_rt,2)
    e_scatter_rt_x = cat(1,e_scatter_rt_x,easy_ta_rt(:,i));
    e_scatter_rt_y = cat(1,e_scatter_rt_y,easy_tp_rt(:,i));
    
    e_scatter_p_x = cat(1,e_scatter_p_x,easy_ta_p(:,i));
    e_scatter_p_y = cat(1,e_scatter_p_y,easy_tp_p(:,i));
    
    d_scatter_rt_x = cat(1,d_scatter_rt_x,difficult_ta_rt(:,i));
    d_scatter_rt_y = cat(1,d_scatter_rt_y,difficult_tp_rt(:,i));
    
    d_scatter_p_x = cat(1,d_scatter_p_x,difficult_ta_p(:,i));
    d_scatter_p_y = cat(1,d_scatter_p_y,difficult_tp_p(:,i));
end

%% Scatter plot showing all individual observers (separated by F/C)
figure; hold on;
scatter(e_scatter_rt_x,e_scatter_rt_y,'MarkerEdgeColor',easyclrTA)
scatter(d_scatter_rt_x,d_scatter_rt_y,'MarkerEdgeColor',difficultclrTA)
h = refline(1,0);
h.Color = [1 1 1]*0.4;

figure; hold on;
scatter(e_scatter_p_x,e_scatter_p_y,'MarkerEdgeColor',easyclrTA)
scatter(d_scatter_p_x,d_scatter_p_y,'MarkerEdgeColor',difficultclrTA)
h = refline(1,0);
h.Color = [1 1 1]*0.4;

%% Scatter plot for average across observers
figure; hold on;
scatter(mean(easy_ta_rt,1),mean(easy_tp_rt,1),'MarkerEdgeColor',easyclrTA)
scatter(mean(difficult_ta_rt,1),mean(difficult_tp_rt,1),'MarkerEdgeColor',difficultclrTA)
h = refline(1,0);
h.Color = [1 1 1]*0.4;

figure; hold on;
scatter(mean(easy_ta_p,2),mean(easy_tp_p,2),'MarkerEdgeColor',easyclrTA)
scatter(mean(difficult_ta_p,2),mean(difficult_tp_p,2),'MarkerEdgeColor',difficultclrTA)
h = refline(1,0);
h.Color = [1 1 1]*0.4;

%% Plot rt for feature TP and TA   
figure;hold on;

errorbar(100:30:460,m_easy_tp_rt*1000,s_easy_tp_rt*1000,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTP)
errorbar(100:30:460,m_easy_tp_rt*1000,s_easy_ta_rt*1000,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTA)

legend('Target Present','Target Absent')

ylim([500 900])
set(gca,'YTick', 500:100:900,'FontSize',15,'LineWidth',2,'Fontname','Ariel')   
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Reaction Time','FontSize',20,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
xlim([0 500])

title('Feature Main Search Reaction Time','FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Feature_rtDelays'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Plot rt for conjunction TP and TA   
figure;hold on;

errorbar(100:30:460,m_difficult_tp_rt*1000,s_difficult_tp_rt*1000,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTP)
errorbar(100:30:460,m_difficult_ta_rt*1000,s_difficult_ta_rt*1000,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTA)

legend('Target Present','Target Absent')

ylim([500 900])
set(gca,'YTick', 500:100:900,'FontSize',15,'LineWidth',2,'Fontname','Ariel')     
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Reaction Time','FontSize',20,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')

xlim([0 500])

title('Conjunction Main Search Reaction Time','FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Conjunction_rtDelays'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Normalized
% %% Plot rt for feature and conjunction, TP and TA   
% figure;hold on;
% 
% errorbar(100:30:460,e_tp_rt,s_e_tp_rt,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTP)
% errorbar(100:30:460,e_ta_rt,s_e_ta_rt,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTA)
% errorbar(100:30:460,d_tp_rt,s_d_tp_rt,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTP)
% errorbar(100:30:460,d_ta_rt,s_d_ta_rt,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTA)
% 
% % legend('Feature Target Present','Feature Target Absent','Conjunction Target Present','Conjunction Target Absent')
% 
% % set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
% set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')
% 
% ylabel('Normalized Reaction Time','FontSize',20,'Fontname','Ariel')
% xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
% % ylim([0 1])
% xlim([0 500])
% 
% title('Main Search Reaction Time','FontSize',20,'Fontname','Ariel')
% 
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\rtDelaysN'],'\',filesep));
% print ('-dpdf', '-r500',namefig);

% %% Plot performance for feature/conjunction, TP and TA   
% figure;hold on;
% 
% errorbar(100:30:460,e_tp_p,s_e_tp_p,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTP)
% errorbar(100:30:460,e_ta_p,s_e_ta_p,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTA)
% errorbar(100:30:460,d_tp_p,s_d_tp_p,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTP)
% errorbar(100:30:460,d_ta_p,s_d_ta_p,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTA)
% 
% % legend('Feature Target Present','Feature Target Absent','Conjunction Target Present','Conjunction Target Absent')
% 
% % set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
% set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')
% 
% ylabel('Normalized Accuracy','FontSize',18,'Fontname','Ariel')
% xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
% % ylim([0 1])
% xlim([0 500])
% 
% title('Main Search Performance','FontSize',20,'Fontname','Ariel')
% 
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\perfDelaysN'],'\',filesep));
% print ('-dpdf', '-r500',namefig);

%% Plot performance for feature, TP and TA   
figure;hold on;

errorbar(100:30:460,m_easy_tp_p,s_easy_tp_p,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTP)
errorbar(100:30:460,m_easy_ta_p,s_easy_ta_p,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTA)

legend('Target Present','Target Absent')

% set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Normalized Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
% ylim([0 1])
xlim([0 500])

title('Main Search Performance','FontSize',20,'Fontname','Ariel')
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Feature_perfDelaysN'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Plot performance for conjunction, TP and TA   
figure;hold on;

errorbar(100:30:460,m_difficult_tp_p,s_difficult_tp_p,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTP)
errorbar(100:30:460,m_difficult_ta_p,s_difficult_ta_p,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTA)

legend('Target Present','Target Absent')

% set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Normalized Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
% ylim([0 1])
xlim([0 500])
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
title('Conjunction Main Search Performance','FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Conjunction_perfDelaysN'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Plot feature difference between TP and TA (discrimination)
sem_diff = std(easy_tp_p - easy_ta_p,[],2)/sqrt(numObs);
figure;hold on;
errorbar(100:30:460,m_easy_tp_p - m_easy_ta_p,sem_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTP)

[sig] = diff_ttest(cat(3,easy_tp_p,easy_ta_p),false);
for i=1:size(sig,1)
    for j=1:size(sig,3)
        y = -0.05;
        if sig(i,1,j) <= 0.05/13
            plot((i-1)*30+100,y,'*','Color',[0 0 0])
        elseif sig(i,1,j) <= 0.05
            plot((i-1)*30+100,y,'+','Color',[0 0 0])
        end
    end
end

set(gca,'YTick',-.1:.05:.15,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([-.1 .15])
xlim([0 500])

title('Feature Main Search Performance - Discrimination','FontSize',20,'Fontname','Ariel')
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Feature_perfDelaysDiff_discrimination'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Plot difficult difference between TP and TA (discrimination)
sem_diff = std(difficult_tp_p - difficult_ta_p,[],2)/sqrt(numObs);
figure;hold on;
errorbar(100:30:460,m_difficult_tp_p - m_difficult_ta_p,sem_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTP)

[sig] = diff_ttest(cat(3,difficult_tp_p,difficult_ta_p),false);
for i=1:size(sig,1)
    for j=1:size(sig,3)
        y = -0.05;
        if sig(i,1,j) <= 0.05/13
            plot((i-1)*30+100,y,'*','Color',[0 0 0])
        elseif sig(i,1,j) <= 0.05
            plot((i-1)*30+100,y,'+','Color',[0 0 0])
        end
    end
end

set(gca,'YTick',-.1:.05:.15,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([-.1 .15])
xlim([0 500])

title('Conjunction Main Search Performance - Discrimination','FontSize',20,'Fontname','Ariel')
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Conjunction_perfDelaysDiff_discrimination'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Plot feature difference between TP and TA (detection)
sem_diff = std(easy_tpD_p - easy_ta_p,[],2)/sqrt(numObs);
figure;hold on;
errorbar(100:30:460,m_easy_tpD_p - m_easy_ta_p,sem_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTP)

[sig] = diff_ttest(cat(3,easy_tpD_p,easy_ta_p),false);
for i=1:size(sig,1)
    for j=1:size(sig,3)
        y = -0.05;
        if sig(i,1,j) <= 0.05/13
            plot((i-1)*30+100,y,'*','Color',[0 0 0])
        elseif sig(i,1,j) <= 0.05
            plot((i-1)*30+100,y,'+','Color',[0 0 0])
        end
    end
end

set(gca,'YTick',-.1:.05:.15,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([-.1 .15])
xlim([0 500])

title('Feature Main Search Performance - Detection','FontSize',20,'Fontname','Ariel')
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Feature_perfDelaysDiff_detection'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Plot conjunction difference between TP and TA (detection)
sem_diff = std(difficult_tpD_p - difficult_ta_p,[],2)/sqrt(numObs);
figure;hold on;
errorbar(100:30:460,m_difficult_tpD_p - m_difficult_ta_p,sem_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTP)

[sig] = diff_ttest(cat(3,difficult_tpD_p,difficult_ta_p),false);
for i=1:size(sig,1)
    for j=1:size(sig,3)
        y = -0.05;
        if sig(i,1,j) <= 0.05/13
            plot((i-1)*30+100,y,'*','Color',[0 0 0])
        elseif sig(i,1,j) <= 0.05
            plot((i-1)*30+100,y,'+','Color',[0 0 0])
        end
    end
end

set(gca,'YTick',-.1:.05:.15,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([-.1 .15])
xlim([0 500])

title('Conjunction Main Search Performance - Detection','FontSize',20,'Fontname','Ariel')
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Conjunction_perfDelaysDiff_detection'],'\',filesep));
print ('-dpdf', '-r500',namefig);


%% Plot SQUARE overall perf, hits, correct rejections
e_sq = nanmean(easy_pairs(:,:,1:6),3);
% sem_e_sq = std(e_sq,[],2)./numObs;
e_sq = nanmean(e_sq,2);
d_sq = nanmean(difficult_pairs(:,:,1:6),3);
% sem_d_sq = std(d_sq,[],2)./numObs;
d_sq = nanmean(d_sq,2);

e_tp_sq = nanmean(easy_tp_pairs(:,:,1:6),3);
sem_e_tp_sq = std(e_tp_sq,[],2)./numObs;
e_tp_sq = nanmean(e_tp_sq,2);

d_tp_sq = nanmean(difficult_tp_pairs(:,:,1:6),3);
sem_d_tp_sq = std(d_tp_sq,[],2)./numObs;
d_tp_sq = nanmean(d_tp_sq,2);

e_cr_sq = nanmean(easy_cr_pairs(:,:,1:6),3);
sem_e_cr_sq = std(e_cr_sq,[],2)./numObs;
e_cr_sq = nanmean(e_sq,2);

d_cr_sq = nanmean(difficult_cr_pairs(:,:,1:6),3);
sem_d_cr_sq = std(d_cr_sq,[],2)./numObs;
d_cr_sq = nanmean(d_cr_sq,2);

figure; hold on;
errorbar(100:30:460,e_tp_sq,sem_e_tp_sq,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTP)
errorbar(100:30:460,e_cr_sq,sem_e_cr_sq,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclrTA)
plot(100:30:460,e_sq,'--','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',easyclr)

legend('Hits','Correct Rejections','Overall Performance','Location','SouthWest')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Performance Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([0 1])
xlim([0 500])
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
title('Feature Main Search Performance on Square','FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Feature_perfDelaysAllSQ'],'\',filesep));
print ('-dpdf', '-r500',namefig);

figure; hold on;
errorbar(100:30:460,d_tp_sq,sem_d_tp_sq,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTP)
errorbar(100:30:460,d_cr_sq,sem_d_cr_sq,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclrTA)
plot(100:30:460,d_sq,'--','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',difficultclr)

legend('Hits','Correct Rejections','Overall Performance','Location','SouthWest')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Performance Accuracy','FontSize',18,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([0 1])
xlim([0 500])
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
title('Conjunction Main Search Performance on Square','FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\main-exp\Conjunction_perfDelaysAllSQ'],'\',filesep));
print ('-dpdf', '-r500',namefig);
keyboard
end

function [nrmlzd] = normalize(all_delays,obs)
    m_obs_delays = mean(all_delays(:,obs),1);
    nrmlzd = all_delays(:,obs) - m_obs_delays;
end