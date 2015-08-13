function overall_probe_analysis2(task)
%% This function solves for p1 and p2 for each obs and then averages them
%% Example
%%% overall_probe_analysis2('difficult');

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

pbSH = [];
pbDH = [];
pbDg = [];
pbDDg1 = [];
pbDDg2 = [];
pbDDg3 = [];
pnSH = [];
pnDH = [];
pnDg = [];
pnDDg1 = [];
pnDDg2 = [];
pnDDg3 = [];

P1 = [];
P2 = [];

numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if fileL == 4 || fileL == 5 && ~strcmp(obs(1,1),'.')
        [pb,po,pn,pbp,pop,pnp,SH,DH,di,di1,di2,di3] = p_probe_analysis(obs,task,true);              
        
        pboth = cat(3,pboth,pb);
        pone = cat(3,pone,po);
        pnone = cat(3,pnone,pn); 

        pboth1 = horzcat(pboth1,pb);
        pone1 = horzcat(pone1,po);
        pnone1 = horzcat(pnone1,pn);         
        
        pboth_pair = horzcat(pboth_pair,pbp);
        pone_pair = horzcat(pone_pair,pop); 
        pnone_pair = horzcat(pnone_pair,pnp);

        pbSH = horzcat(pbSH,SH(:,1)); 
        pbDH = horzcat(pbDH,DH(:,1));
        pbDg = horzcat(pbDg,di(:,1));
        pbDDg1 = horzcat(pbDDg1,di1(:,1));
        pbDDg2 = horzcat(pbDDg2,di2(:,1));        
        pbDDg3 = horzcat(pbDDg3,di3(:,1));   
        
        pnSH = horzcat(pnSH,SH(:,2));
        pnDH = horzcat(pnDH,DH(:,2));
        pnDg = horzcat(pnDg,di(:,2));   
        pnDDg1 = horzcat(pnDDg1,di1(:,2));   
        pnDDg2 = horzcat(pnDDg2,di2(:,2));   
        pnDDg3 = horzcat(pnDDg3,di3(:,2));  
        
        numObs = numObs + 1;
    end
end

%% Averaging across runs
Mpb = mean(mean(pboth,2),3);
Mpo = mean(mean(pone,2),3);
Mpn = mean(mean(pnone,2),3);

Spb = std(pboth1,[],2)./sqrt(numObs);
Spo = std(pone1,[],2)./sqrt(numObs);
Spn = std(pnone1,[],2)./sqrt(numObs); 

figure;hold on;
errorbar(100:30:460,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
errorbar(100:30:460,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
errorbar(100:30:460,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

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
    P1 = horzcat(P1,p1);
    P2 = horzcat(P2,p2);
end

P1 = mean(P1,2);
P2 = mean(P2,2);

%% Plot p1 and p2 for each probe delay
figure;hold on;
plot(100:30:460,P1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
plot(100:30:460,P2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

legend('p1','p2','Location','SouthEast')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([0 1])
xlim([0 500])

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
[p1,p2] = quadratic_analysis(pair_p1,pair_p2);

%% Plot p1 and p2 for each pair - square configuration
figure;
for numPair = 1:size(pair_p1,3)/2
    subplot(2,3,numPair)
    hold on;
    plot(100:30:460,p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    plot(100:30:460,p2(:,:,numPair),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')
    set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    ylim([0 1])
    xlim([0 500])
    
    if numPair == 1 || numPair == 4
        ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
    end
    if numPair == 4
        xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
    end

    title(['PAIR n' num2str(numPair) ' (' obs ')'],'FontSize',14,'Fontname','Ariel')  
end

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2PAIR1']);
print ('-djpeg', '-r500',namefig);

%% Plot p1 and p2 for each pair - diamond configuration
figure;
for numPair = 1:size(pair_p1,3)/2
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

    title(['PAIR n' num2str(numPair+6)],'FontSize',14,'Fontname','Ariel')  
end

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2PAIR2']);
print ('-djpeg', '-r500',namefig);

%% Averaging across runs pair by pair for hemifields and diagonals
MpbSH = mean(mean(pbSH,2),3);
MpnSH = mean(mean(pnSH,2),3);
MpbDH = mean(mean(pbDH,2),3);
MpnDH = mean(mean(pnDH,2),3);
MpbDg = mean(mean(pbDg,2),3);
MpnDg = mean(mean(pnDg,2),3);
MpbDDg1 = mean(mean(pbDDg1,2),3);
MpnDDg1 = mean(mean(pnDDg1,2),3);
MpbDDg2 = mean(mean(pbDDg2,2),3);
MpnDDg2 = mean(mean(pnDDg2,2),3);
MpbDDg3 = mean(mean(pbDDg3,2),3);
MpnDDg3 = mean(mean(pnDDg3,2),3);

%% Graph same/different hemifields and diagonals
figure; hold on;
for i = 1:6
    if i == 1
        [p1,p2] = quadratic_analysis(MpbSH, MpnSH);
    elseif i == 2
        [p1,p2] = quadratic_analysis(MpbDH, MpnDH);
    elseif i == 3
        [p1,p2] = quadratic_analysis(MpbDg, MpnDg);
    elseif i == 4
        [p1,p2] = quadratic_analysis(MpbDDg1, MpnDDg1);            
    elseif i == 5
        [p1,p2] = quadratic_analysis(MpbDDg2, MpnDDg2);
    else
        [p1,p2] = quadratic_analysis(MpbDDg3, MpnDDg3);
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
        title('Same Hemifield','FontSize',14,'Fontname','Ariel')  
        ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
    elseif i == 2
        title('Different Hemifield','FontSize',14,'Fontname','Ariel')           
    elseif i == 3
        title('Square Diagonals','FontSize',14,'Fontname','Ariel')
    else
        title(['Diamond Diagonals' num2str(i-3)],'FontSize',14,'Fontname','Ariel')
    end     

    if i == 4
        ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
        xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
    end

end
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2HemiDiag']);
print ('-djpeg', '-r500',namefig);
end

