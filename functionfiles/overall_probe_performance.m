function [sqClick1,sqClick2] = overall_probe_performance(expN,present,task,grouping)
%% This function averages the general performance on the probe task across observers
%% Example
%%% overall_probe_performance(1,1,'difficult',1);

%% Parameters
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% task = 'difficult'; ('easy' or 'difficult')
% grouping = 1; (if 1, probes must be exactly correct; if 2, probes must
% match by shape; if 3, probes must match by aperture)

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFileName = '1';
    titleName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\' condition];
    if present == 1
        saveFileName = '_2TP';
        titleName = 'TP';
    elseif present == 2
        saveFileName = '_2TA';
        titleName = 'TA';
    elseif present == 3
        saveFileName = '_2';
        titleName = '';
    end
end

if grouping == 2 || grouping == 3
    saveFileName = [saveFileName '_' num2str(grouping)];
end

if grouping == 1
    groupTypeName = '';
    ymin = 0;
elseif grouping == 2
    groupTypeName = 'Shape ';
    ymin = 20;
elseif grouping == 3
    groupTypeName = 'Aperture ';
    ymin = 20;
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
perfDelays=[];
perfTP=[];
perfTA=[];
perfClicks=[];
perfClicks1P=[];
perfClicks2P=[];
numObs = 0;

dir_name = setup_dir();
files = dir(strrep(dir_name,'\',filesep));  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2) && ~strcmp(obs(1,1),'.')
        [perf,pTP,pTA,pClicks,pClicksP] = p_probe_performance(obs,task,expN,present,false,grouping);
        if ~isnan(perf) 
            perfDelays = horzcat(perfDelays,perf);
            perfTP = horzcat(perfTP,pTP);
            perfTA = horzcat(perfTA,pTA);
            perfClicks = horzcat(perfClicks,pClicks);
            perfClicks1P = horzcat(perfClicks1P,pClicksP(:,1,:));
            perfClicks2P = horzcat(perfClicks2P,pClicksP(:,2,:));
            numObs = numObs + 1;
        end
    end
end

MpD = nanmean(perfDelays,2);
SpD = std(perfDelays,[],2)./sqrt(numObs);

MpTP = nanmean(perfTP,2);
SpTP = std(perfTP,[],2)./sqrt(numObs);
MpTA = nanmean(perfTA,2);
SpTA = std(perfTA,[],2)./sqrt(numObs);

MperfClicks = nanmean(perfClicks,2);
MpClick1 = MperfClicks(:,:,1);
MpClick2 = MperfClicks(:,:,2);
SpClick1 = std(perfClicks(:,:,1),[],2)./sqrt(numObs);
SpClick2 = std(perfClicks(:,:,2),[],2)./sqrt(numObs);

sqClick1 = mean(perfClicks1P(:,:,1:6),3);
sqClick2 = mean(perfClicks2P(:,:,1:6),3);

SsqClick1 = std(sqClick1,[],2)./sqrt(numObs);
SsqClick2 = std(sqClick2,[],2)./sqrt(numObs);

MsqClick1 = mean(sqClick1,2);
MsqClick2 = mean(sqClick2,2);

%% Plot average across observers
figure; hold on;
avgPerf = NaN(1,numObs);
for i=1:numObs  
    plot(100:30:460,perfDelays(:,i)*100,'-o','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',6)
    avgPerf(1,i) = mean(perfDelays(:,i))*100;    
end
errorbar(100:30:460,MpD*100,SpD*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

for i=1:numObs
    ColOrd = get(gca,'ColorOrder');    

    [m,n] = size(ColOrd);
    ColRow = rem(i,m);
    if ColRow == 0
      ColRow = m;
    end
    % Get the color
    Col = ColOrd(ColRow,:);    

    line([0 500],[avgPerf(1,i) avgPerf(1,i)],'Color',Col)

end

% legend_obs = cell(numObs,1);
% for i=1:numObs
%     legend_obs{i} = ['obs ' num2str(i)];
% end
% legend_obs{numObs+1} = 'average';
% legend(legend_obs,'Location','SouthWest')

ylim([ymin 100])
xlim([0 500])

set(gca,'YTick', ymin:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Probe Performance ' groupTypeName '(n = ' num2str(numObs) ') ' titleName],'FontSize',18)
        
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

if grouping == 1
    chance = 8.33;
elseif grouping == 2
    chance = 33.3;
elseif grouping == 3
    chance = 25;
end 

plot([0 500],[chance chance],'Color',[0 0 0],'LineStyle','--')

namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerf' saveFileName],'\',filesep));
print ('-djpeg', '-r500',namefig);

% Check for outliers
%     avgAcrossDelays = mean(MpD*100);
%     z_score = std(mean(perfDelays*100,1));
%     avgAcrossDelays + 2*z_score
%     avgAcrossDelays - 2*z_score
%     mean(perfDelays*100,1)

% %% Plot average across observers - target loc probed
% figure; hold on;
% for i=1:numObs
%     plot(100:30:460,perfTP(:,i)*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8)
% end
% errorbar(100:30:460,MpTP*100,SpTP*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
% 
% legend_obs = cell(numObs,1);
% for i=1:numObs
%     legend_obs{i} = ['obs ' num2str(i)];
% end
% legend_obs{numObs+1} = 'average';
% legend(legend_obs,'Location','NorthWest')
% 
% ylim([0 100])
% xlim([0 500])
% set(gca,'YTick', 0:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
% set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
% 
% title([condition ' Perf-target loc probed' saveFileName],'FontSize',18)
% xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
% ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
% 
% plot([0 500],[8.33 8.33],'Color',[0 0 0],'LineStyle','--')
% 
% namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfTP' saveFileName],'\',filesep));
% print ('-djpeg', '-r500',namefig);
% 
% %% Plot average across observers - target loc not probed
% figure; hold on;
% for i=1:numObs
%     plot(100:30:460,perfTA(:,i)*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8)
% end   
% errorbar(100:30:460,MpTA*100,SpTA*100,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
% 
% legend_obs = cell(numObs,1);
% for i=1:numObs
%     legend_obs{i} = ['obs ' num2str(i)];
% end
% legend_obs{numObs+1} = 'average';
% legend(legend_obs,'Location','NorthWest')
% 
% ylim([0 100])
% xlim([0 500])
% set(gca,'YTick', 0:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
% set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
% 
% title([condition ' Perf-target loc not probed' saveFileName],'FontSize',18)
% xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
% ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
% 
% plot([0 500],[8.33 8.33],'Color',[0 0 0],'LineStyle','--')
% 
% namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfTA' saveFileName],'\',filesep));
% print ('-djpeg', '-r500',namefig);

mPerf = mean(perfDelays,1)    

% if grouping == 2 || grouping == 3
%     mPerf = mean(perfDelays,2);
%     q = rot90(mPerf);
%     imagesc(q)
% end    

%% Plot C1 and C2
figure;hold on;
errorbar(100:30:460,MpClick1*100,SpClick1*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color','r')
errorbar(100:30:460,MpClick2*100,SpClick2*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color','b')
legend('click 1','click 2')
ylim([ymin 100])
xlim([0 500])

set(gca,'YTick', ymin:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Probe Performance'],'FontSize',18)
        
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  
namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfClick' saveFileName],'\',filesep));
print ('-djpeg', '-r500',namefig);

%% Plot C1 and C2 for square
figure;hold on;
errorbar(100:30:460,MsqClick1*100,SsqClick1*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color','r')
errorbar(100:30:460,MsqClick2*100,SsqClick2*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color','b')
legend('click 1','click 2')
ylim([ymin 100])
xlim([0 500])

set(gca,'YTick', ymin:20:100,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')

title([condition ' Probe Performance on Square'],'FontSize',18)
        
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')  

figure;hold on;
for i = 1:size(sqClick1,2)
    plot(100:30:460,sqClick1(:,i)-sqClick2(:,i))
end

xlim([0 500])
set(gca,'XTick', 0:100:500,'FontSize',15,'LineWidth',2,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',15,'Fontname','Ariel')

title([condition ' Probe Performance on Square'],'FontSize',18)
     
namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_probePerfClick_SQ' saveFileName],'\',filesep));
print ('-djpeg', '-r500',namefig);
end