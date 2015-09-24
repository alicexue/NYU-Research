function [perf,pTP,pTA] = p_probe_performance(obs,task,printFg)
%% Example
% p_probe_performance('ax','difficult',true);

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
perf = zeros(13,10000);
pTP = zeros(13,10000);
pTA = zeros(13,10000);
c = 1;

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task]);    
for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL > 4 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [p,pTargetP,pTargetA] = probe_performance(obs,task,filename);
        perf(:,c) = p; 
        pTP(:,c) = pTargetP;
        pTA(:,c) = pTargetA;
        c = c + 1;
    end
end
perf = perf(:,1:c-1);
pTP = pTP(:,1:c-1);
pTA = pTA(:,1:c-1);

perf = mean(perf,2);
pTP = mean(pTP,2);
pTA = mean(pTA,2);

if printFg
    %% Plot performance
    figure; hold on;
    plot(100:30:460,p*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([20 100])
    xlim([0 500])
    set(gca,'YTick', 20:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    
    title([condition ' Probe Performance (' obs ')'],'FontSize',18)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_probePerf']);
    print ('-djpeg', '-r500',namefig);
    
    %% Plot performance when target location is probed
    figure; hold on;
    plot(100:30:460,pTP*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([20 100])
    xlim([0 500])
    set(gca,'YTick', 20:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    
    title([condition ' Performance-target loc probed (' obs ')'],'FontSize',15)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_probePerfTP']);
    print ('-djpeg', '-r500',namefig);    
    
    %% Plot performance when target location is not probed
    figure; hold on;
    plot(100:30:460,pTA*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([20 100])
    xlim([0 500])
    set(gca,'YTick', 20:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    
    title([condition ' Performance-target loc not probed (' obs ')'],'FontSize',15)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_probePerfTA']);
    print ('-djpeg', '-r500',namefig);    
    
end
end