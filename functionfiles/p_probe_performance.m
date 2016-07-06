function [perf,pTP,pTA,pTP_Pair,pTA_Pair,perfClicks,perfClicksP] = p_probe_performance(obs,task,expN,trialType,printFg,grouping)
%% Example
%%% p_probe_performance('ax','difficult',2,2,true,1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% printFg = false; (if true, prints and saves figures

%% Outputs
% perf is a 13x1 matrix for overall probe performance at each delay
% pTP is a 13x1 matrix for overall probe performance at each delay when the
% target location is probed
% pTA is a 13x1 matrix for overal probe performance at each delay when the
% target location is not probed

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\figures\' obs '_' condition];
    saveFilePairsLoc = ['\main_' task '\figures\pairs\' obs '_' condition];
    saveFileName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\figures\' obs '_' condition];
    saveFilePairsLoc = ['\target present or absent\main_' task '\figures\pairs\' obs '_' condition];
    if trialType == 1
        saveFileName = '_2TP';
    elseif trialType == 2
        saveFileName = '_2TA';
    elseif trialType == 3
        saveFileName = '_2';
    end
elseif expN == 3
    saveFileLoc = ['\control exp\figures\' obs];
    saveFilePairsLoc = ['\control exp\figures'];
    saveFileName = '';
end

%% Obtain perf for each run and concatenate over each run
perf = [];
pTP = [];
pTA = [];
pTP_Pair = [];
pTA_Pair = [];
pClick1 = [];
pClick2 = [];
pClick1P = [];
pClick2P = [];
c = 1;

if expN == 1
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\main_', task]);  
elseif expN == 2
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\target present or absent\main_', task]);  
elseif expN == 3
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\control exp']);  
end

for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL > 4 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [p,pTargetP,pTargetA,pTarget,pClicks,pClickPairs] = probe_performance(obs,task,filename,expN,trialType,grouping);
        perf(:,c) = p; 
        pTP = horzcat(pTP,pTargetP);
        pTA = horzcat(pTA,pTargetA);
        pClick1 = horzcat(pClick1,pClicks(:,:,1));
        pClick2 = horzcat(pClick2,pClicks(:,:,2));
        pClick1P = horzcat(pClick1P,pClickPairs(:,1,:));
        pClick2P = horzcat(pClick2P,pClickPairs(:,2,:));
        if expN ~= 3
            pTP_Pair = horzcat(pTP_Pair,pTarget(:,1,:));
            pTA_Pair = horzcat(pTA_Pair,pTarget(:,2,:));
        end
    end
end

perf = nanmean(perf,2);
pTP = nanmean(pTP,2);
pTA = nanmean(pTA,2);

perfClicks = cat(3,nanmean(pClick1,2),nanmean(pClick2,2));

perfClicksP = cat(2,nanmean(pClick1P,2),nanmean(pClick2P,2));

pTP_Pair = nanmean(pTP_Pair,2);
pTA_Pair = nanmean(pTA_Pair,2);
if printFg && expN~=3 && trialType~=4
    %% Plot performance
    figure; hold on;
    plot(100:30:460,perf*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([0 100])
    xlim([0 500])
    set(gca,'YTick', 0:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Probe Performance (' obs ')'],'FontSize',18)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    plot([0 500],[8.33 8.33],'Color',[0 0 0],'LineStyle','--')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_probePerf']);
    print ('-djpeg', '-r500',namefig);

    %% Plot performance when target location is probed
    figure; hold on;
    plot(100:30:460,pTP*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([0 100])
    xlim([0 500])
    set(gca,'YTick', 0:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Performance-target loc probed (' obs ')'],'FontSize',15)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    plot([0 500],[8.33 8.33],'Color',[0 0 0],'LineStyle','--')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_probePerfTP']);
    print ('-djpeg', '-r500',namefig);    

    %% Plot performance when target location is not probed
    figure; hold on;
    plot(100:30:460,pTA*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    ylim([0 100])
    xlim([0 500])
    set(gca,'YTick', 0:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

    title([condition ' Performance-target loc not probed (' obs ')'],'FontSize',15)
    xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

    plot([0 500],[8.33 8.33],'Color',[0 0 0],'LineStyle','--')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_probePerfTA']);
    print ('-djpeg', '-r500',namefig);       
end
end