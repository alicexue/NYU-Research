function fft_p1_p2(p1,p2,diff,expN,trialType,task,note)
%% This function does an FFT on the difference between p1 and p2 
%% Example
% fft_p1_p2(p1,p2,[],2,1,'easy','TB');

%% Parameters
% p1 and p2 must be 13 x numObs matrices (ex. all_p1 and all_p2 from
% overall_probe_analysis)
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% task = 'easy'; ('easy' or 'difficult')
% note = 'TB' (must be a string; used for saving the file)

%% Figure outputs
% prints the following figures:
% 1: difference between p1 and p2
% 2: amplitude spectrum of FFT on average difference between p1 and p2 for
% all observers
% 3: average amplitude spectrum for FFT on each observer
% 4: individual amplitude spectrums for all observers

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Load data
dir_name = setup_dir();
if expN == 1
    saveFileLoc = '';
    saveFileName = '1';
    titleName = '';
elseif expN == 2
    saveFileLoc = '\target present or absent\';
    if trialType == 1 || trialType == 4
        saveFileName = '_2TP';
        titleName = 'TP';
    elseif trialType == 2
        saveFileName = '_2TA';
        titleName = 'TA';
    elseif trialType == 3
        saveFileName = '_2';
        titleName = '';
    elseif trialType == 5
        saveFileName = '_2Discri';
        titleName = 'TP Discri';
    elseif trialType == 6
        saveFileName = '_2Detect';
        titleName = 'TP Detect';
    elseif trialType == 7
        saveFileName = '_NotProbed';
        titleName = 'Target Not Probed';
    elseif trialType == 8
        saveFileName = '_CompareProbeTargetLoc';
        titleName = 'Compare Probe and Target Location';
    elseif trialType == 9
        saveFileName = '_CompareProbeTargetLocDetect';
        titleName = 'Compare Probe and Target Location, Detect Correctly';
    end    
end

if ~isempty(p1)
    diff = p1 - p2;
end
m_diff = nanmean(diff,2);
std_diff = nanstd(diff,[],2)./sqrt(size(diff,2));

%% Plot difference of p1 and p2
figure; hold on;
for i = 1:size(diff,2)
    plot(100:30:460,diff(:,i),'-o','LineWidth',0.8,'MarkerFaceColor',[1 1 1],'MarkerSize',6)
end
errorbar(100:30:460,m_diff,std_diff,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
set(gca,'YTick',-1:.5:1,'FontSize',15,'LineWidth',2','Fontname','Ariel')
ylabel('P1 - P2','FontSize',15,'Fontname','Ariel')
xlabel('Time from discrimination task onset [ms]','FontSize',15,'Fontname','Ariel')
ylim([-1 1])
xlim([0 500])
plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
title([condition ' Search (n = ' num2str(size(diff,2)) ') ' titleName],'FontSize',18,'Fontname','Ariel')
namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\time\' condition '_p1p2_difference' note saveFileName],'\',filesep)); 
print ('-djpeg', '-r500',namefig); 

a_m_diff = nanmean(diff,2);
a_fft_r=fft(a_m_diff);

for i=1:size(diff,2)
    i_fft_r(:,i)=fft(diff(:,i));
end

a_fft_results=abs(a_fft_r);
i_fft_results=abs(i_fft_r);

%% Plot amplitude spectrum for FFT on average difference between p1 and p2 across all observers
figure; hold on;
plot(a_fft_results,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
% plot([2.8 5.6 8.3 11.1 13.9 16.7],a_fft_results(2:7),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
ylabel('Amplitude (au)','FontSize',15,'Fontname','Ariel')
xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
% set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')
% set(gca,'YTick',0:.2:1.4,'FontSize',12,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',0:.2:2,'FontSize',12,'LineWidth',2','Fontname','Ariel')
% ylim([0 1.4])
ylim([0 2])
title([condition ' Search-FFT on the average data-' titleName],'FontSize',18,'Fontname','Ariel')
% namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\time\' condition '_FFTavg_' note saveFileName],'\',filesep));
% print ('-dpdf', '-r500',namefig); 

%% Plots average amplitude spectrum for FFT on each observer's p1 p2 difference
figure; hold on;
% m_fft = nanmean(i_fft_results(2:7,:),2);
% fft_std = nanstd(i_fft_results(2:7,:),[],2)/sqrt(size(diff,2));
m_fft = nanmean(i_fft_results,2);
plot(m_fft,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
% errorbar([2.8 5.6 8.3 11.1 13.9 16.7],m_fft,fft_std,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])
ylabel('Amplitude (au)','FontSize',15,'Fontname','Ariel')
xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
% set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',0.5:.5:3,'FontSize',12,'LineWidth',2','Fontname','Ariel')
ylim([0.5 3])
title([condition ' Search-FFT on the individual data-' titleName],'FontSize',18,'Fontname','Ariel')
namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\time\' condition '_FFTindiv_13POINTS' note saveFileName],'\',filesep));
print ('-dpdf', '-r500',namefig); 
keyboard

%% Plots individual amplitude spectrums for each observer
figure; hold on;
for i = 1:size(diff,2)
    fft_results = i_fft_results(:,i);
    plot([2.8 5.6 8.3 11.1 13.9 16.7],fft_results(2:7),'o-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8)
end
ylabel('Amplitude (au)','FontSize',15,'Fontname','Ariel')
xlabel('Frequency (Hz)','FontSize',15,'Fontname','Ariel')
set(gca,'XTick',[2.8 5.6 8.3 11.1 13.9 16.7],'FontSize',12,'LineWidth',2','Fontname','Ariel')
set(gca,'YTick',0:0.5:4,'FontSize',12,'LineWidth',2','Fontname','Ariel')
ylim([0 4])
title([condition ' Search-FFT on the individual data-' titleName],'FontSize',18,'Fontname','Ariel')

% namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '\time\' condition '_FFTindividuals_' note saveFileName],'\',filesep));
% print ('-djpeg', '-r500',namefig);

end