function [hit,false_alarm,all_RT] = p_norminv_search_slope(obs,task,type)
%% Example
% p_norminv_search_slope('ax','difficult',1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
    
%% Obtain pboth, pone and pnone for each run and concatenate over run
hit = [];
false_alarm = [];
all_RT = [];

dir_name = setup_dir();
files = dir(strrep([dir_name '\' obs '\target present or absent\' task],'\',filesep));    
for n = 1:size(files,1)
    filename = files(n).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')         
        [h,f,RT] = norminv_search_slope(obs,task,filename,type);
        hit = horzcat(hit,h);
        false_alarm = horzcat(false_alarm,f);
        
        all_RT = horzcat(all_RT,RT);
    end
end

hit = nanmean(hit,2);
false_alarm = nanmean(false_alarm,2);

all_RT = nanmedian(all_RT,2);
end



