function [rt4,rt8,perf4,perf8] = search_slope(date,obs,block_tocheck,task)
%%% GOOD ONE
%%% Example of entry parameters to the function
% date: '140604'
% obs: 'test'
% block_tocheck: 1
% condition: 'contrast10 eccentricity4' %%% This is to inform the graph, i.e. to save this in the name of the graph

%% Load data

if block_tocheck < 10
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\' date '_stim0' num2str(block_tocheck) '.mat'])
else
    load(['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\' date '_stim' num2str(block_tocheck) '.mat'])
end

%% Transform data
exp = getTaskParameters(myscreen,task);

%% Compute reaction time according to the set size
setsize = 4:4:8;

size4 = exp.randVars.setsize==4;
size8 = exp.randVars.setsize==8;

rt4 = nanmean(exp.reactionTime(size4));
rt8 = nanmean(exp.reactionTime(size8));

rt4_sd = nanstd(exp.reactionTime(size4))/sqrt(size(exp.reactionTime(size4),2));
rt8_sd = nanstd(exp.reactionTime(size8))/sqrt(size(exp.reactionTime(size8),2));

%% Compute performance accoding to the set size
for n = 1:size(exp.randVars.targetOrientation,2)
    if (exp.randVars.targetOrientation(n) == 1 && exp.response(n) == 1) || (exp.randVars.targetOrientation(n) == 2 && exp.response(n) == 2)
        perf(n) = 1;
    else
        perf(n) = 0;
    end
end

perf4 = mean(perf(size4));
perf8 = mean(perf(size8));

perf4_std = std(perf(size4))/sqrt(size(perf(size4),2));
perf8_std = std(perf(size8))/sqrt(size(perf(size8),2));

%% Plot the rt data
rt = [rt4 rt8];
rt_sd = [rt4_sd rt8_sd];

% figure;hold on;
% errorbar(setsize,rt*1000,rt_sd*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
% 
% xlim([3 9])
% set(gca,'XTick', 4:4:8)
% ylim([0 2000])
% %set(gca,'YTick', 50:10:100)
% 
% % title([obs ' ' condition],'FontSize',14)
% xlabel('Set size','FontSize',12)
% ylabel('Reaction time (ms)','FontSize',12)


%% Save the rt data
% if block_tocheck < 10
% namefig=sprintf(['/Users/hyunjinoh/Desktop/Jane/MATLAB/data/' obs '/' date '_stim0' num2str(block_tocheck) '_RT']);
% elseif block_tocheck >= 10
% namefig=sprintf(['/Users/hyunjinoh/Desktop/Jane/MATLAB/data/' obs '/' date '_stim' num2str(block_tocheck) '_RT']);
% end
% print ('-djpeg', '-r500',namefig);
%% Plot the perf data
p = [perf4 perf8];
p_sd = [perf4_std perf8_std];

% figure;hold on;
% errorbar(setsize,p*100,p_sd*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
% 
% xlim([3 9])
% set(gca,'XTick', 4:4:8)
% ylim([0 100])
% set(gca,'YTick', 50:10:100)
% 
% % title([obs ' ' condition],'FontSize',14)
% xlabel('Set size','FontSize',12)
% ylabel('Percent correct','FontSize',12)

%% Save the perf data

% if block_tocheck < 10
% namefig=sprintf(['/Users/hyunjinoh/Desktop/Jane/MATLAB/data/' obs '/' date '_stim0' num2str(block_tocheck) '_perf']);
% elseif block_tocheck >= 10
% namefig=sprintf(['/Users/hyunjinoh/Desktop/Jane/MATLAB/data/' obs '/' date '_stim' num2str(block_tocheck) '_perf' ]);
% end
% print ('-djpeg', '-r500',namefig);

end