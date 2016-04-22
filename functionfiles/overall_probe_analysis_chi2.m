function overall_probe_analysis_chi2(task,expN,trialType,printFg,printStats,observers)
%% This function graphs raw probabilities and p1 & p2 for overall, pairs, and hemifields across all observers
%% Example
%%% overall_probe_analysis_chi2('difficult',2,2,true,true,{});

%% Parameters

%% Outputs

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\' condition];
    saveFilePairsLoc = ['\main_' task '\pairs\' condition];
    saveFileName = '';
    titleName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\' condition];
    saveFilePairsLoc = ['\target present or absent\main_' task '\pairs\' condition];
    if trialType == 1
        titleName = 'chi2TP';
        saveFileName = 'chi2_2TP';
    elseif trialType == 2
        titleName = 'chi2TA';
        saveFileName = 'chi2_2TA';
    elseif trialType == 3
        titleName = 'chi2';
        saveFileName = 'chi2_2';
    end
end

%% Obtain pboth, pone and pnone for each observer and concatenate over observer
all_p1 = [];
all_p2 = [];

all_pb = [];
all_po = [];
all_pn = [];

numObs = 0;

dir_name = setup_dir();
files = dir(strrep(dir_name,'\',filesep));  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2) && ~strcmp(obs(1,1),'.') && (ismember(obs,observers) || isempty(observers))
        obs_pb = [];
        obs_po = [];
        obs_pn = [];
        [~,~,~,chi2,p,~] = p_search_target_location(obs,task,expN);        
        [~,~,~,~,~,pbp,pop,pnp,~,~,~,~,~,~,~,~] = p_probe_analysis(obs,task,expN,trialType,false,false,false,1); 
        if ~isempty(pbp)
            numObs = numObs + 1;
            fprintf([obs ': ']);
            for pair = 1:size(p,2);
                if (p(1,pair) >= 0.05) 
                    obs_pb = horzcat(obs_pb,pbp(:,:,pair));
                    obs_po = horzcat(obs_po,pop(:,:,pair));
                    obs_pn = horzcat(obs_pn,pnp(:,:,pair));
                else 
                    fprintf([num2str(pair) ', ']);
                end
            end
            fprintf('\n');
            
        end
        obs_pb = mean(obs_pb,2);
        obs_pn = mean(obs_pn,2);
        [obs_p1,obs_p2] = quadratic_analysis(obs_pb,obs_pn);
        all_pb = horzcat(all_pb,obs_pb);
        all_po = horzcat(all_po,obs_po);
        all_pn = horzcat(all_pn,obs_pn);
        all_p1 = horzcat(all_p1,obs_p1);
        all_p2 = horzcat(all_p2,obs_p2);
    end
end

Mpb = mean(all_pb,2);
Spb = std(all_pb,[],2)/sqrt(numObs);
Mpo = mean(all_po,2);
Spo = std(all_po,[],2)/sqrt(numObs);
Mpn = mean(all_pn,2);
Spn = std(all_pn,[],2)/sqrt(numObs);

m_p1 = mean(all_p1,2);
Sp1 = std(all_p1,[],2)/sqrt(numObs);
m_p2 = mean(all_p2,2);
Sp2 = std(all_p2,[],2)/sqrt(numObs);
 
if printFg
    %% Averaging across runs
    figure;hold on;
    errorbar(100:30:460,Mpb,Spb,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[1 0 0])
    errorbar(100:30:460,Mpo,Spo,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 1 0])
    errorbar(100:30:460,Mpn,Spn,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 1])

    legend('PBoth','POne','PNone')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Percent correct','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    title([condition ' Search (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_rawProbsObs' saveFileName],'\',filesep));

    print ('-djpeg', '-r500',namefig);

    %% Plot p1 and p2 for each probe delay    
    figure;hold on;

    errorbar(100:30:460,m_p1,Sp1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
    errorbar(100:30:460,m_p2,Sp2,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])

    legend('p1','p2','Location','SouthEast')

    set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
    set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

    ylabel('Probe report probabilities','FontSize',20,'Fontname','Ariel')
    xlabel('Time from search array onset [ms]','FontSize',20,'Fontname','Ariel')
    ylim([0 1])

    xlim([0 500])

    title([condition ' Search (n = ' num2str(numObs) ') ' titleName],'FontSize',24,'Fontname','Ariel')

    namefig=sprintf('%s', strrep([dir_name '\figures\' saveFileLoc '_p1p2Obs' saveFileName],'\',filesep));

    print ('-djpeg', '-r500',namefig);
end

%% Conduct ANOVA on p1 and p2
if printStats
    p1p2 = zeros(numObs*13*2,4);
    index = 0;
    for i = 1:numObs
        p1p2(index+1:index+13,1) = all_p1(:,i);
        p1p2(index+1:index+13,2) = rot90(1:13,-1);
        p1p2(index+1:index+13,3) = rot90([1,1,1,1,1,1,1,1,1,1,1,1,1]);
        p1p2(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
        index = index + 13;
        p1p2(index+1:index+13,1) = all_p2(:,i);
        p1p2(index+1:index+13,2) = rot90(1:13,-1);
        p1p2(index+1:index+13,3) = rot90([2,2,2,2,2,2,2,2,2,2,2,2,2]);
        p1p2(index+1:index+13,4) = rot90([i,i,i,i,i,i,i,i,i,i,i,i,i]);
        index = index + 13;
    end
    RMAOV2(p1p2);    
end
end