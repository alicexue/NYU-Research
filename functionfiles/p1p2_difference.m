function [diff] = p1p2_difference(p1,p2,obs,task,displayFg)
% This function finds the difference of p1 and p2 for each observer and then
% takes the average across observers

% Enter '' as obs if you want overall p1-p2 (this will save the figures in
% the overall figures folder instead of an individual's)

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Plot difference of p1 and p2 for each probe delay
diff = p1 - p2;
m_diff = mean(diff,2);
std_diff = std(diff,[],2)./sqrt(size(diff,2));

if displayFg
    figure;hold on;

    errorbar(100:30:460,m_diff,std_diff,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[0 0 0])

    set(gca,'YTick',-0.6:.2:0.8,'FontSize',15,'LineWidth',2','Fontname','Ariel')
    ylabel('P1 - P2','FontSize',15,'Fontname','Ariel')
    xlabel('Time from discrimination task onset [ms]','FontSize',15,'Fontname','Ariel')
    ylim([-0.6 0.8])
    xlim([0 500])

    if strcmp(obs,'')
        title([condition ' Search '],'FontSize',18,'Fontname','Ariel')
        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\time\' condition '_p1p2_diff_tmp']);
    elseif strcmp(obs,'all')
        title([condition ' Search (n = ' num2str(size(diff,2)) ')'],'FontSize',18,'Fontname','Ariel')
        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\figures\' condition '_p1p2_difference']);       
    else
        title([condition ' Search (' obs ')'],'FontSize',18,'Fontname','Ariel')
        namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\time\' obs '_' condition '_p1p2_difference']);
    end
    print ('-djpeg', '-r500',namefig);
end
end
