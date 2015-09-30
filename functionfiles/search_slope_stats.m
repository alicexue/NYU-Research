function search_slope_stats()
% Find the ttest statistics for all observers' search slope print them in the
% command window

%% Conduct ttest and print results
files = dir('C:\Users\Alice\Documents\MATLAB\data');  
for n = 1:size(files,1)
    obs = files(n).name;
    fileL = size(obs,2);
    if (fileL == 2 || fileL == 3) && ~strcmp(obs(1,1),'.')
        for n=1:2
            if n == 1
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
end
