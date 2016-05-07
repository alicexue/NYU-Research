function [pbothPD,ponePD,pnonePD,pbothAD,poneAD,pnoneAD,p1P,p2P,p1A,p2A,nTrialsP,nTrialsA,p1PS,p2PS,p1AS,p2AS,minTrialsP,minTrialsA] = p_probe_target_analysis(obs,task,expN,present,printFg)
%% Example
%%% p_probe_target_analysis('ax','difficult',2,1,false);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% printFg = true; (if true, prints and saves figures)

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\figures\' obs '_' condition];
    saveFileName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\figures\' obs '_' condition];
    if present == 1
        saveFileName = '_2TP';
    elseif present == 2
        saveFileName = '_2TA';
    elseif present == 3
        saveFileName = '_2';
    end
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
pbothPD=[];
ponePD=[];
pnonePD=[];
pbothAD=[];
poneAD=[];
pnoneAD=[];
pbothPDP=[];
pnonePDP=[];
pbothADP=[];
pnoneADP=[];

nTrialsP=0;
nTrialsA=0;

dir_name = setup_dir();
files = dir(strrep(dir_name,'\',filesep));  
if expN == 1
    files = dir([dir_name '\', obs, '\main_', task],'\',filesep);  
elseif expN == 2
    files = dir([dir_name '\', obs, '\target present or absent\main_', task],'\',filesep);  
end

for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [pbPD,poPD,pnPD,pbAD,poAD,pnAD,pbPDP,pnPDP,pbADP,pnADP,numTrialsP,numTrialsA] = probe_target_analysis(obs,task,filename,expN,present);
        
        pbothPD=horzcat(pbothPD,pbPD);
        ponePD=horzcat(ponePD,poPD);
        pnonePD=horzcat(pnonePD,pnPD);
        
        pbothAD=horzcat(pbothAD,pbAD);
        poneAD=horzcat(poneAD,poAD);
        pnoneAD=horzcat(pnoneAD,pnAD);
        
        pbothPDP=horzcat(pbothPDP,pbPDP);
        pnonePDP=horzcat(pnonePDP,pnPDP);
        pbothADP=horzcat(pbothADP,pbADP);
        pnoneADP=horzcat(pnoneADP,pnADP);    
        
        nTrialsP = nTrialsP + numTrialsP;
        nTrialsA = nTrialsA + numTrialsA;
    end
end

%% Averaging across runs 
SpbPD = std(pbothPD,[],2)/sqrt(size(pbothPD,2));
SpoPD = std(ponePD,[],2)/sqrt(size(ponePD,2));
SpnPD = std(pnonePD,[],2)/sqrt(size(pnonePD,2)); 

SpbAD = std(pbothAD,[],2)/sqrt(size(pbothAD,2));
SpoAD = std(poneAD,[],2)/sqrt(size(poneAD,2));
SpnAD = std(pnoneAD,[],2)/sqrt(size(pnoneAD,2));

MpbPD = nanmean(pbothPD,2);
MpoPD = nanmean(ponePD,2);
MpnPD = nanmean(pnonePD,2);
MpbAD = nanmean(pbothAD,2);
MpoAD = nanmean(poneAD,2);
MpnAD = nanmean(pnoneAD,2);
MpbPDP = nanmean(pbothPDP,2);
MpnPDP = nanmean(pnonePDP,2);
MpbADP = nanmean(pbothADP,2);
MpnADP = nanmean(pnoneADP,2);  

%% Transform pboth and pnone into p1 and p2
[p1P,p2P] = quadratic_analysis(MpbPD,MpnPD);
[p1A,p2A] = quadratic_analysis(MpbAD,MpnAD);
    
if printFg == true 
    %% Graph p1 p2 when target location is probed
    figure;hold on;
    errorbar(100:30:460,MpbPD,SpbPD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,MpoPD,SpoPD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,MpnPD,SpnPD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])
    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',18,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search - Target Probed (' obs ')' saveFileName],'FontSize',16,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\' obs saveFileLoc '_TP' '_rawProbs' saveFileName],'\',filesep));
    print ('-djpeg', '-r500',namefig);
    %% Plot p1 and p2 for each probe delay

    figure;hold on;
    plot(100:30:460,p1P,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
    plot(100:30:460,p2P,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])
    
    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    
    ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',18,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])

    title([condition ' Search - Target Probed - ' num2str(nTrialsP) ' Trials (' obs ')' saveFileName],'FontSize',16,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\' obs saveFileLoc '_TP_p1p2' saveFileName],'\',filesep));
    print ('-djpeg', '-r500',namefig); 
    %% Graph p1 p2 when target location is not probed
    figure;hold on;
    errorbar(100:30:460,MpbAD,SpbAD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,MpoAD,SpoAD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,MpnAD,SpnAD,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])
    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',18,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',18,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search - Target Not Probed (' obs ')' saveFileName],'FontSize',16,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\' obs saveFileLoc '_TA' '_rawProbs' saveFileName],'\',filesep));
    print ('-djpeg', '-r500',namefig);
    
    %% Plot p1 and p2 for each probe delay
    figure;hold on;
    plot(100:30:460,p1A,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
    plot(100:30:460,p2A,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])
    
    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    
    ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',18,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])

    title([condition ' Search - Target Not Probed - ' num2str(nTrialsA) ' Trials (' obs ')' saveFileName],'FontSize',16,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\' obs saveFileLoc '_TA_p1p2' saveFileName],'\',filesep));
    print ('-djpeg', '-r500',namefig); 
        
end

p1PS=[];
p2PS=[];
p1AS=[];
p2AS=[];
minTrialsP = 0;
minTrialsA = 0;
%% Plot sampled data
if ~isempty(pbothPD)
    [p1PS,p2PS,minTrialsP] = sampling(obs,pbothPD,pnonePD,task,true,100,printFg);
    [p1AS,p2AS,minTrialsA] = sampling(obs,pbothAD,pnoneAD,task,false,100,printFg); 
end
end

