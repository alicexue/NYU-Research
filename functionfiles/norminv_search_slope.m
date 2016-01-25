function [hit,false_alarm,RT] = norminv_search_slope(obs,task,file,type)
%% Example
%%% norminv_search_slope('ax','difficult','151109_stim04.mat',1);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% file = '150701_stim05.mat'; (name of stim file)
% type = 1; (1: detection,2: discrimination)

%% Load data
load(['C:\Users\alice_000\Documents\MATLAB\data\' obs '\target present or absent\' task '\' file])

%% Transform data
exp = getTaskParameters(myscreen,task);
size4 = exp.randVars.setsize==4;
size8 = exp.randVars.setsize==8;

%% Compute performance according to the set size
noFixBreakIndices = find(task{1}.randVars.fixBreak == 0);
hit = NaN(1,size(noFixBreakIndices,2));
false_alarm = NaN(1,size(noFixBreakIndices,2));
RT = NaN(1,size(noFixBreakIndices,2));
fa_RT = NaN(1,size(noFixBreakIndices,2));

ishit = false;
isfa = false;

for n = 1:size(noFixBreakIndices,2)
    tmp = noFixBreakIndices(n);
    response = exp.response(tmp);
    presence = exp.randVars.presence(tmp);
    orientation = exp.randVars.targetOrientation(tmp);
    if type == 1
        if (presence == 1 && (response == 1 || response == 2))
            hit(n) = 1;
            ishit = true;
        else
            ishit = false;
            hit(n) = 0;
        end
        if (presence == 2 && (response == 1 || response == 2))
            isfa = true;
            false_alarm(n) = 1;
        else
            ishit = false;
            false_alarm(n) = 0;
        end
    elseif type == 2
        if (presence == 1 && orientation == 2 && response == 2)
            hit(n) = 1;
            ishit = true;
        else
            hit(n) = 0;
            ishit = false;
        end
        if (presence == 1 && orientation == 1 && response == 2)
            false_alarm(n) = 1;
            isfa = true;
        else
            false_alarm(n) = 0;
            isfa = false;
        end
    end
    RT(n) = exp.reactionTime(n);
    s4(n) = size4(tmp);
    s8(n) = size8(tmp);
end 

i4 = 1;
i8 = 1;

for n = 1:size(noFixBreakIndices,2)
    if s4(n)
        hit_4(i4) = hit(n);
        false_alarm_4(i4) = false_alarm(n);
        RT4(i4) = RT(n);
        i4 = i4 + 1;
    end
    if s8(n)
        hit_8(i8) = hit(n);
        false_alarm_8(i8) = false_alarm(n);
        RT8(i8) = RT(n);
        i8 = i8 + 1;
    end
end

if mean(hit_4 == 0)
    hit_4 = horzcat(hit_4,1);
end
if mean(hit_8 == 0)
    hit_8 = horzcat(hit_8,1);
end
if mean(false_alarm_4 == 0)
    false_alarm_4 = horzcat(false_alarm_4,1);
end
if mean(false_alarm_8 == 0)
    false_alarm_8 = horzcat(false_alarm_8,1);
end

hit = vertcat(hit_4,hit_8);
false_alarm = vertcat(false_alarm_4,false_alarm_8);

RT = vertcat(RT4,RT8);
end