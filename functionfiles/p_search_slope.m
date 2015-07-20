function p_search_slope(obs, task, date1, date2, maxBlockN)
%%% This function analyzes all of the data from date1 to date2 with a block
%%% number <= maxBlockN. 
%%% date1 and date2 can differ by month but not year

%%% Example
%%% p_search_slope('ax', 'difficult', '150701', '150709', 7)

%% Parameters

%obs = 'ax';
%task = 'difficult'
%date1 = '150701';
%date2 = '150709';
%maxBlockN = 7;

% maxBlockN refers to the largest number block across all dates

%% Obtain pboth, pone and pnone for each run and concatenate over run
date1num = str2num(date1);
date2num = str2num(date2);
numDates = date2num - date1num + 1;

rt4_avg = zeros(1,numDates*2);
rt8_avg = zeros(1,numDates*2);
perf4_avg = zeros(1,numDates*2);
perf8_avg = zeros(1,numDates*2);
c = 1;
n = 1;
if numDates > 100
    n = fix((date2num - date1num)/100)+1;
end
for tmp = 1:n 
    n2 = fix(str2num(date1)/100)*100+((tmp-1)*100);
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
rt_std = [std(rt4_avg) std(rt8_avg)];

figure;hold on;
errorbar(4:4:8,rt*1000,rt_std*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')
ylim([0 500])
%set(gca,'YTick', 50:10:100)

% title([obs ' ' condition],'FontSize',14)
xlabel('set size','FontSize',25,'FontName','Times New Roman')
ylabel('RT (ms)','FontSize',25,'FontName','Times New Roman')
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\rt\' obs '_' task '_rtSetSize']);
print ('-djpeg', '-r500',namefig);

%% Plot performance
p = [mean(perf4_avg) mean(perf8_avg)];
p_std = [std(perf4_avg) std(perf8_avg)];

figure;hold on;
errorbar(4:4:8,p*100,p_std*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')
ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',25,'LineWidth',2,'FontName','Times New Roman')

% title([obs ' ' condition],'FontSize',14)
xlabel('set size','FontSize',25,'FontName','Times New Roman')
ylabel('Accuracy','FontSize',25,'FontName','Times New Roman')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\perf\' obs '_' task '_perfSetSize']);
print ('-djpeg', '-r500',namefig);

end