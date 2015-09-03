function [all_p1,all_p2] = overall_probe_analysis2(task)
%% This function gets p1 and p2 from all observers and averages them
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

numObs = 0;

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        [P1,P2,pb,po,pn,pbp,pnp,SH,DH,di,si1,si2,diD] = p_probe_analysis(obs,task,true);       
        if ~isempty(P1) 
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
           
            all_p1 = horzcat(all_p1,P1);
            all_p2 = horzcat(all_p2,P2);
            numObs = numObs + 1;
        end
    end
end

pair_p1=mean(pair_p1,2);
pair_p2=mean(pair_p2,2);

SH_p1=mean(SH_p1,2);
DH_p1=mean(DH_p1,2);
di_p1=mean(di_p1,2);
si1_p1=mean(si1_p1,2);
si2_p1=mean(si2_p1,2);
diD_p1=mean(diD_p1,2);

SH_p2=mean(SH_p2,2);
DH_p2=mean(DH_p2,2);
di_p2=mean(di_p2,2);
si1_p2=mean(si1_p2,2);
si2_p2=mean(si2_p2,2);
diD_p2=mean(diD_p2,2);

all_p1=mean(all_p1,2);
all_p2=mean(all_p2,2);

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

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_rawProbs']);
print ('-djpeg', '-r500',namefig);

%% Plot p1 and p2 for each probe delay
figure;hold on;
plot(100:30:460,all_p1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
plot(100:30:460,all_p2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

legend('p1','p2','Location','SouthEast')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
xlabel('Time from discrimination task onset [ms]','FontSize',20,'Fontname','Ariel')
ylim([0 1])
xlim([0 500])

title([condition ' Search'],'FontSize',24,'Fontname','Ariel')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2']);
print ('-djpeg', '-r500',namefig);

%% Plot p1 and p2 for each pair - square configuration
figure;
for numPair = 1:size(pair_p1,3)/2
    subplot(2,3,numPair)
    hold on;
    plot(100:30:460,pair_p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    plot(100:30:460,pair_p2(:,:,numPair),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

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

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_2p1p2PAIR1']);
print ('-djpeg', '-r500',namefig);

%% Plot p1 and p2 for each pair - diamond configuration
figure;
for numPair = 1:size(pair_p1,3)/2
    subplot(2,3,numPair)
    hold on;
    plot(100:30:460,pair_p1(:,:,numPair+6),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    plot(100:30:460,pair_p2(:,:,numPair+6),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

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

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_2p1p2PAIR2']);
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
    subplot(1,3,i)
    hold on;
    plot(100:30:460,t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    plot(100:30:460,t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

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
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_2p1p2HemiDiagS']);
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
    subplot(1,3,i)
    hold on;
    plot(100:30:460,t1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    plot(100:30:460,t2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

    ylim([0 1])
    xlim([0 500])

    title(['Diamond Diagonals n' num2str(i)],'FontSize',14,'Fontname','Ariel')

    if i == 1
        ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
    elseif i == 2
        xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
    end

end
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_2p1p2HemiDiagD']);
print ('-djpeg', '-r500',namefig);
end

