function p_perf1_slope(obs, task, date1, date2, maxBlockN)
%% Example
% p_perf1_slope('ax', 'difficult', '150716', '150721', 1)

%% Parameters
% obs = 'ax';
% task = 'difficult';
% date1 = '150716';
% date2 = '150721';
% maxBlockN = 1;

%% Change task name to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain perf for each run and concatenate over each run
date1num = str2double(date1);
date2num = str2double(date2);
numDates = date2num - date1num + 1;
perf_avg = zeros(15,numDates*2);
rt_median = [];
c = 1;
m = 1;
if numDates > 100
    m = fix((date2num - date1num)/100)+1;
end
for tmp = 1:m 
    n = fix(str2double(date1)/100)*100+((tmp-1)*100);
    if tmp~=1 && numDates > 100
        date1num = n;
        date2num = date1num+31;
    elseif tmp==1 && numDates > 100
        date2num = n+31;
    end
    for date = date1num:date2num
        for blockN = 0:maxBlockN
            if blockN < 10
                strTmp = ['0', num2str(blockN)];
            else
                strTmp = num2str(blockN);
            end  
            s = ['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task, '\', num2str(date), '_stim', strTmp, '.mat'];    
            exists = exist(s,'file');            
            if exists ~= 0
                [perfDelays,rtDelays] = perf1_slope(num2str(date),obs,blockN,task);
                perf_avg(:,c) = perfDelays; 
                rt_median = horzcat(rt_median,rtDelays);
                c = c + 1;
            end
        end
    end
end
perf_avg = perf_avg(:,1:c-1);
rt_median = rt_median(:,1:c-1);
%% Plot performance
figure; hold on;
p = zeros(1,15);
p_sem = zeros(1,15);
for delay = 1:size(perf_avg,1)
    p(delay) = mean(perf_avg(delay,:));
    p_sem(delay) = (std(perf_avg(delay,:))/sqrt(size(perf_avg,2)));
end

errorbar(1:1:15,p*100,p_sem*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

xlim([0 16])
set(gca,'XTick', 1:1:15,'FontSize',17,'LineWidth',2,'FontName','Times New Roman')
ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',17,'LineWidth',2,'FontName','Times New Roman')

title([condition ' Performance (' obs ')'],'FontSize',14)
xlabel('Trials','FontSize',15,'FontName','Times New Roman')
ylabel('Accuracy','FontSize',15,'FontName','Times New Roman')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_PerfDelays']);
print ('-djpeg', '-r500',namefig);

%% Plot rt
figure; hold on;
rt = zeros(1,15);
rt_sem = zeros(1,15);
for delay = 1:size(rt_median,1)
    rt(1,delay) = median(rt_median(delay,:));
    rt_sem(1,delay) = (std(rt_median(delay,:))/sqrt(size(rt_median,2)));
end

errorbar(1:1:15,rt*1000,rt_sem*1000,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

xlim([0 16])
set(gca,'XTick', 1:1:15,'FontSize',17,'LineWidth',2,'FontName','Times New Roman')
ylim([0 3000])

title([condition ' Reaction Time (' obs ')'],'FontSize',14)
xlabel('Trials','FontSize',15,'FontName','Times New Roman')
ylabel('RT [ms] ','FontSize',15,'FontName','Times New Roman')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_rtDelays']);
print ('-djpeg', '-r500',namefig);
end