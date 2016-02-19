function [easy_dprime,difficult_dprime] = overall_norminv_search_slope(type,divideRT)
%% Example
%%% overall_norminv_search_slope(1,false);
% type = 1 for detection
% type = 2 for discrimination
% type = 3 for target absent trials - report absence correctly

if type == 1
    typeName = 'Detection';
elseif type == 2
    typeName = 'Discrimination';
elseif type == 3
    typeName = 'Detect Absence';
end

saveFileLoc = '\target present or absent';
if divideRT
    saveFileName = 'efficiency';
else
    saveFileName = '';
end

easy_hit = [];
easy_false_alarm = [];

difficult_hit = [];
difficult_false_alarm = [];

easy_RT = [];
difficult_RT = [];

%% Load data
files = dir('C:\Users\alice_000\Documents\MATLAB\data');  
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
            [hit,false_alarm,RT] = p_norminv_search_slope(obs,task,type);
                if ~isnan(hit)
                    if strcmp(task,'easy')
                        easy_hit = horzcat(easy_hit,hit);
                        easy_false_alarm = horzcat(easy_false_alarm,false_alarm);
                        easy_RT = horzcat(easy_RT,RT);
                    else
                        difficult_hit = horzcat(difficult_hit,hit);
                        difficult_false_alarm = horzcat(difficult_false_alarm,false_alarm);                        
                        difficult_RT = horzcat(difficult_RT,RT);
                    end
                end
        end
    end
end

numObs = size(easy_hit,2);

easy_h = easy_hit;
easy_fa = easy_false_alarm;

difficult_h = difficult_hit;
difficult_fa = difficult_false_alarm;   

easy_z_hit = norminv(easy_h,0,1);
easy_z_fa = norminv(easy_fa,0,1);

difficult_z_hit = norminv(difficult_h,0,1);
difficult_z_fa = norminv(difficult_fa,0,1);

easy_dprime = easy_z_hit - easy_z_fa;
difficult_dprime = difficult_z_hit - difficult_z_fa;

if divideRT
    for x = 1:size(easy_hit,1)
        for y = 1:size(easy_hit,2)
            easy_dprime(x,y) = easy_dprime(x,y)/easy_RT(x,y);
            difficult_dprime(x,y) = difficult_dprime(x,y)/difficult_RT(x,y);
        end
    end
end

s_easy_dprime = std(easy_dprime,[],2)/sqrt(numObs);
s_difficult_dprime = std(difficult_dprime,[],2)/sqrt(numObs);

%% Plot dprime
figure;hold on;

for i=1:numObs
    plot(4:4:8,easy_dprime(:,i),'-o','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',9)
end

errorbar(4:4:8,mean(easy_dprime,2),s_easy_dprime,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

legend_obs = cell(numObs,1);
for i=1:numObs
    legend_obs{i} = ['obs ' num2str(i)];
end
legend_obs{numObs+1} = 'average';    
l = legend(legend_obs);    
set(l,'FontSize',12);      

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')

if divideRT
    if type == 3
        inc = 11;
        ymax = 45;
    else
        inc = 4;
        ymax = 25;
    end    
    set(gca,'YTick', 1:inc:ymax,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([0 ymax]) 
else
    if type == 3
        ymax = 5;
    else
        ymax = 3;
    end
    set(gca,'YTick', 0:1:ymax,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([0 ymax])
end

xlabel('Set Size','FontSize',18,'Fontname','Ariel')
if divideRT
    ylabel('efficiency','FontSize',18,'Fontname','Ariel')
    title(['Feature Efficiency - ' typeName ' (n = ' num2str(numObs) ')'],'FontSize',18)
else
    ylabel('d prime','FontSize',18,'Fontname','Ariel')
    title(['Feature d prime - ' typeName ' (n = ' num2str(numObs) ')'],'FontSize',18)
end

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\easy\Feature_dprime_slope' num2str(type) saveFileName]);
print ('-djpeg', '-r500',namefig);

%% Plot dprime
figure;hold on;

for i=1:numObs
    plot(4:4:8,difficult_dprime(:,i),'-o','LineWidth',1,'MarkerFaceColor',[1 1 1],'MarkerSize',9)
end

errorbar(4:4:8,mean(difficult_dprime,2),s_difficult_dprime,'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

legend_obs = cell(numObs,1);
for i=1:numObs
    legend_obs{i} = ['obs ' num2str(i)];
end
legend_obs{numObs+1} = 'average';    
l = legend(legend_obs);    
set(l,'FontSize',12);      

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')

if divideRT
    if type == 3
        inc = 11;
        ymax = 45;
    else
        inc = 4;
        ymax = 25;
    end    
    set(gca,'YTick', 1:inc:ymax,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([0 ymax]) 
else
    if type == 3
        ymax = 5;
    else
        ymax = 3;
    end
    set(gca,'YTick', 0:1:ymax,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([0 ymax])
end

xlabel('Set Size','FontSize',18,'Fontname','Ariel')
if divideRT
    ylabel('efficiency','FontSize',18,'Fontname','Ariel')
    title(['Conjunction Efficiency - ' typeName ' (n = ' num2str(numObs) ')'],'FontSize',18)
else
    ylabel('d prime','FontSize',18,'Fontname','Ariel')
    title(['Conjunction d prime - ' typeName ' (n = ' num2str(numObs) ')'],'FontSize',18)
end

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\difficult\Conjunction_dprime_slope' num2str(type) saveFileName]);
print ('-djpeg', '-r500',namefig);
end

