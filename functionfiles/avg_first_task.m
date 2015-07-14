function [rt_all,rt_sd_all,perf_all,perf_sd_all] = avg_first_task(obs,date,nBlocks,nameBlock)
%This program allows averaging reaction time and perfromance of the first task.

%% parameters
%block_tocheck = 1;
%date = '141009';
%obs = 'ho';
%title_task = 'Difficult';

rt_all = [];
rt_sd_all = [];
perf_all = [];
perf_sd_all = [];

for h = 1:size(date,2)
    used_date = date{h};
    used_block = nBlocks(h);
    for i = 1:used_block
        [rt,rt_sd,perf,perf_sd] = p_search_slope(used_date,obs,nameBlock(i));
        rt_all = [rt_all,rt];
        rt_sd_all = [rt_sd_all,rt_sd];
        perf_all = [perf_all,perf];
        perf_sd_all = [perf_sd_all,perf_sd];
    end
end

end

