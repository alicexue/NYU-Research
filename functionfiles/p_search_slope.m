function [rt4,rt8,perf4,perf8] = p_search_slope(obs,task,training,printFg)
%% Example
%%% p_search_slope('ax','difficult',false,true);

%% Parameters
% obs = 'ax';
% task = 'difficult';
% training = false;

% the training boolean is for the first two days of the pre-experiment

%% Change task name to feature/conjunction
if strcmp(task(1:4),'easy')
    condition = 'Feature';
else
    condition = 'Conjunction';
end

if training
    tTask = [task '\training'];
else 
    tTask = task;
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
rt4 = zeros(1,1000);
rt8 = zeros(1,1000);
perf4 = zeros(1,1000);
perf8 = zeros(1,1000);
c = 1;

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\', tTask]);  
for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')         
        [RT4,RT8,Perf4,Perf8] = search_slope(obs,task,filename,training);

        rt4(c) = RT4;
        rt8(c) = RT8;
        perf4(c) = Perf4;
        perf8(c) = Perf8;
        c = c + 1;
    end
end

rt4 = rt4(1:c-1);
rt8 = rt8(1:c-1);

rt4_median = median(rt4);
rt8_median = median(rt8);

perf4 = perf4(1:c-1);
perf8 = perf8(1:c-1);

perf4_avg = mean(perf4);
perf8_avg = mean(perf8);

rt_median = [rt4_median rt8_median];
rt_sem = [std(rt4)/size(rt4,2) std(rt8)/size(rt4,2)];

p = [perf4_avg perf8_avg];
p_sem = [std(perf4)/size(perf4,2) std(perf8)/size(perf8,2)];

if printFg == true
    %% Plot reaction time
    figure;hold on;
    errorbar(4:4:8,rt_median*1000,rt_sem*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

    xlim([3 9])
    set(gca,'XTick',4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    ylim([0 300])

    title([condition ' Reaction Time (' obs ')'],'FontSize',22)
    xlabel('Set Size','FontSize',20,'Fontname','Ariel')
    ylabel('RT [ms]','FontSize',20,'Fontname','Ariel')
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' tTask '\figures\' obs '_' condition '_rtSetSize']);
    print ('-djpeg', '-r500',namefig);

    %% Plot performance
    figure;hold on;
    errorbar(4:4:8,p*100,p_sem*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

    xlim([3 9])
    set(gca,'XTick', 4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    ylim([50 100])
    set(gca,'YTick', 50:20:100,'FontSize',20,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Accuracy (' obs ')'],'FontSize',22)
    xlabel('Set Size','FontSize',20,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',20,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' tTask '\figures\' obs '_' condition '_perfSetSize']);
    print ('-djpeg', '-r500',namefig);
end
end