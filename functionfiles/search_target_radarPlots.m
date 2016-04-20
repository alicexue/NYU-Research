function search_target_radarPlots()

[easy_m_p_discri,easy_m_p_detect,easy_p_discri,easy_p_detect,easy_p_probe,easy_m_p_probe] = overall_search_target_location('easy',2);
[difficult_m_p_discri,difficult_m_p_detect,difficult_p_discri,difficult_p_detect,difficult_p_probe,difficult_m_p_probe] = overall_search_target_location('difficult',2);

numObs = size(easy_p_discri,2);

dir_name = setup_dir();

figure; hold on;
radarPlot(easy_p_discri,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title('Feature Discrimination','FontSize',15)
% namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\p1p2diff' saveFileName],'\',filesep));
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\Feature_Discrimination');
print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(easy_p_detect,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title('Feature Detection','FontSize',15)
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\Feature_Detection');
print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(easy_p_probe,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title('Feature Probe Performance','FontSize',15)
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\Feature_ProbePerf');
print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(difficult_p_discri,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title('Conjunction Discrimination','FontSize',15)
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\Difficult_Discrimination');
print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(difficult_p_detect,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title('Conjunction Detection','FontSize',15)
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\Difficult_Detection');
print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(difficult_p_probe,'-o','LineWidth',1.6,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title('Conjunction Probe Performance','FontSize',15)
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\Difficult_ProbePerf');
print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(horzcat(easy_m_p_discri,difficult_m_p_discri),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title(['Average Discrimination Performance (n = ' num2str(numObs) ')'],'FontSize',15)
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\DiscriminationAvg');
print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(horzcat(easy_m_p_detect,difficult_m_p_detect),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title(['Average Detection Performance (n = ' num2str(numObs) ')'],'FontSize',15)
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\DetectionAvg');
print ('-djpeg', '-r500',namefig);

figure; hold on;
radarPlot(horzcat(easy_m_p_probe,difficult_m_p_probe),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9);
title(['Average Probe Performance (n = ' num2str(numObs) ')'],'FontSize',15)
namefig=sprintf('%s', 'C:\Users\alice_000\Documents\MATLAB\data\figures\target present or absent\performance fields\ProbePerfAvg');
print ('-djpeg', '-r500',namefig);
end
