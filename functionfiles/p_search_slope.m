function [rt4,rt8,perf4,perf8] = p_search_slope(obs,task,expN,trialType,configuration,training,printFg)
%% Example
% p_search_slope('ax','difficult',2,1,3,false,true);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% trialType = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% configuration = 1; (1: all trials regardless of search configuration; 2:
% square configuration; 3: diamond configuration)
% training = false; (if true, uses stim files in training folder)
% printFg = true; (if true, prints and saves figures)

%% Outputs
% rt4 is a matrix of the median rt's for set size 4 for each stim file for obs
% rt8 is a matrix of the median rt's for set size 8 for each stim file for obs

%% Change task name to feature/conjunction
if strcmp(task(1:4),'easy')
    condition = 'Feature';
else
    condition = 'Conjunction';
end

saveFileName = '';
if expN == 1
    if training
        tTask = [task '\training'];
    else 
        tTask = task;
    end
elseif expN == 2
    tTask = ['target present or absent\' task];
    if trialType == 1
        saveFileName = '_2TP';
    elseif trialType == 2
        saveFileName = '_2TA';
    elseif trialType == 3
        saveFileName = '_2';
    end
end
    
%% Obtain pboth, pone and pnone for each run and concatenate over run
rt4 = NaN(1,1000);
rt8 = NaN(1,1000);
perf4 = NaN(1,1000);
perf8 = NaN(1,1000);
c = 1;

files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\', tTask]);  
for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')         
        [RT4,RT8,Perf4,Perf8] = search_slope(obs,task,filename,expN,trialType,configuration,training);

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
    if expN == 1
        ylim([0 300])
        set(gca,'YTick', 0:50:300,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    elseif expN == 2
        ylim([0 400])
        set(gca,'YTick', 0:100:400,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    end         
    title([condition ' Reaction Time (' obs ')'],'FontSize',22)
    xlabel('Set Size','FontSize',20,'Fontname','Ariel')
    ylabel('RT [ms]','FontSize',20,'Fontname','Ariel')
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' tTask '\figures\' obs '_' condition '_rtSetSize' saveFileName]);
    print ('-dpdf', '-r500',namefig);

    %% Plot performance
    figure;hold on;
    errorbar(4:4:8,p*100,p_sem*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

    xlim([3 9])
    set(gca,'XTick', 4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    ylim([50 100])
    set(gca,'YTick', 50:10:100,'FontSize',20,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Accuracy (' obs ')'],'FontSize',22)
    xlabel('Set Size','FontSize',20,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',20,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' tTask '\figures\' obs '_' condition '_perfSetSize' saveFileName]);
    print ('-dpdf', '-r500',namefig);
end
end