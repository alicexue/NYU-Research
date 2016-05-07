function pre_exp_scatterplot(configuration)
%% Example
%%% pre_exp_scatterplot(2)

%% Setup for saving figures
dir_name = setup_dir();
saveFileLoc = '\target present or absent';
if configuration == 1
    saveFileName = '';
elseif configuration == 2
    saveFileName = '_SQ';
elseif configuration == 3
    saveFileName = '_DMD';
end

%% Set colors
easy4 = [255 170 0]/255;
easy8 = [255 102 0]/255;
difficult4 = [0 170 255]/255;
difficult8 = [0 0 204]/255;

%% Get data
[easy_rt_tp,easy_perf_tp,difficult_rt_tp,difficult_perf_tp] = overall_search_slope(2,1,configuration,false,false,'ad',false);
[easy_rt_ta,easy_perf_ta,difficult_rt_ta,difficult_perf_ta] = overall_search_slope(2,2,configuration,false,false,'ad',false);

%% Plot scatterplots
figure; hold on;
scatter(easy_rt_ta(1,:)*1000,easy_rt_tp(1,:)*1000,'MarkerEdgeColor',easy4)
scatter(easy_rt_ta(2,:)*1000,easy_rt_tp(2,:)*1000,'MarkerEdgeColor',easy8)
scatter(difficult_rt_ta(1,:)*1000,difficult_rt_tp(1,:)*1000,'MarkerEdgeColor',difficult4)
scatter(difficult_rt_ta(2,:)*1000,difficult_rt_tp(2,:)*1000,'MarkerEdgeColor',difficult8)
set(gca,'XTick',0:100:400,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',0:100:400,'FontSize',18,'LineWidth',2','Fontname','Ariel')
xlim([0 400])
ylim([0 400])
xlabel('RT for Target Absent (ms)','FontSize',20,'Fontname','Ariel')
ylabel('RT for Target Present (ms)','FontSize',18,'Fontname','Ariel')
h = refline(1,0);
h.Color = [1 1 1]*0.4;
% legend('Feature Set Size 4','Feature Set Size 8','Conjunction Set Size 4','Conjunction Set Size 8')
title('Reaction Time')
namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\pre-exp\rt' saveFileName],'\',filesep));    
print ('-dpdf', '-r500',namefig);    


figure; hold on;
scatter(easy_perf_ta(1,:)*100,easy_perf_tp(1,:)*100,'MarkerEdgeColor',easy4)
scatter(easy_perf_ta(2,:)*100,easy_perf_tp(2,:)*100,'MarkerEdgeColor',easy8)
scatter(difficult_perf_ta(1,:)*100,difficult_perf_tp(1,:)*100,'MarkerEdgeColor',difficult4)
scatter(difficult_perf_ta(2,:)*100,difficult_perf_tp(2,:)*100,'MarkerEdgeColor',difficult8)
set(gca,'XTick',20:20:100,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',20:20:100,'FontSize',18,'LineWidth',2','Fontname','Ariel')
xlim([20 100])
ylim([20 100])
xlabel('Accuracy for Target Absent','FontSize',20,'Fontname','Ariel')
ylabel('Accuracy for Target Present','FontSize',18,'Fontname','Ariel')
h = refline(1,0);
h.Color = [1 1 1]*0.4;
% legend('Feature Set Size 4','Feature Set Size 8','Conjunction Set Size 4','Conjunction Set Size 8')
title('Performance')
namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\pre-exp\perf' saveFileName],'\',filesep));    
print ('-dpdf', '-r500',namefig);

tp_p = rot90(horzcat(difficult_perf_tp(1,:),difficult_perf_tp(2,:)))
ta_p = rot90(horzcat(difficult_perf_ta(1,:),difficult_perf_ta(2,:)))
% tp_p = rot90(horzcat(easy_perf_tp(1,:),easy_perf_tp(2,:),difficult_perf_tp(1,:),difficult_perf_tp(2,:)))
% ta_p = rot90(horzcat(easy_perf_ta(1,:),easy_perf_ta(2,:),difficult_perf_ta(1,:),difficult_perf_ta(2,:)))
[h,p,ci,stats] = ttest(tp_p,ta_p)
mean(tp_p,1)
mean(ta_p,1)

tp_rt = rot90(horzcat(difficult_rt_tp(1,:),difficult_rt_tp(2,:)))
ta_rt = rot90(horzcat(difficult_rt_ta(1,:),difficult_rt_ta(2,:)))
% tp_rt = rot90(horzcat(easy_rt_tp(1,:),easy_rt_tp(2,:),difficult_rt_tp(1,:),difficult_rt_tp(2,:)))
% ta_rt = rot90(horzcat(easy_rt_ta(1,:),easy_rt_ta(2,:),difficult_rt_ta(1,:),difficult_rt_ta(2,:)))
[h,p,ci,stats] = ttest(tp_rt,ta_rt)
mean(tp_rt,1)
mean(ta_rt,1)
keyboard
end