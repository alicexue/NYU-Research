function [pb,po,pn,pbp,pop,pnp,SH,DH,di,di1,di2,di3] = p_probe_analysis(obs, task, multipleObs)
%% Example
%%% p_probe_analysis('ax','difficult',false);

%% Parameters
% obs = 'ax';
% task = 'difficult'
% multipleObs = false;

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
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
pbDDg1=[];
pbDDg2=[];
pbDDg3=[];

pnSH=[];
pnDH=[];
pnDg=[];
pnDDg1=[];
pnDDg2=[];
pnDDg3=[];

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task]);  
for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [b,o,n,bp,op,np] = probe_analysis(obs,task,filename); 

        pb = horzcat(pb,b);
        po = horzcat(po,o);
        pn = horzcat(pn,n); 

        pbp = horzcat(pbp,bp);
        pop = horzcat(pop,op); 
        pnp = horzcat(pnp,np);      

        pbSH = horzcat(pbSH,(cat(3,bp(:,:,1),bp(:,:,6)))); 
        pbDH = horzcat(pbDH,(cat(3,bp(:,:,2),bp(:,:,5))));
        pbDg = horzcat(pbDg,(cat(3,bp(:,:,3),bp(:,:,4))));
        pbDDg1 = horzcat(pbDDg1,(cat(3,bp(:,:,9),bp(:,:,10))));
        pbDDg2 = horzcat(pbDDg2,(cat(3,bp(:,:,8),bp(:,:,11))));
        pbDDg3 = horzcat(pbDDg3,(cat(3,bp(:,:,7),bp(:,:,12))));
        
        pnSH = horzcat(pnSH,(cat(3,np(:,:,1),np(:,:,6)))); 
        pnDH = horzcat(pnDH,(cat(3,np(:,:,2),np(:,:,5))));
        pnDg = horzcat(pnDg,(cat(3,np(:,:,3),np(:,:,4))));
        pnDDg1 = horzcat(pnDDg1,(cat(3,np(:,:,9),np(:,:,10))));
        pnDDg2 = horzcat(pnDDg2,(cat(3,np(:,:,8),np(:,:,11))));
        pnDDg3 = horzcat(pnDDg3,(cat(3,np(:,:,7),np(:,:,12))));
    end
end

%% Averaging across runs pair by pair for hemifields and diagonals
pbMsHemi = mean(mean(pbSH,2),3);
pnMsHemi = mean(mean(pnSH,2),3);
pbMdHemi = mean(mean(pbDH,2),3);
pnMdHemi = mean(mean(pnDH,2),3);
pbMsDiag = mean(mean(pbDg,2),3);
pnMsDiag = mean(mean(pnDg,2),3);
pbMdDiag1 = mean(mean(pbDDg1,2),3);
pnMdDiag1 = mean(mean(pnDDg1,2),3);
pbMdDiag2 = mean(mean(pbDDg2,2),3);
pnMdDiag2 = mean(mean(pnDDg2,2),3);
pbMdDiag3 = mean(mean(pbDDg3,2),3);
pnMdDiag3 = mean(mean(pnDDg3,2),3);  

if multipleObs == false 
    %% Averaging across runs
    Mpb = mean(pb,2);
    Mpo = mean(po,2);
    Mpn = mean(pn,2);
    Spb = std(pb,[],2)./sqrt(size(pb,2));
    Spo = std(po,[],2)./sqrt(size(po,2));
    Spn = std(pn,[],2)./sqrt(size(pn,2));

    figure;hold on;
    errorbar(100:30:460,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])
    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search (' obs ')'],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_rawProbs']);
    print ('-djpeg', '-r500',namefig);

    %% Transform pboth and pnone into p1 and p2
    [p1,p2] = quadratic_analysis(Mpb,Mpn);

    %% Plot p1 and p2 for each probe delay

    figure;hold on;
    plot(100:30:460,p1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
    plot(100:30:460,p2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    
    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])

    title([condition ' Search (' obs ')'],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2']);
    print ('-djpeg', '-r500',namefig); 

    %% Averaging across runs pair by pair
    Mpb_pair = mean(pbp,2);
    Mpn_pair = mean(pnp,2);

    %% Transform pboth and pnone into p1 and p2
    [p1,p2] = quadratic_analysis(Mpb_pair,Mpn_pair);
    
    %% Plot p1 and p2 for each probe delay for each pair - square configuration
    figure;
    for numPair = 1:size(Mpb_pair,3)/2
        subplot(2,3,numPair)
        hold on; 
        plot(100:30:460,p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(100:30:460,p2(:,:,numPair),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2','Location','SouthEast')
        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        ylim([0 1])
        
        if numPair == 1 || numPair == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 4
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        title(['PAIR n' num2str(numPair) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2PAIR1']);
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
        
        if numPair == 1 || numPair == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 4
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end

        title(['PAIR n' num2str(numPair+6) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2PAIR2']);
    print ('-djpeg', '-r500',namefig);     

    %% Graph same/different hemifields and diagonals
    figure; hold on;
    for i = 1:6
        if i == 1
            [p1,p2] = quadratic_analysis(pbMsHemi, pnMsHemi);
        elseif i == 2
            [p1,p2] = quadratic_analysis(pbMdHemi, pnMdHemi);
        elseif i == 3
            [p1,p2] = quadratic_analysis(pbMsDiag, pnMsDiag);
        elseif i == 4
            [p1,p2] = quadratic_analysis(pbMdDiag1, pnMdDiag1);            
        elseif i == 5
            [p1,p2] = quadratic_analysis(pbMdDiag2, pnMdDiag2);
        else
            [p1,p2] = quadratic_analysis(pbMdDiag3, pnMdDiag3);
        end    
        subplot(2,3,i)
        hold on;
        plot(100:30:460,p1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(100:30:460,p2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        
        if i == 1           
            title(['Same Hemifield (' obs ')'],'FontSize',14,'Fontname','Ariel')  
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
        elseif i == 2
            title(['Different Hemifield (' obs ')'],'FontSize',14,'Fontname','Ariel')           
        elseif i == 3
            title(['Square Diagonals (' obs ')'],'FontSize',14,'Fontname','Ariel')
        else
            title(['Diamond Diagonals' num2str(i-3) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end     
        
        if i == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end
        
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2HemiDiag']);
    print ('-djpeg', '-r500',namefig);
end

SH = horzcat(pbMsHemi,pnMsHemi);
DH = horzcat(pbMdHemi,pnMdHemi);
di = horzcat(pbMsDiag,pnMsDiag);
di1 = horzcat(pbMdDiag1,pnMdDiag1);
di2 = horzcat(pbMdDiag2,pnMdDiag2);
di3 = horzcat(pbMdDiag3,pnMdDiag3);
end

