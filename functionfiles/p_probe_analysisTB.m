function [p1ANDtb,p2ANDtb,p1ORtb,p2ORtb,p1TOP,p2TOP,p1BOTTOM,p2BOTTOM,p1ANDlr,p2ANDlr,p1ORlr,p2ORlr,p1LEFT,p2LEFT,p1RIGHT,p2RIGHT]=p_probe_analysisTB(obs,task,expN,present,difference,printFg)
%% Example
%%% p_probe_analysisTB('ax','difficult',2,1,false,false);

%% Parameters
% obs = 'ax'; (observer's initials)
% task = 'difficult'; ('easy' or 'difficult')
% expN = 1; (1 or 2)
% present = 1; (only relevant for expN == 2; 1:target-present trials,
% 2:target-absent trials, 3:all trials)
% difference = false; (if true, plots difference of p1 and p2)
% printFg = true; (if true, prints and saves figures)

%% Outputs
% p1ANDtb and p2ANDtb are 13x1 matrices for p1 and p2 when the probes are
% on the top AND the bottom
% p1ORtb and p2ORtb are 13x1 matrices for p1 and p2 when the probes are
% on the top OR the bottom
% p1TOP and p2TOP are 13x1 matrices for p1 and p2 when both probes are on
% top
% p1BOTTOM and p2BOTTOM are 13x1 matrices for p1 and p2 when both probes
% are on the bottom
% the remaining outputs are similar but for left and right

%% Change task filename to feature/conjunction
if strcmp(task,'difficult')
    condition = 'Conjunction';
else 
    condition = 'Feature';
end

if expN == 1
    saveFileLoc = ['\main_' task '\figures\' obs '_' condition];
    saveFileName = '';
elseif expN == 2
    saveFileLoc = ['\target present or absent\main_' task '\figures\' obs '_' condition];
    if present == 1
        saveFileName = '_2TP';
    elseif present == 2
        saveFileName = '_2TA';
    elseif present == 3
        saveFileName = '_2';
    end
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

if expN == 1
    files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\main_', task]);  
elseif expN == 2
    files = dir(['C:\Users\Alice\Documents\MATLAB\data\', obs, '\target present or absent\main_', task]);  
end

for i = 1:size(files,1)
    filename = files(i).name;
    fileL = size(filename,2);
    if fileL == 17 && strcmp(filename(fileL-4+1:fileL),'.mat') && isa(str2double(filename(1:6)),'double')
        [b,o,n,bp,op,np] = probe_analysis(obs,task,filename,expN,present); 
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
        
pbANDtbm = nanmean(pbANDtb,2);
pnANDtbm = nanmean(pnANDtb,2);
pbORtbm = nanmean(pbORtb,2);
pnORtbm = nanmean(pnORtb,2);
pbTOPm = nanmean(pbTOP,2);
pnTOPm = nanmean(pnTOP,2);
pbBOTTOMm = nanmean(pbBOTTOM,2);
pnBOTTOMm = nanmean(pnBOTTOM,2);

pbANDlrm = nanmean(pbANDlr,2);
pnANDlrm = nanmean(pnANDlr,2);
pbORlrm = nanmean(pbORlr,2);
pnORlrm = nanmean(pnORlr,2);
pbLEFTm = nanmean(pbLEFT,2);
pnLEFTm = nanmean(pnLEFT,2);
pbRIGHTm = nanmean(pbRIGHT,2);
pnRIGHTm = nanmean(pnRIGHT,2);

[p1ANDtb,p2ANDtb] = quadratic_analysis(pbANDtbm,pnANDtbm);  
[p1ORtb,p2ORtb] = quadratic_analysis(pbORtbm,pnORtbm);
[p1TOP,p2TOP] = quadratic_analysis(pbTOPm,pnTOPm);
[p1BOTTOM,p2BOTTOM] = quadratic_analysis(pbBOTTOMm,pnBOTTOMm);

[p1ANDlr,p2ANDlr] = quadratic_analysis(pbANDlrm,pnANDlrm);  
[p1ORlr,p2ORlr] = quadratic_analysis(pbORlrm,pnORlrm);
[p1LEFT,p2LEFT] = quadratic_analysis(pbLEFTm,pnLEFTm);
[p1RIGHT,p2RIGHT] = quadratic_analysis(pbRIGHTm,pnRIGHTm);

if printFg && ~isempty(pbANDtb) && ~difference
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
        set(gca,'XTick',0:200:500,'FontSize',16,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])
        
        if i == 1 
            title([condition ' - Top and Bottom' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('Probe Report Probabilities','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Top or Bottom' saveFileName '(' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs saveFileLoc '_p1p2TB1' saveFileName]);
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
        set(gca,'XTick',0:200:500,'FontSize',16,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])
        
        if i == 1 
            title([condition ' - Top' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('Probe Report Probabilities','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Bottom' saveFileName '(' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs saveFileLoc '_p1p2TB2' saveFileName]);
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
        set(gca,'XTick',0:200:500,'FontSize',16,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])
        
        if i == 1 
            title([condition ' - Left and Right' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('Probe Report Probabilities','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Left or Right' saveFileName '(' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs saveFileLoc '_p1p2LR1' saveFileName]);
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
        set(gca,'XTick',0:200:500,'FontSize',16,'LineWidth',2','Fontname','Ariel')

        ylim([0 1])
        xlim([0 500])
        
        if i == 1 
            title([condition ' - Left' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('Probe Report Probabilities','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Right' saveFileName '(' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs saveFileLoc '_p1p2LR2' saveFileName]);
    print ('-djpeg', '-r500',namefig);       
end

if printFg && difference
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
        plot(100:30:460,p1-p2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-1:.5:1,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:500,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([-1 1])
        xlim([0 500])
        
        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        if i == 1 
            title([condition ' - Top and Bottom' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Top or Bottom' saveFileName '(' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs saveFileLoc '_p1p2TB1diff' saveFileName]);
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
        plot(100:30:460,p1-p2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])
              
        set(gca,'YTick',-1:.5:1,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:500,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([-1 1])
        xlim([0 500])
        
        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        if i == 1 
            title([condition ' - Top' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Bottom' saveFileName '(' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs saveFileLoc '_p1p2TB2diff' saveFileName]);
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
        plot(100:30:460,p1-p2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])
      
        set(gca,'YTick',-1:.5:1,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:500,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([-1 1])
        xlim([0 500])
        
        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        if i == 1 
            title([condition ' - Left and Right' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Left or Right' saveFileName '(' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs saveFileLoc '_p1p2LR1diff' saveFileName]);
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
        plot(100:30:460,p1-p2,'ro-','LineWidth',1.5,'MarkerFaceColor',[1 1 1],'MarkerSize',6,'Color',[0 0 0])

        set(gca,'YTick',-1:.5:1,'FontSize',12,'LineWidth',2,'Fontname','Ariel')
        set(gca,'XTick',0:200:500,'FontSize',12,'LineWidth',2','Fontname','Ariel')

        ylim([-1 1])
        xlim([0 500])
        
        plot([0 500],[0 0],'Color',[0 0 0],'LineStyle','--')
        
        if i == 1 
            title([condition ' - Left' saveFileName],'FontSize',14,'Fontname','Ariel')
            ylabel('P1 - P2','FontSize',16,'Fontname','Ariel') 
            xlabel('Time from search array onset [ms]','FontSize',16,'Fontname','Ariel')
        elseif i == 2
            title(['Right' saveFileName '(' obs ')'],'FontSize',14,'Fontname','Ariel')
        end 
    end
    namefig=sprintf('%s', ['C:\Users\Alice\Documents\MATLAB\data\' obs saveFileLoc '_p1p2LR2diff' saveFileName]);
    print ('-djpeg', '-r500',namefig);       
end

end

        
        
        
        
        
        