function [p1ANDtb,p2ANDtb,p1ORtb,p2ORtb,p1TOP,p2TOP,p1BOTTOM,p2BOTTOM,p1ANDlr,p2ANDlr,p1ORlr,p2ORlr,p1LEFT,p2LEFT,p1RIGHT,p2RIGHT]=p_probe_analysisTB(obs, task, printFg)
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
pbANDtb=[];
pnANDtb=[];

pbORtb=[];
pnORtb=[];

pbTOP=[];
pnTOP=[];

pbBOTTOM=[];
pnBOTTOM=[];

pbANDlr=[];
pnANDlr=[];

pbORlr=[];
pnORlr=[];

pbLEFT=[];
pnLEFT=[];

pbRIGHT=[];
pnRIGHT=[];

files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task]);  
for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [b,o,n,bp,op,np] = probe_analysis(obs,task,filename); 
        pbANDtb = horzcat(pbANDtb,bp(:,:,1),bp(:,:,2),bp(:,:,5),bp(:,:,6),bp(:,:,12));
        pnANDtb = horzcat(pnANDtb,np(:,:,1),np(:,:,2),np(:,:,5),np(:,:,6),np(:,:,12));

        pbORtb = horzcat(pbORtb,bp(:,:,3),bp(:,:,4),bp(:,:,8),bp(:,:,9),bp(:,:,10),bp(:,:,11));
        pnORtb = horzcat(pnORtb,np(:,:,3),np(:,:,4),np(:,:,8),np(:,:,9),np(:,:,10),np(:,:,11));
        
        pbTOP = horzcat(pbTOP,bp(:,:,3),bp(:,:,9),bp(:,:,11));
        pnTOP = horzcat(pnTOP,np(:,:,3),np(:,:,9),np(:,:,11));
        
        pbBOTTOM = horzcat(pbBOTTOM,bp(:,:,4),bp(:,:,8),bp(:,:,10));
        pnBOTTOM = horzcat(pnBOTTOM,np(:,:,4),np(:,:,8),np(:,:,10));
        
        pbANDlr = horzcat(pbANDlr,bp(:,:,2),bp(:,:,3),bp(:,:,4),bp(:,:,5),bp(:,:,7));
        pnANDlr = horzcat(pnANDlr,np(:,:,2),np(:,:,3),np(:,:,4),np(:,:,5),np(:,:,7));

        pbORlr = horzcat(pbORlr,bp(:,:,1),bp(:,:,6),bp(:,:,8),bp(:,:,9),bp(:,:,10),bp(:,:,11));
        pnORlr = horzcat(pnORlr,np(:,:,1),np(:,:,6),np(:,:,8),np(:,:,9),np(:,:,10),np(:,:,11));
        
        pbLEFT = horzcat(pbLEFT,bp(:,:,6),bp(:,:,10),bp(:,:,11));
        pnLEFT = horzcat(pnLEFT,np(:,:,6),np(:,:,10),np(:,:,11));
        
        pbRIGHT = horzcat(pbRIGHT,bp(:,:,1),bp(:,:,8),bp(:,:,9));
        pnRIGHT = horzcat(pnRIGHT,np(:,:,1),np(:,:,8),np(:,:,9));        
        
    end
end
        
pbANDtbm = mean(pbANDtb,2);
pnANDtbm = mean(pnANDtb,2);
pbORtbm = mean(pbORtb,2);
pnORtbm = mean(pnORtb,2);
pbTOPm = mean(pbTOP,2);
pnTOPm = mean(pnTOP,2);
pbBOTTOMm = mean(pbBOTTOM,2);
pnBOTTOMm = mean(pnBOTTOM,2);

pbANDlrm = mean(pbANDlr,2);
pnANDlrm = mean(pnANDlr,2);
pbORlrm = mean(pbORlr,2);
pnORlrm = mean(pnORlr,2);
pbLEFTm = mean(pbLEFT,2);
pnLEFTm = mean(pnLEFT,2);
pbRIGHTm = mean(pbRIGHT,2);
pnRIGHTm = mean(pnRIGHT,2);

[p1ANDtb,p2ANDtb] = quadratic_analysis(pbANDtbm,pnANDtbm);  
[p1ORtb,p2ORtb] = quadratic_analysis(pbORtbm,pnORtbm);
[p1TOP,p2TOP] = quadratic_analysis(pbTOPm,pnTOPm);
[p1BOTTOM,p2BOTTOM] = quadratic_analysis(pbBOTTOMm,pnBOTTOMm);

[p1ANDlr,p2ANDlr] = quadratic_analysis(pbANDlrm,pnANDlrm);  
[p1ORlr,p2ORlr] = quadratic_analysis(pbORlrm,pnORlrm);
[p1LEFT,p2LEFT] = quadratic_analysis(pbLEFTm,pnLEFTm);
[p1RIGHT,p2RIGHT] = quadratic_analysis(pbRIGHTm,pnRIGHTm);

if printFg
    %% Graph TOP AND BOTTOM, TOP OR BOTTOM
    figure; hold on;
    for i = 1:2
        if i == 1
            p1 = p1ANDtb;
            p2 = p2ANDtb;
        elseif i == 2
            p1 = p1ORtb;
            p2 = p2ORtb;
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
            title([condition ' - Top or Bottom (' obs ')'],'FontSize',14,'Fontname','Ariel')
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
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2TB2']);
    print ('-djpeg', '-r500',namefig);    
    
    %% Graph LEFT AND RIGHT, LEFT OR RIGHT
    figure; hold on;
    for i = 1:2
        if i == 1
            p1 = p1ANDlr;
            p2 = p2ANDlr;
        elseif i == 2
            p1 = p1ORlr;
            p2 = p2ORlr;
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
            title([condition ' - Left and Right (' obs ')'],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title([condition ' - Left or Right (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2LR1']);
    print ('-djpeg', '-r500',namefig);
    %% Graph TOP and BOTTOM separately
    figure; hold on;
    for i = 1:2
        if i == 1
            p1 = p1LEFT;
            p2 = p2LEFT;
        elseif i == 2
            p1 = p1RIGHT;
            p2 = p2RIGHT;
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
            title([condition ' - Left (' obs ')'],'FontSize',14,'Fontname','Ariel')
            ylabel('Percent correct','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title([condition ' - Right (' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs '\main_' task '\figures\' obs '_' condition '_p1p2LR2']);
    print ('-djpeg', '-r500',namefig);       
end
end

        
        
        
        
        
        