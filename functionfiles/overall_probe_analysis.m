function [all_p1,all_p2,pairs_p1,pairs_p2,pair_p1,pair_p2] = overall_probe_analysis(task,expN,trialType,difference,correct,printFg,printColormap,printFFT,printStats,grouping,absDiff,cMin,cMax,observers)
%% This function graphs raw probabilities and p1 & p2 for overall, pairs, and hemifields across all observers
%% Example
%%% [all_p1,all_p2,pairs_p1,pairs_p2,pair_p1,pair_p2] = overall_probe_analysis('difficult',2,2,false,false,true,true,true,false,1,true,0.1,0.3,{'ax','ld'});

%% Parameters
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2) 
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
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFilePairsLoc = ['\main_' task '\pairs\' condition];
    saveFileName = '';
    titleName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\' condition];
    saveFilePairsLoc = ['\target present or absent\main_' task '\pairs\' condition];
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
end

%% Obtain pboth, pone and pnone for each observer and concatenate over observer
pboth=[];
pone=[];
pnone=[];

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

pairs_p1=[];
pairs_p2=[];

numObs = 0;

thisdir = 'C:\Users\alice_000\Documents\MATLAB\data';
files = dir(thisdir);  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2) && ~strcmp(obs(1,1),'.') && (ismember(obs,observers) || isempty(observers))
        [P1,P2,pb,po,pn,pbp,pnp,SH,DH,di,si1,si2,diD,P1C2,P2C2,pb_pairs,pn_pairs] = p_probe_analysis(obs,task,expN,trialType,false,correct,false,grouping); 
        if ~isempty(P1)            
            all_p1 = horzcat(all_p1,P1);
            all_p2 = horzcat(all_p2,P2);

            pboth = horzcat(pboth,pb);
            pone = horzcat(pone,po);
            pnone = horzcat(pnone,pn); 

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
            
            [tmpP1,tmpP2] = quadratic_analysis(pb_pairs,pn_pairs);
            pairs_p1 = horzcat(pairs_p1,tmpP1);
            pairs_p2 = horzcat(pairs_p2,tmpP2);
            
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

s_pairs_p1 = nanstd(pairs_p1,[],2)/sqrt(numObs);
s_pairs_p2 = nanstd(pairs_p2,[],2)/sqrt(numObs);

m_pairs_p1 = nanmean(pairs_p1,2);
m_pairs_p2 = nanmean(pairs_p2,2);

s_pair_p1=nanstd(pair_p1,[],2)/sqrt(numObs);
s_pair_p2=nanstd(pair_p2,[],2)/sqrt(numObs);

m_pair_p1=nanmean(pair_p1,2);
m_pair_p2=nanmean(pair_p2,2);

if printFg && ~difference
    % make a data directory if necessary
%     if ~isdir(fullfile(thisdir,'figures'))
%         disp('Making figures directory');
%         mkdir(thisdir,'figures');
%     end    
%     if ~isdir(fullfile([thisdir '\figures'],'pairs'))
%         disp('Making pairs directory');
%         mkdir([thisdir '\figures'],'pairs');
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
        namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_rawProbsC1' saveFileName]);
    else
        namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_rawProbs' saveFileName]);
    end
    print ('-djpeg', '-r500',namefig);
    %% Plot p1 and p2 for each probe delay    
    figure;hold on;

    errorbar(100:30:460,m_p1,Sp1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    errorbar(100:30:460,m_p2,Sp2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    xlim([0 500])

    title([condition ' Search (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2' saveFileName]);

    print ('-djpeg', '-r500',namefig);
    
    if correct
        %% Plot p1 and p2 for each probe delay - p1 and p2 from corrected pboth and pnone
        %% pboth and pnone
        [P1C1,P2C1] = quadratic_analysis(pboth,pnone);
        Sp1C1 = nanstd(P1C1,[],2)/sqrt(numObs)*size(P1C1,1)/(size(P1C1,1)-1);
        Sp2C1 = nanstd(P2C1,[],2)/sqrt(numObs)*size(P2C1,1)/(size(P2C1,1)-1);
        P1C1 = nanmean(P1C1,2);
        P2C1 = nanmean(P2C1,2);
        
        figure;hold on;
        errorbar(100:30:460,P1C1,Sp1C1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(100:30:460,P2C1,Sp2C1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',-0.2:.2:1.2,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.2 1.2])

        title([condition ' Search (n = ' num2str(numObs) ')'],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\main_' task '\' condition '_p1p2C1']);
        print ('-djpeg', '-r500',namefig);
        
        %% Plot p1 and p2 for each probe delay - average of corrected p1 and p2 for each observer 
        Sp1C2 = nanstd(P1_C2,[],2)./sqrt(numObs)*size(P1_C2,1)/(size(P1_C2,1)-1);
        Sp2C2 = nanstd(P2_C2,[],2)./sqrt(numObs)*size(P2_C2,1)/(size(P2_C2,1)-1);
        P1_C2 = nanmean(P1_C2,2);
        P2_C2 = nanmean(P2_C2,2);
        figure;hold on;

        errorbar(100:30:460,P1_C2,Sp1C2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(100:30:460,P2_C2,Sp2C2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',-0.35:.35:0.35,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.35 0.35])        

        xlim([0 500])

        title([condition ' Search (n = ' num2str(numObs) ')' titleName],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2C2' saveFileName]);
        print ('-djpeg', '-r500',namefig);
        
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
        errorbar(100:30:460,P1C3,Sp1C3,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        errorbar(100:30:460,P2C3,Sp2C3,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',-0.4:.1:0.4,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.4 0.4])

        title([condition ' Search (n = ' num2str(numObs) ')' titleName],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2C3' saveFileName]);
        print ('-djpeg', '-r500',namefig);
    end
    if ~correct
        %% Plot p1 and p2 for each pair - square configuration
        figure;
        for numPair = 1:size(m_pair_p1,3)/2
            subplot(2,3,numPair)
            hold on;

            errorbar(100:30:460,m_pair_p1(:,:,numPair),s_pair_p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
            errorbar(100:30:460,m_pair_p2(:,:,numPair),s_pair_p2(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

            legend('p1','p2','Location','SouthEast')
            set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            ylim([0 1])
            xlim([0 500])

            if numPair == 4
                ylabel('Probe report probabilities','FontSize',14,'Fontname','Ariel')
            end
            if numPair == 5
                xlabel('Time from search array onset [ms]','FontSize',14,'Fontname','Ariel')
            end

            title(['PAIR n' num2str(numPair)],'FontSize',14,'Fontname','Ariel')  
        end

        namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2PAIR1' saveFileName]);
        print ('-djpeg', '-r500',namefig);

        %% Plot p1 and p2 for each pair - diamond configuration
        figure;
        for numPair = 1:size(m_pair_p1,3)/2
            subplot(2,3,numPair)
            hold on;

            errorbar(100:30:460,m_pair_p1(:,:,numPair+6),s_pair_p1(:,:,numPair+6),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
            errorbar(100:30:460,m_pair_p2(:,:,numPair+6),s_pair_p2(:,:,numPair+6),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

            legend('p1','p2','Location','SouthEast')
            set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            ylim([0 1])
            xlim([0 500])

            if numPair == 4
                ylabel('Probe report probabilities','FontSize',14,'Fontname','Ariel')
            end
            if numPair == 5
                xlabel('Time from search array onset [ms]','FontSize',14,'Fontname','Ariel')
            end

            title(['PAIR n' num2str(numPair+6)],'FontSize',14,'Fontname','Ariel')  
        end

        namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2PAIR2' saveFileName]);
        print ('-djpeg', '-r500',namefig);  
 
%         %% Graph same/different hemifields and diagonals for square configuration
%         figure; hold on;
%         for i = 1:3
%             if i == 1
%                 t1 = SH_p1;
%                 t2 = SH_p2;
%             elseif i == 2
%                 t1 = DH_p1;
%                 t2 = DH_p2;
%             elseif i == 3
%                 t1 = di_p1;
%                 t2 = di_p2;
%             end    
% 
%             s_t1 = nanstd(t1,[],2)/sqrt(numObs);
%             s_t2 = nanstd(t2,[],2)/sqrt(numObs);
% 
%             t1 = nanmean(t1,2);
%             t2 = nanmean(t2,2);
% 
%             subplot(1,3,i)
%             hold on;
% 
%             errorbar(100:30:460,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
%             errorbar(100:30:460,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])
% 
%             legend('p1','p2','Location','SouthEast')
% 
%             set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
%             set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
% 
%             ylim([0 1])
%             xlim([0 500])
% 
%             if i == 1           
%                 title('Same Hemifield','FontSize',14,'Fontname','Ariel')  
%                 ylabel('Probe report probabilities','FontSize',16,'Fontname','Ariel') 
%             elseif i == 2
%                 title('Different Hemifield','FontSize',14,'Fontname','Ariel')  
%                 xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
%             elseif i == 3
%                 title('Square Diagonals','FontSize',14,'Fontname','Ariel')
%             end    
%         end
%         namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2HemiDiagS' saveFileName]);
%         print ('-djpeg', '-r500',namefig);
% 
%         %% Graph same/different hemifields and diagonals for diamond configuration
%         figure; hold on;
%         for i = 1:3
%             if i == 1
%                 t1 = si1_p1;
%                 t2 = si1_p2;
%             elseif i == 2
%                 t1 = si2_p1;
%                 t2 = si2_p2;
%             elseif i == 3
%                 t1 = diD_p1;
%                 t2 = diD_p2;
%             end    
% 
%             s_t1 = nanstd(t1,[],2)/sqrt(numObs);
%             s_t2 = nanstd(t2,[],2)/sqrt(numObs);
% 
%             t1 = nanmean(t1,2);
%             t2 = nanmean(t2,2);
% 
%             subplot(1,3,i)
%             hold on;
% 
%             errorbar(100:30:460,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
%             errorbar(100:30:460,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])
% 
%             legend('p1','p2','Location','SouthEast')
% 
%             set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
%             set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
% 
%             ylim([0 1])
%             xlim([0 500])
% 
%             if i == 1 || i == 2
%                 title(['Diamond Sides n' num2str(i)],'FontSize',14,'Fontname','Ariel')
%             elseif i == 3
%                 title(['Diamond Diagonals n' num2str(i)],'FontSize',14,'Fontname','Ariel')
%             end
% 
%             if i == 1
%                 ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
%             elseif i == 2
%                 xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
%             end
% 
%         end
%         namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2HemiDiagD' saveFileName]);
%         print ('-djpeg', '-r500',namefig);
        
        %%%%%%%%%%%%%%%%%%%% OTHER PAIR GROUPINGS %%%%%%%%%%%%%%%%%%%%%%%% 
        for i = 1:size(m_pairs_p1,3)
            t1 = m_pairs_p1(:,:,i);
            t2 = m_pairs_p2(:,:,i);
            s1 = s_pairs_p1(:,:,i);
            s2 = s_pairs_p2(:,:,i);
            figure;hold on;
            errorbar(100:30:460,t1,s1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
            errorbar(100:30:460,t2,s2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

            legend('p1','p2','Location','SouthEast')

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

            namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFilePairsLoc '_p1p2_' name saveFileName]);
            print ('-djpeg', '-r500',namefig);   
        end     
        
    end
end

diff_p1p2 = m_p1-m_p2;
diff_pair_p1p2 = m_pair_p1-m_pair_p2;

if printFg && difference
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

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2diff' saveFileName]);

    print ('-djpeg', '-r500',namefig);    
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

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2PAIR1diff' saveFileName]);
    print ('-djpeg', '-r500',namefig);

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

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2PAIR2diff' saveFileName]);
    print ('-djpeg', '-r500',namefig);  

    %% Graph same/different hemifields and diagonals for square configuration
    figure; hold on;
    for i = 1:3
        if i == 1
            t1 = SH_p1;
            t2 = SH_p2;
        elseif i == 2
            t1 = DH_p1;
            t2 = DH_p2;
        elseif i == 3
            t1 = di_p1;
            t2 = di_p2;
        end    

        s_diff = std(t1-t2,[],2)/sqrt(numObs);
        
        t1 = nanmean(t1,2);
        t2 = nanmean(t2,2);

        d = t1 - t2;
        
        subplot(1,3,i)
        hold on;
        errorbar(100:30:460,d,s_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')

        ylim([-0.8 0.8])
        xlim([0 500])

        if i == 1           
            title('Same Hemifield','FontSize',14,'Fontname','Ariel')  
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel') 
        elseif i == 2
            title('Different Hemifield','FontSize',14,'Fontname','Ariel')  
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 3
            title('Square Diagonals','FontSize',14,'Fontname','Ariel')
        end    
        
        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
    end
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2HemiDiagSdiff' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Graph same/different hemifields and diagonals for diamond configuration
    figure; hold on;
    for i = 1:3
        if i == 1
            t1 = si1_p1;
            t2 = si1_p2;
        elseif i == 2
            t1 = si2_p1;
            t2 = si2_p2;
        elseif i == 3
            t1 = diD_p1;
            t2 = diD_p2;
        end    

        s_diff = std(t1-t2,[],2)/sqrt(numObs);
        
        t1 = nanmean(t1,2);
        t2 = nanmean(t2,2);

        d = t1 - t2;
        
        subplot(1,3,i)
        hold on;

        errorbar(100:30:460,d,s_diff,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-0.8:.4:0.8,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2,'Fontname','Ariel')

        ylim([-0.8 0.8])
        xlim([0 500])

        if i == 1 || i == 2
            title(['Diamond Sides n' num2str(i)],'FontSize',14,'Fontname','Ariel')
        elseif i == 3
            title(['Diamond Diagonals n' num2str(i)],'FontSize',14,'Fontname','Ariel')
        end

        if i == 1
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel') 
        elseif i == 2
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end
        
        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
    end
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_p1p2HemiDiagDdiff' saveFileName]);
    print ('-djpeg', '-r500',namefig);
end    

%% Conducts ANOVA on P1 and P2
if printStats
    p1p2 = zeros(numObs*13*2,4);
    index = 0;
    for i = 1:numObs
        p1p2(index+1:index+13,1) = all_p1(:,i);
        p1p2(index+1:index+13,2) = rot90(1:13,-1);
        p1p2(index+1:index+13,3) = rot90([1,1,1,1,1,1,1,1,1,1,1,1,1]);
        p1p2(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
        index = index + 13;
        p1p2(index+1:index+13,1) = all_p2(:,i);
        p1p2(index+1:index+13,2) = rot90(1:13,-1);
        p1p2(index+1:index+13,3) = rot90([2,2,2,2,2,2,2,2,2,2,2,2,2]);
        p1p2(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
        index = index + 13;
    end
    RMAOV2(p1p2);    
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
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_Overall' saveFileName]);
    print ('-djpeg', '-r500',namefig);

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
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_OverallAvg' saveFileName]);
    print ('-djpeg', '-r500',namefig);

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
    % namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_PerfField' saveFileName]);
    % print ('-djpeg', '-r500',namefig);
    % 
    % %% Plot Performance Field groupings averaged across delays
    % ylim([0.5 3.5])
    % set(gca,'YTick',1:1:3,'YTickLabel',{'3','2','1'})
    % set(gca,'XTickLabel',{'','',''})
    % ylabel('Grouping','FontSize',12,'Fontname','Ariel')
    % xlabel('Averaged Across Delays','FontSize',12,'Fontname','Ariel')
    % title([condition ' P1 - P2 (Performance Field) ' titleName],'FontSize',15,'Fontname','Ariel')
    % namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_PerfFieldAvg' saveFileName]);
    % print ('-djpeg', '-r500',namefig);
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
    % namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_Hemifield' saveFileName]);
    % print ('-djpeg', '-r500',namefig);
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
    % namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_HemifieldAvg' saveFileName]);
    % print ('-djpeg', '-r500',namefig);
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
    % namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_Distance' saveFileName]);
    % print ('-djpeg', '-r500',namefig);
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
    % namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_DistanceAvg' saveFileName]);
    % print ('-djpeg', '-r500',namefig);
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
    % namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_Config' saveFileName]);
    % print ('-djpeg', '-r500',namefig);
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
    % namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_ConfigAvg' saveFileName]);
    % print ('-djpeg', '-r500',namefig);


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
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_Square' saveFileName]);
    print ('-djpeg', '-r500',namefig);

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
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_SquareAvg' saveFileName]);
    print ('-djpeg', '-r500',namefig);

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
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_Diamond' saveFileName]);
    print ('-djpeg', '-r500',namefig);

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
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\' saveFileLoc '_DiamondAvg' saveFileName]);
    print ('-djpeg', '-r500',namefig);
end

if printFFT
    %% Conduct FFT's
    obsDiff = pair_p1 - pair_p2;
    diff1and6 = mean(cat(3,obsDiff(:,:,1),obsDiff(:,:,6)),3);
    diff2and5 = mean(cat(3,obsDiff(:,:,2),obsDiff(:,:,5)),3);
    diff3and4 = mean(cat(3,obsDiff(:,:,3),obsDiff(:,:,4)),3);
    diff7 = mean(obsDiff(:,:,7),3);
    diff12 = mean(obsDiff(:,:,12),3);

    % diffSquare = mean(cat(3,obsDiff(:,:,1),obsDiff(:,:,2),obsDiff(:,:,3),obsDiff(:,:,4),obsDiff(:,:,5),obsDiff(:,:,6)),3);

    fft_p1_p2([],[],diff1and6,expN,trialType,task,'1and6');
    fft_p1_p2([],[],diff2and5,expN,trialType,task,'2and5');
    fft_p1_p2([],[],diff3and4,expN,trialType,task,'3and4');
    fft_p1_p2([],[],diff7,expN,trialType,task,'7');
    fft_p1_p2([],[],diff12,expN,trialType,task,'12');

    % fft_p1_p2([],[],diffSquare,expN,present,task,'Square');

    fft_p1_p2(all_p1,all_p2,[],expN,trialType,task,'');
end
end

