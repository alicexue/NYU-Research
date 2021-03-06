%% Bootstrap analysis on Mathilde's data: THE ACCURATE ANALYSIS 
% load('for_laura_old.mat')

% to get frequencies
% ((1:13)./(460-100))*1000
% 2.78*(1:6)

% peak is significant when p <.05/6 ==> p < 0.0083
% ==> p < 0.001

task = 'difficult';
name = 'square';
trialType = 2;

if trialType == 1
    saveFileName = '_2TP';
elseif trialType == 2
    saveFileName = '_2TA';
else
    saveFileName = '2';
end

nameObs = {'ad';'ax';'dg';'ek';'en';'ga';'id';'jp';'ld';'mc';'mr';'rp';'sl';'xw';'ys';'yz'};

% [all_p1,all_p2,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,squareP1,squareP2,diamondP1,diamondP2,~,~] = overall_probe_analysis(task,2,trialType,false,false,false,false,false,false,1,true,0.1,0.3,nameObs);
if strcmp(name, 'all')
    subj_pA = all_p1;
    subj_pB = all_p2;
elseif strcmp(name,'square')
    subj_pA = squareP1;
    subj_pB = squareP2;
elseif strcmp(name,'diamond')
    subj_pA = diamondP1;
    subj_pB = diamondP2;
end

%load('for_laura_new.mat')
%subj_pA = new_ntc_pA;
%subj_pB = new_ntc_pB;
%% Frequency resolution
% xaxis = (1:15)*(1/(450-30));
% xaxis = xaxis(1:6);
xaxis = [2.78 5.56 8.34 11.12 13.90 16.68];

%% Bootstrap parameters

repeatnumber = 100000;
% repeatnumber = 10;

%% Bootstrap
fft_p = [];
fft_ALL_p = [];

for repeat = 1:repeatnumber;
    disp(['Repeat number: ' num2str(repeat)])
    for sub = 1:size(subj_pA,2)
        
        rand_idx_p1 = randsample(1:size(subj_pA,1),size(subj_pA,1));
        rand_idx_p2 = randsample(1:size(subj_pB,1),size(subj_pA,1));
        
        p1(sub,:) = subj_pA(rand_idx_p1,sub);
        p2(sub,:) = subj_pB(rand_idx_p2,sub);
    end;
    
    p1p2 = p1-p2;
    
    for sub = 1:size(p1,1)
        result_fft(:,sub) = fft(p1p2(sub,:));
    end;
    ind_fft = mean(abs(result_fft),2);
    ind_fft = ind_fft';
    fft_p(repeat,:) = ind_fft;% mean(abs(fft(p1p2)));
    
    Mean_p1p2 = mean(p1p2,1)
    all_fft = abs(fft(Mean_p1p2));
    fft_ALL_p(repeat,:) = all_fft;
    
end;

%data_p = data_p/repeatnumber;







%% Plot bootstrap results: Average of individual fft
data = fft_p(:,2:7);
data2 = subj_pA(1:13,:) - subj_pB(1:13,:);

freqs = [2.78 5.56 8.34 11.12 13.90 16.68];
ci2 = 0.99;
na = 0;
 
list = [0.9999 0.999 0.99 0.95];%
back = [1 0.2 0.1];
a = [0.3 0.9 0.2; 0.3 0.3 0.85; 0.6 0.3 0.6; 0.8 0.3 0.25];
lim = zeros(1,size(freqs,2));
lim(:) = 1.8;

result_fft = zeros(size(data2,2),size(data2,1));
for sub = 1:size(data2,2)
    result_fft(sub,:) = fft(data2(:,sub));
end;
result_fft = result_fft(:,2:7);
real = nanmean(abs(result_fft));

figure; hold on;
title('p1 - p2')
h = fill([freqs freqs(end:-1:1) freqs(1)],[lim zeros(size(freqs)) lim(1)],back);
set(h,'edgecolor',get(h,'facecolor'));
ylim([0 lim(1)])
b = length(a);

count = 0;

real_sem = std(abs(result_fft),1)/sqrt(size(nameObs,1));

for ci = list
    allftimefunction = sort(data,1);
    percentile = floor(ci*(repeatnumber-na));
    upperlim = allftimefunction(percentile,:);
    expected = nanmean(allftimefunction(1:end-na,:),1);
    
    h=fill([freqs freqs(end:-1:1) freqs(1)],[upperlim zeros(size(freqs)) upperlim(1)],a(b,:));
    set(h,'edgecolor',get(h,'facecolor'));
    
    plot(freqs,expected,'k--','LineWidth',1.5);
% %     errorbar(freqs,real,real_sem,'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
    b = b-1;
    xlim([2  16.7])
% %     ylim([0.6 lim(1)])
end
set(gca, 'XTick',[2.78 5.56 8.34 11.12 13.90 16.68])
namefig = sprintf(['boot_secVersion_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);

%% Plot bootstrap results: on the average data across observers
data = fft_ALL_p(:,2:7);
data2 = nanmean((subj_pA(1:13,:) - subj_pB(1:13,:)),2);

freqs = [2.78 5.56 8.34 11.12 13.90 16.68];
ci2 = 0.99;
na = 0;
 
list = [0.9999 0.999 0.99 0.95];%
back = [1 0.2 0.1];
a = [0.3 0.9 0.2; 0.3 0.3 0.85; 0.6 0.3 0.6; 0.8 0.3 0.25];
lim = zeros(1,size(freqs,2));
lim(:) = 0.9;

real = abs(fft(data2));
real = real(2:7);

figure; hold on;
title('p1 - p2')
h = fill([freqs freqs(end:-1:1) freqs(1)],[lim zeros(size(freqs)) lim(1)],back);
set(h,'edgecolor',get(h,'facecolor'));
ylim([0 lim(1)])
b = length(a);

count = 0;

for ci = list
    allftimefunction = sort(data,1);
    percentile = floor(ci*(repeatnumber-na));
    upperlim = allftimefunction(percentile,:);
    expected = nanmean(allftimefunction(1:end-na,:),1);
    
    h=fill([freqs freqs(end:-1:1) freqs(1)],[upperlim zeros(size(freqs)) upperlim(1)],a(b,:));
    set(h,'edgecolor',get(h,'facecolor'));
    
    plot(freqs,expected,'k--','LineWidth',1.5);
    plot(freqs,real,'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
    b = b-1;
    xlim([2  16.7])
    ylim([0 lim(1)])
end
set(gca, 'XTick',[2.78 5.56 8.34 11.12 13.90 16.68])
namefig = sprintf(['boot_ind_mainVersion_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);


%% Plot bootstrap results: CONTINUOUS SCALE - avg of individual fft
% load('fft_p_old.mat')
% load('for_laura_old.mat')
% subj_pA = old_ntc_pA;
% subj_pB = old_ntc_pB;

% load('fft_p_new.mat')
% load('for_laura_new.mat')
% subj_pA = new_ntc_pA;
% subj_pB = new_ntc_pB;

repeatnumber = 100000;

data = fft_p(:,2:7);
data2 = subj_pA(1:13,:) - subj_pB(1:13,:);

freqs = [2.78 5.56 8.34 11.12 13.90 16.68];
ci2 = 0.99;
na = 0;
 
list = [0.9999 0.999 0.99 0.95];%
back = [1 0.2 0.1];
a = [0.3 0.9 0.2; 0.3 0.3 0.85; 0.6 0.3 0.6; 0.8 0.3 0.25];
lim = zeros(1,size(freqs,2));
lim(:) = 2.1;

result_fft = zeros(size(data2,2),size(data2,1));
for sub = 1:size(data2,2)
    result_fft(sub,:) = fft(data2(:,sub));
end;
result_fft = result_fft(:,2:7);
real = mean(abs(result_fft));

figure; hold on;
title('p1 - p2')
%h = fill([freqs freqs(end:-1:1) freqs(1)],[lim zeros(size(freqs)) lim(1)],back);
%set(h,'edgecolor',get(h,'facecolor'));
ylim([0 lim(1)])
b = length(a);

count = 0;

for ci = list
    allftimefunction = sort(data,1);
    percentile = floor(ci*(repeatnumber-na));
    upperlim = allftimefunction(percentile,:);
    expected = mean(allftimefunction(1:end-na,:),1);
    
    %h=fill([freqs freqs(end:-1:1) freqs(1)],[upperlim zeros(size(freqs)) upperlim(1)],a(b,:));
    %set(h,'edgecolor',get(h,'facecolor'));
    
    plot(freqs,upperlim,'k--','LineWidth',1.5);
    
    plot(freqs,expected,'k--','LineWidth',1.5);
    plot(freqs,real,'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
    b = b-1;
    xlim([2  16.7])
    ylim([.6 1.8])
end
set(gca, 'XTick',[2.78 5.56 8.34 11.12 13.90 16.68])
namefig = sprintf(['bootFFTLINEold_indiv_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);

save('fft_ALL_p.mat','fft_ALL_p')


% get colormap
C = green_colormap();

a = zeros(size(allftimefunction,1),size(allftimefunction,2));
count = size(allftimefunction,1);
for iA = 1:length(a)
    a(iA,:) = allftimefunction(count,:);
    count = count - 1;
end
maybeNorm = (a-min(min(a)))./(max(max(a))-min(min(a)));
figure;imagesc(a);colormap(C);colorbar;
namefig = sprintf(['colorBoot_indiv_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);

%%
b = a(1:78487,:);
maybeNorm = (b-min(min(b)))./(max(max(b))-min(min(b)));
figure;imagesc(b);
set(gca,'clim',[1 1.8])

%%
figure;
surf(freqs,1:100000,allftimefunction);%-log10(pvals)
hold on;
view(0,0);
colormap(C);colorbar;
set(gcf,'Renderer','Zbuffer');
shading interp;
plot(freqs,real,'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
%set(gca,'ylim',[78000 100000])
%set(gca,'clim',[1.1 1.8])
hold off;
namefig = sprintf(['colorBootnew_indiv_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);


%% Plot bootstrap results: CONTINUOUS SCALE - fft on average data
repeatnumber = 100000;

data = fft_ALL_p(:,2:7);
data2 = nanmean((subj_pA(1:13,:) - subj_pB(1:13,:)),2);

freqs = [2.78 5.56 8.34 11.12 13.90 16.68];
ci2 = 0.99;
na = 0;
 
list = [0.9999 0.999 0.99 0.95];%
back = [1 0.2 0.1];
a = [0.3 0.9 0.2; 0.3 0.3 0.85; 0.6 0.3 0.6; 0.8 0.3 0.25];
lim = zeros(1,size(freqs,2));
lim(:) = 2.1;

real = abs(fft(data2));
real = real(2:7);

figure; hold on;
title('p1 - p2')
%h = fill([freqs freqs(end:-1:1) freqs(1)],[lim zeros(size(freqs)) lim(1)],back);
%set(h,'edgecolor',get(h,'facecolor'));
ylim([0 lim(1)])
b = length(a);

count = 0;

for ci = list
    allftimefunction = sort(data,1);
    percentile = floor(ci*(repeatnumber-na));
    upperlim = allftimefunction(percentile,:);
    expected = mean(allftimefunction(1:end-na,:),1);
    
    %h=fill([freqs freqs(end:-1:1) freqs(1)],[upperlim zeros(size(freqs)) upperlim(1)],a(b,:));
    %set(h,'edgecolor',get(h,'facecolor'));
    
    plot(freqs,upperlim,'k--','LineWidth',1.5);
    
    plot(freqs,expected,'k--','LineWidth',1.5);
    plot(freqs,real,'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
    b = b-1;
    xlim([2  16.7])
% %     ylim([0 .8])
end
set(gca, 'XTick',[2.78 5.56 8.34 11.12 13.90 16.68])
namefig = sprintf(['bootFFTLINEold_avg_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);

save('fft_ALL_p.mat','fft_ALL_p')


%%

% get colormap
C = green_colormap();

a = zeros(size(allftimefunction,1),size(allftimefunction,2));
count = size(allftimefunction,1);
for iA = 1:length(a)
    a(iA,:) = allftimefunction(count,:);
    count = count - 1;
end
maybeNorm = (a-min(min(a)))./(max(max(a))-min(min(a)));
figure;imagesc(a);colormap(C);colorbar;
namefig = sprintf(['colorBoot_avg_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);

%%
b = a(1:78487,:);
maybeNorm = (b-min(min(b)))./(max(max(b))-min(min(b)));
figure;imagesc(b);
% % set(gca,'clim',[1 1.8])

%%
figure;
surf(freqs,1:100000,allftimefunction);%-log10(pvals)
hold on;
view(0,0);
colormap(C);colorbar;
set(gcf,'Renderer','Zbuffer');
shading interp;
plot(freqs,real,'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
%set(gca,'ylim',[78000 100000])
set(gca,'clim',[1.1 1.8])
hold off;
namefig = sprintf(['colorBootnew_avg_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);

%% TEST
data2 = mean((subj_pA(1:13,:) - subj_pB(1:13,:)),2);
f = abs(fft(data2));
figure;
plot(xaxis,f(2:7),'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1])
% % ylim([0 1])
set(gca,'XTick',xaxis)
set(gca,'XTickLabel',xaxis)
xlabel('Frequency (Hz)','FontSize',16)
ylabel('Amplitude (au)','FontSize',16)
title('FFT of the grand-average curve','FontSize',16)

namefig = sprintf(['FFTgrandAvg_' task '_' name saveFileName]);
print('-dpdf','-r500',namefig);
keyboard
