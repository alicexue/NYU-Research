function [P1,P2] = overall_probe_analysis2(task)
%% This function averages pboth, pone, and pnone for all observers and then finds p1 and p2
%% Example
%%% overall_probe_analysis('difficult');

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

pboth_pair=[];
pnone_pair=[];

pbSH=[];
pbDH=[];
pbDg=[];
pbDSi1=[];
pbDSi2=[];
pbDDg=[];

pnSH=[];
pnDH=[];
pnDg=[];
pnDSi1=[];
pnDSi2=[];
pnDDg=[];

numObs = 0;

files = dir('C:\Users\alice_000\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [P1,P2,pb,po,pn,pbp,pnp,SH,DH,di,si1,si2,diD] = p_probe_analysis(obs,task,true);       
        if ~isempty(P1)
            pboth = horzcat(pboth,pb);
            pone = horzcat(pone,po);
            pnone = horzcat(pnone,pn); 

            pboth_pair = horzcat(pboth_pair,pbp);
            pnone_pair = horzcat(pnone_pair,pnp);

            pbSH = horzcat(pbSH,SH(:,1)); 
            pbDH = horzcat(pbDH,DH(:,1));
            pbDg = horzcat(pbDg,di(:,1));
            pbDSi1 = horzcat(pbDSi1,si1(:,1));
            pbDSi2 = horzcat(pbDSi2,si2(:,1));        
            pbDDg = horzcat(pbDDg,diD(:,1));        
            pnSH = horzcat(pnSH,SH(:,2));
            pnDH = horzcat(pnDH,DH(:,2));
            pnDg = horzcat(pnDg,di(:,2));   
            pnDSi1 = horzcat(pnDSi1,si1(:,2));   
            pnDSi2 = horzcat(pnDSi2,si2(:,2));   
            pnDDg = horzcat(pnDDg,diD(:,2));  

            numObs = numObs + 1;
        end
    end
end

%% Averaging across runs
Mpb = mean(pboth,2);
Mpo = mean(pone,2);
Mpn = mean(pnone,2);
Spb = std(pboth,[],2)./sqrt(numObs);
Spo = std(pone,[],2)./sqrt(numObs);
Spn = std(pnone,[],2)./sqrt(numObs);

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

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\main_' task '\' condition '_rawProbs']);
print ('-djpeg', '-r500',namefig);

%% Transform pboth and pnone into p1 and p2
[P1,P2] = quadratic_analysis(Mpb,Mpn);

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

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\main_' task '\' condition '_2p1p2']);
print ('-djpeg', '-r500',namefig);

%% Averaging across runs pair by pair
Mpb_pair = mean(pboth_pair,2);
Mpn_pair = mean(pnone_pair,2);

%% Transform pboth and pnone into p1 and p2
[p1,p2] = quadratic_analysis(Mpb_pair,Mpn_pair);

%% Plot p1 and p2 for each pair - square configuration
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
    xlim([0 500])
    
    if numPair == 1 || numPair == 4
        ylabel('Percent correct','FontSize',16,'Fontname','Ariel')
    end
    if numPair == 5
        xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
    end

    title(['PAIR n' num2str(numPair)],'FontSize',14,'Fontname','Ariel')  
end

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\main_' task '\' condition '_2p1p2PAIR1']);
print ('-djpeg', '-r500',namefig);

%% Plot p1 and p2 for each pair - diamond configuration
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

    title(['PAIR n' num2str(numPair+6)],'FontSize',14,'Fontname','Ariel')  
end

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\main_' task '\' condition '_2p1p2PAIR2']);
print ('-djpeg', '-r500',namefig);

%% Averaging across runs pair by pair for hemifields and diagonals
MpbSH = mean(mean(pbSH,2),3);
MpnSH = mean(mean(pnSH,2),3);
MpbDH = mean(mean(pbDH,2),3);
MpnDH = mean(mean(pnDH,2),3);
MpbDg = mean(mean(pbDg,2),3);
MpnDg = mean(mean(pnDg,2),3);
MpbDg1 = mean(mean(pbDSi1,2),3);
MpnDg1 = mean(mean(pnDSi1,2),3);
MpbDg2 = mean(mean(pbDSi2,2),3);
MpnDg2 = mean(mean(pnDSi2,2),3);
MpbDg3 = mean(mean(pbDDg,2),3);
MpnDg3 = mean(mean(pnDDg,2),3);       

%% Graph same/different hemifields and diagonals for square configuration
figure; hold on;
for i = 1:3
    if i == 1
        [p1,p2] = quadratic_analysis(MpbSH, MpnSH);
    elseif i == 2
        [p1,p2] = quadratic_analysis(MpbDH, MpnDH);
    elseif i == 3
        [p1,p2] = quadratic_analysis(MpbDg, MpnDg);
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
        title('Square Diagonals','FontSize',14,'Fontname','Ariel')
    end    
end
namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\main_' task '\' condition '_2p1p2HemiDiagS']);
print ('-djpeg', '-r500',namefig);

%% Graph same/different hemifields and diagonals for diamond configuration
figure; hold on;
for i = 1:3
    if i == 1
        [p1,p2] = quadratic_analysis(MpbDg1, MpnDg1);            
    elseif i == 2
        [p1,p2] = quadratic_analysis(MpbDg2, MpnDg2);
    elseif i == 3
        [p1,p2] = quadratic_analysis(MpbDg3, MpnDg3);
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
namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures\main_' task '\' condition '_2p1p2HemiDiagD']);
print ('-djpeg', '-r500',namefig);
end

