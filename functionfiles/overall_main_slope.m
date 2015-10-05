function overall_main_slope(task)
%% Example
% overall_main_slope('easy');

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Load the data
all_rt=[];
all_p=[];

numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [rt,p] = p_main_slope(obs,task,false);
        if ~isnan(p)
            all_rt = horzcat(all_rt,rot90(rt,-1));
            all_p = horzcat(all_p,rot90(p,-1));
            numObs = numObs + 1;
        end
    end
end

rt_m = mean(all_rt,2);
p_m = mean(all_p,2);

rt_sem = std(all_rt,[],2)./sqrt(numObs);
p_sem = std(all_p,[],2)./sqrt(numObs);

%% Plot rt
figure; hold on;

for i=1:numObs
    plot(100:30:460,all_rt(:,i)*1000,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8)
end

errorbar(100:30:460,rt_m*1000,rt_sem*1000,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

legend('obs 1','obs 2','obs 3','obs 4','obs 5','average','Location','NorthEast')

ylim([0 2000])
set(gca,'YTick', 0:500:2000,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
title([condition ' Reaction Time (n = ' num2str(numObs) ')'],'FontSize',20)
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('RT [ms] ','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_rtDelays']);
print ('-djpeg', '-r500',namefig);

%% Plot performance
figure; hold on;

for i=1:numObs
    plot(100:30:460,all_p(:,i)*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8)
end

errorbar(100:30:460,p_m*100,p_sem*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

legend('obs 1','obs 2','obs 3','obs 4','obs 5','average','Location','SouthEast')

ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Performance (n = ' num2str(numObs) ')'],'FontSize',20)
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_PerfDelays']);
print ('-djpeg', '-r500',namefig);

end