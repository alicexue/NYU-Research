function fft_p1_p2(p1,p2,task,note)
%% Example
% fft_p1_p2(p1,p2,'easy','TB');

%% Notes about parameters
% p1 and p2 must be 13x1 matrices (call the function first and save the p1
% and p2 outputs
% The "note" parameter is used to save the file
% e.g. the "note" can be 'overall','top','bottom','left','right'). Must be a string.

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end


[diff] = p1p2_difference(p1,p2,'',task,true);
m_diff = mean(diff,2);
fft_r=fft(m_diff);
fft_results=abs(fft_r);

figure; hold on;
plot([2.8 5.6 8.3 11.1 13.9 16.7],fft_results(2:7),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
ylabel('Amplitude (au)','FontSize',15,'Fontname','Ariel')
xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
ylim([0 1])
title([condition ' Search - FFT on the average data'],'FontSize',18,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\time\' condition '_FFT_' note]);
print ('-djpeg', '-r500',namefig); 
end