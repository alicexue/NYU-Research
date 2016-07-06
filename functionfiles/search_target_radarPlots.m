function search_target_radarPlots(perf)
%% Parameters
% perf = true; plot performance when perf is true or plot reaction time if false

[easy_p_discri,easy_p_detect,easy_p_probe] = overall_search_target_location('easy',2,perf);
[difficult_p_discri,difficult_p_detect,difficult_p_probe] = overall_search_target_location('difficult',2,perf);

easyclr = [255 102 0]/255;
difficultclr = [0 0 204]/255;

numObs = size(easy_p_discri,2);

dir_name = setup_dir();

% make performance field folder

if perf
    titleName = 'Performance';
    saveFileName = ''; 
else
    titleName = 'Reaction Time';
    saveFileName = '_RT';
end

easy_m_p_discri = nanmean(easy_p_discri,2);
easy_m_p_detect = nanmean(easy_p_detect,2);
easy_m_p_probe = nanmean(easy_p_probe,2);
difficult_m_p_discri = nanmean(difficult_p_discri,2);
difficult_m_p_detect = nanmean(difficult_p_detect,2);
difficult_m_p_probe = nanmean(difficult_p_probe,2);

%% Individual data
% figure; hold on;
% radarPlot(easy_p_discri,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Feature Discrimination','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Feature_Discrimination'],'\',filesep));
% print ('-dpdf', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(easy_p_detect,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Feature Detection','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Feature_Detection'],'\',filesep));
% print ('-dpdf', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(easy_p_probe,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Feature Probe Performance','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Feature_ProbePerf'],'\',filesep));
% print ('-dpdf', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(difficult_p_discri,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Conjunction Discrimination','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Difficult_Discrimination'],'\',filesep));
% print ('-dpdf', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(difficult_p_detect,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Conjunction Detection','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Difficult_Detection'],'\',filesep));
% print ('-dpdf', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(difficult_p_probe,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Conjunction Probe Performance','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Difficult_ProbePerf'],'\',filesep));
% print ('-dpdf', '-r500',namefig);

figure; hold on;
radarPlot(horzcat(easy_m_p_discri,difficult_m_p_discri),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Discrimination ' titleName ' (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiscriminationAvg' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

figure; hold on;
radarPlot(horzcat(easy_m_p_detect,difficult_m_p_detect),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Detection ' titleName ' (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DetectionAvg' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

figure; hold on;
radarPlot(horzcat(easy_m_p_probe,difficult_m_p_probe),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Probe Performance (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\ProbePerfAvg' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Square - Note: the figure does not a accurately represent locations in the search display; graph must be rotated 45 counterclockwise
% Discrimination
easy_sq_discri = cat(1,easy_p_discri(8,:),easy_p_discri(2,:),easy_p_discri(4,:),easy_p_discri(6,:));
difficult_sq_discri = cat(1,difficult_p_discri(8,:),difficult_p_discri(2,:),difficult_p_discri(4,:),difficult_p_discri(6,:));

easy_m_sq_discri = mean(easy_sq_discri,2);
difficult_m_sq_discri = mean(difficult_sq_discri,2);

figure; hold on;
radarPlot(horzcat(easy_m_sq_discri,difficult_m_sq_discri),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Discrimination ' titleName ' on Square (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\SquareDiscriminationAvg' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

% Detection
easy_sq_detect = cat(1,easy_p_detect(8,:),easy_p_detect(2,:),easy_p_detect(4,:),easy_p_detect(6,:));
difficult_sq_detect = cat(1,difficult_p_detect(8,:),difficult_p_detect(2,:),difficult_p_detect(4,:),difficult_p_detect(6,:));

easy_m_sq_detect = mean(easy_sq_detect,2);
difficult_m_sq_detect = mean(difficult_sq_detect,2);

figure; hold on;
radarPlot(horzcat(easy_m_sq_detect,difficult_m_sq_detect),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Detection ' titleName ' on Square (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\SquareDetectionAvg' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

% Probe Perf
easy_sq_probe = cat(1,easy_p_probe(8,:),easy_p_probe(2,:),easy_p_probe(4,:),easy_p_probe(6,:));
difficult_sq_probe = cat(1,difficult_p_probe(8,:),difficult_p_probe(2,:),difficult_p_probe(4,:),difficult_p_probe(6,:));

easy_m_sq_probe = mean(easy_sq_probe,2);
difficult_m_sq_probe = mean(difficult_sq_probe,2);

figure; hold on;
radarPlot(horzcat(easy_m_sq_probe,difficult_m_sq_probe),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Probe Performance on Square (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\SquareProbeAvg'],'\',filesep));
print ('-dpdf', '-r500',namefig);

%% Diamond
% Discrimination
easy_dmd_discri = cat(1,easy_p_discri(1,:),easy_p_discri(3,:),easy_p_discri(5,:),easy_p_discri(7,:));
difficult_dmd_discri = cat(1,difficult_p_discri(1,:),difficult_p_discri(3,:),difficult_p_discri(5,:),difficult_p_discri(7,:));

easy_m_dmd_discri = mean(easy_dmd_discri,2);
difficult_m_dmd_discri = mean(difficult_dmd_discri,2);

figure; hold on;
radarPlot(horzcat(easy_m_dmd_discri,difficult_m_dmd_discri),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average ' titleName ' on Diamond (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiamondDiscriminationAvg' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

% Detection
easy_dmd_detect = cat(1,easy_p_detect(1,:),easy_p_detect(3,:),easy_p_detect(5,:),easy_p_detect(7,:));
difficult_dmd_detect = cat(1,difficult_p_detect(1,:),difficult_p_detect(3,:),difficult_p_detect(5,:),difficult_p_detect(7,:));

easy_m_dmd_detect = mean(easy_dmd_detect,2);
difficult_m_dmd_detect = mean(difficult_dmd_detect,2);

figure; hold on;
radarPlot(horzcat(easy_m_dmd_detect,difficult_m_dmd_detect),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average ' titleName ' on Diamond (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiamondDetectionAvg' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

% Probe Perf
easy_dmd_probe = cat(1,easy_p_probe(1,:),easy_p_probe(3,:),easy_p_probe(5,:),easy_p_probe(7,:));
difficult_dmd_probe = cat(1,difficult_p_probe(1,:),difficult_p_probe(3,:),difficult_p_probe(5,:),difficult_p_probe(7,:));

easy_m_dmd_probe = mean(easy_dmd_probe,2);
difficult_m_dmd_probe = mean(difficult_dmd_probe,2);

figure; hold on;
radarPlot(horzcat(easy_m_dmd_probe,difficult_m_dmd_probe),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Probe Performance on Diamond (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiamondProbeAvg'],'\',filesep));
print ('-dpdf', '-r500',namefig);

numObs = size(easy_p_discri,2);

%% Discrimination
% horizontal meridian
easy_horz_discri = mean(vertcat(easy_p_discri(1,:),easy_p_discri(5,:)),1);
sem_easy_horz_discri = std(easy_horz_discri,[],2)./sqrt(numObs);
m_easy_horz_discri = mean(easy_horz_discri,2);

difficult_horz_discri = mean(vertcat(difficult_p_discri(1,:),difficult_p_discri(5,:)),1);
sem_difficult_horz_discri = std(difficult_horz_discri,[],2)./sqrt(numObs);
m_difficult_horz_discri = mean(difficult_horz_discri,2);

% vertical meridian
easy_vert_discri = mean(vertcat(easy_p_discri(3,:),easy_p_discri(7,:)),1);
sem_easy_vert_discri = std(easy_vert_discri,[],2)./sqrt(numObs);
m_easy_vert_discri = mean(easy_vert_discri,2);

difficult_vert_discri = mean(vertcat(difficult_p_discri(3,:),difficult_p_discri(7,:)),1);
sem_difficult_vert_discri = std(difficult_vert_discri,[],2)./sqrt(numObs);
m_difficult_vert_discri = mean(difficult_vert_discri,2);

figure;hold on;
x = [1 1.5];
y = [m_difficult_horz_discri,m_difficult_vert_discri];
sem = [sem_difficult_horz_discri,sem_difficult_vert_discri];
h1 = bar(x,y,0.5,'FaceColor',difficultclr);
errorbar(x,y,sem,'.','Color',[0 0 0])

x =  [2.5 3];
y = [m_easy_horz_discri,m_easy_vert_discri];
sem = [sem_easy_horz_discri,sem_easy_vert_discri];
h2 = bar(x,y,0.5,'FaceColor',easyclr);
errorbar(x,y,sem,'.','Color',[0 0 0])

set(gca,'YTick',0:.2:1,'FontSize',15,'LineWidth',2','Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')
set(gca,'XTick',.5:.5:3.5,'XTickLabel',{'','Horz','Vert','','Horz','Vert',''},'FontSize',15,'LineWidth',2,'Fontname','Ariel')
title('Discrimination Accuracy','FontSize',15,'Fontname','Ariel')
ylim([0 1])

legend([h1,h2],'Conjunction','Feature','Location','NorthWest')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiamondDiscri_MeridianBar' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

sprintf('Discrimination\n')
sprintf('Conjunction\n')
[h,p,tstat,ci] = ttest(rot90(difficult_horz_discri),rot90(difficult_vert_discri))

sprintf('Feature\n')
[h,p,tstat,ci] = ttest(rot90(easy_horz_discri),rot90(easy_vert_discri))

%% Detect
%%% square

%%% search
% horizontal meridian
upper_horz_meridian = mean(vertcat(easy_p_detect(8,:),easy_p_detect(6,:)),1);
lower_horz_meridian = mean(vertcat(easy_p_detect(2,:),easy_p_detect(4,:)),1);

sprintf('Feature Horizontal Meridian\n')
[h,p,tstat,ci] = ttest(rot90(upper_horz_meridian),rot90(lower_horz_meridian))

upper_horz_meridian = mean(vertcat(difficult_p_detect(8,:),difficult_p_detect(6,:)),1);
lower_horz_meridian = mean(vertcat(difficult_p_detect(2,:),difficult_p_detect(4,:)),1);

sprintf('Conjunction Horizontal Meridian\n')
[h,p,tstat,ci] = ttest(rot90(upper_horz_meridian),rot90(lower_horz_meridian))


% vertical meridian
left_vert_meridian = mean(vertcat(easy_p_detect(4,:),easy_p_detect(6,:)),1);
right_vert_meridian = mean(vertcat(easy_p_detect(2,:),easy_p_detect(8,:)),1);

sprintf('Feature Vertical Meridian\n')
[h,p,tstat,ci] = ttest(rot90(left_vert_meridian),rot90(right_vert_meridian))

left_vert_meridian = mean(vertcat(difficult_p_detect(4,:),difficult_p_detect(6,:)),1);
right_vert_meridian = mean(vertcat(difficult_p_detect(2,:),difficult_p_detect(8,:)),1);

sprintf('Conjunction Vertical Meridian\n')
[h,p,tstat,ci] = ttest(rot90(left_vert_meridian),rot90(right_vert_meridian))


%%% probe
% horizontal meridian
upper_horz_meridian = mean(vertcat(easy_p_probe(8,:),easy_p_probe(6,:)),1);
lower_horz_meridian = mean(vertcat(easy_p_probe(2,:),easy_p_probe(4,:)),1);

sprintf('Feature Vertical Meridian Probe\n')
[h,p,tstat,ci] = ttest(rot90(upper_horz_meridian),rot90(lower_horz_meridian))

upper_horz_meridian = mean(vertcat(difficult_p_probe(8,:),difficult_p_probe(6,:)),1);
lower_horz_meridian = mean(vertcat(difficult_p_probe(2,:),difficult_p_probe(4,:)),1);

sprintf('Conjunction Vertical Meridian Probe\n')
[h,p,tstat,ci] = ttest(rot90(upper_horz_meridian),rot90(lower_horz_meridian))


% vertical meridian
left_vert_meridian = mean(vertcat(easy_p_probe(4,:),easy_p_probe(6,:)),1);
right_vert_meridian = mean(vertcat(easy_p_probe(2,:),easy_p_probe(8,:)),1);

sprintf('Feature Vertical Meridian Probe\n')
[h,p,tstat,ci] = ttest(rot90(left_vert_meridian),rot90(right_vert_meridian))

left_vert_meridian = mean(vertcat(difficult_p_probe(4,:),difficult_p_probe(6,:)),1);
right_vert_meridian = mean(vertcat(difficult_p_probe(2,:),difficult_p_probe(8,:)),1);

sprintf('Conjunction Vertical Meridian Probe\n')
[h,p,tstat,ci] = ttest(rot90(left_vert_meridian),rot90(right_vert_meridian))


%%% diamond
% horizontal meridian
easy_horz_detect = mean(vertcat(easy_p_detect(1,:),easy_p_detect(5,:)),1);
sem_easy_horz_detect = std(easy_horz_detect,[],2)./sqrt(numObs);
m_easy_horz_detect = mean(easy_horz_detect,2);

difficult_horz_detect = mean(vertcat(difficult_p_detect(1,:),difficult_p_detect(5,:)),1);
sem_difficult_horz_detect = std(difficult_horz_detect,[],2)./sqrt(numObs);
m_difficult_horz_detect = mean(difficult_horz_detect,2);

% vertical meridian
easy_vert_detect = mean(vertcat(easy_p_detect(3,:),easy_p_detect(7,:)),1);
sem_easy_vert_detect = std(easy_vert_detect,[],2)./sqrt(numObs);
m_easy_vert_detect = mean(easy_vert_detect,2);

difficult_vert_detect = mean(vertcat(difficult_p_detect(3,:),difficult_p_detect(7,:)),1);
sem_difficult_vert_detect = std(difficult_vert_detect,[],2)./sqrt(numObs);
m_difficult_vert_detect = mean(difficult_vert_detect,2);

figure;hold on;
x = [1 1.5];
y = [m_difficult_horz_detect,m_difficult_vert_detect];
sem = [sem_difficult_horz_detect,sem_difficult_vert_detect];
h1 = bar(x,y,0.5,'FaceColor',difficultclr);
errorbar(x,y,sem,'.','Color',[0 0 0])

x =  [2.5 3];
y = [m_easy_horz_detect,m_easy_vert_detect];
sem = [sem_easy_horz_detect,sem_easy_vert_detect];
h2 = bar(x,y,0.5,'FaceColor',easyclr);
errorbar(x,y,sem,'.','Color',[0 0 0])

set(gca,'YTick',0:.2:1,'FontSize',15,'LineWidth',2','Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')
set(gca,'XTick',.5:.5:3.5,'XTickLabel',{'','Horz','Vert','','Horz','Vert',''},'FontSize',15,'LineWidth',2,'Fontname','Ariel')
title('Detection Accuracy','FontSize',15,'Fontname','Ariel')
ylim([0 1])

legend([h1,h2],'Conjunction','Feature','Location','NorthWest')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiamondDetect_MeridianBar' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

sprintf('Detection\n')
sprintf('Conjunction\n')
[h,p,tstat,ci] = ttest(rot90(difficult_horz_detect),rot90(difficult_vert_detect))

sprintf('Feature\n')
[h,p,tstat,ci] = ttest(rot90(easy_horz_detect),rot90(easy_vert_detect))

%% Probe
% horizontal meridian
easy_horz_probe = mean(vertcat(easy_p_probe(1,:),easy_p_probe(5,:)),1);
sem_easy_horz_probe = std(easy_horz_probe,[],2)./sqrt(numObs);
m_easy_horz_probe = mean(easy_horz_probe,2);

difficult_horz_probe = mean(vertcat(difficult_p_probe(1,:),difficult_p_probe(5,:)),1);
sem_difficult_horz_probe = std(difficult_horz_probe,[],2)./sqrt(numObs);
m_difficult_horz_probe = mean(difficult_horz_probe,2);

% vertical meridian
easy_vert_probe = mean(vertcat(easy_p_probe(3,:),easy_p_probe(7,:)),1);
sem_easy_vert_probe = std(easy_vert_probe,[],2)./sqrt(numObs);
m_easy_vert_probe = mean(easy_vert_probe,2);

difficult_vert_probe = mean(vertcat(difficult_p_probe(3,:),difficult_p_probe(7,:)),1);
sem_difficult_vert_probe = std(difficult_vert_probe,[],2)./sqrt(numObs);
m_difficult_vert_probe = mean(difficult_vert_probe,2);

figure;hold on;
x = [1 1.5];
y = [m_difficult_horz_probe,m_difficult_vert_probe];
sem = [sem_difficult_horz_probe,sem_difficult_vert_probe];
h1 = bar(x,y,0.5,'FaceColor',difficultclr);
errorbar(x,y,sem,'.','Color',[0 0 0])

x =  [2.5 3];
y = [m_easy_horz_probe,m_easy_vert_probe];
sem = [sem_easy_horz_probe,sem_easy_vert_probe];
h2 = bar(x,y,0.5,'FaceColor',easyclr);
errorbar(x,y,sem,'.','Color',[0 0 0])

set(gca,'YTick',0:.2:1,'FontSize',15,'LineWidth',2','Fontname','Ariel')
ylabel('Accuracy','FontSize',15,'Fontname','Ariel')
set(gca,'XTick',.5:.5:3.5,'XTickLabel',{'','Horz','Vert','','Horz','Vert',''},'FontSize',15,'LineWidth',2,'Fontname','Ariel')
title('Probe Report Accuracy','FontSize',15,'Fontname','Ariel')
ylim([0 1])

legend([h1,h2],'Conjunction','Feature','Location','NorthWest')

namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiamondProbe_MeridianBar' saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig);

sprintf('Probe\n')
sprintf('Conjunction\n')
[h,p,tstat,ci] = ttest(rot90(difficult_horz_probe),rot90(difficult_vert_probe))

sprintf('Feature\n')
[h,p,tstat,ci] = ttest(rot90(easy_horz_probe),rot90(easy_vert_probe))

% sprintf('\n Feature Discrimination SQ\n')
% stimulus_loc_RMAOV1(easy_sq_discri)
% sprintf('\n Conjunction Discrimination SQ\n')
% stimulus_loc_RMAOV1(difficult_sq_discri)
sprintf('\n Feature Detection SQ\n')
stimulus_loc_RMAOV1(easy_sq_detect)
sprintf('\n Conjunction Detection SQ\n')
stimulus_loc_RMAOV1(difficult_sq_detect)
sprintf('\nFeature Probe SQ\n')
stimulus_loc_RMAOV1(easy_sq_probe)
sprintf('\n Conjunction Probe SQ\n')
stimulus_loc_RMAOV1(difficult_sq_probe)

% sprintf('\n Feature Discrimination DMD\n')
% stimulus_loc_RMAOV1(easy_dmd_discri)
% sprintf('\n Conjunction Discrimination DMD\n')
% stimulus_loc_RMAOV1(difficult_dmd_discri)
sprintf('\n Feature Detection DMD\n')
stimulus_loc_RMAOV1(easy_dmd_detect)
sprintf('\n Conjunction Detection DMD\n')
stimulus_loc_RMAOV1(difficult_dmd_detect)
sprintf('\n Feature Probe DMD\n')
stimulus_loc_RMAOV1(easy_dmd_probe)
sprintf('\n Conjunction Probe DMD\n')
stimulus_loc_RMAOV1(difficult_dmd_probe)

function stimulus_loc_RMAOV1(loc_data)
    numObs = size(loc_data,2);
    % data
    columnOne = [];
    % stimulus location
    columnTwo = [];
    % obs
    columnThree = [];
    for i=1:size(loc_data,2)
        columnOne = vertcat(columnOne,loc_data(:,i));  
    end

    for i=1:4:size(columnOne,1)
        columnTwo = vertcat(columnTwo,rot90(1:4,-1));
    end

%     for i=1:numObs:size(columnTwo,1)
%         columnThree = vertcat(columnThree,rot90(1:numObs,-1));
%     end
    
    for i=1:numObs
        columnThree = vertcat(columnThree,ones(4,1)*i);
    end
    
    data = horzcat(columnOne,columnTwo,columnThree);    
    RMAOV1(data);    
end
end
