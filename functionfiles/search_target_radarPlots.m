function search_target_radarPlots()

[easy_m_p_discri,easy_m_p_detect,easy_p_discri,easy_p_detect,easy_p_probe,easy_m_p_probe] = overall_search_target_location('easy',2);
[difficult_m_p_discri,difficult_m_p_detect,difficult_p_discri,difficult_p_detect,difficult_p_probe,difficult_m_p_probe] = overall_search_target_location('difficult',2);

numObs = size(easy_p_discri,2);

dir_name = setup_dir();

% make performance field folder

% figure; hold on;
% radarPlot(easy_p_discri,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Feature Discrimination','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Feature_Discrimination'],'\',filesep));
% print ('-djpeg', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(easy_p_detect,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Feature Detection','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Feature_Detection'],'\',filesep));
% print ('-djpeg', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(easy_p_probe,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Feature Probe Performance','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Feature_ProbePerf'],'\',filesep));
% print ('-djpeg', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(difficult_p_discri,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Conjunction Discrimination','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Difficult_Discrimination'],'\',filesep));
% print ('-djpeg', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(difficult_p_detect,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Conjunction Detection','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Difficult_Detection'],'\',filesep));
% print ('-djpeg', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(difficult_p_probe,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
% title('Conjunction Probe Performance','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\Difficult_ProbePerf'],'\',filesep));
% print ('-djpeg', '-r500',namefig);

% figure; hold on;
% radarPlot(horzcat(easy_m_p_discri,difficult_m_p_discri),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
% title(['Average Discrimination Performance (n = ' num2str(numObs) ')'],'FontSize',15)
% legend('Feature','Conjunction','Location','SouthEast')
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiscriminationAvg'],'\',filesep));
% print ('-djpeg', '-r500',namefig);
% 
% figure; hold on;
% radarPlot(horzcat(easy_m_p_detect,difficult_m_p_detect),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
% title(['Average Detection Performance (n = ' num2str(numObs) ')'],'FontSize',15)
% legend('Feature','Conjunction','Location','SouthEast')
% namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DetectionAvg'],'\',filesep));
% print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(horzcat(easy_m_p_probe,difficult_m_p_probe),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Probe Performance (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\ProbePerfAvg'],'\',filesep));
print ('-djpeg', '-r500',namefig);

%%% Diamond
% Discrimination
easy_dmd_discri = cat(1,easy_m_p_discri(1,:),easy_m_p_discri(3,:),easy_m_p_discri(5,:),easy_m_p_discri(7,:));
difficult_dmd_discri = cat(1,difficult_m_p_discri(1,:),difficult_m_p_discri(3,:),difficult_m_p_discri(5,:),difficult_m_p_discri(7,:));
figure; hold on;
radarPlot(horzcat(easy_dmd_discri,difficult_dmd_discri),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Discrimination Performance on Diamond (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiamondDiscriminationAvg'],'\',filesep));
print ('-djpeg', '-r500',namefig);

% Detection
easy_dmd_detect = cat(1,easy_m_p_detect(1,:),easy_m_p_detect(3,:),easy_m_p_detect(5,:),easy_m_p_detect(7,:));
difficult_dmd_detect = cat(1,difficult_m_p_detect(1,:),difficult_m_p_detect(3,:),difficult_m_p_detect(5,:),difficult_m_p_detect(7,:));
figure; hold on;
radarPlot(horzcat(easy_dmd_detect,difficult_dmd_detect),'-o','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12);
title(['Average Detection Performance on Diamond (n = ' num2str(numObs) ')'],'FontSize',15)
legend('Feature','Conjunction','Location','SouthEast')
namefig=sprintf('%s', strrep([dir_name '\figures\target present or absent\performance fields\DiamondDetectionAvg'],'\',filesep));
print ('-djpeg', '-r500',namefig);

keyboard
end
