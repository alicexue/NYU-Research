%% Fourier Transform Analysis on the TMS data

addpath('c:\Program Files\MATLAB\R2015b\toolbox\circ_stats')

allDataDir = setup_dir();
subSample = 1;

% %% Load the dprime data
% dp_valid_target = zeros(length(nameObs),10);
% dp_invalid_target = zeros(length(nameObs),10);
% dp_valid_distracter = zeros(length(nameObs),10);
% dp_invalid_distracter = zeros(length(nameObs),10);
% 
% for iObs = 1:length(nameObs)
%     if subSample == 1
%         load([allDataDir '/dprime_' nameObs{iObs} '_subSample'])
%     else
%         load([allDataDir '/dprime_' nameObs{iObs} ''])
%     end
%     dp_valid_target(iObs,:) = dprime_valid_endo_target;
%     dp_invalid_target(iObs,:) = dprime_invalid_endo_target;
%     dp_valid_distracter(iObs,:) = dprime_valid_endo_distracter;
%     dp_invalid_distracter(iObs,:) = dprime_invalid_endo_distracter;
% end
% 
% invTarget = dp_invalid_target(:,3:10);
% invDist = dp_invalid_distracter(:,3:10);
% vTarget = dp_valid_target(:,3:10);
% vDist = dp_valid_distracter(:,3:10);

%% Phase analysis - Version 2 - phase distribution

% invalidTarg = dp_invalid_target(:,3:10);
% invalidDist = dp_invalid_distracter(:,3:10);

task = 'difficult';
name = 'square';

nameObs = {'ad';'ax';'dg';'ek';'en';'ga';'id';'jp';'ld';'mc';'mr';'rp';'sl';'xw';'ys';'yz'};

% [all_p1,all_p2,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,squareP1,squareP2,~,~,~,~] = overall_probe_analysis(task,2,2,false,false,false,false,false,false,1,true,0.1,0.3,nameObs);
% if strcmp(name, 'all')
%     a_p1 = all_p1;
%     a_p2 = all_p2;
% elseif strcmp(name,'square')
%     a_p1 = squareP1;
%     a_p2 = squareP2;
% end

a_p1 = fliplr(rot90(a_p1,-1));
a_p2 = fliplr(rot90(a_p2,-1));

phTarg=[];
phDist=[];
amp = [];
for a = 1:size(a_p1,1)
    phTarg(a,:) = angle(fft(a_p1(a,:)));
    phDist(a,:) = angle(fft(a_p2(a,:)));
end
phTarg = phTarg(:,5);
phDist = phDist(:,5);

phDif = phTarg - phDist;
figure;
rose(phDif,150)
namefig=sprintf(['phase_dif_' task '_' name saveFileName]);
print ('-djpeg', '-r500',namefig);

figure;
rose(circ_mean(phDif),80)
namefig=sprintf(['phase_dif_avg_' task '_' name saveFileName]);
print ('-djpeg', '-r500',namefig);

[s s0] = circ_std(phDif);
figure;
rose(circ_mean(phDif)-(s0/9),80)
namefig=sprintf(['phase_dif_avg-sem_' task '_' name saveFileName]);
print ('-djpeg', '-r500',namefig);
figure;
rose(circ_mean(phDif)+(s0/9),80)
namefig=sprintf(['phase_dif_avg+sem_' task '_' name]);
print ('-djpeg', '-r500',namefig);

%%% Circular Statistics
kappa_Targ = circ_kappa(phTarg);
kappa_Dist = circ_kappa(phDist);

[pval, f] = circ_ktest(phTarg, phDist); % same distribution
[pval, table] = circ_wwtest(phTarg,phDist); % different mean

%% Monte Carlo analysis

% For each observer, we estimate hit and false alarm rates based on a
% binomial distribution and then compute the dprimes and the corresponding
% FFT.

% Load the Hit and False alarm data
% hit_valid_target = zeros(length(nameObs),10);
% hit_invalid_target = zeros(length(nameObs),10);
% fa_valid_target = zeros(length(nameObs),10);
% fa_invalid_target = zeros(length(nameObs),10);
% 
% hit_valid_distracter = zeros(length(nameObs),10);
% hit_invalid_distracter = zeros(length(nameObs),10);
% fa_valid_distracter = zeros(length(nameObs),10);
% fa_invalid_distracter = zeros(length(nameObs),10);
% 
% for iObs = 1:length(nameObs)
%     if subSample == 1
%         load([allDataDir '/hitFa_target_subSample_' nameObs{iObs} '.mat'])
%         load([allDataDir '/hitFa_distracter_subSample_' nameObs{iObs} '.mat'])
%     else
%         load([allDataDir '/hitFa_target_' nameObs{iObs} '.mat'])
%         load([allDataDir '/hitFa_distracter_' nameObs{iObs} '.mat'])
%     end
%     hit_valid_target(iObs,:) = hit_vec_endo_valid_target;
%     hit_invalid_target(iObs,:) = hit_vec_endo_invalid_target;
%     hit_valid_distracter(iObs,:) = hit_vec_endo_valid_distracter;
%     hit_invalid_distracter(iObs,:) = hit_vec_endo_invalid_distracter;
%     
%     fa_valid_target(iObs,:) = fa_vec_endo_valid_target;
%     fa_invalid_target(iObs,:) = fa_vec_endo_invalid_target;
%     fa_valid_distracter(iObs,:) = fa_vec_endo_valid_distracter;
%     fa_invalid_distracter(iObs,:) = fa_vec_endo_invalid_distracter;
% end

%%
% 12 invalid trials per condition
% 36 valid trials per condition

% repeatnumber = 10000;
repeatnumber = 10;

invTargetHit = hit_invalid_target(:,3:10);
invDistHit = hit_invalid_distracter(:,3:10);
vTargetHit = hit_valid_target(:,3:10);
vDistHit = hit_valid_distracter(:,3:10);

invTargetFa = fa_invalid_target(:,3:10);
invDistFa = fa_invalid_distracter(:,3:10);
vTargetFa = fa_valid_target(:,3:10);
vDistFa = fa_valid_distracter(:,3:10);

% expectHitinv = [invTargetHit;invDistHit];
expectHitTargetinv = mean(invTargetHit,2);
expectHitDistinv = mean(invDistHit,2);
% expectHitv = [vTargetHit;vDistHit];
expectHitTargetv = mean(vTargetHit,2);
expectHitDistv = mean(vDistHit,2);
% expectFainv = [invTargetHit;invDistHit];
expectFaTargetinv = mean(invTargetFa,2);
expectFaDistinv = mean(invDistFa,2);
% expectFav = [vTargetHit;vDistHit];
expectFaTargetv = mean(vTargetFa,2);
expectFaDistv = mean(vDistFa,2);

new_invTargetHit = [];
new_invDistHit = [];
new_invTargetFa = [];
new_invDistFa = [];

new_vTargetHit = [];
new_vDistHit = [];
new_vTargetFa = [];
new_vDistFa = [];

boot_ind_fft_inv = [];
boot_all_fft_inv = [];
boot_ind_fft_v = [];
boot_all_fft_v = [];

boot_angle_Dv = [];
boot_angle_Dinv = [];
boot_angle_Tv = [];
boot_angle_Tinv = [];

phase_v = [];
phase_inv = [];

numInvalid = 24;
numValid = 36;

for repeat = 1:repeatnumber;
    
    disp(['Running repetition number ' num2str(repeat)])
    
    for f = 1:size(invTargetHit,2)
        for s = 1:size(invTargetHit,1)
            counter_invTargetHit = 0;
            counter_invDistHit = 0;
            counter_invTargetFa = 0;
            counter_invDistFa = 0;
            counter_vTargetHit = 0;
            counter_vDistHit = 0;
            counter_vTargetFa = 0;
            counter_vDistFa = 0;
            
            for t = 1:numInvalid %Invalid
                random_value_invTargetHit = rand;
                random_value_invDistHit = rand;
                random_value_invTargetFa = rand;
                random_value_invDistFa = rand;
                
                if expectHitTargetinv(s) > random_value_invTargetHit
                    counter_invTargetHit = counter_invTargetHit +1;
                end;
                
                if expectHitDistinv(s) > random_value_invDistHit
                    counter_invDistHit = counter_invDistHit +1;
                end;
                
                if expectFaTargetinv(s) > random_value_invTargetFa
                    counter_invTargetFa = counter_invTargetFa +1;
                end;
                
                if expectFaDistinv(s) > random_value_invDistFa
                    counter_invDistFa = counter_invDistFa +1;
                end;
            end;
            for t = 1:numValid %Valid
                random_value_vTargetHit = rand;
                random_value_vDistHit = rand;
                random_value_vTargetFa = rand;
                random_value_vDistFa = rand;
                
                if expectHitTargetv(s) > random_value_vTargetHit
                    counter_vTargetHit = counter_vTargetHit +1;
                end;
                
                if expectHitDistv(s) > random_value_vDistHit
                    counter_vDistHit = counter_vDistHit +1;
                end;
                
                if expectFaTargetv(s) > random_value_vTargetFa
                    counter_vTargetFa = counter_vTargetFa +1;
                end;
                
                if expectFaDistv(s) > random_value_vDistFa
                    counter_vDistFa = counter_vDistFa +1;
                end;
                
            end;
            if counter_invTargetHit == 0
                counter_invTargetHit = 1;
            elseif counter_invTargetHit == numInvalid
                counter_invTargetHit = numInvalid-1;
            end
            if counter_vTargetHit == 0
                counter_vTargetHit = 1;
            elseif counter_vTargetHit == numValid
                counter_vTargetHit = numValid-1;
            end
            if counter_invTargetFa == 0
                counter_invTargetFa = 1;
            elseif counter_invTargetFa == numInvalid
                counter_invTargetFa = numInvalid-1;
            end
            if counter_vTargetFa == 0
                counter_vTargetFa = 1;
            elseif counter_vTargetFa == numValid
                counter_vTargetFa = numValid-1;
            end
            
            if counter_invDistHit == 0
                counter_invDistHit = 1;
            elseif counter_invDistHit == numInvalid
                counter_invDistHit = numInvalid-1;
            end
            if counter_vDistHit == 0
                counter_vDistHit = 1;
            elseif counter_vDistHit == numValid
                counter_vDistHit = numValid-1;
            end
            if counter_invDistFa == 0
                counter_invDistFa = 1;
            elseif counter_invDistFa == numInvalid
                counter_invDistFa = numInvalid-1;
            end
            if counter_vDistFa == 0
                counter_vDistFa = 1;
            elseif counter_vDistFa == numValid
                counter_vDistFa = numValid-1;
            end
            new_invTargetHit(s) = counter_invTargetHit/numInvalid;
            new_invDistHit(s) = counter_invDistHit/numInvalid;
            new_invTargetFa(s) = counter_invTargetFa/numInvalid;
            new_invDistFa(s) = counter_invDistFa/numInvalid;
            new_vTargetHit(s) = counter_vTargetHit/numValid;
            new_vDistHit(s) = counter_vDistHit/numValid;
            new_vTargetFa(s) = counter_vTargetFa/numValid;
            new_vDistFa(s) = counter_vDistFa/numValid;
        end;
        temp_invTargetHit(f,:) = new_invTargetHit';
        temp_invDistHit(f,:) = new_invDistHit';
        temp_invTargetFa(f,:) = new_invTargetFa';
        temp_invDistFa(f,:) = new_invDistFa';
        
        temp_vTargetHit(f,:) = new_vTargetHit';
        temp_vDistHit(f,:) = new_vDistHit';
        temp_vTargetFa(f,:) = new_vTargetFa';
        temp_vDistFa(f,:) = new_vDistFa';
    end;
    
    %%% Compute surrogate dprime
    for iObs = 1:size(invTargetHit,1)
        for a=1:size(invTargetHit,2)
            dprime_vtarget(iObs,a)=norminv(temp_vTargetHit(a,iObs),0,1)-norminv(temp_vTargetFa(a,iObs),0,1);
            dprime_invtarget(iObs,a)=norminv(temp_invTargetHit(a,iObs),0,1)-norminv(temp_invTargetFa(a,iObs),0,1);
            dprime_vdist(iObs,a)=norminv(temp_vDistHit(a,iObs),0,1)-norminv(temp_vDistFa(a,iObs),0,1);
            dprime_invdist(iObs,a)=norminv(temp_invDistHit(a,iObs),0,1)-norminv(temp_invDistFa(a,iObs),0,1);
        end
    end
    
    IT_ID(:,:,repeat) = dprime_invtarget - dprime_invdist;
    VT_VD(:,:,repeat) = dprime_vtarget - dprime_vdist;
    
    IT(:,:,repeat) = dprime_invtarget;
    ID(:,:,repeat) = dprime_invdist;
    VT(:,:,repeat) = dprime_vtarget;
    VD(:,:,repeat) = dprime_vdist;
    
    invalidDif = dprime_invtarget-dprime_invdist;
    validDif = dprime_vtarget-dprime_vdist;
    
    amp = [];
    for a = 1:size(invalidDif,1)
        amp(a,:) = abs(fft(invalidDif(a,:)));
        ampT(a,:) = abs(fft(dprime_invtarget(a,:)));
        ampD(a,:) = abs(fft(dprime_invdist(a,:)));
    end
    
    invalidDifmean = mean(invalidDif,1);
    invalidTmean = mean(dprime_invtarget,1);
    invalidDmean = mean(dprime_invdist,1);
    
    ADistinv = angle(fft(invalidDmean));
    ATarginv = angle(fft(invalidTmean));
    
    amp = mean(amp);
    ampT = mean(ampT);
    ampD = mean(ampD);
    ampMean = abs(fft(invalidDifmean));
    ampMeanT = abs(fft(invalidTmean));
    ampMeanD = abs(fft(invalidDmean));
    
    boot_ind_fft_inv(repeat,:) = amp(2:5);
    boot_all_fft_inv(repeat,:) = ampMean(2:5);
    
    boot_ind_fft_invT(repeat,:) = ampT(2:5);
    boot_all_fft_invT(repeat,:) = ampMeanT(2:5);
    
    boot_ind_fft_invD(repeat,:) = ampD(2:5);
    boot_all_fft_invD(repeat,:) = ampMeanD(2:5);
    
    p = angle(fft(invalidDifmean));
    phase_inv(repeat,:)=p(3);
    
    amp = [];
    for a = 1:size(validDif,1)
        amp(a,:) = abs(fft(validDif(a,:)));
        ampvT(a,:) = abs(fft(dprime_vtarget(a,:)));
        ampvD(a,:) = abs(fft(dprime_vdist(a,:)));
    end
    
    validDifmean = mean(validDif,1);
    validTmean = mean(dprime_vtarget,1);
    validDmean = mean(dprime_vdist,1);
    
    ADistv = angle(fft(validDmean));
    ATargv = angle(fft(validTmean));
    
    amp = mean(amp);
    ampT = mean(ampvT);
    ampD = mean(ampvD);
    ampMean = abs(fft(validDifmean));
    ampMeanT = abs(fft(validTmean));
    ampMeanD = abs(fft(validDmean));
    
    boot_ind_fft_v(repeat,:) = amp(2:5);
    boot_all_fft_v(repeat,:) = ampMean(2:5);
    
    boot_ind_fft_vT(repeat,:) = ampT(2:5);
    boot_all_fft_vT(repeat,:) = ampMeanT(2:5);
    
    boot_ind_fft_vD(repeat,:) = ampD(2:5);
    boot_all_fft_vD(repeat,:) = ampMeanD(2:5);
    
    boot_angle_v(repeat,:) = ATargv - ADistv;
    boot_angle_inv(repeat,:) = ATarginv - ADistinv;
    
    p=angle(fft(validDifmean));
    phase_v(repeat,:)=p(3);
    
    ADistv = angle(fft(mean(dprime_vdist)));
    ATargv = angle(fft(mean(dprime_vtarget)));
    pdif = ATargv - ADistv;
    phase_vDIF(repeat,:)=pdif(3);
    
    ADistinv = angle(fft(mean(dprime_invdist)));
    ATarginv = angle(fft(mean(dprime_invtarget)));
    pdif = ATarginv - ADistinv;
    phase_invDIF(repeat,:)=pdif(3);
    
end;

IT_ID = sort(squeeze(mean(IT_ID,1))');
VT_VD = sort(squeeze(mean(VT_VD,1))');

%%
% save('SimMonte.mat','boot_angle_inv','boot_angle_v','boot_ind_fft_inv',...
% 'boot_all_fft_inv','boot_ind_fft_invT','boot_all_fft_invT','boot_ind_fft_invD','boot_all_fft_invD',...
% 'boot_ind_fft_v','boot_all_fft_v','boot_ind_fft_vT','boot_all_fft_vT','boot_ind_fft_vD','boot_all_fft_vD',...
% 'phase_v','phase_inv','ADistv','ADistinv','ATargv','ATarginv','phase_vDIF','phase_invDIF')

%load 'SimMonte.mat'

%% Plot: FFT on the average

repeatnumber = 10000;
%%% Stats on the difference between Target and Distractor
% data2 = invTarget - invDist;
% data2 = vTarget - vDist;
% data = boot_all_fft_inv;
% data = boot_all_fft_v;

%%% Stats separately for Target and Distractor
% data2 = vTarget;
% data2 = vDist;
% data2 = invTarget;
data2 = invDist;
% data = boot_all_fft_vT;
% data = boot_all_fft_vD;
% data = boot_all_fft_invT;
data = boot_all_fft_invD;

freqs = [2.5 5 7.5 10];
% list = [0.9999 0.999 0.99 0.95];%
list = [0.95 0.90];%
back = [1 0.2 0.1];
a = [0.3 0.9 0.2; 0.3 0.3 0.85; 0.6 0.3 0.6; 0.8 0.3 0.25];
b = length(a);
lim = zeros(1,size(freqs,2));
lim(:) = 50;

real = abs(fft(mean(data2,1)));
real = real';

figure; hold on;
title('FFT on the average data (valid Target)','FontSize',14)
h = fill([freqs freqs(end:-1:1) freqs(1)],[lim zeros(size(freqs)) lim(1)],back);
set(h,'edgecolor',get(h,'facecolor'));
ylim([0 lim(1)])
for ci = list
    ftimefunction = sort(data,1);
    percentile = floor(ci*(repeatnumber));
    upperlim = ftimefunction(percentile,:);
    expected = mean(ftimefunction(1:end,:),1);
    
    h = fill([freqs freqs(end:-1:1) freqs(1)],[upperlim zeros(size(freqs)) upperlim(1)],a(b,:));
    set(h,'edgecolor',get(h,'facecolor'));
    plot(freqs,expected,'--k','LineWidth',1.5);
    
    plot(freqs,real(2:5),'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
    b = b-1;
    ylim([0 1.3])
end;

xlim([2.5 10])
set(gca, 'XTick',[2.5 5 7.5 10])

namefig=sprintf('/e/4.1/p3/roberts/Desktop/fftvTarg');
% print ('-djpeg', '-r500',namefig);

%% Compute p values
realData = real(2:5);
realData = realData';
for iFreq = 1:4
    statsPValues(iFreq) = (repeatnumber- min(find(ftimefunction(:,iFreq)>realData(iFreq))))./repeatnumber;
end

%% Correction for multiple comparisons
%%% stats on the difference
statsINV = [0.8366 0.0446 0.1114 0.8545];
statsV = [0.7078 0.8306 0.9284 0.4779];

%%% stats separately for all 4 conditions
statsVT = [0.1919 0.7250 0.8850 0.9712];
statsVD = [0.3667 0.9961 0.9956 0.3116];
statsINVT = [0.6893 0.0729 0.1194 0.9661];
statsINVD = [0.3734 0.0077 0.5134 0.8360];

%%% 
% toCorrect = [statsINV(2) statsV(2)];
% toCorrect = [statsINVT(2) statsINVD(2)];
toCorrect = [statsVT(2) statsVD(2) statsINVT(2) statsINVD(2)];
toCorrect = toCorrect./2;
p_fdr = fdr(toCorrect)
%% Plot: FFT on the average - PHASE ANALYSIS

data2 = ATarg-ADist;
data = boot_angle_inv;

freqs = 75:50:425;
list = [0.95 0.90];
back = [1 0.2 0.1];
a = [0.3 0.9 0.2; 0.3 0.3 0.85; 0.6 0.3 0.6; 0.8 0.3 0.25];
b = length(a);
lim = zeros(1,size(freqs,2));
lim(:) = 50;

real = data2;

figure; hold on;
title('INVALID: Target Stimulated - Distracter Stimulated','FontSize',14)
h = fill([freqs freqs(end:-1:1) freqs(1)],[lim zeros(size(freqs))-.25 lim(1)],back);
set(h,'edgecolor',get(h,'facecolor'));
ylim([0 lim(1)])
for ci = list
    ftimefunction = sort(data,1);
    percentile = floor(ci*(repeatnumber));
    lowpercentile = floor(((1-ci)/2)*repeatnumber);
    upperlim = ftimefunction(percentile,:);
    lowerlim = ftimefunction(lowpercentile+1,:);
    expected = mean(ftimefunction(1:end,:),1);
    
    h = fill([freqs freqs(end:-1:1) freqs(1)],[upperlim lowerlim upperlim(1)],a(b,:));
    set(h,'edgecolor',get(h,'facecolor'));
    plot(freqs,expected,'--k','LineWidth',1.5);
    
    plot(freqs,real,'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
    b = b-1;
    ylim([-.25 0.25])
end;

xlim([75 425])
set(gca, 'XTick',[75:50:425])

namefig=sprintf('/e/4.1/p3/roberts/Desktop/bootangleV');
print ('-djpeg', '-r500',namefig);

%% Phase
% figure;hold on;
% subplot(1,2,1);
% rose(phase_v)
% subplot(1,2,2);
% rose(phase_inv)
load 'SimMonte.mat'
repeatnumber = 10000;
pv = angle(fft(mean(dp_valid_target(:,3:10)-dp_valid_distracter(:,3:10))));
pin = angle(fft(mean(dp_invalid_target(:,3:10)-dp_invalid_distracter(:,3:10))));

figure;hold on;
subplot(1,2,1);
rose(pv(3),80);title('Valid')
subplot(1,2,2);
rose(pin(3),80);title('Invalid')

pvT = angle(fft(mean(dp_valid_target(:,3:10))));
pinvT = angle(fft(mean(dp_invalid_target(:,3:10))));
pvD = angle(fft(mean(dp_valid_distracter(:,3:10))));
pinvD = angle(fft(mean(dp_invalid_distracter(:,3:10))));

avT = fft(mean(dp_valid_target(:,3:10)));
ainvT = fft(mean(dp_invalid_target(:,3:10)));
avD = fft(mean(dp_valid_distracter(:,3:10)));
ainvD = fft(mean(dp_invalid_distracter(:,3:10)));

figure;hold on;
subplot(2,2,1);
rose(angle(avD(3)));compass(avD(3));title('Valid-Distractor');
subplot(2,2,2);
rose(angle(avT(3)));compass(avT(3));title('Valid-Target')
subplot(2,2,3);
rose(angle(ainvD(3)));compass(ainvD(3));title('Invalid-Distractor')
subplot(2,2,4);
rose(angle(ainvT(3)));compass(ainvT(3));title('Invalid-Target')

figure;hold on;
rose(angle(avD(3)));compass(avT(3));compass(avD(3));title('Valid');
figure;hold on;
rose(angle(ainvD(3)));compass(ainvT(3));compass(ainvD(3));title('Invalid');

%%%
real = (pinvT(3)-pinvD(3));
data = (phase_invDIF);

ftimefunction = sort((data),1);
percentile = floor(.99*(repeatnumber));
lowpercentile = floor(((1-.99)/2)*repeatnumber);
upperlim = ftimefunction(percentile,:);
lowerlim = ftimefunction(lowpercentile+1,:);

figure;hold on;
subplot(1,2,1);
rose(lowerlim,80)
subplot(1,2,2);
rose(upperlim,80)


% expected = circ_mean(ftimefunction(1:end,:),1);
% plot([1 1],[upperlim lowerlim],'k-','LineWidth',1.5)
% plot(expected,'ok','LineWidth',1.5);
% plot((real),'ro','LineWidth',3,'MarkerSize',6,'MarkerFaceColor',[1 1 1]);
% 
% namefig=sprintf('/e/4.1/p3/roberts/Desktop/6');
% print ('-djpeg', '-r500',namefig);

%% Plot: FFT on the individual data

data2 = invTarget - invDist;
% data2 = vTarget - vDist;
data = boot_ind_fft_inv;
% data = boot_ind_fft_v;

freqs = [2.5 5 7.5 10];
list = [0.95 0.90];%
back = [1 0.2 0.1];
a = [0.3 0.9 0.2; 0.3 0.3 0.85; 0.6 0.3 0.6; 0.8 0.3 0.25];
b = length(a);
lim = zeros(1,size(freqs,2));
lim(:) = 50;

result_fft = zeros(size(data2,1),size(data2,2));
for sub = 1:size(data2,1)
    result_fft(sub,:) = fft(data2(sub,:));
end;
result_fft = result_fft(:,2:5);
real = mean(abs(result_fft));

figure; hold on;
title('FFT on the average data','FontSize',14)
h = fill([freqs freqs(end:-1:1) freqs(1)],[lim zeros(size(freqs)) lim(1)],back);
set(h,'edgecolor',get(h,'facecolor'));
ylim([0 lim(1)])
for ci = list
    ftimefunction = sort(data,1);
    percentile = floor(ci*(repeatnumber));
    upperlim = ftimefunction(percentile,:);
    expected = mean(ftimefunction(1:end,:),1);
    
    h = fill([freqs freqs(end:-1:1) freqs(1)],[upperlim zeros(size(freqs)) upperlim(1)],a(b,:));
    set(h,'edgecolor',get(h,'facecolor'));
    plot(freqs,expected,'--k','LineWidth',1.5);
    
    plot(freqs,real,'ko-','LineWidth',3,'MarkerSize',12,'MarkerFaceColor',[1 1 1]);
    b = b-1;
    ylim([1 2])
end;

xlim([2.5 10])
set(gca, 'XTick',[2.5 5 7.5 10])

%% Bootstrap analysis

% In case of Monte Carlo
%12 invalid trials per condition
%36 valid trials per condition

repeatnumber = 1000;

invTarget = dp_invalid_target(:,3:10);
invDist = dp_invalid_distracter(:,3:10);
vTarget = dp_valid_target(:,3:10);
vDist = dp_valid_distracter(:,3:10);

boot_ind_fft = [];
boot_all_fft = [];

for repeat = 1:repeatnumber;
    
    disp(['Running repetition number ' num2str(repeat)])
    for s = 1:size(invTarget,1)
        idx = randsample(size(invTarget,2),size(invTarget,2))';
        bootinvTarget(s,:) = invTarget(s,idx);
        idx = randsample(size(invDist,2),size(invDist,2))';
        bootinvDist(s,:) = invDist(s,idx);
        idx = randsample(size(vTarget,2),size(vTarget,2))';
        bootvTarget(s,:) = vTarget(s,idx);
        idx = randsample(size(vDist,2),size(vDist,2))';
        bootvDist(s,:) = vDist(s,idx);
    end;
    
    invalidDif = bootinvTarget-bootinvDist;
    validDif = bootvTarget-bootvDist;
    
    amp = [];
    for a = 1:size(invTarget,1)
        amp(a,:) = abs(fft(invalidDif(a,:)));
    end
    
    invalidDifmean = mean(invalidDif,1);
    
    amp = mean(amp);
    ampMean = abs(fft(invalidDifmean));
    
    boot_ind_fft_inv(repeat,:) = amp(2:5);
    boot_all_fft_inv(repeat,:) = ampMean(2:5);
    
    amp = [];
    for a = 1:size(vTarget,1)
        amp(a,:) = abs(fft(validDif(a,:)));
    end
    
    validDifmean = mean(validDif,1);
    
    amp = mean(amp);
    ampMean = abs(fft(validDifmean));
    
    boot_ind_fft_v(repeat,:) = amp(2:5);
    boot_all_fft_v(repeat,:) = ampMean(2:5);
   keyboard 
end;



