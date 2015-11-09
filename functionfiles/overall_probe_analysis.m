function [all_p1,all_p2] = overall_probe_analysis(task,expN,present,correct,printFg,printStats)
%% This function gets p1 and p2 from all observers and averages them
%% Example
%%% overall_probe_analysis('difficult',2,2,false,true,false);

%% Parameters
% task = 'difficult'
% printFg = false;
% correct = false;

% if correct=true, the data will be corrected by the global average
%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc1 = ['\main_' task '\' condition];
    saveFileName = '1';
elseif expN == 2
    saveFileLoc1 = ['\target present or absent\main_' task '\' condition];
    if present == 1
        saveFileName = '_2TP';
    elseif present == 2
        saveFileName = '_2TA';
    elseif present == 3
        saveFileName = '_2';
    end
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
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

numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [P1,P2,pb,po,pn,pbp,pnp,SH,DH,di,si1,si2,diD,P1C2,P2C2] = p_probe_analysis(obs,task,expN,present,correct,false); 
%         a = {SH,DH,di,si1,si2,diD};
%         b = {SH_p1,DH_p1,di_p1,si1_p1,si2_p1,diD_p1,SH_p2,DH_p2,di_p2,si1_p2,si2_p2,diD_p2};
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

pair_p1=nanmean(pair_p1,2);
pair_p2=nanmean(pair_p2,2);

if printFg 
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
    
    title([condition ' Search (n = ' num2str(numObs) ')'],'FontSize',24,'Fontname','Ariel')

    if correct
         namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_rawProbsC1' saveFileName]);
    else
        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_rawProbs' saveFileName]);
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
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    xlim([0 500])

    title([condition ' Search (n = ' num2str(numObs) ')'],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_p1p2' saveFileName]);

    print ('-djpeg', '-r500',namefig);
    
    if correct
%         %% Plot p1 and p2 for each probe delay - p1 and p2 from corrected
%         %% pboth and pnone
%         [P1C1,P2C1] = quadratic_analysis(pboth,pnone);
%         Sp1C1 = nanstd(P1C1,[],2)/sqrt(numObs)*size(P1C1,1)/(size(P1C1,1)-1);
%         Sp2C1 = nanstd(P2C1,[],2)/sqrt(numObs)*size(P2C1,1)/(size(P2C1,1)-1);
%         P1C1 = nanmean(P1C1,2);
%         P2C1 = nanmean(P2C1,2);
%         
%         figure;hold on;
%         errorbar(100:30:460,P1C1,Sp1C1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
%         errorbar(100:30:460,P2C1,Sp2C1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])
% 
%         legend('p1','p2','Location','SouthEast')
% 
%         set(gca,'YTick',-0.2:.2:1.2,'FontSize',18,'LineWidth',2','Fontname','Ariel')
%         set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')
% 
%         ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
%         xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
%         ylim([-0.2 1.2])
% 
%         title([condition ' Search (n = ' num2str(numObs) ')'],'FontSize',24,'Fontname','Ariel')
% 
%         namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\main_' task '\' condition '_p1p2C1']);
%         print ('-djpeg', '-r500',namefig);
%         
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
        xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.35 0.35])        

        xlim([0 500])

        title([condition ' Search (n = ' num2str(numObs) ')'],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_p1p2C2' saveFileName]);
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
        xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.4 0.4])

        title([condition ' Search (n = ' num2str(numObs) ')'],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_p1p2C3' saveFileName]);
        print ('-djpeg', '-r500',namefig);
    end
    if ~correct
        %% Plot p1 and p2 for each pair - square configuration
        figure;
        for numPair = 1:size(pair_p1,3)/2
            subplot(2,3,numPair)
            hold on;

            errorbar(100:30:460,pair_p1(:,:,numPair),s_pair_p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
            errorbar(100:30:460,pair_p2(:,:,numPair),s_pair_p2(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

            legend('p1','p2','Location','SouthEast')
            set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            ylim([0 1])
            xlim([0 500])

            if numPair == 1 || numPair == 4
                ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
            end
            if numPair == 5
                xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
            end

            title(['PAIR n' num2str(numPair)],'FontSize',14,'Fontname','Ariel')  
        end

        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_p1p2PAIR1' saveFileName]);
        print ('-djpeg', '-r500',namefig);

        %% Plot p1 and p2 for each pair - diamond configuration
        figure;
        for numPair = 1:size(pair_p1,3)/2
            subplot(2,3,numPair)
            hold on;

            errorbar(100:30:460,pair_p1(:,:,numPair+6),s_pair_p1(:,:,numPair+6),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
            errorbar(100:30:460,pair_p2(:,:,numPair+6),s_pair_p2(:,:,numPair+6),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

            legend('p1','p2','Location','SouthEast')
            set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            ylim([0 1])
            xlim([0 500])

            if numPair == 1 || numPair == 4
                ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
            end
            if numPair == 5
                xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
            end

            title(['PAIR n' num2str(numPair+6)],'FontSize',14,'Fontname','Ariel')  
        end

        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_p1p2PAIR2' saveFileName]);
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

            s_t1 = nanstd(t1,[],2)/sqrt(numObs);
            s_t2 = nanstd(t2,[],2)/sqrt(numObs);

            t1 = nanmean(t1,2);
            t2 = nanmean(t2,2);

            subplot(1,3,i)
            hold on;

            errorbar(100:30:460,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
            errorbar(100:30:460,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

            legend('p1','p2','Location','SouthEast')

            set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

            ylim([0 1])
            xlim([0 500])

            if i == 1           
                title('Same Hemifield','FontSize',14,'Fontname','Ariel')  
                ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            elseif i == 2
                title('Different Hemifield','FontSize',14,'Fontname','Ariel')  
                xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
            elseif i == 3
                title('Square Diagonals','FontSize',14,'Fontname','Ariel')
            end    
        end
        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_p1p2HemiDiagS' saveFileName]);
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

            s_t1 = nanstd(t1,[],2)/sqrt(numObs);
            s_t2 = nanstd(t2,[],2)/sqrt(numObs);

            t1 = nanmean(t1,2);
            t2 = nanmean(t2,2);

            subplot(1,3,i)
            hold on;

            errorbar(100:30:460,t1,s_t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
            errorbar(100:30:460,t2,s_t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

            legend('p1','p2','Location','SouthEast')

            set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
            set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

            ylim([0 1])
            xlim([0 500])

            if i == 1 || i == 2
                title(['Diamond Sides n' num2str(i)],'FontSize',14,'Fontname','Ariel')
            elseif i == 3
                title(['Diamond Diagonals n' num2str(i)],'FontSize',14,'Fontname','Ariel')
            end

            if i == 1
                ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            elseif i == 2
                xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
            end

        end
        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' saveFileLoc1 '_p1p2HemiDiagD' saveFileName]);
        print ('-djpeg', '-r500',namefig);
    end
end

if printStats
    p1p2 = zeros(numObs*13*2,4);
    index = 0;
    for i = 1:numObs
        p1p2(index+1:index+13,1) = all_p1(:,i);
        p1p2(index+1:index+13,2) = rot90([13,12,11,10,9,8,7,6,5,4,3,2,1]);
        p1p2(index+1:index+13,3) = rot90([1,1,1,1,1,1,1,1,1,1,1,1,1]);
        p1p2(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
        index = index + 13;
        p1p2(index+1:index+13,1) = all_p2(:,i);
        p1p2(index+1:index+13,2) = rot90([13,12,11,10,9,8,7,6,5,4,3,2,1]);
        p1p2(index+1:index+13,3) = rot90([2,2,2,2,2,2,2,2,2,2,2,2,2]);
        p1p2(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
        index = index + 13;
    end
    RMAOV2(p1p2);    
end
end

