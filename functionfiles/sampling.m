function [p1,p2] = sampling(obs,pb,pn,task,targetpresent,n)

% if obs is 'all', then the no obs name will appear in the title of the
% figure
% targetpresent is a boolean

% figure is not saved

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

pb_logical = ~isnan(pb);
pb_indices = double(pb_logical);

trialN = zeros(13,1);

for i=1:size(pb_indices,1)
    trialN(i,1) = sum(pb_indices(i,:)); 
end

minTrials = min(trialN);

pb_sample = zeros(13,minTrials);
pn_sample = zeros(13,minTrials);

pb_mean = zeros(13,n);
pn_mean = zeros(13,n);

i=1;
while i<=n
    for j=1:size(pb_sample,1)
        r = randi(size(pb,2));
        for l=1:minTrials
            while isnan(pb(j,r)) 
                r = randi(minTrials);
            end
            pb_sample(j,l) = pb(j,r);
            pn_sample(j,l) = pn(j,r);
            r = randi(size(pb,2));           
        end
    end
    pb_mean(:,i) = mean(pb_sample,2);
    pn_mean(:,i) = mean(pn_sample,2);
    i = i + 1;    
end

% pb_mean = mean(pb_mean,2);
% pn_mean = mean(pn_mean,2);

[p1,p2] = quadratic_analysis(pb_mean,pn_mean);

p1 = mean(p1,2);
p2 = mean(p2,2);

figure;hold on;
plot(100:30:460,p1,'ro-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.96 .37 .15])
plot(100:30:460,p2,'go-','LineWidth',3,'MarkerFaceColor',[1 1 1],'MarkerSize',12,'Color',[.13 .7 .15])

legend('p1','p2','Location','SouthEast')

set(gca,'YTick',0:.2:1,'FontSize',18,'LineWidth',2','Fontname','Ariel')
set(gca,'XTick',0:100:500,'FontSize',18,'LineWidth',2','Fontname','Ariel')

ylabel('Probe report probabilities','FontSize',18,'Fontname','Ariel')
xlabel('Time from discrimination task onset [ms]','FontSize',18,'Fontname','Ariel')
ylim([0 1])
xlim([0 500])

if strcmp(obs,'all')
    if targetpresent
        title([condition ' Search-Target Probed-' num2str(minTrials) ' Trials/Delay'],'FontSize',16,'Fontname','Ariel')
    else
        title([condition ' Search-Target Not Probed-' num2str(minTrials) ' Trials/Delay'],'FontSize',16,'Fontname','Ariel')
    end
else
    if targetpresent
        title([condition ' Search-Target Probed-' num2str(minTrials) ' Trials/Delay (' obs ')'],'FontSize',16,'Fontname','Ariel')
    else
        title([condition ' Search-Target Not Probed-' num2str(minTrials) ' Trials/Delay (' obs ')'],'FontSize',16,'Fontname','Ariel')
    end    
end

end