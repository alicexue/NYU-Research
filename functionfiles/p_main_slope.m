function [rt,p] = p_main_slope(obs,task,expN,present,printFg)
%% Example
% p_main_slope('ax','difficult',2,1,true);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% printFg = true; (if true, prints and saves figures

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\figures\' obs '_' condition];
    saveFileName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\figures\' obs '_' condition];
    if present == 1
        saveFileName = '_2TP';
    elseif present == 2
        saveFileName = '_2TA';
    elseif present == 3
        saveFileName = '_2';
    end
end
%% Obtain perf for each run and concatenate over each run
perf_avg = zeros(13,10000);
rt_median = [];
c = 1;

dir_name = setup_dir();
if expN == 1
    dir_loc = [dir_name '\' obs '\main_' task];
elseif expN == 2
    dir_loc = [dir_name '\' obs '\target present or absent\main_' task];
end

files = dir(strrep(dir_loc,'\',filesep));  

for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL > 4 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [perfDelays,rtDelays] = main_slope(obs,task,filename,expN,present);
        perf_avg(:,c) = perfDelays; 
        rt_median = horzcat(rt_median,rtDelays);
        c = c + 1;
    end
end
perf_avg = perf_avg(:,1:c-1);

rt = zeros(1,13);
rt_sem = zeros(1,13);
for delay = 1:size(rt_median,1)
    rt(1,delay) = nanmedian(rt_median(delay,:));
end
rt_sem(1,delay) = (nanstd(rt)/sqrt(size(rt_median,2)));

p = zeros(1,13);
p_sem = zeros(1,13);
for delay = 1:size(perf_avg,1)
    p(delay) = nanmean(perf_avg(delay,:));
    p_sem(delay) = (nanstd(perf_avg(delay,:))/sqrt(size(perf_avg,2)));
end

if printFg
    %% Plot rt
    figure; hold on;

    errorbar(100:30:460,rt*1000,rt_sem*1000,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([0 1200])
    set(gca,'YTick', 0:200:1200,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    title([condition ' Reaction Time (' obs ')' saveFileName],'FontSize',20)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('RT [ms] ','FontSize',15,'Fontname','Ariel')  

    namefig=sprintf('%s', [dir_loc '\' obs '\' saveFileLoc '_rtDelays' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Plot performance
    figure; hold on;

    errorbar(100:30:460,p*100,p_sem*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([30 100])
    set(gca,'YTick', 30:10:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Performance (' obs ')' saveFileName],'FontSize',20)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    namefig=sprintf('%s', [dir_loc '\' obs '\' saveFileLoc '_PerfDelays' saveFileName]);
    print ('-djpeg', '-r500',namefig);
end
end