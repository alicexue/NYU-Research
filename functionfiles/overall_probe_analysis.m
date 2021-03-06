function [all_p1,all_p2,pairs_p1,pairs_p2,pair_p1,pair_p2,sameHemiP1,sameHemiP2,diffHemiP1,diffHemiP2,d1P1,d1P2,d2P1,d2P2,d3P1,d3P2,configP1P2,squareP1,squareP2,diamondP1,diamondP2,pair1346P1,pair1346P2] = overall_probe_analysis(task,expN,trialType,difference,correct,printFg,printColormap,printFFT,printStats,grouping,absDiff,cMin,cMax,observers)
%% This function graphs raw probabilities and p1 & p2 for overall, pairs, and hemifields across all observers
%% Example
%%% [all_p1,all_p2,pairs_p1,pairs_p2,pair_p1,pair_p2] = overall_probe_analysis('difficult',2,2,false,false,true,true,true,false,1,true,0.1,0.3,{'ax','ld'});
% overall_probe_analysis('difficult',2,2,false,false,true,true,true,false,1,true,0.1,0.3,{});
%% Parameters
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1, 2, or 3) 
% 1:exp when target was always present
% 2:exp when target was present or absent
% 3:control exp
% trialType = 1; (only valid for expN == 2; all possible options below)
% 1:target-present trials
% 2:target-absent trials 
% 3:all trials
% 4:correct rejection trials
% 5:BOTH probes answered correctly in previous trial
% 6:ONE probe answered correctly in previous trial
% 7:NONE of the probes answered correctly in previous trial
% difference = false; (if true, plots difference of p1 and p2)
% correct = false; (if true, p1 and p2 are corrected for each individual and also by the global average)
% printFg = false; (if true, prints and saves the figures)
% printStats = false; (if true, conducts ANOVA on overall p1 p2 data and prints output in cmd window)
% grouping = 1; (if 1, probes must be exactly correct; if 2, probes must 
% match by shape; if 3, probes must match by aperture)
% absDiff = true; (if true, takes absolute value of difference - for the colormaps)
% observers is a cell of the observers' initials. if empty, then all observers' data are plotted

%% Outputs
% all_p1 and all_p2 are matrices for the p1 and p2 values for all observers
% (e.g. for 3 observers, a 13x3 matrix for p1 and p2)

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
    p1clr = [0 0 204]/255;
    p2clr = [0 170 255]/255;
else 
    condition = 'Feature';
    p1clr = [255 102 0]/255;
    p2clr = [255 170 0]/255;
end

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFilePairsLoc = ['\main_' task '\pairs\' condition];
    saveFileName = '';
    titleName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\' condition];
    saveFilePairsLoc = ['\target present or absent\main_' task '\pairs\' condition];
    saveFileConfigLoc = ['\target present or absent\main_' task '\configuration\' condition];
    if trialType == 1
        titleName = 'TP';
        saveFileName = '_2TP';
    elseif trialType == 2
        titleName = 'TA';
        saveFileName = '_2TA';
    elseif trialType == 3
        titleName = '';
        saveFileName = '_2';
    elseif trialType == 4
        titleName = 'CR';
        saveFileName = '_2CR';
    elseif trialType == 5
        titleName = 'prevPB';
        saveFileName = '_2PB';
    elseif trialType == 6
        titleName = 'prevPO';
        saveFileName = '_2PO';
    elseif trialType == 7
        titleName = 'prevPN';
        saveFileName = '_2PN';
    end
elseif expN == 3
    saveFileLoc = '\control exp';
    titleName = '';
    saveFileName = '';
end

%% Obtain pboth, pone and pnone for each observer and concatenate over observer
pboth=[];
pone=[];
pnone=[];

pbothp=[];
pnonep=[];

pair_p1=[];
pair_p2=[];

SH_p1=[];
DH_p1=[];
di_p1=[];
si1_p1=[];
si2_p1=[];
diD_p1=[];

SH_p2=[];
DH_p2=[];
di_p2=[];
si1_p2=[];
si2_p2=[];
diD_p2=[];

all_p1=[];
all_p2=[];

P1_C2=[];
P2_C2=[];

numObs = 0;

dir_name = setup_dir();
files = dir(strrep(dir_name,'\',filesep));  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2) && ~strcmp(obs(1,1),'.') && (ismember(obs,observers) || isempty(observers))
        [P1,P2,pb,po,pn,pbp,~,pnp,SH,DH,di,si1,si2,diD,P1C2,P2C2] = p_probe_analysis(obs,task,expN,trialType,false,correct,false,grouping); 
        if ~isempty(P1)            
            all_p1 = horzcat(all_p1,P1);
            all_p2 = horzcat(all_p2,P2);          
            
            pboth = horzcat(pboth,pb);
            pone = horzcat(pone,po);
            pnone = horzcat(pnone,pn); 
            
            pbothp = horzcat(pbothp,pbp);
            pnonep = horzcat(pnonep,pnp); 
            
            [tmpP1,tmpP2] = quadratic_analysis(pbp,pnp);
            pair_p1 = horzcat(pair_p1,tmpP1);
            pair_p2 = horzcat(pair_p2,tmpP2);            

            [tmpP1,tmpP2] = quadratic_analysis(SH(:,1),SH(:,2));
            SH_p1 = horzcat(SH_p1,tmpP1);
            SH_p2 = horzcat(SH_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(DH(:,1),DH(:,2));
            DH_p1 = horzcat(DH_p1,tmpP1);
            DH_p2 = horzcat(DH_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(di(:,1),di(:,2));
            di_p1 = horzcat(di_p1,tmpP1);
            di_p2 = horzcat(di_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(si1(:,1),si1(:,2));
            si1_p1 = horzcat(si1_p1,tmpP1);
            si1_p2 = horzcat(si1_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(si2(:,1),si2(:,2));
            si2_p1 = horzcat(si2_p1,tmpP1);
            si2_p2 = horzcat(si2_p2,tmpP2);

            [tmpP1,tmpP2] = quadratic_analysis(diD(:,1),diD(:,2));
            diD_p1 = horzcat(diD_p1,tmpP1);
            diD_p2 = horzcat(diD_p2,tmpP2);            
            
            if ~isnan(P1C2)
                P1_C2 = horzcat(P1_C2,P1C2);
                P2_C2 = horzcat(P2_C2,P2C2);
            end
            numObs = numObs + 1;
        end
    end
end

Mpb = nanmean(pboth,2);
Mpo = nanmean(pone,2);
Mpn = nanmean(pnone,2);
Spb = nanstd(pboth,[],2)./sqrt(numObs);
Spo = nanstd(pone,[],2)./sqrt(numObs);
Spn = nanstd(pnone,[],2)./sqrt(numObs);

Sp1 = nanstd(all_p1,[],2)./sqrt(numObs);
Sp2 = nanstd(all_p2,[],2)./sqrt(numObs);

m_p1=nanmean(all_p1,2);
m_p2=nanmean(all_p2,2);

s_pair_p1=nanstd(pair_p1,[],2)/sqrt(numObs);
s_pair_p2=nanstd(pair_p2,[],2)/sqrt(numObs);

m_pair_p1=nanmean(pair_p1,2);
m_pair_p2=nanmean(pair_p2,2);

pbp_1_6 = mean(cat(3,pbothp(:,:,1),pbothp(:,:,6)),3);
pbp_2_5 = mean(cat(3,pbothp(:,:,2),pbothp(:,:,5)),3);
pbp_3_4 = mean(cat(3,pbothp(:,:,3),pbothp(:,:,4)),3);
pbp_8_10 = mean(cat(3,pbothp(:,:,8),pbothp(:,:,10)),3);
pbp_9_11 = mean(cat(3,pbothp(:,:,9),pbothp(:,:,11)),3);

pnp_1_6 = mean(cat(3,pnonep(:,:,1),pnonep(:,:,6)),3);
pnp_2_5 = mean(cat(3,pnonep(:,:,2),pnonep(:,:,5)),3);
pnp_3_4 = mean(cat(3,pnonep(:,:,3),pnonep(:,:,4)),3);
pnp_8_10 = mean(cat(3,pnonep(:,:,8),pnonep(:,:,10)),3);
pnp_9_11 = mean(cat(3,pnonep(:,:,9),pnonep(:,:,11)),3);

% % pbp_1_6 = cat(3,pbothp(:,:,1),pbothp(:,:,6));
% % pbp_2_5 = cat(3,pbothp(:,:,2),pbothp(:,:,5));
% % pbp_3_4 = cat(3,pbothp(:,:,3),pbothp(:,:,4));
% % pbp_8_10 = cat(3,pbothp(:,:,8),pbothp(:,:,10));
% % pbp_9_11 = cat(3,pbothp(:,:,9),pbothp(:,:,11));
% % 
% % pnp_1_6 = cat(3,pnonep(:,:,1),pnonep(:,:,6));
% % pnp_2_5 = cat(3,pnonep(:,:,2),pnonep(:,:,5));
% % pnp_3_4 = cat(3,pnonep(:,:,3),pnonep(:,:,4));
% % pnp_8_10 = cat(3,pnonep(:,:,8),pnonep(:,:,10));
% % pnp_9_11 = cat(3,pnonep(:,:,9),pnonep(:,:,11));

pairs_PB = cat(3,pbothp(:,:,7),pbothp(:,:,12),pbp_1_6,pbp_2_5,pbp_3_4,pbp_8_10,pbp_9_11);
pairs_PN = cat(3,pnonep(:,:,7),pnonep(:,:,12),pnp_1_6,pnp_2_5,pnp_3_4,pnp_8_10,pnp_9_11);
[pairs_p1,pairs_p2] = quadratic_analysis(pairs_PB,pairs_PN);

s_pairs_p1 = nanstd(pairs_p1,[],2)/sqrt(numObs);
s_pairs_p2 = nanstd(pairs_p2,[],2)/sqrt(numObs);

m_pairs_p1 = nanmean(pairs_p1,2);
m_pairs_p2 = nanmean(pairs_p2,2);

sameHemiPB = mean(cat(3,pbothp(:,:,1),pbothp(:,:,6),pbothp(:,:,8),pbothp(:,:,9),pbothp(:,:,10),pnonep(:,:,11)),3);
sameHemiPN = mean(cat(3,pnonep(:,:,1),pnonep(:,:,6),pnonep(:,:,8),pnonep(:,:,9),pnonep(:,:,10),pnonep(:,:,11)),3);
[sameHemiP1,sameHemiP2] = quadratic_analysis(sameHemiPB,sameHemiPN);
sem_sameHemiP1 = std(sameHemiP1,[],2)./sqrt(numObs);  
sem_sameHemiP2 = std(sameHemiP2,[],2)./sqrt(numObs); 

diffHemiPB = mean(cat(3,pbothp(:,:,2),pbothp(:,:,3),pbothp(:,:,4),pbothp(:,:,5),pbothp(:,:,7)),3);
diffHemiPN = mean(cat(3,pnonep(:,:,2),pnonep(:,:,3),pnonep(:,:,4),pnonep(:,:,5),pnonep(:,:,7)),3);
[diffHemiP1,diffHemiP2] = quadratic_analysis(diffHemiPB,diffHemiPN);
sem_diffHemiP1 = std(diffHemiP1,[],2)./sqrt(numObs);  
sem_diffHemiP2 = std(diffHemiP2,[],2)./sqrt(numObs);  

d1PB = mean(cat(3,pbothp(:,:,8),pbothp(:,:,9),pbothp(:,:,10),pbothp(:,:,11)),3);
d1PN = mean(cat(3,pnonep(:,:,8),pnonep(:,:,9),pnonep(:,:,10),pnonep(:,:,11)),3);
[d1P1,d1P2] = quadratic_analysis(d1PB,d1PN);
sem_d1P1 = std(d1P1,[],2)./sqrt(numObs);  
sem_d1P2 = std(d1P2,[],2)./sqrt(numObs); 

d2PB = mean(cat(3,pbothp(:,:,1),pbothp(:,:,3),pbothp(:,:,4),pbothp(:,:,6)),3);
d2PN = mean(cat(3,pnonep(:,:,1),pnonep(:,:,3),pnonep(:,:,4),pnonep(:,:,6)),3);
[d2P1,d2P2] = quadratic_analysis(d2PB,d2PN);
sem_d2P1 = std(d2P1,[],2)./sqrt(numObs);  
sem_d2P2 = std(d2P2,[],2)./sqrt(numObs);  

d3PB = mean(cat(3,pbothp(:,:,2),pbothp(:,:,5),pbothp(:,:,7),pbothp(:,:,12)),3);
d3PN = mean(cat(3,pnonep(:,:,2),pnonep(:,:,5),pnonep(:,:,7),pnonep(:,:,12)),3);
[d3P1,d3P2] = quadratic_analysis(d3PB,d3PN);
sem_d3P1 = std(d3P1,[],2)./sqrt(numObs);  
sem_d3P2 = std(d3P2,[],2)./sqrt(numObs);  

squarePB = mean(cat(3,pbothp(:,:,1),pbothp(:,:,2),pbothp(:,:,3),pbothp(:,:,4),pbothp(:,:,5),pbothp(:,:,6)),3);
squarePN = mean(cat(3,pnonep(:,:,1),pnonep(:,:,2),pnonep(:,:,3),pnonep(:,:,4),pnonep(:,:,5),pnonep(:,:,6)),3);
% % squarePB = cat(3,pbothp(:,:,1),pbothp(:,:,2),pbothp(:,:,3),pbothp(:,:,4),pbothp(:,:,5),pbothp(:,:,6));
% % squarePN = cat(3,pnonep(:,:,1),pnonep(:,:,2),pnonep(:,:,3),pnonep(:,:,4),pnonep(:,:,5),pnonep(:,:,6));
% % find number of trials in which delta < 0
% fprintf('---------------------------------\n')
% fprintf('Number of corrections for square:\n')

% squarePB = mean(squarePB,2);
% squarePN = mean(squarePN,2);
[squareP1,squareP2] = quadratic_analysis(squarePB,squarePN);
sem_squareP1 = std(squareP1,[],2)./sqrt(numObs);  
sem_squareP2 = std(squareP2,[],2)./sqrt(numObs); 

% % boot_analysis

% fprintf('---------------------------------\n')

diamondPB = mean(cat(3,pbothp(:,:,7),pbothp(:,:,8),pbothp(:,:,9),pbothp(:,:,10),pbothp(:,:,11),pbothp(:,:,12)),3);
diamondPN = mean(cat(3,pnonep(:,:,7),pnonep(:,:,8),pnonep(:,:,9),pnonep(:,:,10),pnonep(:,:,11),pnonep(:,:,12)),3);
[diamondP1,diamondP2] = quadratic_analysis(diamondPB,diamondPN);
sem_diamondP1 = std(diamondP1,[],2)./sqrt(numObs);  
sem_diamondP2 = std(diamondP2,[],2)./sqrt(numObs); 

configP1P2 = cat(1,mean(squareP1,2),mean(squareP2,2),mean(diamondP1,2),mean(diamondP2,2));

pair1346PB = mean(cat(3,pbothp(:,:,1),pbothp(:,:,3),pbothp(:,:,4),pbothp(:,:,6)),3);
pair1346PN = mean(cat(3,pnonep(:,:,1),pnonep(:,:,3),pnonep(:,:,4),pnonep(:,:,6)),3);
[pair1346P1,pair1346P2] = quadratic_analysis(pair1346PB,pair1346PN);

if printFg && ~difference && expN~=3
    % make a data directory if necessary
    thisdir = strrep(dir_name,'\',filesep);
    if ~isdir(fullfile(thisdir,'figures'))
        disp('Making figures directory');
        mkdir(thisdir,'figures');
    end    
% if exp == 2
%     if ~isdir(fullfile(strrep([thisdir '\figures\main_' task],'\',filesep)),'target present or absent')
%         disp('Making figures directory');
%         mkdir(thisdir,strrep([thisdir '\figures\main_' task],'\',filesep));
%     end     
% end
%  need to correct this. also need to add for pairs and configuration
%  folder
%     if ~isdir(fullfile(strrep([thisdir '\figures\main_' task],'\',filesep)),['main_' task])
%         disp('Making task directory');
%         mkdir(strrep([thisdir '\figures\main_' task],'\',filesep),['main_' task]);
%     end   

    %% Averaging across runs
    if correct
        Spb = Spb*size(Spb,1)/(size(Spb,1)-1);
        Spo = Spo*size(Spo,1)/(size(Spo,1)-1);
        Spn = Spn*size(Spn,1)/(size(Spn,1)-1);
    end
    figure;hold on;
    errorbar(100:30:460,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

    legend('PBoth','POne','PNone')

    if correct
        set(gca,'YTick',-0.15:.05:.15,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.15 0.15])            
    else
        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([0 1])
    end
    
    title([condition ' Search (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')

    if correct
        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_rawProbsC1' saveFileName],'\',filesep));
    else
        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_rawProbs' saveFileName],'\',filesep));
    end
    print ('-dpdf', '-r500',namefig);
    %% Plot p1 and p2 for each probe delay    
    figure;hold on;

    errorbar(100:30:460,m_p1,Sp1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
    errorbar(100:30:460,m_p2,Sp2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

    legend('p1','p2','Location','Best')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])
   
    title([condition ' Search (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')

    plot(50,mean(m_p1,1),'s','Color',p1clr,'LineWidth',2,'MarkerSize',8)
    plot(50,mean(m_p2,1),'s','Color',p2clr,'LineWidth',2,'MarkerSize',8)
   
    h = refline(0,2/12);
    h.Color = [1 1 1]*0.4;
    h.LineStyle = '--';
    
    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);
    
    if correct
        %% Plot p1 and p2 for each probe delay - p1 and p2 from corrected pboth and pnone
        [P1C1,P2C1] = quadratic_analysis(pboth,pnone);
        Sp1C1 = nanstd(P1C1,[],2)/sqrt(numObs)*size(P1C1,1)/(size(P1C1,1)-1);
        Sp2C1 = nanstd(P2C1,[],2)/sqrt(numObs)*size(P2C1,1)/(size(P2C1,1)-1);
        P1C1 = nanmean(P1C1,2);
        P2C1 = nanmean(P2C1,2);
        
        figure;hold on;
        errorbar(100:30:460,P1C1,Sp1C1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,P2C1,Sp2C1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',-0.2:.2:1.2,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.2 1.2])

        title([condition ' Search (n = ' num2str(numObs) ')'],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures\main_' task '\' condition '_p1p2C1'],'\',filesep));
        print ('-dpdf', '-r500',namefig);
        
        %% Plot p1 and p2 for each probe delay - average of corrected p1 and p2 for each observer 
        Sp1C2 = nanstd(P1_C2,[],2)./sqrt(numObs)*size(P1_C2,1)/(size(P1_C2,1)-1);
        Sp2C2 = nanstd(P2_C2,[],2)./sqrt(numObs)*size(P2_C2,1)/(size(P2_C2,1)-1);
        P1_C2 = nanmean(P1_C2,2);
        P2_C2 = nanmean(P2_C2,2);
        figure;hold on;

        errorbar(100:30:460,P1_C2,Sp1C2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,P2_C2,Sp2C2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',-0.35:.35:0.35,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.35 0.35])        

        xlim([0 500])

%         title(condition,'FontSize',24,'Fontname','Ariel')
        title([condition ' Search (n = ' num2str(numObs) ')' titleName],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2C2' saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);
        
        %% Plot p1 and p2 - corrected by combined global average
        global_averageC3 = nanmean(vertcat(all_p1,all_p2),1);
        for i=1:13
            P1C3(i,:) = all_p1(i,:)-global_averageC3;
            P2C3(i,:) = all_p2(i,:)-global_averageC3;
        end
        Sp1C3 = nanstd(P1C3,[],2)/sqrt(numObs)*size(P1C3,1)*2/(size(P1C3,1)*2-1);
        Sp2C3 = nanstd(P2C3,[],2)/sqrt(numObs)*size(P2C3,1)/(size(P2C3,1)-1);        
        P1C3 = nanmean(P1C3,2);
        P2C3 = nanmean(P2C3,2);
        
        figure;hold on;
        errorbar(100:30:460,P1C3,Sp1C3,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,P2C3,Sp2C3,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',-0.4:.1:0.4,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.4 0.4])

        title([condition ' Search (n = ' num2str(numObs) ')' titleName],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2C3' saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);
    end
    if ~correct
        %% Plot p1 and p2 for each pair - square configuration
        figure;
        for numPair = 1:size(m_pair_p1,3)/2
            subplot(2,3,numPair)
            hold on;

            errorbar(100:30:460,m_pair_p1(:,:,numPair),s_pair_p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
            errorbar(100:30:460,m_pair_p2(:,:,numPair),s_pair_p2(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

            legend('p1','p2','Location','Best')
            set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            ylim([0 1])
            xlim([0 500])

            h = refline(0,2/12);
            h.Color = [1 1 1]*0.4;
            h.LineStyle = '--';
            
            if numPair == 4
                ylabel('Probe report probabilities','FontSize',14,'Fontname','Ariel')
            end
            if numPair == 5
                xlabel('Time from search array onset [ms]','FontSize',14,'Fontname','Ariel')
            end

            title(['PAIR n' num2str(numPair)],'FontSize',14,'Fontname','Ariel')  
        end

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2PAIR1' saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);

        %% Plot p1 and p2 for each pair - diamond configuration
        figure;
        for numPair = 1:size(m_pair_p1,3)/2
            subplot(2,3,numPair)
            hold on;

            errorbar(100:30:460,m_pair_p1(:,:,numPair+6),s_pair_p1(:,:,numPair+6),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
            errorbar(100:30:460,m_pair_p2(:,:,numPair+6),s_pair_p2(:,:,numPair+6),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

            legend('p1','p2','Location','Best')
            set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            ylim([0 1])
            xlim([0 500])

            h = refline(0,2/12);
            h.Color = [1 1 1]*0.4;
            h.LineStyle = '--';
            
            if numPair == 4
                ylabel('Probe report probabilities','FontSize',14,'Fontname','Ariel')
            end
            if numPair == 5
                xlabel('Time from search array onset [ms]','FontSize',14,'Fontname','Ariel')
            end

            title(['PAIR n' num2str(numPair+6)],'FontSize',14,'Fontname','Ariel')  
        end

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2PAIR2' saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);  
 
        %% Plot p1 and p2 for square configuration
        figure;
        hold on;        
        errorbar(100:30:460,mean(squareP1,2),sem_squareP1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,mean(squareP2,2),sem_squareP2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

%         legend('p1','p2','Location','Best')

        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        [sig] = diff_ttest(cat(3,squareP1,squareP2),false);
        
        for delay=1:size(sig,1)
            if sig(delay,1) <= 0.05/13
                plot((delay-1)*30+100,0.05,'*','Color',[0 0 0])
            elseif sig(delay,1) <= 0.05
                plot((delay-1)*30+100,0.05,'+','Color',[0 0 0])
            end   
        end        

        ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
        ylim([0 1])
        xlim([0 500])

        title([condition ' Search - Square Configuration - (n = ' num2str(numObs) ') ' titleName],'FontSize',18,'Fontname','Ariel')

        plot(50,mean(mean(squareP1,2),1),'s','Color',p1clr,'LineWidth',2,'MarkerSize',8)
        plot(50,mean(mean(squareP2,2),1),'s','Color',p2clr,'LineWidth',2,'MarkerSize',8)
        
        h = refline(0,2/12);
        h.Color = [1 1 1]*0.4;
        h.LineStyle = '--';
        
        namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileConfigLoc '_p1p2SQ' saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);   
        
        %% Plot scatterplot for square configuration 
        figure; hold on;
        scatter(mean(squareP1,1),mean(squareP2,1))
        set(gca,'XTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        xlim([0 1])
        ylim([0 1])
        xlabel('P1','FontSize',20,'Fontname','Ariel')
        ylabel('P2','FontSize',18,'Fontname','Ariel')
        title(['P1 v. P2 per observer (' condition ' Square, TA)'])
        namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileConfigLoc '_p1p2SQ_SCATTERPLOT' saveFileName],'\',filesep));    
        print ('-dpdf', '-r500',namefig);    

        keyboard
        %% Plot p1 and p2 for diamond configuration
        figure;
        hold on;        
        errorbar(100:30:460,mean(diamondP1,2),sem_diamondP1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,mean(diamondP2,2),sem_diamondP2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

%         legend('p1','p2','Location','Best')

        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
        ylim([0 1])
        xlim([0 500])

        [sig] = diff_ttest(cat(3,diamondP1,diamondP2),false);
        for delay=1:size(sig,1)
            if sig(delay,1) <= 0.05/13
                plot((delay-1)*30+100,0.05,'*','Color',[0 0 0])
            elseif sig(delay,1) <= 0.05
                plot((delay-1)*30+100,0.05,'+','Color',[0 0 0])
            end   
        end 
        
        title([condition ' Search - Diamond Configuration - (n = ' num2str(numObs) ') ' titleName],'FontSize',18,'Fontname','Ariel')

        plot(50,mean(mean(diamondP1,2),1),'s','Color',p1clr,'LineWidth',2,'MarkerSize',8)
        plot(50,mean(mean(diamondP2,2),1),'s','Color',p2clr,'LineWidth',2,'MarkerSize',8)

        h = refline(0,2/12);
        h.Color = [1 1 1]*0.4;
        h.LineStyle = '--';
        
        namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileConfigLoc '_p1p2DMD' saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);         
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT HEMIFIELDS %%%%%%%%%%%%%%%%%%%%%%%
        %% Plot p1 and p2 for same hemifield
        figure;
        hold on;       
        errorbar(100:30:460,mean(sameHemiP1,2),sem_sameHemiP1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,mean(sameHemiP2,2),sem_sameHemiP2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
        ylim([0 1])
        xlim([0 500])

        title([condition ' Search - Same Hemi - (n = ' num2str(numObs) ') ' titleName],'FontSize',18,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2SH' saveFileName],'\',filesep));

        print ('-dpdf', '-r500',namefig);        
        
        %% Plot p1 and p2 for different hemifield
        figure;
        hold on;        
        errorbar(100:30:460,mean(diffHemiP1,2),sem_diffHemiP1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,mean(diffHemiP2,2),sem_diffHemiP2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
        ylim([0 1])
        xlim([0 500])

        title([condition ' Search - Diff Hemi - (n = ' num2str(numObs) ') ' titleName],'FontSize',18,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2DH' saveFileName],'\',filesep));

        print ('-dpdf', '-r500',namefig);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOT ACCORDING TO DISTANCE %%%%%%%%%%%%%%%%%%%%%%%
        %% Plot p1 and p2 for d1 (shortest distance)
        figure;
        hold on;              
        errorbar(100:30:460,mean(d1P1,2),sem_d1P1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,mean(d1P2,2),sem_d1P2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
        ylim([0 1])
        xlim([0 500])

        title([condition ' Search - Shortest Dist - (n = ' num2str(numObs) ') ' titleName],'FontSize',18,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2D1' saveFileName],'\',filesep));

        print ('-dpdf', '-r500',namefig);
        
        %% Plot p1 and p2 for d2 (medium distance)
        figure;
        hold on;
        errorbar(100:30:460,mean(d2P1,2),sem_d2P1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,mean(d2P2,2),sem_d2P2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
        ylim([0 1])

        xlim([0 500])

        title([condition ' Search - Medium Dist - (n = ' num2str(numObs) ') ' titleName],'FontSize',18,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2D2' saveFileName],'\',filesep));

        print ('-dpdf', '-r500',namefig);   
        
        %% Plot p1 and p2 for d3 (farthest distance)
        figure;
        hold on;        
        errorbar(100:30:460,mean(d3P1,2),sem_d3P1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,mean(d3P2,2),sem_d3P2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
        ylim([0 1])
        xlim([0 500])

        title([condition ' Search - Farthest Dist - (n = ' num2str(numObs) ') ' titleName],'FontSize',18,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2D3' saveFileName],'\',filesep));

        print ('-dpdf', '-r500',namefig);  
    end            
    %%%%%%%%%%%%%%%%%%%% OTHER PAIR GROUPINGS %%%%%%%%%%%%%%%%%%%%%%%% 
    for i = 1:size(m_pairs_p1,3)
        t1 = m_pairs_p1(:,:,i);
        t2 = m_pairs_p2(:,:,i);
        s1 = s_pairs_p1(:,:,i);
        s2 = s_pairs_p2(:,:,i);

        figure;hold on;
        errorbar(100:30:460,t1,s1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p1clr)
        errorbar(100:30:460,t2,s2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',p2clr)

        legend('p1','p2','Location','Best')

        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([0 1])
        xlim([0 500])

        if i == 1
            name = '7';
        elseif i == 2
            name = '12';
        elseif i == 3
            name = '1 and 6';
        elseif i == 4
            name = '2 and 5';            
        elseif i == 5
            name = '3 and 4';
        elseif i == 6
            name = '8 and 10';                 
        elseif i == 7
            name = '9 and 11';   
        end

        title([condition ' Search - Pair ' name ' ' titleName],'FontSize',20,'Fontname','Ariel')

        namefig=sprintf('%s', strrep([dir_name '\figures\' saveFilePairsLoc '_p1p2_' name saveFileName],'\',filesep));
        print ('-dpdf', '-r500',namefig);   
    end     
end
if printFg && difference && expN~=3
    %% Plot p1 and p2 for each probe delay    
    figure;hold on;
    d = m_p1-m_p2;
    s_diff = std(all_p1-all_p2,[],2)/sqrt(numObs);
    errorbar(100:30:460,d,s_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

    set(gca,'YTick',-0.6:.2:0.6,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2,'Fontname','Ariel')

    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([-0.6 0.6])
    xlim([0 500])

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
    
    title([condition ' Search (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2diff' saveFileName],'\',filesep));

    print ('-dpdf', '-r500',namefig);    
    %% Plot p1 and p2 for each pair - square configuration
    figure;
    for numPair = 1:size(m_pair_p1,3)/2
        subplot(2,3,numPair)
        hold on;
        d = m_pair_p1(:,:,numPair)-m_pair_p2(:,:,numPair);
        s_diff = std(pair_p1(:,:,numPair)-pair_p2(:,:,numPair),[],2)/sqrt(numObs);
        errorbar(100:30:460,d,s_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        ylim([-0.8 0.8])
        xlim([0 500])

        if numPair == 1 || numPair == 4
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end
        
        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        title(['PAIR n' num2str(numPair)],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2PAIR1diff' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    %% Plot p1 and p2 for each pair - diamond configuration
    figure;
    for numPair = 1:size(m_pair_p1,3)/2
        subplot(2,3,numPair)
        hold on;
        d = m_pair_p1(:,:,numPair+6)-m_pair_p2(:,:,numPair+6);
        s_diff = std(pair_p1(:,:,numPair+6)-pair_p2(:,:,numPair+6),[],2)/sqrt(numObs);
        errorbar(100:30:460,d,s_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])
        
        set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        ylim([-0.8 0.8])
        xlim([0 500])

        if numPair == 1 || numPair == 4
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        title(['PAIR n' num2str(numPair+6)],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_p1p2PAIR2diff' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);  

end

if printFg && expN==3 
    sem_pb = std(pboth,[],2)./sqrt(numObs);
    sem_po = std(pone,[],2)./sqrt(numObs);
    sem_pn = std(pnone,[],2)./sqrt(numObs);
    
    sem_p1 = std(all_p1,[],2)./sqrt(numObs);
    sem_p2 = std(all_p2,[],2)./sqrt(numObs);
    
    %% Plot PBoth, POne, PNone bar graph for control exp
    figure; 
    hold on
    bar(1,Mpb(1),.5,'FaceColor',[1 0 0])
    bar(2,Mpo(1),.5,'FaceColor',[0 1 0])
    bar(3,Mpn(1),.5,'FaceColor',[0 0 1])
    errorbar(1,Mpb(1),sem_pb(1,1),'.','Color',[0 0 0])
    errorbar(2,Mpo(1),sem_po(1,1),'.','Color',[0 0 0])
    errorbar(3,Mpn(1),sem_pn(1,1),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',1:1:3,'XTickLabel',{'PBoth','POne','PNone'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([0 4])
    ylim([0 1])
    ylabel('Percent Correct')
    title('Control Exp')
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\rawProbsBar'],'\',filesep));
    print ('-dpdf', '-r500',namefig); 
    
    %% Graph p1 p2 bar graph for control exp
    figure;
    hold on
    bar(1,m_p1(1,1),.5,'FaceColor',[0 0 0])
    bar(2,m_p2(1,1),.5,'FaceColor',[0 0 0])
    errorbar(1,m_p1(1,1),sem_p1(1,1),'.','Color',[0 0 0])
    errorbar(2,m_p2(1,1),sem_p2(1,1),'.','Color',[0 0 0])
    hold off
    set(gca,'XTick',1:1:2,'XTickLabel',{'P1','P2'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([0 3])
    ylim([0 1])
    ylabel('Probe report probability')
    title('Cueing Task')
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2Bar'],'\',filesep));
    print ('-dpdf','-r500',namefig); 
    
    %% Plot p1 and p2 with same color for all obs for control exp
    figure;
    hold on
    for i=1:numObs
        plot(1,all_p1(1,i),'-ro','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',5,'Color',[0 153 51]/255)
        plot(1.5,all_p2(1,i),'-ro','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',5,'Color',[0 153 51]/255)
    end    
    errorbar(1,m_p1(1,1),sem_p1(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    errorbar(1.5,m_p2(1,1),sem_p2(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    hold off
    set(gca,'XTick',1:.5:1.5,'XTickLabel',{'P1','P2'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([.5 2])
    ylim([2/12 1])
    ylabel('Probe report probability')
    title('Cueing Task')
%     h = refline(0,2/12);
%     h.Color = [1 1 1]*0.4;
%     h.LineStyle = '--';
    
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
 
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
    set(gcf, 'renderer', 'painters');
    
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2Plot'],'\',filesep));
    print (gcf,'-dpdf','-r500',namefig); 
    
    [H,P,CI,STATS] = ttest(rot90(all_p1(1,:)),rot90(all_p2(1,:)))
        
    %% Plot p1 p2 with numbers for each obs for control exp
    figure;
    hold on
    for i=1:numObs
%         t(1) = text(.989,all_p1(1,i),num2str(i));
%         t(2) = text(1.489,all_p2(1,i),num2str(i));
        t(1) = text(.95,all_p1(1,i),num2str(i));
        t(2) = text(1.45,all_p2(1,i),num2str(i));
        set(t(:),'FontSize',7,'Fontname','Ariel')
    end    
    errorbar(1,m_p1(1,1),sem_p1(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    errorbar(1.5,m_p2(1,1),sem_p2(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    hold off
    set(gca,'XTick',1:.5:1.5,'XTickLabel',{'P1','P2'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([.5 2])
    ylim([2/12 1])
    ylabel('Probe report probability')
    title('Cueing Task')
%     h = refline(0,2/12);
%     h.Color = [1 1 1]*0.4;
%     h.LineStyle = '--';
    
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
 
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
    set(gcf, 'renderer', 'painters');
    
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2PlotN'],'\',filesep));
    print (gcf,'-dpdf','-r500',namefig); 
    
    %% Plot p1 and p2 with different colors for each obs for control exp
    figure;
    hold on
    colorOrder = {[255 51 51],[255 102 51],[255 153 51],[255 204 51],[153 255 51],[51 255 102],[51 255 153],[51 204 255],[51 153 255],[51 51 255],[102 51 255],[153 51 255],[204 51 255],[255 51 153],[255 51 102],[255 51 51]};
    for i=1:numObs
        if i*2-1<size(colorOrder,2)
            clr = colorOrder{i*2-1}/255;
        else
            clr = colorOrder{(i-(size(colorOrder,2)/2))*2}/255;
        end
        plot(1,all_p1(1,i),'-ro','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',5,'Color',clr)
        plot(1.5,all_p2(1,i),'-ro','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',5,'Color',clr)
    end
    errorbar(1,m_p1(1,1),sem_p1(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    errorbar(1.5,m_p2(1,1),sem_p2(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    hold off
    set(gca,'XTick',1:.5:1.5,'XTickLabel',{'P1','P2'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([.5 2])
    ylim([2/12 1])
    ylabel('Probe report probability') 
    title('Cueing Task')
%     h = refline(0,2/12);
%     h.Color = [1 1 1]*0.4;
%     h.LineStyle = '--';
    
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
 
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
    set(gcf, 'renderer', 'painters');
    
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2PlotC'],'\',filesep));
    print (gcf,'-dpdf','-r500',namefig); 
    
    %% Plot p1 and p2 with same color for all obs for control exp
    
    median_p1 = median(all_p1(1,:));
    median_p2 = median(all_p2(1,:));

    figure;
    hold on
    for i=1:numObs
        plot(1,all_p1(1,i),'-ro','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',5,'Color',[0 153 51]/255)
        plot(1.5,all_p2(1,i),'-ro','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',5,'Color',[0 153 51]/255)
    end    
    errorbar(1,median_p1,sem_p1(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    errorbar(1.5,median_p2,sem_p2(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    hold off
    set(gca,'XTick',1:.5:1.5,'XTickLabel',{'P1','P2'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([.5 2])
    ylim([2/12 1])
    ylabel('Probe report probability')
    title('Cueing Task')
%     h = refline(0,2/12);
%     h.Color = [1 1 1]*0.4;
%     h.LineStyle = '--';
    
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
 
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
    set(gcf, 'renderer', 'painters');
    
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2MedianPlot'],'\',filesep));
    print (gcf,'-dpdf','-r500',namefig); 
    
    %% Plot p1 p2 with numbers for each obs for control exp
    figure;
    hold on
    for i=1:numObs
%         t(1) = text(.989,all_p1(1,i),num2str(i));
%         t(2) = text(1.489,all_p2(1,i),num2str(i));
        t(1) = text(.95,all_p1(1,i),num2str(i));
        t(2) = text(1.45,all_p2(1,i),num2str(i));
        set(t(:),'FontSize',7,'Fontname','Ariel')
    end    
    errorbar(1,median_p1,sem_p1(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    errorbar(1.5,median_p2,sem_p2(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    hold off
    set(gca,'XTick',1:.5:1.5,'XTickLabel',{'P1','P2'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([.5 2])
    ylim([2/12 1])
    ylabel('Probe report probability')
    title('Cueing Task')
%     h = refline(0,2/12);
%     h.Color = [1 1 1]*0.4;
%     h.LineStyle = '--';
    
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
 
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
    set(gcf, 'renderer', 'painters');
    
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2PlotMedianN'],'\',filesep));
    print (gcf,'-dpdf','-r500',namefig); 
    
    %% Plot p1 and p2 with different colors for each obs for control exp
    figure;
    hold on
    colorOrder = {[255 51 51],[255 102 51],[255 153 51],[255 204 51],[153 255 51],[51 255 102],[51 255 153],[51 204 255],[51 153 255],[51 51 255],[102 51 255],[153 51 255],[204 51 255],[255 51 153],[255 51 102],[255 51 51]};
    for i=1:numObs
        if i*2-1<size(colorOrder,2)
            clr = colorOrder{i*2-1}/255;
        else
            clr = colorOrder{(i-(size(colorOrder,2)/2))*2}/255;
        end
        plot(1,all_p1(1,i),'-ro','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',5,'Color',clr)
        plot(1.5,all_p2(1,i),'-ro','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',5,'Color',clr)
    end
    errorbar(1,median_p1,sem_p1(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    errorbar(1.5,median_p2,sem_p2(1,1),'-ro','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])
    hold off
    set(gca,'XTick',1:.5:1.5,'XTickLabel',{'P1','P2'},'FontSize',13,'LineWidth',2','Fontname','Ariel')    
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    xlim([.5 2])
    ylim([2/12 1])
    ylabel('Probe report probability') 
    title('Cueing Task')
%     h = refline(0,2/12);
%     h.Color = [1 1 1]*0.4;
%     h.LineStyle = '--';
    
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
 
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [6.25 7.5]);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
    set(gcf, 'renderer', 'painters');
    
    namefig=sprintf('%s', strrep([dir_name '\figures\control exp\p1p2PlotMedianC'],'\',filesep));
    print (gcf,'-dpdf','-r500',namefig);     
end
%% Bar graphs for PBOTH, PNONE, and PONE. Note that the graph is not saved.
% figure;hold on;
% y = [];
% x = 1:numObs;
% for i = 1:numObs
%     y = [y;mean(pboth(:,i)),mean(pone(:,i)),mean(pnone(:,i))];
% end
% b = bar(x,y);
% set(gca,'YTick',0:.2:1,'FontSize',15,'LineWidth',2','Fontname','Ariel')
% ylabel('Percent correct','FontSize',15,'Fontname','Ariel')
% xlabel('Observer','FontSize',15,'Fontname','Ariel')
% title([condition ' Probe Performance' saveFileName],'FontSize',15,'Fontname','Ariel')
% ylim([0 1])
% set(gca,'XTick',1:1:numObs,'FontSize',15,'LineWidth',2','Fontname','Ariel')
% legend('PBoth','POne','PNone')

if printColormap
    %% Plot colormap for all pairs across all delays
    figure; hold on;
    all_diff = m_pair_p1 - m_pair_p2;
    d = [];
    for i = 1:size(all_diff,3)
        d(i,:) = all_diff(:,:,i);
    end
    diff = flipud(d);
    if absDiff
        diff = abs(diff);
    end
    imagesc(diff,[cMin cMax]);
    colorbar
    xlim([0.5 13.5])
    ylim([0.5 12.5])
    set(gca,'YTick',1:1:12,'YTickLabel',{'12','11','10','9','8','7','6','5','4','3','2','1'})
    set(gca,'XTick',1:1:13,'XTickLabel',{'100','130','160','190','220','250','280','310','340','370','400','430','460'})
    ylabel('Pair Number','FontSize',10,'Fontname','Ariel')
    xlabel('Time from Search Array Onset [ms]','FontSize',10,'Fontname','Ariel')
    title([condition ' P1 - P2 ' titleName],'FontSize',15,'Fontname','Ariel')
    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_Overall' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    %% Plot colormap of all pairs averaged across all delays
    figure; hold on;
    diff = mean(d,2);
    imagesc(diff,[cMin cMax]);
    colorbar
    ylim([0.5 12.5])
    set(gca,'YTick',1:1:12,'YTickLabel',{'12','11','10','9','8','7','6','5','4','3','2','1'})
    set(gca,'XTickLabel',{'','',''})
    ylabel('Pair Number','FontSize',10,'Fontname','Ariel')
    xlabel('Averaged Across Delays','FontSize',10,'Fontname','Ariel')
    title([condition ' P1 - P2 ' titleName],'FontSize',15,'Fontname','Ariel')
    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_OverallAvg' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    % %% Plot Performance Field groupings for all delays
    % figure; hold on;
    % group1 = mean(vertcat(d(8,:),d(9,:),d(10,:),d(11,:)),1);
    % group2 = mean(vertcat(d(7,:),d(12,:)),1);
    % group3 = mean(vertcat(d(1,:),d(2,:),d(3,:),d(4,:),d(5,:),d(6,:)),1);
    % groups = vertcat(group1,group2,group3);
    % if absDiff
    %     groups = abs(groups);
    % end
    % imagesc(flipud(groups),[cMin cMax]);
    % colorbar
    % xlim([0.5 13.5])
    % ylim([0.5 3.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
    % set(gca,'XTick',1:1:13,'XTickLabel',{'100','130','160','190','220','250','280','310','340','370','400','430','460'})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Performance Field) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_PerfField' saveFileName],'\',filesep));
    % print ('-dpdf', '-r500',namefig);
    % 
    % %% Plot Performance Field groupings averaged across delays
    % ylim([0.5 3.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
    % set(gca,'XTickLabel',{'','',''})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Performance Field) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_PerfFieldAvg' saveFileName],'\',filesep));
    % print ('-dpdf', '-r500',namefig);
    % 
    % %% Plot Hemifield groupings across all delays
    % figure; hold on;
    % group1 = mean(vertcat(d(2,:),d(3,:),d(4,:),d(5,:),d(7,:)),1);
    % group2 = mean(vertcat(d(8,:),d(9,:),d(10,:),d(11,:),d(12,:)),1);
    % group3 = mean(vertcat(d(1,:),d(6,:)),1);
    % groups = vertcat(group1,group2,group3);
    % if absDiff
    %     groups = abs(groups);
    % end
    % imagesc(flipud(groups),[cMin cMax]);
    % colorbar
    % figure; hold on;
    % groups = mean(groups,2);
    % imagesc(flipud(groups),[cMin cMax]);
    % colorbar
    % xlim([0.5 13.5])
    % ylim([0.5 3.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
    % set(gca,'XTick',1:1:13,'XTickLabel',{'100','130','160','190','220','250','280','310','340','370','400','430','460'})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Hemifield) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_Hemifield' saveFileName],'\',filesep));
    % print ('-dpdf', '-r500',namefig);
    % 
    % %% Plot Hemifield groupings averaged across delays
    % figure; hold on;
    % groups = mean(groups,2);
    % imagesc(flipud(groups),[cMin cMax]);
    % colorbar
    % ylim([0.5 3.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
    % set(gca,'XTickLabel',{'','',''})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Hemifield) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_HemifieldAvg' saveFileName],'\',filesep));
    % print ('-dpdf', '-r500',namefig);
    % 
    % %% Plot colormap for Distance groupings across all delays
    % figure; hold on;
    % group1 = mean(vertcat(d(2,:),d(5,:),d(7,:),d(12,:)),1);
    % group2 = mean(vertcat(d(1,:),d(3,:),d(4,:),d(6,:)),1);
    % group3 = mean(vertcat(d(8,:),d(9,:),d(10,:),d(11,:)),1);
    % groups = vertcat(group1,group2,group3);
    % if absDiff
    %     groups = abs(groups);
    % end
    % imagesc(flipud(groups),[cMin cMax]);
    % colorbar
    % xlim([0.5 13.5])
    % ylim([0.5 3.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
    % set(gca,'XTick',1:1:13,'XTickLabel',{'100','130','160','190','220','250','280','310','340','370','400','430','460'})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Distance) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_Distance' saveFileName],'\',filesep));
    % print ('-dpdf', '-r500',namefig);
    % 
    % %% Plot colormap for Distance groupings averaged across all delays
    % figure; hold on;
    % groups = mean(groups,2);
    % imagesc(flipud(groups),[cMin cMax]);
    % colorbar
    % ylim([0.5 3.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
    % set(gca,'XTickLabel',{'','',''})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Distance) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_DistanceAvg' saveFileName],'\',filesep));
    % print ('-dpdf', '-r500',namefig);
    % 
    % %% Plot colormap for Configuration groupings for each delay
    % figure; hold on;
    % group1 = mean(vertcat(d(1,:),d(2,:),d(3,:),d(4,:),d(5,:),d(6,:)),1);
    % group2 = mean(vertcat(d(7,:),d(8,:),d(9,:),d(10,:),d(11,:),d(12,:)),1);
    % groups = vertcat(group1,group2);
    % if absDiff
    %     groups = abs(groups);
    % end
    % imagesc(flipud(groups),[cMin cMax]);
    % colorbar
    % xlim([0.5 13.5])
    % ylim([0.5 2.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'Diamond','Square'})
    % set(gca,'XTick',1:1:13,'XTickLabel',{'100','130','160','190','220','250','280','310','340','370','400','430','460'})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Configuration) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_Config' saveFileName],'\',filesep));
    % print ('-dpdf', '-r500',namefig);
    % 
    % %% Plot colormap for Configuration groups averaged across delays
    % figure; hold on;
    % groups = mean(groups,2);
    % imagesc(flipud(groups),[cMin cMax]);
    % colorbar
    % ylim([0.5 2.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'Diamond','Square'})
    % set(gca,'XTickLabel',{'','',''})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Configuration) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_ConfigAvg' saveFileName],'\',filesep));
    % print ('-dpdf', '-r500',namefig);


    %% Plot colormap for square configuration for each delay
    figure; hold on;
    group1 = mean(vertcat(d(1,:),d(6,:)),1);
    group2 = mean(vertcat(d(3,:),d(4,:)),1);
    group3 = mean(vertcat(d(2,:),d(5,:)),1);
    groups = vertcat(group1,group2,group3);
    if absDiff
        groups = abs(groups);
    end
    imagesc(flipud(groups),[cMin cMax]);
    colorbar
    xlim([0.5 13.5])
    ylim([0.5 3.5])
    set(gca,'YTick',1:1:3,'YTickLabel',{'2 and 5','3 and 4','1 and 6'})
    set(gca,'XTick',1:1:13,'XTickLabel',{'100','130','160','190','220','250','280','310','340','370','400','430','460'})
    ylabel('Pairs','FontSize',12,'Fontname','Ariel')
    xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
    title([condition ' P1 - P2 (Square) ' titleName],'FontSize',15,'Fontname','Ariel')
    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_Square' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    %% Plot colormap for square configuration averaged across delays
    figure; hold on;
    groups = mean(groups,2);
    imagesc(flipud(groups),[cMin cMax]);
    colorbar
    ylim([0.5 3.5])
    set(gca,'YTick',1:1:3,'YTickLabel',{'2 and 5','3 and 4','1 and 6'})
    set(gca,'XTickLabel',{'','',''})
    ylabel('Pairs','FontSize',12,'Fontname','Ariel')
    xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
    title([condition ' P1 - P2 (Square) ' titleName],'FontSize',15,'Fontname','Ariel')
    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_SquareAvg' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    %% Plot colormap for diamond configuration for each delay
    figure; hold on;
    group1 = mean(d(7,:),1);
    group2 = mean(d(12,:),1);
    groups = vertcat(group1,group2);
    if absDiff
        groups = abs(groups);
    end
    imagesc(flipud(groups),[cMin cMax]);
    colorbar
    xlim([0.5 13.5])
    ylim([0.5 2.5])
    set(gca,'YTick',1:1:2,'YTickLabel',{'12','7'})
    set(gca,'XTick',1:1:13,'XTickLabel',{'100','130','160','190','220','250','280','310','340','370','400','430','460'})
    ylabel('Pairs','FontSize',12,'Fontname','Ariel')
    xlabel('Time from Search Array Onset [ms]','FontSize',12,'Fontname','Ariel')
    title([condition ' P1 - P2 (Diamond) ' titleName],'FontSize',15,'Fontname','Ariel')
    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_Diamond' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);

    %% Plot colormap for diamond configuration averaged across delays
    figure; hold on;
    groups = mean(groups,2);
    imagesc(flipud(groups),[cMin cMax]);
    colorbar
    ylim([0.5 2.5])
    set(gca,'YTick',1:1:2,'YTickLabel',{'12','7'})
    set(gca,'XTickLabel',{'','',''})
    ylabel('Pairs','FontSize',12,'Fontname','Ariel')
    xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
    title([condition ' P1 - P2 (Diamond) ' titleName],'FontSize',15,'Fontname','Ariel')
    namefig=sprintf('%s', strrep([dir_name '\figures' saveFileLoc '_DiamondAvg' saveFileName],'\',filesep));
    print ('-dpdf', '-r500',namefig);
end

if printFFT && expN~=3
    %% Conduct FFT's
%     obsDiff = pair_p1 - pair_p2;
%     diff1and6 = mean(cat(3,obsDiff(:,:,1),obsDiff(:,:,6)),3);
%     diff2and5 = mean(cat(3,obsDiff(:,:,2),obsDiff(:,:,5)),3);
%     diff3and4 = mean(cat(3,obsDiff(:,:,3),obsDiff(:,:,4)),3);
%     diff7 = mean(obsDiff(:,:,7),3);
%     diff12 = mean(obsDiff(:,:,12),3);

%     fft_p1_p2([],[],diff1and6,expN,trialType,task,'1and6');
%     fft_p1_p2([],[],diff2and5,expN,trialType,task,'2and5');
%     fft_p1_p2([],[],diff3and4,expN,trialType,task,'3and4');
%     fft_p1_p2([],[],diff7,expN,trialType,task,'7');
%     fft_p1_p2([],[],diff12,expN,trialType,task,'12');

    fft_p1_p2(squareP1,squareP2,[],expN,trialType,task,'Square');

    fft_p1_p2(all_p1,all_p2,[],expN,trialType,task,'');
end

%% Conducts ANOVA on P1 and P2
if printStats
   setupRMAOV2(all_p1,all_p2)
   fprintf('------------------------------------------------------\n')
   fprintf('SQUARE CONFIGURATION\n')
   setupRMAOV2(squareP1,squareP2);
   fprintf('------------------------------------------------------\n')
   fprintf('DIAMOND CONFIGURATION\n')  
   setupRMAOV2(diamondP1,diamondP2);   
end
end

function setupRMAOV2(p1,p2)
numObs = size(p1,2);
p1p2 = zeros(numObs*13*2,4);
index = 0;
for i = 1:numObs
    p1p2(index+1:index+13,1) = p1(:,i);
    p1p2(index+1:index+13,2) = rot90(1:13,-1);
    p1p2(index+1:index+13,3) = ones(13,1);
    p1p2(index+1:index+13,4) = ones(13,1)*i;
    index = index + 13;
    p1p2(index+1:index+13,1) = p2(:,i);
    p1p2(index+1:index+13,2) = rot90(1:13,-1);
    p1p2(index+1:index+13,3) = ones(13,1)*2;
    p1p2(index+1:index+13,4) = ones(13,1)*i;
    index = index + 13;
end
RMAOV2(p1p2);  
end

