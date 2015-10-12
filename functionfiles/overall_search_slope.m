function overall_search_slope(displayFg,displayStats)
%% Example
% overall_search_slope(true,true);

%% Parameters
% displayFg = true;
% displayStats = true;

% if displayStats is true, then search_slope_stats() is called at the end
% must manually add observers to the legend

if displayFg
    easy_rt=[];
    easy_perf=[];

    difficult_rt=[];
    difficult_perf=[];

    s_easy_rt=[];
    s_easy_perf=[];

    s_difficult_rt=[];
    s_difficult_perf=[];

    numObs = 0;

    %% Load data
    files = dir('C:\Users\Alice\Documents\MATLAB\data');  
    for n = 1:size(files,1)
        obs = files(n).name;
        fileL = size(obs,2);
        if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
            for i=1:2
                if i == 1
                    task = 'easy';
                else 
                    task = 'difficult';
                end
                [rt4,rt8,perf4,perf8] = p_search_slope(obs,task,false,false);
                    if ~isempty(rt4)
                        if strcmp(task,'easy')
                            easy_rt=horzcat(easy_rt,vertcat(median(rt4),median(rt8)));
                            easy_perf=horzcat(easy_perf,vertcat(mean(perf4),mean(perf8)));
                            s_easy_rt=horzcat(s_easy_rt,vertcat(std(rt4)/size(rt4,2),std(rt8)/size(rt4,2)));
                            s_easy_perf=horzcat(s_easy_perf,vertcat(std(perf4)/size(perf4,2),std(perf8)/size(perf4,2)));
                            numObs = numObs+1;
                        else
                            difficult_rt=horzcat(difficult_rt,vertcat(median(rt4),median(rt8)));
                            difficult_perf=horzcat(difficult_perf,vertcat(mean(perf4),mean(perf8)));
                            s_difficult_rt=horzcat(s_difficult_rt,vertcat(std(rt4)/size(rt4,2),std(rt8)/size(rt4,2)));
                            s_difficult_perf=horzcat(s_difficult_perf,vertcat(std(perf4)/size(perf4,2),std(perf8)/size(perf4,2)));                        
                        end
                    end
            end
        end
    end

    m_easy_rt=mean(easy_rt,2);
    m_easy_perf=mean(easy_perf,2);
    ms_easy_rt=std(easy_rt,[],2)./sqrt(numObs);
    ms_easy_perf=std(easy_perf,[],2)./sqrt(numObs);

    m_difficult_rt=mean(difficult_rt,2);
    m_difficult_perf=mean(difficult_perf,2);
    ms_difficult_rt=std(difficult_rt,[],2)./sqrt(numObs);
    ms_difficult_perf=std(difficult_perf,[],2)./sqrt(numObs);

    %% Plot reaction time
    figure;hold on;
    for i=1:numObs
        errorbar(4:4:8,easy_rt(:,i)*1000,s_easy_rt(:,i),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9)
    end

    errorbar(4:4:8,m_easy_rt*1000,ms_easy_rt*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9,'Color',[0 0 0])

    legend_obs = cell(numObs,1);
    for i=1:numObs
        legend_obs{i} = ['obs ' num2str(i)];
    end
    legend_obs{numObs+1} = 'average';
    l = legend(legend_obs,'Location','SouthWest');    
    set(l,'FontSize',12);    

    xlim([3 9])
    set(gca,'XTick',4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    ylim([0 250])
    set(gca,'YTick', 0:50:250,'FontSize',20,'LineWidth',2,'Fontname','Ariel')

    title(['Feature Reaction Time (n = ' num2str(numObs) ')'],'FontSize',22)
    xlabel('Set Size','FontSize',20,'Fontname','Ariel')
    ylabel('RT [ms]','FontSize',20,'Fontname','Ariel')
    namefig=sprintf('%s', 'C:\Users\Alice\Documents\MATLAB\data\figures\easy\Feature_rtSetSize');
    print ('-djpeg', '-r500',namefig);

    %% Plot performance
    figure;hold on;

    for i=1:numObs
        errorbar(4:4:8,easy_perf(:,i)*100,s_easy_perf(:,i),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9)
    end

    errorbar(4:4:8,m_easy_perf*100,ms_easy_perf*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

    legend_obs = cell(numObs,1);
    for i=1:numObs
        legend_obs{i} = ['obs ' num2str(i)];
    end
    legend_obs{numObs+1} = 'average';    
    l = legend(legend_obs,'Location','SouthWest');    
    set(l,'FontSize',12);      

    xlim([3 9])
    set(gca,'XTick', 4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    ylim([50 100])
    set(gca,'YTick', 50:10:100,'FontSize',20,'LineWidth',2,'Fontname','Ariel')

    title(['Feature Accuracy (n = ' num2str(numObs) ')'],'FontSize',22)
    xlabel('Set Size','FontSize',20,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',20,'Fontname','Ariel')

    namefig=sprintf('%s', 'C:\Users\Alice\Documents\MATLAB\data\figures\easy\Feature_perfSetSize');
    print ('-djpeg', '-r500',namefig);

    %% Plot reaction time
    figure;hold on;

    for i=1:numObs
        errorbar(4:4:8,difficult_rt(:,i)*1000,s_difficult_rt(:,i),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9)
    end

    errorbar(4:4:8,m_difficult_rt*1000,ms_difficult_rt*1000,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

    legend_obs = cell(numObs,1);
    for i=1:numObs
        legend_obs{i} = ['obs ' num2str(i)];
    end
    legend_obs{numObs+1} = 'average';      
    l = legend(legend_obs,'Location','SouthWest');    
    set(l,'FontSize',12);    

    xlim([3 9])
    set(gca,'XTick',4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    ylim([0 250])
    set(gca,'YTick', 0:50:250,'FontSize',20,'LineWidth',2,'Fontname','Ariel')

    title(['Conjunction Reaction Time (n = ' num2str(numObs) ')'],'FontSize',22)
    xlabel('Set Size','FontSize',20,'Fontname','Ariel')
    ylabel('RT [ms]','FontSize',20,'Fontname','Ariel')
    namefig=sprintf('%s', 'C:\Users\Alice\Documents\MATLAB\data\figures\difficult\Conjunction_rtSetSize');
    print ('-djpeg', '-r500',namefig);

    %% Plot performance
    figure;hold on;

    for i=1:numObs
        errorbar(4:4:8,difficult_perf(:,i)*100,s_difficult_perf(:,i),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9)
    end

    errorbar(4:4:8,m_difficult_perf*100,ms_difficult_perf*100,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

    legend_obs = cell(numObs,1);
    for i=1:numObs
        legend_obs{i} = ['obs ' num2str(i)];
    end
    legend_obs{numObs+1} = 'average';
    l = legend(legend_obs,'Location','SouthWest');    
    set(l,'FontSize',12); 

    xlim([3 9])
    set(gca,'XTick', 4:4:8,'FontSize',20,'LineWidth',2,'Fontname','Ariel')
    ylim([50 100])
    set(gca,'YTick', 50:10:100,'FontSize',20,'LineWidth',2,'Fontname','Ariel')

    title(['Conjunction Accuracy (n = ' num2str(numObs) ')'],'FontSize',22)
    xlabel('Set Size','FontSize',20,'Fontname','Ariel')
    ylabel('Accuracy','FontSize',20,'Fontname','Ariel')

    namefig=sprintf('%s', 'C:\Users\Alice\Documents\MATLAB\data\figures\difficult\Conjunction_perfSetSize');
    print ('-djpeg', '-r500',namefig);
end
if displayStats
    search_slope_stats();
end
end

function search_slope_stats()
% Find the ttest statistics for all observers' search slope print them in the
% command window

%% Conduct ttest and print results
rt_easy4=[];
p_easy4=[];
rt_easy8=[];
p_easy8=[];

rt_difficult4=[];
p_difficult4=[];
rt_difficult8=[];
p_difficult8=[];

files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        for i=1:2
            if i == 1
                task = 'easy';
            else 
                task = 'difficult';
            end
            [rt4,rt8,perf4,perf8] = p_search_slope(obs,task,false,false);
            rt_slope = (median(rt8) - median(rt4))/4*1000;
            p_slope = (mean(perf8) - mean(perf4))/4*100;               
            [rt_h,rt_p,rt_ci,rt_stats] = ttest(rt4,rt8);
            [p_h,p_p,p_ci,p_stats] = ttest(perf4,perf8);       
         
            if ~isempty(rt4)
                if strcmp(task,'easy')
                    rt_easy4 = horzcat(rt_easy4,median(rt4));
                    p_easy4 = horzcat(p_easy4,mean(perf4));
                    rt_easy8 = horzcat(rt_easy8,median(rt8));
                    p_easy8 = horzcat(p_easy8,mean(perf8));                    
                else
                    rt_difficult4 = horzcat(rt_difficult4,median(rt4));
                    p_difficult4 = horzcat(p_difficult4,mean(perf4));
                    rt_difficult8 = horzcat(rt_difficult8,median(rt8));
                    p_difficult8 = horzcat(p_difficult8,mean(perf8));                    
                end                
                rt_h = num2str(rt_h);
                rt_p = num2str(rt_p);
                rt_ci = num2str(rt_ci);
                rt_tstat = num2str(rt_stats.tstat);

                p_h = num2str(p_h);
                p_p = num2str(p_p);
                p_ci = num2str(p_ci);
                p_tstat = num2str(p_stats.tstat);        

                fprintf('------------------------------------------------------\n')
                fprintf(['obs: ' obs ', task: ' task '\n'])
                fprintf(['rt slope = ' num2str(rt_slope) '\n'])
                fprintf(['t = ' rt_tstat '\n'])
                fprintf(['p = ' rt_p '\n'])
                fprintf(['ci = [' rt_ci ']\n'])        
                fprintf(['perf slope = ' num2str(p_slope) '\n'])
                fprintf(['t = ' p_tstat '\n'])
                fprintf(['p = ' p_p '\n'])
                fprintf(['ci = [' p_ci ']\n'])   
            end
        end
    end
end

% rt_easy4 = mean(rt_easy4,2);
% p_easy4 = mean(p_easy4,2);
% rt_difficult4 = mean(rt_difficult4,2);
% p_difficult4 = mean(p_difficult4,2);
% 
% rt_easy8 = mean(rt_easy8,2);
% p_easy8 = mean(p_easy8,2);
% rt_difficult8 = mean(rt_difficult8,2);
% p_difficult8 = mean(p_difficult8,2);

rt_easy_slope = (mean(rt_easy8)-mean(rt_easy4))/4*1000;
p_easy_slope = (mean(p_easy8)-mean(p_easy4))/4*100;
rt_difficult_slope = (mean(rt_difficult8)-mean(rt_difficult4))/4*1000;
p_difficult_slope = (mean(p_difficult8)-mean(p_difficult4))/4*100;

[rt_h,rt_p,rt_ci,rt_stats] = ttest(rt_easy4,rt_easy8);
[p_h,p_p,p_ci,p_stats] = ttest(p_easy4,p_easy8);  
fprintf('------------------------------------------------------\n')
fprintf('overall, task: easy\n')
fprintf(['rt slope = ' num2str(rt_easy_slope) '\n'])
fprintf(['t = ' num2str(rt_tstat) '\n'])
fprintf(['p = ' num2str(rt_p) '\n'])
fprintf(['ci = [' num2str(rt_ci) ']\n'])        
fprintf(['perf slope = ' num2str(p_easy_slope) '\n'])
fprintf(['t = ' num2str(p_tstat) '\n'])
fprintf(['p = ' num2str(p_p) '\n'])
fprintf(['ci = [' num2str(p_ci) ']\n'])   


[rt_h,rt_p,rt_ci,rt_stats] = ttest(rt_difficult4,rt_difficult8);
[p_h,p_p,p_ci,p_stats] = ttest(p_difficult4,p_difficult8);  
fprintf('------------------------------------------------------\n')
fprintf('overall, task: difficult\n')
fprintf(['rt slope = ' num2str(rt_difficult_slope) '\n'])
fprintf(['t = ' num2str(rt_tstat) '\n'])
fprintf(['p = ' num2str(rt_p) '\n'])
fprintf(['ci = [' num2str(rt_ci) ']\n'])        
fprintf(['perf slope = ' num2str(p_difficult_slope) '\n'])
fprintf(['t = ' num2str(p_tstat) '\n'])
fprintf(['p = ' num2str(p_p) '\n'])
fprintf(['ci = [' num2str(p_ci) ']\n'])  

end

