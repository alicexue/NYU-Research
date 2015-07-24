function [rt4_avg,rt8_avg,perf4_avg,perf8_avg] = p_search_slope(obs,task)
%% Example
%%% p_search_slope('ax', 'difficult',false)

%% Parameters
% obs = 'ax';
% task = 'difficult'

%% Change task name to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
rt4_avg = zeros(1,500);
rt8_avg = zeros(1,500);
perf4_avg = zeros(1,500);
perf8_avg = zeros(1,500);
c = 1;

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\', task]);  
for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL > 4 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [rt4,rt8,perf4,perf8] = search_slope(obs,task,filename);

        rt4_avg(c) = rt4;
        rt8_avg(c) = rt8;
        perf4_avg(c) = perf4;
        perf8_avg(c) = perf8;
        c = c + 1;
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
set(gca,'XTick',4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
ylim([0 500])

title([condition ' Reaction Time (' obs ')'],'FontSize',22)
xlabel('Set Size','FontSize',20,'Fontname','Ariel')
ylabel('RT [ms]','FontSize',20,'Fontname','Ariel')
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\figures\' obs '_' condition '_rtSetSize']);
print ('-djpeg', '-r500',namefig);

%% Plot performance
p = [mean(perf4_avg) mean(perf8_avg)];
p_sem= [std(perf4_avg)/size(perf4_avg,2) std(perf8_avg)/size(perf4_avg,2)];

figure;hold on;
errorbar(4:4:8,p*100,p_sem*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
ylim([50 100])
set(gca,'YTick', 50:20:100,'FontSize',20,'LineWidth',2,'Fontname','Ariel')

title([condition ' Accuracy (' obs ')'],'FontSize',22)
xlabel('Set Size','FontSize',20,'Fontname','Ariel')
ylabel('Accuracy','FontSize',20,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\' task '\figures\' obs '_' condition '_perfSetSize']);
print ('-djpeg', '-r500',namefig);
end