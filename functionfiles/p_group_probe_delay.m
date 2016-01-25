function [P1,P2,Mpb,Mpo,Mpn,Mpb_pair,Mpn_pair,SH,DH,di,si1,si2,dDi] = p_group_probe_delay(obs,task,expN,present,delaysPerGroup,printFg,grouping)
%% Example
%%% p_group_probe_delay('ax','difficult',2,2,3,false);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or difficult')
% expN = 1; (1 or 2)
% present = 1; (1:target-present trials, 2:target-absent trials, 3:all trials)
% delaysPerGroup must be a factor of 12
% printFg = true; (figures are printed and saved)

%% Outputs
% Each output contains a matrix of data for obs 

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

%% Load data
if expN == 1
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\main_', task]);  
elseif expN == 2
    files = dir(['C:\Users\alice_000\Documents\MATLAB\data\', obs, '\target present or absent\main_', task]);  
end

for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [b,o,n,bp,op,np] = probe_analysis(obs,task,filename,expN,present,grouping); 
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
    end
end

pbMsHemi = [];
pnMsHemi = [];
pbMdHemi = [];
pnMdHemi = [];
pbMsDiag = [];
pnMsDiag = [];
pbMdSide1 = [];
pnMdSide1 = [];
pbMdSide2 = [];
pnMdSide2 = [];
pbMdDiag3 = [];
pnMdDiag3 = [];
P1=[];
P2=[];
Mpb=[];
Mpo=[];
Mpn=[];
Mpb_pair=[];
Mpn_pair=[];

if ~isempty(pb)
    nGroups = 12/delaysPerGroup;
    groupN = 1;
    x_axis_labels=cell(nGroups,1);
    for i = 1:nGroups
        pbSH = nanmean(nanmean(pbSH,2),3);
        pbMsHemi(i,1) = mean(pbSH(groupN:groupN+delaysPerGroup-1,1));
        pnSH = nanmean(nanmean(pnSH,2),3);
        pnMsHemi(i,1) = mean(pnSH(groupN:groupN+delaysPerGroup-1,1)); 

        pbDH = nanmean(nanmean(pbDH,2),3);
        pbMdHemi(i,1) = mean(pbDH(groupN:groupN+delaysPerGroup-1,1));
        pnDH = nanmean(nanmean(pnDH,2),3);
        pnMdHemi(i,1) = mean(pnDH(groupN:groupN+delaysPerGroup-1,1));  

        pbDg = nanmean(nanmean(pbDg,2),3);
        pbMsDiag(i,1) = mean(pbDg(groupN:groupN+delaysPerGroup-1,1));
        pnDg = nanmean(nanmean(pnDg,2),3);
        pnMsDiag(i,1) = mean(pnDg(groupN:groupN+delaysPerGroup-1,1));      

        pbDSi1 = nanmean(nanmean(pbDSi1,2),3);
        pbMdSide1(i,1) = mean(pbDSi1(groupN:groupN+delaysPerGroup-1,1));
        pnDSi1 = nanmean(nanmean(pnDSi1,2),3);
        pnMdSide1(i,1) = mean(pnDSi1(groupN:groupN+delaysPerGroup-1,1));    

        pbDSi2 = nanmean(nanmean(pbDSi2,2),3);
        pbMdSide2(i,1) = mean(pbDSi2(groupN:groupN+delaysPerGroup-1,1));
        pnDSi2 = nanmean(nanmean(pnDSi2,2),3);
        pnMdSide2(i,1) = mean(pnDSi2(groupN:groupN+delaysPerGroup-1,1));  

        pbDDg3 = nanmean(nanmean(pbDDg3,2),3);
        pbMdDiag3(i,1) = mean(pbDDg3(groupN:groupN+delaysPerGroup-1,1));
        pnDDg3 = nanmean(nanmean(pnDDg3,2),3);
        pnMdDiag3(i,1) = mean(pnDDg3(groupN:groupN+delaysPerGroup-1,1));   

        pbp = nanmean(pbp,2);
        Mpb_pair(i,1,:) = mean(pbp(groupN:groupN+delaysPerGroup-1,:,:));    
        pnp = nanmean(pnp,2);
        Mpn_pair(i,1,:) = mean(pnp(groupN:groupN+delaysPerGroup-1,:,:));

        Mpb(i,:) = mean(pb(groupN:groupN+delaysPerGroup-1,:));
        Mpo(i,:) = mean(po(groupN:groupN+delaysPerGroup-1,:));
        Mpn(i,:) = mean(pn(groupN:groupN+delaysPerGroup-1,:));    

        x_axis_labels{i} = [num2str((groupN)*30 + 70) '-' num2str((groupN+delaysPerGroup-1)*30 + 70)];
        groupN = groupN + delaysPerGroup; 
    end
    plotIndex = 300/(nGroups-1);

    Mpb = nanmean(Mpb,2);
    Mpo = nanmean(Mpo,2);
    Mpn = nanmean(Mpn,2);

    %% Transform pboth and pnone into p1 and p2
    [P1,P2] = quadratic_analysis(Mpb,Mpn);

    %% Transform pboth and pnone into p1 and p2
    [p1,p2] = quadratic_analysis(Mpb_pair,Mpn_pair);
end

if printFg && ~isempty(Mpb)
    %% Averaging across runs
    figure;hold on;
    plot(30:plotIndex:330,Mpb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    plot(30:plotIndex:330,Mpo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    plot(30:plotIndex:330,Mpn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])
    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',30:plotIndex:330,'XTickLabel',x_axis_labels,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    
    ylabel('Percent correct','FontSize',14,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',14,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 350])
    
    title([condition ' Search (' obs ')' saveFileName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_rawProbsG' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Plot p1 and p2 for each probe delay
    figure;hold on;
    plot(30:plotIndex:330,P1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
    plot(30:plotIndex:330,P2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])
    
    legend('p1','p2','Location','SouthEast')
      
    set(gca,'YTick',0:.2:1,'FontSize',13,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',30:plotIndex:330,'XTickLabel',x_axis_labels,'FontSize',13,'LineWidth',2','Fontname','Ariel')

    ylabel('Probe report probabilities','FontSize',14,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',14,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 350])

    title([condition ' Search (' obs ')' saveFileName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_p1p2G' saveFileName]);
    print ('-djpeg', '-r500',namefig); 
    %% Establish x-axis labels 
    nGroups = 12/delaysPerGroup;
    if mod(delaysPerGroup,2) == 0
        tmpIndex = int16(nGroups/2)+1;
    else
        tmpIndex = int16((nGroups+1)/2);
    end
    index = 300/(nGroups-1)*(tmpIndex-1);  
    %% Plot p1 and p2 for each probe delay for each pair - square configuration
    figure;
    for numPair = 1:size(Mpb_pair,3)/2
        subplot(2,3,numPair)
        hold on; 
        plot(30:plotIndex:330,p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(30:plotIndex:330,p2(:,:,numPair),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')
        set(gca,'YTick',0:.2:1.0,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',10,'LineWidth',2','Fontname','Ariel')
        ylim([0 1.0])
        xlim([0 350])

        if numPair == 1 || numPair == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        title(['PAIR n' num2str(numPair) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_p1p2PAIR1G' saveFileName]);
    print ('-djpeg', '-r500',namefig);

    %% Plot p1 and p2 for each probe delay for each pair - diamond configuration
    figure;
    for numPair = 1:size(Mpb_pair,3)/2
        subplot(2,3,numPair)
        hold on;
        plot(30:plotIndex:330,p1(:,:,numPair+6),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(30:plotIndex:330,p2(:,:,numPair+6),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')
        set(gca,'YTick',0:.2:1,'FontSize',10,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',10,'LineWidth',2','Fontname','Ariel')
        ylim([0 1])
        xlim([0 350])

        if numPair == 1 || numPair == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        title(['PAIR n' num2str(numPair+6) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_p1p2PAIR2G' saveFileName]);
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
        plot(30:plotIndex:330,p1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(30:plotIndex:330,p2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',10,'LineWidth',2','Fontname','Ariel')
        ylim([0 1])
        xlim([0 350])

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
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_p1p2HemiDiagSG' saveFileName]);
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
        plot(30:plotIndex:330,p1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(30:plotIndex:330,p2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',10,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',30:index:330,'XTickLabel',{x_axis_labels{1},x_axis_labels{tmpIndex}},'FontSize',10,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 350])

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
    namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\' obs '\' saveFileLoc '_p1p2HemiDiagDG' saveFileName]);
    print ('-djpeg', '-r500',namefig);
end
SH = horzcat(pbMsHemi,pnMsHemi);
DH = horzcat(pbMdHemi,pnMdHemi);
di = horzcat(pbMsDiag,pnMsDiag);
si1 = horzcat(pbMdSide1,pnMdSide1);
si2 = horzcat(pbMdSide2,pnMdSide2);
dDi = horzcat(pbMdDiag3,pnMdDiag3);
end

