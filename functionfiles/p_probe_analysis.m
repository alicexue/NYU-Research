function p_probe_analysis(obs,date,nBlocks,nameBlock,title_task)
%%% Example
%%% p_probe_analysis('ho',{'141113' '141118' '141120'},[2 1 2],{{'1';'2'};{'1'};{'1';'2'}},'Difficult')
%% Parameters

%block_tocheck = 1;
%date = '141009';
%obs = 'ho';
%title_task = 'Difficult';

%% Obtain pboth, pone and pnone for each run and concatenate over run
pboth=[];
pone=[];
pnone=[];
pboth_pair=[];
pone_pair=[];
pnone_pair=[];

for h = 1:size(date,2)
    used_date = date{h};
    used_block = nBlocks(h);
    
    for i = 1:used_block
        [pb,po,pn,pbp,pop,pnp] = probe_analysis(used_date,obs,cell2mat(nameBlock{h}(i)));
        
        pboth = [pboth,pb];
        pone = [pone,po];
        pnone = [pnone,pn];
        if i == 1 && h == 1
            pboth_pair = pbp;
            pone_pair = pop;
            pnone_pair = pnp;
        else
            pboth_pair = cat(2,pboth_pair,pbp);
            pone_pair = cat(2,pone_pair,pop);
            pnone_pair = cat(2,pnone_pair,pnp);
        end
        
    end
end

%% Averaging across runs
Mpb = mean (pboth,2);
Mpo = mean (pone,2);
Mpn = mean (pnone,2);
Spb = std (pboth,[],2)./sqrt(size(pboth,2));
Spo = std (pone,[],2)./sqrt(size(pone,2));
Spn = std (pnone,[],2)./sqrt(size(pnone,2));

figure;hold on;
errorbar(30:30:450,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
errorbar(30:30:450,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
errorbar(30:30:450,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

legend('PBoth','POne','PNone')

set(gca,'YTick',0:.2:1)
ylabel('Percent correct','FontSize',12)
xlabel('Time from search array onset [ms]','FontSize',12)
ylim([0 1])

title([title_task ' search (' obs ')'],'FontSize',14)

namefig=sprintf([title_task '_' obs '_rawProbs']);
print ('-djpeg', '-r500',namefig);

%% Transform pboth and pnone into p1 and p2
[p1,p2] = quadratic_analysis(Mpb,Mpn);

%% Plot p1 and p2 for each probe delay

figure;hold on;
plot(30:30:450,p1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
plot(30:30:450,p2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

legend('p1','p2','Location','SouthEast')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','FontName','Times New Roman')
ylabel('Probe report probabilities','FontSize',20,'FontName','Times New Roman')
xlabel('Time from discrimination task onset (ms)','FontSize',20,'FontName','Times New Roman')
ylim([0 1])

title([title_task ' search (' obs ')'],'FontSize',24,'FontName','Times New Roman')

namefig=sprintf([title_task '_' obs '_p1p2']);
print ('-djpeg', '-r500',namefig);

%% Averaging across runs pair by pair
Mpb_pair = mean (pboth_pair,2);
Mpn_pair = mean (pnone_pair,2);

%% Transform pboth and pnone into p1 and p2
[p1,p2] = quadratic_analysis(Mpb_pair,Mpn_pair);

%% Plot p1 and p2 for each probe delay

figure;
for numPair = 1:size(p1,3)
    subplot(2,3,numPair)
    hold on;
    plot(30:30:450,p1(:,:,numPair),'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    plot(30:30:450,p2(:,:,numPair),'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])
    
    legend('p1','p2')
    
    set(gca,'YTick',0:.2:1)
    
    if numPair == 1 || numPair == 4
        ylabel('Percent correct','FontSize',12)
    end
    if numPair == 4
        xlabel('Time from search array onset [ms]','FontSize',12)
    end
    ylim([0 1])
    
    title(['PAIR n' num2str(numPair) ' (' obs ')'],'FontSize',14)
    
end

namefig=sprintf([title_task '_' obs '_p1p2PAIR']);
print ('-djpeg', '-r500',namefig);

end

