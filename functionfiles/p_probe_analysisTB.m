function [p1AND,p2AND,p1OR,p2OR,p1TOP,p2TOP,p1BOTTOM,p2BOTTOM]=p_probe_analysisTB(obs, task, printFg)
%% Example
%%% p_probe_analysisTB('ax','difficult',false);

%% Parameters
% obs = 'ax';
% task = 'difficult'
% multipleObs = true;

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

%% Obtain pboth, pone and pnone for each run and concatenate over run
pbAND=[];
pnAND=[];

pbOR=[];
pnOR=[];

pbTOP=[];
pnTOP=[];

pbBOTTOM=[];
pnBOTTOM=[];

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task]);  
for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [b,o,n,bp,op,np] = probe_analysis(obs,task,filename); 
        pbAND = horzcat(pbAND,bp(:,:,1),bp(:,:,2),bp(:,:,5),bp(:,:,6),bp(:,:,12));
        pnAND = horzcat(pnAND,np(:,:,1),np(:,:,2),np(:,:,5),np(:,:,6),np(:,:,12));

        pbOR = horzcat(pbOR,bp(:,:,3),bp(:,:,4),bp(:,:,8),bp(:,:,9),bp(:,:,10),bp(:,:,11));
        pnOR = horzcat(pnOR,np(:,:,3),np(:,:,4),np(:,:,8),np(:,:,9),np(:,:,10),np(:,:,11));
        
        pbTOP = horzcat(pbTOP,bp(:,:,3),bp(:,:,9),bp(:,:,11));
        pnTOP = horzcat(pnTOP,np(:,:,3),np(:,:,9),np(:,:,11));
        
        pbBOTTOM = horzcat(pbBOTTOM,bp(:,:,4),bp(:,:,8),bp(:,:,10));
        pnBOTTOM = horzcat(pnBOTTOM,np(:,:,4),np(:,:,8),np(:,:,10));
        
    end
end
        
pbANDm = mean(pbAND,2);
pnANDm = mean(pnAND,2);
pbORm = mean(pbOR,2);
pnORm = mean(pnOR,2);
pbTOPm = mean(pbTOP,2);
pnTOPm = mean(pnTOP,2);
pbBOTTOMm = mean(pbBOTTOM,2);
pnBOTTOMm = mean(pnBOTTOM,2);

[p1AND,p2AND] = quadratic_analysis(pbANDm,pnANDm);  
[p1OR,p2OR] = quadratic_analysis(pbORm,pnORm);
[p1TOP,p2TOP] = quadratic_analysis(pbTOPm,pnTOPm);
[p1BOTTOM,p2BOTTOM] = quadratic_analysis(pbBOTTOMm,pnBOTTOMm);

if printFg
    %% Graph TOP AND BOTTOM, TOP OR BOTTOM
    figure; hold on;
    for i = 1:2
        if i == 1
            p1 = p1AND;
            p2 = p2AND;
        elseif i == 2
            p1 = p1OR;
            p2 = p2OR;
        end
        subplot(1,2,i)
        hold on;
        plot(100:30:460,p1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(100:30:460,p2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])
        
        if i == 1 
            title([condition ' - Top and Bottom (' obs ')'],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title([condition ' - Top and Bottom (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2TB1']);
    print ('-djpeg', '-r500',namefig);
    %% Graph TOP and BOTTOM separately
    figure; hold on;
    for i = 1:2
        if i == 1
            p1 = p1TOP;
            p2 = p2TOP;
        elseif i == 2
            p1 = p1BOTTOM;
            p2 = p2BOTTOM;
        end
        subplot(1,2,i)
        hold on;
        plot(100:30:460,p1,'ro-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.96 .37 .15])
        plot(100:30:460,p2,'go-','LineWidth',2,'MarkerFaceColor',[1 1 1],'MarkerSize',8,'Color',[.13 .7 .15])   

        legend('p1','p2','Location','SouthEast')

        set(gca,'YTick',0:.2:1,'FontSize',12,'LineWidth',2','Fontname','Ariel')
        set(gca,'XTick',0:200:600,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])
        
        if i == 1 
            title([condition ' - Top (' obs ')'],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title([condition ' - Bottom (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2TB1']);
    print ('-djpeg', '-r500',namefig);    
end
end

        
        
        
        
        
        