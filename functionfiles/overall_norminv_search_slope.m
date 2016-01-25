function [easy_dprime,difficult_dprime] = overall_norminv_search_slope(type,divideRT)
%% Example
%%% overall_norminv_search_slope(1,false);

if type == 1
    typeName = 'Detection';
elseif type == 2
    typeName = 'Discrimination';
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
easy_false_alarmRT = [];

difficult_RT = [];
difficult_false_alarmRT = [];

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

s_easy_dprime = std(easy_dprime,[],2)/sqrt(numObs);
s_difficult_dprime = std(difficult_dprime,[],2)/sqrt(numObs);

if divideRT
    for x = 1:size(easy_hit,1)
        for y = 1:size(easy_hit,2)
            easy_dprime(x,y) = easy_dprime(x,y)/easy_RT(x,y);
            difficult_dprime(x,y) = difficult_dprime(x,y)/difficult_RT(x,y);
        end
    end
end

%% Plot dprime
figure;hold on;

for i=1:numObs
    plot(4:4:8,easy_dprime(:,i),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9)
end

% errorbar(4:4:8,mean(easy_dprime,2)(:,i),mean(s_easy_dprime,2)(:,i),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

legend_obs = cell(numObs,1);
for i=1:numObs
    legend_obs{i} = ['obs ' num2str(i)];
end
% legend_obs{numObs+1} = 'average';    
l = legend(legend_obs);    
set(l,'FontSize',12);      

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')

if divideRT
    set(gca,'YTick', 1:4:25,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([0 25])
else
    set(gca,'YTick', 1:1:3,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([0 3])
end

title(['Feature d prime - ' typeName ' (n = ' num2str(numObs) ')'],'FontSize',18)
xlabel('Set Size','FontSize',18,'Fontname','Ariel')
if divideRT
    ylabel('efficiency','FontSize',18,'Fontname','Ariel')
else
    ylabel('d prime','FontSize',18,'Fontname','Ariel')
end

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\easy\Feature_dprime_slope' num2str(type) saveFileName]);
print ('-djpeg', '-r500',namefig);

%% Plot dprime
figure;hold on;

for i=1:numObs
    plot(4:4:8,difficult_dprime(:,i),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',9)
end

% errorbar(4:4:8,mean(difficult_dprime,2)(:,i),mean(s_difficult_dprime,2)(:,i),'-o','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',10,'Color',[0 0 0])

legend_obs = cell(numObs,1);
for i=1:numObs
    legend_obs{i} = ['obs ' num2str(i)];
end
% legend_obs{numObs+1} = 'average';    
l = legend(legend_obs);    
set(l,'FontSize',12);      

xlim([3 9])
set(gca,'XTick', 4:4:8,'FontSize',18,'LineWidth',2,'Fontname','Ariel')

if divideRT
    set(gca,'YTick', 1:4:25,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([0 25])    
else
    set(gca,'YTick', 1:1:3,'FontSize',18,'LineWidth',2,'Fontname','Ariel')
    ylim([0 3])
end

title(['Conjunction d prime - ' typeName ' (n = ' num2str(numObs) ')'],'FontSize',18)
xlabel('Set Size','FontSize',18,'Fontname','Ariel')
if divideRT
    ylabel('efficiency','FontSize',18,'Fontname','Ariel')
else
    ylabel('d prime','FontSize',18,'Fontname','Ariel')
end

namefig=sprintf('%s', ['C:\Users\alice_000\Documents\MATLAB\data\figures' saveFileLoc '\difficult\Conjunction_dprime_slope' num2str(type) saveFileName]);
print ('-djpeg', '-r500',namefig);
end

