function [pb,po,pn,pbp,pop,pnp,pbSH,pbDH,pbD,pnSH,pnDH,pnD] = p_probe_analysis(obs, task, overallObs)
%% Example
%%% p_probe_analysis('ax', 'difficult',false)

%% Parameters
% obs = 'ax';
% task = 'difficult'
% overallObs = false;

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
pbD=[];
pnSH=[];
pnDH=[];
pnD=[];

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task]);  
for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL > 4 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [b,o,n,bp,op,np,sH,dH,di] = probe_analysis(obs,task,filename); 

        pb = horzcat(pb,b);
        po = horzcat(po,o);
        pn = horzcat(pn,n); 

        pbp = horzcat(pbp,bp);
        pop = horzcat(pop,op); 
        pnp = horzcat(pnp,np);

        pbSH = horzcat(pbSH,sH(:,:,1:2)); 
        pbDH = horzcat(pbDH,dH(:,:,1:2));
        pbD = horzcat(pbD,di(:,:,1:2));
        pnSH = horzcat(pnSH,sH(:,:,3:4));
        pnDH = horzcat(pnDH,dH(:,:,3:4));
        pnD = horzcat(pnD,di(:,:,3:4));                 
    end
end

if overallObs == false 
    %% Averaging across runs
    Mpb = mean(pb,2);
    Mpo = mean(po,2);
    Mpn = mean(pn,2);
    Spb = std(pb,[],2)./sqrt(size(pb,2));
    Spo = std(po,[],2)./sqrt(size(po,2));
    Spn = std(pn,[],2)./sqrt(size(pn,2));

    figure;hold on;
    errorbar(40:30:460,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(40:30:460,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(40:30:460,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

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
    plot(40:30:460,p1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
    plot(40:30:460,p2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search (' obs ')'],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2']);
    print ('-djpeg', '-r500',namefig);

    %% Averaging across runs pair by pair
    Mpb_pair = mean(pbp,2);
    Mpn_pair = mean(pnp,2);

    %% Transform pboth and pnone into p1 and p2
    [p1,p2] = quadratic_analysis(Mpb_pair,Mpn_pair);

    %% Plot p1 and p2 for each probe delay
    figure;
    for numPair = 1:size(p1,3)
        subplot(2,3,numPair)
        hold on;
        plot(40:30:460,p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(40:30:460,p2(:,:,numPair),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

        legend('p1','p2')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        if numPair == 1 || numPair == 4
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        if numPair == 5
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        end
        ylim([0 1])

        title(['PAIR n' num2str(numPair) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
    end

    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2PAIR']);
    print ('-djpeg', '-r500',namefig);

    %% Averaging across runs pair by pair for hemifields and diagonals
    pbMsHemi = mean(pbSH,2);
    pnMsHemi = mean(pnSH,2);
    pbMdHemi = mean(pbDH,2);
    pnMdHemi = mean(pnDH,2);
    pbMdiag = mean(pbD,2);
    pnMdiag = mean(pnD,2);

    pbMsHemi = mean(pbMsHemi,3);
    pnMsHemi = mean(pnMsHemi,3);
    pbMdHemi = mean(pbMdHemi,3);
    pnMdHemi = mean(pnMdHemi,3);
    pbMdiag = mean(pbMdiag,3);
    pnMdiag = mean(pnMdiag,3);

    %% Graph same/different hemifields and diagonals
    figure; hold on;
    for i = 1:3
        if i == 1
            [p1,p2] = quadratic_analysis(pbMsHemi, pnMsHemi);
        elseif i == 2
            [p1,p2] = quadratic_analysis(pbMdHemi, pnMdHemi);
        else
            [p1,p2] = quadratic_analysis(pbMdiag, pnMdiag);
        end    
        subplot(1,3,i)
        hold on;
        plot(40:30:460,p1(:,:),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(40:30:460,p2(:,:),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

        legend('p1','p2')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        if i == 1 
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
        end
        ylim([0 1])
        if i == 1
            title('Same Hemifield','FontSize',14,'Fontname','Ariel')        
        elseif i == 2
            title('Different Hemifield','FontSize',14,'Fontname','Ariel')  
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')         
        else
            title(['Diagonals (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end     
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2HemiDiag']);
    print ('-djpeg', '-r500',namefig);
end
end

