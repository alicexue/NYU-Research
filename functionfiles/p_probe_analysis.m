function [P1,P2,Mpb,Mpo,Mpn,Mpb_pair,Mpo_pair,Mpn_pair,SH,DH,di,si1,si2,dDi,P1C2,P2C2] = p_probe_analysis(obs,task,expN,trialType,difference,correct,printFg,grouping)
%% Example
%%% p_probe_analysis('ax','difficult',2,2,false,false,false,1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or difficult')
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
% correct = false; (if true, p1 and p2 are corrected for each individual and also by
% the global average)
% printFg = true; (figures are printed and saved)
% grouping = 1; (if 1, probes must be exactly correct; if 2, probes must
% match by shape; if 3, probes must match by aperture)

%% Outputs
% Each output contains a matrix of data for obs 

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\figures\' obs '_' condition];
    saveFilePairsLoc = ['\figures\pairs\' obs '_' condition];
    saveFileName = '';
elseif expN == 2
    saveFileLoc = ['\figures\' obs '_' condition];
    saveFilePairsLoc = ['\figures\pairs\' obs '_' condition];
    if trialType == 1
        saveFileName = '_2TP';
    elseif trialType == 2
        saveFileName = '_2TA';
    elseif trialType == 3
        saveFileName = '_2';
    end
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
pb=[];
po=[];
pn=[];

pbp=[];
pop=[];
pnp=[];

pbSH=[];
pbDH=[];
pbDg=[];
pbDSi1=[];
pbDSi2=[];
pbDDg3=[];

pnSH=[];
pnDH=[];
pnDg=[];
pnDSi1=[];
pnDSi2=[];
pnDDg3=[];

pb_pair_2_5 = [];
pn_pair_2_5 = [];

pb_pair_1_6 = [];
pn_pair_1_6 = [];

pb_pair_9_11 = [];
pn_pair_9_11 = [];

pb_pair_8_10 = [];
pn_pair_8_10 = []; 

pb_pair_3_4 = [];
pn_pair_3_4 = [];

pb_pair_7 = [];
pn_pair_7 = [];

pb_pair_12 = [];
pn_pair_12 = [];

%% Load data
dir_name = setup_dir();
if expN == 1
    dir_loc = [dir_name '\' obs '\main_' task];
elseif expN == 2
    dir_loc = [dir_name '\' obs '\target present or absent\main_' task];
elseif expN == 3
    dir_loc = [dir_name '\' obs '\control exp'];
end

files = dir(strrep(dir_loc,'\',filesep));  

for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [b,o,n,bp,op,np] = probe_analysis(obs,task,filename,expN,trialType,grouping); 
        pb = horzcat(pb,b);
        po = horzcat(po,o);
        pn = horzcat(pn,n); 

        pbp = horzcat(pbp,bp);
        pop = horzcat(pop,op); 
        pnp = horzcat(pnp,np);      

        pbSH = horzcat(pbSH,(cat(3,bp(:,:,1),bp(:,:,6)))); 
        pbDH = horzcat(pbDH,(cat(3,bp(:,:,3),bp(:,:,4))));
        pbDg = horzcat(pbDg,(cat(3,bp(:,:,2),bp(:,:,5))));
        pbDSi1 = horzcat(pbDSi1,(cat(3,bp(:,:,9),bp(:,:,10))));
        pbDSi2 = horzcat(pbDSi2,(cat(3,bp(:,:,8),bp(:,:,11))));
        pbDDg3 = horzcat(pbDDg3,(cat(3,bp(:,:,7),bp(:,:,12))));

        pnSH = horzcat(pnSH,(cat(3,np(:,:,1),np(:,:,6)))); 
        pnDH = horzcat(pnDH,(cat(3,np(:,:,3),np(:,:,4))));
        pnDg = horzcat(pnDg,(cat(3,np(:,:,2),np(:,:,5))));
        pnDSi1 = horzcat(pnDSi1,(cat(3,np(:,:,9),np(:,:,10))));
        pnDSi2 = horzcat(pnDSi2,(cat(3,np(:,:,8),np(:,:,11))));
        pnDDg3 = horzcat(pnDDg3,(cat(3,np(:,:,7),np(:,:,12))));
        
        pb_pair_2_5 = horzcat(pb_pair_2_5,cat(3,bp(:,:,2),bp(:,:,5)));
        pn_pair_2_5 = horzcat(pn_pair_2_5,cat(3,np(:,:,2),np(:,:,5)));

        pb_pair_1_6 = horzcat(pb_pair_1_6,cat(3,bp(:,:,1),bp(:,:,6)));
        pn_pair_1_6 = horzcat(pn_pair_1_6,cat(3,np(:,:,1),np(:,:,6)));

        pb_pair_9_11 = horzcat(pb_pair_9_11,cat(3,bp(:,:,9),bp(:,:,11)));
        pn_pair_9_11 = horzcat(pn_pair_9_11,cat(3,np(:,:,9),np(:,:,11)));

        pb_pair_8_10 = horzcat(pb_pair_8_10,cat(3,bp(:,:,8),bp(:,:,10)));
        pn_pair_8_10 = horzcat(pn_pair_8_10,cat(3,np(:,:,8),np(:,:,10)));    

        pb_pair_3_4 = horzcat(pb_pair_3_4,cat(3,bp(:,:,3),bp(:,:,4)));
        pn_pair_3_4 = horzcat(pn_pair_3_4,cat(3,np(:,:,3),np(:,:,4)));    

        pb_pair_7 = horzcat(pb_pair_7,bp(:,:,7));
        pn_pair_7 = horzcat(pn_pair_7,np(:,:,7));

        pb_pair_12 = horzcat(pb_pair_12,bp(:,:,12));
        pn_pair_12 = horzcat(pn_pair_12,np(:,:,12));            
       
    end
end

pb_pairs = mean(cat(3,pb_pair_7,pb_pair_12,pb_pair_1_6,pb_pair_2_5,pb_pair_3_4,pb_pair_8_10,pb_pair_9_11),2);
pn_pairs = mean(cat(3,pn_pair_7,pn_pair_12,pn_pair_1_6,pn_pair_2_5,pn_pair_3_4,pn_pair_8_10,pn_pair_9_11),2);

%% Averaging across runs pair by pair for hemifields and diagonals
pbMsHemi = nanmean(nanmean(pbSH,2),3);
pnMsHemi = nanmean(nanmean(pnSH,2),3);
pbMdHemi = nanmean(nanmean(pbDH,2),3);
pnMdHemi = nanmean(nanmean(pnDH,2),3);
pbMsDiag = nanmean(nanmean(pbDg,2),3);
pnMsDiag = nanmean(nanmean(pnDg,2),3);
pbMdSide1 = nanmean(nanmean(pbDSi1,2),3);
pnMdSide1 = nanmean(nanmean(pnDSi1,2),3);
pbMdSide2 = nanmean(nanmean(pbDSi2,2),3);
pnMdSide2 = nanmean(nanmean(pnDSi2,2),3);
pbMdDiag3 = nanmean(nanmean(pbDDg3,2),3);
pnMdDiag3 = nanmean(nanmean(pnDDg3,2),3);  

Mpb = nanmean(pb,2);
Mpo = nanmean(po,2);
Mpn = nanmean(pn,2);
Spb = nanstd(pb,[],2)./sqrt(size(pb,2));
Spo = nanstd(po,[],2)./sqrt(size(po,2));
Spn = nanstd(pn,[],2)./sqrt(size(pn,2));

%% Transform pboth and pnone into p1 and p2
[P1,P2] = quadratic_analysis(Mpb,Mpn);

%% Averaging across runs pair by pair
Mpb_pair = nanmean(pbp,2);
Mpo_pair = nanmean(pop,2);
Mpn_pair = nanmean(pnp,2);

%% Transform pboth and pnone into p1 and p2
[p1,p2] = quadratic_analysis(Mpb_pair,Mpn_pair);

if printFg && ~correct && ~isempty(Mpb) && ~difference
    % make a data directory if necessary
    thisdir = strrep(dir_loc,'\',filesep);
    if ~isdir(fullfile(thisdir,'figures'))
        disp('Making figures directory');
        mkdir(thisdir,'figures');
    end    
    if ~isdir(fullfile(strrep([thisdir '\figures'],'\',filesep),'pairs'))
        disp('Making pairs directory');
        mkdir(strrep([thisdir '\figures'],'\',filesep),'pairs');
    end        
    
    %% Averaging across runs
    figure;hold on;
    errorbar(100:30:460,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])
    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])
    
    title([condition ' Search (' obs ')' saveFileName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', [dir_loc saveFileLoc '_rawProbs' saveFileName]);

    print ('-djpeg', '-r500',namefig);

    %% Plot p1 and p2 for each probe delay

    figure;hold on;
    plot(100:30:460,P1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
    plot(100:30:460,P2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])
    
    legend('p1','p2','Location','SouthEast')
      
    set(gca,'YTick',0:.2:1.2,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1.2])
    xlim([0 500])

    title([condition ' Search (' obs ')' saveFileName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2' saveFileName]);
    print ('-djpeg', '-r500',namefig); 
  
    %% Plot p1 and p2 for each probe delay for each pair - square configuration
    figure;
    for numPair = 1:size(Mpb_pair,3)/2
        subplot(2,3,numPair)
        hold on; 
        plot(100:30:460,p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(100:30:460,p2(:,:,numPair),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')
        set(gca,'YTick',0:.2:1.0,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        ylim([0 1.0])
        xlim([0 500])

        if numPair == 1 || numPair == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        title(['PAIR n' num2str(numPair) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end
    
    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2PAIR1' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Plot p1 and p2 for each probe delay for each pair - diamond configuration
    figure;
    for numPair = 1:size(Mpb_pair,3)/2
        subplot(2,3,numPair)
        hold on;
        plot(100:30:460,p1(:,:,numPair+6),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(100:30:460,p2(:,:,numPair+6),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

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

        title(['PAIR n' num2str(numPair+6) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2PAIR2' saveFileName]);
    print ('-djpeg', '-r500',namefig);     

    %% Graph same/different hemifields and diagonals for square configuration
    figure; hold on;
    for i = 1:3
        if i == 1
            [p1,p2] = quadratic_analysis(pbMsHemi, pnMsHemi);
        elseif i == 2
            [p1,p2] = quadratic_analysis(pbMdHemi, pnMdHemi);
        elseif i == 3
            [p1,p2] = quadratic_analysis(pbMsDiag, pnMsDiag);
        end    
        subplot(1,3,i)
        hold on;
        plot(100:30:460,p1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(100:30:460,p2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

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
            title(['Square Diagonals (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end     
    end
    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2HemiDiagS' saveFileName]);
    print ('-djpeg', '-r500',namefig);
    %% Graph same/different hemifields and diagonals
    figure; hold on;
    for i = 1:3
        if i == 1
            [p1,p2] = quadratic_analysis(pbMdSide1, pnMdSide1);            
        elseif i == 2
            [p1,p2] = quadratic_analysis(pbMdSide2, pnMdSide2);
        else
            [p1,p2] = quadratic_analysis(pbMdDiag3, pnMdDiag3);
        end
        subplot(1,3,i)
        hold on;
        plot(100:30:460,p1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(100:30:460,p2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])

        if i == 1 
            title(['Diamond Sides n' num2str(i)],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
        elseif i == 2
            title(['Diamond Sides n' num2str(i)],'FontSize',14,'Fontname','Ariel')
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        else 
            title(['Diamond Diags (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2HemiDiagD' saveFileName]);
    print ('-djpeg', '-r500',namefig);
    
    
    %%%%%%%%%%%%%%%%%%%% OTHER PAIR GROUPINGS %%%%%%%%%%%%%%%%%%%%%%%% 
    for i = 1:size(pb_pairs,3)
        [t1,t2] = quadratic_analysis(pb_pairs(:,:,i),pn_pairs(:,:,i));
        figure;hold on;
        plot(100:30:460,t1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
        plot(100:30:460,t2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')
        
        set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
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
        
        title([condition ' Search - Pair ' name ' (' obs ')' saveFileName],'FontSize',20,'Fontname','Ariel')

        namefig=sprintf('%s', [dir_loc saveFilePairsLoc '_p1p2_' name saveFileName]);
        print ('-djpeg', '-r500',namefig);       
        
    end    
    
end

SH = horzcat(pbMsHemi,pnMsHemi);
DH = horzcat(pbMdHemi,pnMdHemi);
di = horzcat(pbMsDiag,pnMsDiag);
si1 = horzcat(pbMdSide1,pnMdSide1);
si2 = horzcat(pbMdSide2,pnMdSide2);
dDi = horzcat(pbMdDiag3,pnMdDiag3);

P1C2 = NaN(size(Mpb,1),1);
P2C2 = NaN(size(Mpb,1),1);
P1C3 = NaN(size(Mpb,1),1);
P2C3 = NaN(size(Mpb,1),1);

if correct
    if ~isempty(Mpb)
        global_averagePB = nanmean(Mpb);
        global_averagePO = nanmean(Mpo);
        global_averagePN = nanmean(Mpn);
        global_averageP1 = nanmean(P1);
        global_averageP2 = nanmean(P2); 
        global_averageC3 = nanmean(vertcat(P1,P2));         
        for i=1:13
            Mpb(i,1) = Mpb(i,1)-global_averagePB;
            Mpo(i,1) = Mpo(i,1)-global_averagePO;
            Mpn(i,1) = Mpn(i,1)-global_averagePN;
            P1C2(i,1) = P1(i,1)-global_averageP1;
            P2C2(i,1) = P2(i,1)-global_averageP2;    
            P1C3(i,1) = P1(i,1)-global_averageC3;
            P2C3(i,1) = P2(i,1)-global_averageC3;
        end
        [P1C1,P2C1] = quadratic_analysis(Mpb,Mpn);
        Spb = Spb*size(Spb,1)/(size(Spb,1)-1);
        Spo = Spo*size(Spo,1)/(size(Spo,1)-1);
        Spn = Spn*size(Spn,1)/(size(Spn,1)-1);   
    end        
    if printFg
        %% Averaging across runs
        figure;hold on;
        errorbar(100:30:460,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
        errorbar(100:30:460,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
        errorbar(100:30:460,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])
        legend('PBoth','POne','PNone')

        set(gca,'YTick',-0.2:.1:.2,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
        xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.2 0.2])

        title([condition ' Search (' obs ')'],'FontSize',24,'Fontname','Ariel')
        
        namefig=sprintf('%s', [dir_loc saveFileLoc '_rawProbsC1' saveFileName]);
        print ('-djpeg', '-r500',namefig);

        %% Plot p1 and p2 for each probe delay - getting p1 and p2 from the corrected Mpb and Mpn
        figure;hold on;
        plot(100:30:460,P1C1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
        plot(100:30:460,P2C1,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',-0.2:.2:1.2,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.2 1.2])
        xlim([0 500])

        title([condition ' Search (' obs ')'],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', [dir_loc '\' saveFileLoc '_p1p2C1' saveFileName]);
        print ('-djpeg', '-r500',namefig); 

        %% Plot p1 and p2 for each probe delay - p1 and p2 are corrected for the global average
        figure;hold on;
        plot(100:30:460,P1C2,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
        plot(100:30:460,P2C2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',-0.2:.1:0.2,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.2 0.2])
        xlim([0 500])

        title([condition ' Search (' obs ')'],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2C2' saveFileName]);
        print ('-djpeg', '-r500',namefig);
        %% Plot p1 and p2 for each probe delay - p1 and p2 are corrected for the combined global average
        figure;hold on;
        plot(100:30:460,P1C3,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
        plot(100:30:460,P2C3,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',-0.4:.2:0.4,'FontSize',18,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

        ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
        xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
        ylim([-0.4 0.4])
        xlim([0 500])

        title([condition ' Search (' obs ')'],'FontSize',24,'Fontname','Ariel')

        namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2C3' saveFileName]);

        print ('-djpeg', '-r500',namefig);        
    end
end
%
%%%%%%%%%%%%%%%%%%%%%%%%% PLOT DIFFERENCE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if printFg && difference
    %% Plot p1 and p2 for each probe delay

    figure;hold on;
    plot(100:30:460,P1-P2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])
        
    set(gca,'YTick',-0.6:.2:0.6,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([-0.6 0.6])
    xlim([0 500])
    
    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
    
    title([condition ' Search (' obs ')' saveFileName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2diff' saveFileName]);
    print ('-djpeg', '-r500',namefig); 
  
    %% Plot p1 and p2 for each probe delay for each pair - square configuration
    figure;
    for numPair = 1:size(Mpb_pair,3)/2
        subplot(2,3,numPair)
        hold on; 
        plot(100:30:460,p1(:,:,numPair)-p2(:,:,numPair),'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-1:.5:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        ylim([-1 1])
        xlim([0 500])

        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        if numPair == 1 || numPair == 4
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        title(['PAIR n' num2str(numPair) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end
    
    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2PAIR1diff' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Plot p1 and p2 for each probe delay for each pair - diamond configuration
    figure;
    for numPair = 1:size(Mpb_pair,3)/2
        subplot(2,3,numPair)
        hold on;
        plot(100:30:460,p1(:,:,numPair+6)-p2(:,:,numPair+6),'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-1:.5:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        ylim([-1 1])
        xlim([0 500])

        if numPair == 1 || numPair == 4
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end
        
        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        title(['PAIR n' num2str(numPair+6) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2PAIR2diff' saveFileName]);
    print ('-djpeg', '-r500',namefig);     

    %% Graph same/different hemifields and diagonals for square configuration
    figure; hold on;
    for i = 1:3
        if i == 1
            [p1,p2] = quadratic_analysis(pbMsHemi, pnMsHemi);
        elseif i == 2
            [p1,p2] = quadratic_analysis(pbMdHemi, pnMdHemi);
        elseif i == 3
            [p1,p2] = quadratic_analysis(pbMsDiag, pnMsDiag);
        end    
        subplot(1,3,i)
        hold on;
        plot(100:30:460,p1-p2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-1:.5:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([-1 1])
        xlim([0 500])

        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        if i == 1           
            title('Same Hemifield','FontSize',14,'Fontname','Ariel')  
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel') 
        elseif i == 2
            title('Different Hemifield','FontSize',14,'Fontname','Ariel')           
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 3
            title(['Square Diagonals (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end     
    end
    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2HemiDiagSdiff' saveFileName]);
    print ('-djpeg', '-r500',namefig);
    %% Graph same/different hemifields and diagonals
    figure; hold on;
    for i = 1:3
        if i == 1
            [p1,p2] = quadratic_analysis(pbMdSide1, pnMdSide1);            
        elseif i == 2
            [p1,p2] = quadratic_analysis(pbMdSide2, pnMdSide2);
        else
            [p1,p2] = quadratic_analysis(pbMdDiag3, pnMdDiag3);
        end
        subplot(1,3,i)
        hold on;
        plot(100:30:460,p1-p2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-1:.5:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([-1 1])
        xlim([0 500])

        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        if i == 1 
            title(['Diamond Sides n' num2str(i)],'FontSize',14,'Fontname','Ariel')
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel') 
        elseif i == 2
            title(['Diamond Sides n' num2str(i)],'FontSize',14,'Fontname','Ariel')
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        else 
            title(['Diamond Diags (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', [dir_loc saveFileLoc '_p1p2HemiDiagDdiff' saveFileName]);
    print ('-djpeg', '-r500',namefig);
end
end    

