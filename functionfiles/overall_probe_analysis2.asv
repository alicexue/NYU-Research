function overall_probe_analysis2(task)
%% This function solves for p1 and p2 for each obs and then averages them
%% Example
%%% overall_probe_analysis2('difficult')

%% Parameters
% task = 'difficult'

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
pboth=[];
pone=[];
pnone=[];

pboth1=[];
pone1=[];
pnone1=[];

pboth_pair=[];
pone_pair=[];
pnone_pair=[];
pb_sameHemi = [];
pb_diffHemi = [];
pb_diagonal = [];
pn_sameHemi = [];
pn_diffHemi = [];
pn_diagonal = [];

P1 = [];
P2 = [];

numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if fileL == 2 && ~strcmp(obs(1,1),'.')
        [pb,po,pn,pbp,pop,pnp,pbSH,pbDH,pbD,pnSH,pnDH,pnD] = p_probe_analysis(obs,task,true);              
        
        pboth = cat(3,pboth,pb);
        pone = cat(3,pone,po);
        pnone = cat(3,pnone,pn); 

        pboth1 = horzcat(pboth1,pb);
        pone1 = horzcat(pone1,po);
        pnone1 = horzcat(pnone1,pn);         
        
        pboth_pair = horzcat(pboth_pair,pbp);
        pone_pair = horzcat(pone_pair,pop); 
        pnone_pair = horzcat(pnone_pair,pnp);

        pb_sameHemi = horzcat(pb_sameHemi,pbSH); 
        pb_diffHemi = horzcat(pb_diffHemi,pbDH);
        pb_diagonal = horzcat(pb_diagonal,pbD);
        pn_sameHemi = horzcat(pn_sameHemi,pnSH);
        pn_diffHemi = horzcat(pn_diffHemi,pnDH);
        pn_diagonal = horzcat(pn_diagonal,pnD); 
        
        numObs = numObs + 1;
    end
end

%% Averaging across runs
Mpb = mean(pboth,2);
Mpo = mean(pone,2);
Mpn = mean(pnone,2);

Mpb1 = mean(Mpb,3);
Mpo1 = mean(Mpo,3);
Mpn1 = mean(Mpn,3);

Spb = std(pboth1,[],2)./sqrt(numObs);
Spo = std(pone1,[],2)./sqrt(numObs);
Spn = std(pnone1,[],2)./sqrt(numObs);

figure;hold on;
errorbar(40:30:460,Mpb1,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
errorbar(40:30:460,Mpo1,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
errorbar(40:30:460,Mpn1,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

legend('PBoth','POne','PNone')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([0 1])

title([condition ' Search'],'FontSize',24,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_rawProbs']);
print ('-djpeg', '-r500',namefig);

%% Transform pboth and pnone into p1 and p2
for i = 1:size(Mpb,3)
    [p1,p2] = quadratic_analysis(Mpb(:,1,i),Mpn(:,1,i));
    P1 = horzcat(p1);
    P2 = horzcat(p2);
end

P1 = mean(P1,2);
P2 = mean(P2,2);

%% Plot p1 and p2 for each probe delay

figure;hold on;
plot(40:30:460,P1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
plot(40:30:460,P2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

legend('p1','p2','Location','SouthEast')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([0 1])

title([condition ' Search'],'FontSize',24,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2']);
print ('-djpeg', '-r500',namefig);

%% Averaging across runs pair by pair
% Mpb_pair = mean(pboth_pair,2);
% Mpn_pair = mean(pnone_pair,2);

pair_p1 = [];
pair_p2 = [];

for i = 1:numObs
    midL = size(pboth_pair,2)/2;
    obs_pb = pboth_pair(:,1:i*midL,:);
    obs_pn = pnone_pair(:,1:i*midL,:);
    tmp1 = mean(obs_pb,2);
    tmp2 = mean(obs_pn,2);
    [tmpP1,tmpP2] = quadratic_analysis(tmp1,tmp2);
    pair_p1 = horzcat(pair_p1,tmpP1);
    pair_p2 = horzcat(pair_p2,tmpP2);
end
pair_p1 = mean(pair_p1,2);
pair_p2 = mean(pair_p2,2);

%% Transform pboth and pnone into p1 and p2
% [p1,p2] = quadratic_analysis(Mpb_pair,Mpn_pair);

%% Plot p1 and p2 for each probe delay
figure;
for numPair = 1:size(pair_p1,3)
    subplot(2,3,numPair)
    hold on;
    plot(40:30:460,pair_p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    plot(40:30:460,pair_p2(:,:,numPair),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

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

    title(['PAIR n' num2str(numPair)],'FontSize',14,'Fontname','Ariel')  
end

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2PAIR']);
print ('-djpeg', '-r500',namefig);

%% Averaging across runs pair by pair for hemifields and diagonals
pbMsHemi = mean(pb_sameHemi,2);
pnMsHemi = mean(pn_sameHemi,2);
pbMdHemi = mean(pb_diffHemi,2);
pnMdHemi = mean(pn_diffHemi,2);
pbMdiag = mean(pb_diagonal,2);
pnMdiag = mean(pn_diagonal,2);

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
        title('Diagonals','FontSize',14,'Fontname','Ariel')
    end     
end
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2HemiDiag']);
print ('-djpeg', '-r500',namefig);
end

