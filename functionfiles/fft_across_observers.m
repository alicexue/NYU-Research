function fft_across_observers(task)
%% This function takes the average difference of p1 and p2 across all observers
%% and then does and FFT on the difference and plots the results

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Load data and plot FFT results
[p1,p2] = overall_probe_analysis(task,false);
[diff] = p1p2_difference(p1,p2,'',task,true);
m_diff = mean(diff,2);
fft_r=fft(m_diff);
fft_results=abs(fft_r);

% figure; hold on;
% plot(fft_results,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
% ylabel('Amplitude','FontSize',15,'Fontname','Ariel')
% xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')

figure; hold on;
plot([2.8 5.6 8.3 11.1 13.9 16.7],fft_results(2:7),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
ylabel('Amplitude','FontSize',15,'Fontname','Ariel')
xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
ylim([0 1])
title('FFT on the average data')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task  '\time\' condition '_FFT']);
print ('-djpeg', '-r500',namefig); 
end