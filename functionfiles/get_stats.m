function get_stats()
%% Do ANOVA to compare condition, p1 & p2, delay, configuration


%% Get data
[~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,easy_config] = overall_probe_analysis('easy',2,2,false,false,false,false,false,false,1,true,0.1,0.3,{});
[~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,~,difficult_config] = overall_probe_analysis('difficult',2,2,false,false,false,false,false,false,1,true,0.1,0.3,{});

% order for task_config: squareP1, squareP2, diamondP1, diamondP2 

y = vertcat(easy_config,difficult_config);
n = size(y,1);
% g1: condition
g1 = cell(n,1);
% g2: p1 & p2
p1 = cell(13,1);
p2 = cell(13,1);
% g3: delay
% g4: configuration
g4 = cell(n,1);

for i = 1:size(easy_config,1)*2
    if i <= size(easy_config,1)
        g1{i} = 'feature';
        if i <= size(easy_config,1) * 0.5
            g4{i} = 'square';
        else
            g4{i} = 'diamond';
        end
    else
        g1{i} = 'conjunction';
        if i <= size(easy_config,1) * 2 * 0.75
            g4{i} = 'square';
        else
            g4{i} = 'diamond';
        end        
    end
end

for i = 1:13
    p1{i} = 'p1';
    p2{i} = 'p2';
end

g2 = [p1; p2; p1; p2; p1; p2; p1; p2]; 
    
g3 = rot90([1:13, 1:13, 1:13, 1:13, 1:13, 1:13, 1:13, 1:13],-1);

[p,t,stats,terms] = anovan(y,{g1 g2 g3 g4},'model','interaction','varnames',{'condition','p1 & p2','delay','configuration'});
p
t
stats
terms

