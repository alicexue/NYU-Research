function p_search_slope(obs, task, date1, date2, maxBlockN)
%%% This function analyzes all of the data from date1 to date2 with a block
%%% number <= maxBlockN. 
%%% date1 and date2 can differ by month but not year

%% Example
%%% p_search_slope('ax', 'difficult', '150701', '150709', 7)

%% Parameters
%obs = 'ax';
%task = 'difficult'
%date1 = '150701';
%date2 = '150709';
%maxBlockN = 7;

% maxBlockN refers to the largest number block across all dates

%% Change task name to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
date1num = str2double(date1);
date2num = str2double(date2);
numDates = date2num - date1num + 1;

rt4_avg = zeros(1,numDates*3);
rt8_avg = zeros(1,numDates*3);
perf4_avg = zeros(1,numDates*3);
perf8_avg = zeros(1,numDates*3);
c = 1;
n = 1;
if numDates > 100
    n = fix((date2num - date1num)/100)+1;
end
for tmp = 1:n 
    n2 = fix(str2double(date1)/100)*100+((tmp-1)*100);
    if tmp~=1 && numDates > 100
        date1num = n2;
        date2num = date1num+31;
    elseif tmp==1 && numDates > 100
        date2num = n2+31;
    end
    for date = date1num:date2num
        for blockN = 0:maxBlockN
            if blockN < 10
                strTmp = ['0', num2str(blockN)];
            else
                strTmp = num2str(blockN);
            end  
            s = ['C:\Users\Alice\Documents\MATLAB\data\', obs, '\', task, '\', num2str(date), '_stim', strTmp, '.mat'];    
            exists = exist(s,'file');
            if exists ~= 0
                [rt4,rt8,perf4,perf8] = search_slope(num2str(date),obs,blockN,task);

                rt4_avg(c) = rt4;
                rt8_avg(c) = rt8;
                perf4_avg(c) = perf4;
                perf8_avg(c) = perf8;
                c = c + 1;
            end
        end
    end
end
rt4_avg = rt4_avg(1:c-1);
rt8_avg = rt8_avg(1:c-1);
perf4_avg = perf4_avg(1:c-1);
perf8_avg = perf8_avg(1:c-1);

%% Plot reaction time
rt = [mean(rt4_avg) mean(rt8_avg)];
rt_sem = [std(rt4_avg)/size(rt4_avg,2) std(rt8_avg)/size(rt4_avg,2)];
figure;hold on;
errorbar(4:4:8,rt*1000,rt_sem*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',20,'LineWidth',2,'FontName','Times New Roman')
ylim([0 500])

title([condition ' Reaction Time (' obs ')'],'FontSize',22)
xlabel('Set Size','FontSize',20,'FontName','Times New Roman')
ylabel('RT (ms)','FontSize',20,'FontName','Times New Roman')
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\rt\' obs '_' condition '_rtSetSize']);
print ('-djpeg', '-r500',namefig);

%% Plot performance
p = [mean(perf4_avg) mean(perf8_avg)];
p_sem= [std(perf4_avg)/size(perf4_avg,2) std(perf8_avg)/size(perf4_avg,2)];

figure;hold on;
errorbar(4:4:8,p*100,p_sem*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',20,'LineWidth',2,'FontName','Times New Roman')
ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',20,'LineWidth',2,'FontName','Times New Roman')

title([condition ' Accuracy (' obs ')'],'FontSize',22)
xlabel('Set Size','FontSize',20,'FontName','Times New Roman')
ylabel('Accuracy','FontSize',20,'FontName','Times New Roman')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\perf\' obs '_' condition '_perfSetSize']);
print ('-djpeg', '-r500',namefig);
end