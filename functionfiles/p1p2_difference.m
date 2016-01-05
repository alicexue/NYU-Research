function [diff] = p1p2_difference(p1,p2,obs,exp,task,displayFg)
% This function finds the difference of p1 and p2 for each observer and then
% takes the average across observers

% Enter 'all' as obs if you want overall p1-p2 (this will save the figures in
% the overall figures folder instead of an individual's)

% 'all' is entered as a parameter, p1 and p2 don't need to be inputted
%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Plot difference of p1 and p2 for each probe delay
if strcmp(obs,'all')
    [p1,p2] = overall_probe_analysis(task,false,false);
end

diff = p1 - p2;
m_diff = mean(diff,2);
std_diff = std(diff,[],2)./sqrt(size(diff,2));

numObs = 0;

if displayFg
    all_p1=[];
    all_p2=[];
    if strcmp(obs,'all')
        files = dir('C:\Users\Alice\Documents\MATLAB\data');  
        for n = 1:size(files,1)
            obs_name = files(n).name;
            fileL = size(obs_name,2);
            if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')    
                [P1,P2] = p_probe_analysis(obs_name,task,false,false);
                if ~isempty(P1)
                    all_p1 = horzcat(all_p1,P1);
                    all_p2 = horzcat(all_p2,P2);
                    numObs = numObs + 1;
                end
            end
        end
    end
    figure;hold on;

    if strcmp(obs,'all')
        all_diff = all_p1-all_p2;
        for i=1:size(all_diff,2);
            plot(100:30:460,all_diff(:,i),'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8);
        end
    end
    
    errorbar(100:30:460,m_diff,std_diff,'-o','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    if strcmp(obs,'all')
        legend_obs = cell(numObs,1);
        for i=1:numObs
            legend_obs{i} = ['obs ' num2str(i)];
        end
        legend_obs{numObs+1} = 'average';
        legend(legend_obs,'Location','SouthWest')
    end
    
    set(gca,'YTick',-0.6:.2:0.8,'FontSize',15,'LineWidth',2','Fontname','Ariel')
    ylabel('P1 - P2','FontSize',15,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',15,'Fontname','Ariel')
    ylim([-0.6 0.8])
    xlim([0 500])

    plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
    
    if strcmp(obs,'')
        title([condition ' Search '],'FontSize',18,'Fontname','Ariel')
        if exp == 1
            namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\time\' condition '_p1p2_diff_tmp']);
        elseif exp == 2
            namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\target present or absent\time\' condition '_p1p2_diff_tmp']);
        end
    elseif strcmp(obs,'all')
        title([condition ' Search (n = ' num2str(size(diff,2)) ')'],'FontSize',18,'Fontname','Ariel')
        if exp == 1
            namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2_difference']);       
        elseif exp == 2
            namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\target present or absent\' condition '_p1p2_difference']);       
        end
    else
        title([condition ' Search (' obs ')'],'FontSize',18,'Fontname','Ariel')
        if exp == 1
            namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\target present or absent\main_' task '\figures\time\' obs '_' condition '_p1p2_difference']);
        elseif exp == 2
            namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\target present or absent\main_' task '\figures\time\' obs '_' condition '_p1p2_difference']);
        end
    end
    print ('-djpeg', '-r500',namefig);
end
end
