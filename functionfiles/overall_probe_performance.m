function overall_probe_performance(task)
%% This function averages the general performance on the probe task across observers
%% Example
%%% overall_probe_performance('difficult');

%% Parameters
% task = 'difficult'

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
perfDelays=[];
perfTP=[];
perfTA=[];
numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [perf,pTP,pTA] = p_probe_performance(obs,task,false);
        if ~isnan(perf) 
            perfDelays = horzcat(perfDelays,perf);
            perfTP = horzcat(perfTP,pTP);
            perfTA = horzcat(perfTA,pTA);
            numObs = numObs + 1;
        end
    end
end

MpD = mean(perfDelays,2);
SpD = std(perfDelays,[],2)./sqrt(numObs);

MpTP = mean(perfTP,2);
SpTP = std(perfTP,[],2)./sqrt(numObs);
MpTA = mean(perfTA,2);
SpTA = std(perfTA,[],2)./sqrt(numObs);

%% Plot average across observers
figure; hold on;

errorbar(100:30:460,MpD*100,SpD*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

ylim([20 100])
xlim([0 500])
set(gca,'YTick', 20:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Probe Performance (n = ' num2str(numObs) ')'],'FontSize',18)
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_probePerf']);
print ('-djpeg', '-r500',namefig);

%% Plot average across observers - target loc probed
figure; hold on;

errorbar(100:30:460,MpTP*100,SpTP*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

ylim([20 100])
xlim([0 500])
set(gca,'YTick', 20:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Perf-target loc probed (n = ' num2str(numObs) ')'],'FontSize',18)
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_probePerfTP']);
print ('-djpeg', '-r500',namefig);

%% Plot average across observers - target loc not probed
figure; hold on;

errorbar(100:30:460,MpTA*100,SpTA*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

ylim([20 100])
xlim([0 500])
set(gca,'YTick', 20:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Perf-target loc not probed (n = ' num2str(numObs) ')'],'FontSize',18)
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_probePerfTA']);
print ('-djpeg', '-r500',namefig);

end