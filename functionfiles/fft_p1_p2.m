function fft_p1_p2(p1,p2,expN,present,task,note)
%% Example
% fft_p1_p2(p1,p2,'easy','TB');

%% Notes about parameters
% p1 and p2 must be 13xnumObs matrices (call the function first and save the p1
% and p2 outputs
% The "note" parameter is used to save the file
% e.g. the "note" can be 'overall','top','bottom','left','right'). Must be a string.

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = '';
    saveFileName = '';
elseif expN == 2
    saveFileLoc = '\target present or absent';
    if present == 1
        saveFileName = '2TP';
    elseif present == 2
        saveFileName = '2TA';
    elseif present == 3
        saveFileName = '2';
    end
end

% [diff] = p1p2_difference(p1,p2,'',task,true);
diff = p1 - p2;
m_diff = mean(diff,2);
std_diff = std(diff,[],2)./size(diff,2);

figure; hold on;
errorbar(100:30:460,m_diff,std_diff,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
set(gca,'YTick',0:.2:0.8,'FontSize',15,'LineWidth',2','Fontname','Ariel')
ylabel('P1 - P2','FontSize',15,'Fontname','Ariel')
xlabel('Time from discrimination task onset [ms]','FontSize',15,'Fontname','Ariel')
ylim([0 0.8])
xlim([0 500])
title([condition ' Search (n = ' num2str(size(p1,2)) ') ' note],'FontSize',18,'Fontname','Ariel')
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures' saveFileLoc '\time\' condition '_p1p2_difference' note saveFileName]); 
print ('-djpeg', '-r500',namefig); 

a_m_diff = mean(diff,2);
a_fft_r=fft(a_m_diff);

for i=1:size(p1,2)
    i_fft_r(:,i)=fft(diff(:,i));
end

a_fft_results=abs(a_fft_r);
i_fft_results=mean(abs(i_fft_r),2);

figure; hold on;
plot([2.8 5.6 8.3 11.1 13.9 16.7],a_fft_results(2:7),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
ylabel('Amplitude (au)','FontSize',15,'Fontname','Ariel')
xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',0:.1:.4,'FontSize',12,'LineWidth',2','Fontname','Ariel')
ylim([0 .4])
title([condition ' Search - FFT on the average data-' note],'FontSize',18,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures' saveFileLoc '\time\' condition '_FFTavg_' note saveFileName]);
print ('-djpeg', '-r500',namefig); 

figure; hold on;
plot([2.8 5.6 8.3 11.1 13.9 16.7],i_fft_results(2:7),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
ylabel('Amplitude (au)','FontSize',15,'Fontname','Ariel')
xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',0:.2:0.6,'FontSize',12,'LineWidth',2','Fontname','Ariel')
ylim([0 0.6])
title([condition ' Search - FFT on the individual data-' note],'FontSize',18,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures' saveFileLoc '\time\' condition '_FFTindv_' note saveFileName]);
print ('-djpeg', '-r500',namefig); 
end