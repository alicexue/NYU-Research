function display_figures(obs,task,search_slope,main_slope,probe_perf,probe_analysis,probe_target,probeTB)
%% Parameters
% first two parameters must be strings
% all other parameters must be booleans

%% Notes about parameters
% To call all functions that take overall data, then input '' as obs. 
% Otherwise, enter the specific observer's initials

% The parameter "task" can be 'difficult','easy',or 'both'. 
% The parameter "both" will call both 'easy' and 'difficult'

if obs == ''
    if strcmp(task,'both')
        repeatN = 2;
    else
        repeatN = 1;
    end
    
    if search_slope
        overall_search_slope(true);
    end
    
    for i=1:repeatN
        if i == 1
            tmp = 'easy';
        else
            tmp = 'difficult';
        end
        if main_slope
            overall_main_slope(tmp);
        end
        if probe_perf
            overall_probe_performance(tmp);
        end
        if probe_analysis
            overall_probe_analysis(tmp,true);
        end
        if probe_target
            overall_probe_target_analysis(tmp);
        end
        if probeTB
            overall_probe_analysisTB(tmp,true);
        end
    end
else
    if strcmp(task,'both')
        repeatN = 2;
    else
        repeatN = 1;
    end
    
    for i=1:repeatN
        if i == 1
            tmp = 'easy';
        else
            tmp = 'difficult';
        end
        if search_slope
            p_search_slope(obs,tmp,false,true);
        end
        if main_slope
            p_main_slope(obs,tmp,true);
        end
        if probe_perf
            p_probe_performance(obs,tmp,true);
        end
        if probe_analysis
            p_probe_analysis(obs,tmp,true);
        end
        if probe_target
            p_probe_target_analysis(obs,tmp,true);
        end
        if probeTB
            p_probe_analysisTB(obs,tmp,true);
        end
    end
end    
