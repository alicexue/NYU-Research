function p_probe_analysis(obs, task, date1, date2, maxBlockN)
%%% This function analyzes all of the data from date1 to date2 with a block
%%% number <= maxBlockN. 
%%% date1 and date2 can differ by month but not year

%% Example
%%% p_probe_analysis('ax', 'difficult', '150716', '150721', 1)

%% Parameters
% obs = 'ax';
% task = 'difficult'
% date1 = '150714'
% date2 = '150720';
% maxBlockN = 1; 

% maxBlockN refers to the largest number block across all dates

%% Change task name to feature/conjunction
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
pone_pair=[];
pnone_pair=[];
pb_sameHemi = [];
pb_diffHemi = [];
pb_diagonal = [];
pn_sameHemi = [];
pn_diffHemi = [];
pn_diagonal = [];

date1num = str2double(date1);
date2num = str2double(date2);
numDates = date2num - date1num + 1;
m = 1;
if numDates > 100
    m = fix((date2num - date1num)/100)+1;
end
for tmp = 1:m 
    n = fix(str2double(date1)/100)*100+((tmp-1)*100);
    if tmp~=1 && numDates > 100
        date1num = n;
        date2num = date1num+31;
    elseif tmp==1 && numDates > 100
        date2num = n+31;
    end
    for date = date1num:date2num
        for blockN = 0:maxBlockN
            if blockN < 10
                strTmp = ['0', num2str(blockN)];
            else
                strTmp = num2str(blockN);
            end  
            s = ['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task, '\', num2str(date), '_stim', strTmp, '.mat'];    
            exists = exist(s,'file');            
            if exists ~= 0
                [pb,po,pn,pbp,pop,pnp,sHemi,dHemi,diag] = probe_analysis(obs,task,num2str(date),blockN); 

                pboth = horzcat(pboth,pb);
                pone = horzcat(pone,po);
                pnone = horzcat(pnone,pn); 
                
                pboth_pair = horzcat(pboth_pair,pbp);
                pone_pair = horzcat(pone_pair,pop); 
                pnone_pair = horzcat(pnone_pair,pnp);
                
                pb_sameHemi = horzcat(pb_sameHemi,sHemi(:,:,1:2)); 
                pb_diffHemi = horzcat(pb_diffHemi,dHemi(:,:,1:2));
                pb_diagonal = horzcat(pb_diagonal,diag(:,:,1:2));
                pn_sameHemi = horzcat(pn_sameHemi,sHemi(:,:,3:4));
                pn_diffHemi = horzcat(pn_diffHemi,dHemi(:,:,3:4));
                pn_diagonal = horzcat(pn_diagonal,diag(:,:,3:4));                 
            end
        end
    end
end

%% Averaging across runs
Mpb = mean(pboth,2);
Mpo = mean(pone,2);
Mpn = mean(pnone,2);
Spb = std(pboth,[],2)./sqrt(size(pboth,2));
Spo = std(pone,[],2)./sqrt(size(pone,2));
Spn = std(pnone,[],2)./sqrt(size(pnone,2));

figure;hold on;
errorbar(40:30:460,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
errorbar(40:30:460,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
errorbar(40:30:460,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

legend('PBoth','POne','PNone')

set(gca,'YTick',0:.2:1)

% set(gca,'XTick',0:30:500)

ylabel('Percent correct','FontSize',12)
xlabel('Time from search array onset [ms]','FontSize',12)
ylim([0 1])

title([condition ' Search (' obs ')'],'FontSize',14)

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_rawProbs']);
print ('-djpeg', '-r500',namefig);

%% Transform pboth and pnone into p1 and p2
[p1,p2] = quadratic_analysis(Mpb,Mpn);

%% Plot p1 and p2 for each probe delay

figure;hold on;
plot(40:30:460,p1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
plot(40:30:460,p2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

legend('p1','p2','Location','SouthEast')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','FontName','Times New Roman')
ylabel('Probe report probabilities','FontSize',20,'FontName','Times New Roman')
xlabel('Time from discrimination task onset [ms]','FontSize',20,'FontName','Times New Roman')
ylim([0 1])

title([condition ' Search (' obs ')'],'FontSize',24,'FontName','Times New Roman')

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2']);
print ('-djpeg', '-r500',namefig);

%% Averaging across runs pair by pair
Mpb_pair = mean(pboth_pair,2);
Mpn_pair = mean(pnone_pair,2);

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
    
    set(gca,'YTick',0:.2:1)
    set(gca,'XTick',0:100:500)
    
    if numPair == 1 || numPair == 4
        ylabel('Percent correct','FontSize',12)
    end
    if numPair == 4
        xlabel('Time from search array onset [ms]','FontSize',12)
    end
    ylim([0 1])
    
    title(['PAIR n' num2str(numPair) ' (' obs ')'],'FontSize',14)   
end

namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2PAIR']);
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
for n = 1:3
    if n == 1
        [p1,p2] = quadratic_analysis(pbMsHemi, pnMsHemi);
    elseif n == 2
        [p1,p2] = quadratic_analysis(pbMdHemi, pnMdHemi);
    else
        [p1,p2] = quadratic_analysis(pbMdiag, pnMdiag);
    end    
    subplot(1,3,n)
    hold on;
    plot(40:30:460,p1(:,:),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    plot(40:30:460,p2(:,:),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

    legend('p1','p2')

    set(gca,'YTick',0:.2:1)
    set(gca,'XTick',0:100:500)

    if n == 1 
        ylabel('Percent correct','FontSize',12)
    end
    ylim([0 1])
    if n == 1
        title('Same Hemifield','FontSize',14)
        xlabel('Time from search array onset [ms]','FontSize',12)           
    elseif n == 2
        title('Different Hemifield','FontSize',14)     
    else
        title(['Diagonals (' obs ')'],'FontSize',14)
    end     
end
namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2HemiDiag']);
print ('-djpeg', '-r500',namefig);

end

