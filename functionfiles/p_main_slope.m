function [rt_median,perf_avg] = p_main_slope(obs,task)
%% Example
% p_main_slope('ax','difficult');

%% Parameters
% obs = 'ax';
% task = 'difficult';

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain perf for each run and concatenate over each run
perf_avg = zeros(13,10000);
rt_median = [];
c = 1;

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task]);  
for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL > 4 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [perfDelays,rtDelays] = main_slope(obs,task,filename);
        perf_avg(:,c) = perfDelays; 
        rt_median = horzcat(rt_median,rtDelays);
        c = c + 1;
    end
end
perf_avg = perf_avg(:,1:c-1);

%% Plot rt
figure; hold on;
rt = zeros(1,13);
rt_sem = zeros(1,13);
for delay = 1:size(rt_median,1)
    rt(1,delay) = median(rt_median(delay,:));
end
rt_sem(1,delay) = (std(rt)/sqrt(size(rt_median,2)));

errorbar(100:30:460,rt*1000,rt_sem*1000,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

ylim([0 2000])
set(gca,'YTick', 0:500:2000,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
title([condition ' Reaction Time (' obs ')'],'FontSize',20)
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('RT [ms] ','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_rtDelays']);
print ('-djpeg', '-r500',namefig);

%% Plot performance
figure; hold on;
p = zeros(1,13);
p_sem = zeros(1,13);
for delay = 1:size(perf_avg,1)
    p(delay) = mean(perf_avg(delay,:));
    p_sem(delay) = (std(perf_avg(delay,:))/sqrt(size(perf_avg,2)));
end

errorbar(100:30:460,p*100,p_sem*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Performance (' obs ')'],'FontSize',20)
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_PerfDelays']);
print ('-djpeg', '-r500',namefig);

end