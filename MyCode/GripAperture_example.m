% Should use the reading script in "Batch_readData_Mimic_holding.m" to
% generate the variable "Data_table"

% plotting the averaged joint angles for each condition in reaching phase
subj = 'Subject4';
mimicHand = 'right';
if strcmp(mimicHand,'left')
    data_path = ['C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\Data_',subj,'.mat'];
elseif strcmp(mimicHand,'right')
    data_path = ['C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\Data_',subj,'.mat'];
else error('Mimicking hand should be either left or right');
end
load(data_path); % load "Data_table" from saved mat file


num_trials = size(Data_table,1);
hand_DOF = 20; % using 20-DOF hand model

% 1. editing grouping variables
for j = 1:num_trials
    if regexp(Data_table.synchronized_asynchronized{j},'Y')
        Data_table.Object{j} = strcat(Data_table.Object{j},' sync');
    elseif regexp(Data_table.synchronized_asynchronized{j},'N')
        Data_table.Object{j} = strcat(Data_table.Object{j},' async');
    else error('Need to specify if it it synchronized movement or asynchronized by using ''Y'' and ''N''.');
    end
end
% 2. get Reaching GA,  get MGA and plot MGA
GA_LeftHand_all = cell(num_trials,1);
GA_RightHand_all = cell(num_trials,1);
MGA_Left = zeros(num_trials,1);
MGA_Right = zeros(num_trials,1);
for j=1:num_trials
    % select which hand is the micmicing hand, to decide the time span of
    % it's holding phase
    if regexp(mimicHand,'left')
        GA_LeftHand_all{j,1} = Data_table.GA_LeftHand{j}(:,Data_table.LM_leftReaching_start(j):Data_table.LM_leftReaching_end(j));
        MGA_Left(j)=  max(GA_LeftHand_all{j}); % Left Hand
        GA_RightHand_all{j,1} = Data_table.GA_RightHand{j}(:,Data_table.LM_rightReaching_start(j):Data_table.LM_rightReaching_end(j));
        MGA_Right(j)=  max(GA_RightHand_all{j}); % Right Hand
    elseif regexp(mimicHand,'right')
        GA_LeftHand_all{j,1} = Data_table.GA_LeftHand{j}(:,Data_table.RM_leftReaching_start(j):Data_table.RM_leftReaching_end(j));
        MGA_Left(j,:)=  max(GA_LeftHand_all{j,1}); % Left Hand
        GA_RightHand_all{j,1} = Data_table.GA_RightHand{j}(:,Data_table.RM_rightReaching_start(j):Data_table.RM_rightReaching_end(j));
        MGA_Right(j,:)=  max(GA_RightHand_all{j,1}); % Right Hand
    else error('Mimic Hand is not specified correctly, has to be either ''left'' or ''right''.');
    end
end

Grouping = Data_table.Object;

% making boxplot to show the MGA for each object&synchronicity
figure;
subplot(2,1,1);
boxplot(MGA_Left,Grouping);
ylabel('distance');
ylim([0.1 0.6]);
title(['Left Hand for ',mimicHand,' mimicking']);

subplot(2,1,2);
boxplot(MGA_Right,Grouping);
ylim([0.1 0.6]);
title(['Right Hand for ',mimicHand,' mimicking']);
suptitle([subj,' Maximum Grip Aperture']);

% 3. normalize the time spans across all trials for GA, then plot them in a
% 3X2 subplots

% Trick: just need to create normalized time span for each trial and use it as
% x-axis during plotting, use red for left and blue for right hand

%%% 1. cone async %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y_range = [0,0.5];


f2 = figure;


subplot(4,3,1);
hold on
for j=1:5
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

%%% 2. cone sync %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,4);
hold on
for j=6:10
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});
ylabel('distance');

%%% 3. cylinder async %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,2);
hold on
for j=11:15
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

%%% 4. cylinder sync %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,5);
hold on
for j=16:20
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

%%% 5.drum async %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,3);
hold on
for j=21:25
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});
legend('Left Hand','Right Hand');

%%% 6.drum sync %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,6);
hold on
for j=26:30
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

%%% 7.mouse async %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,7);
hold on
for j=31:35
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

%%% 8.mouse sync %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,10);
hold on
for j=36:40
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

%%% 9.papercup async %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,8);
hold on
for j=41:45
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

%%% 10.papercup sync %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,11);
hold on
for j=46:50
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});
xlabel('normalized time');

%%% 11.pen async %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,9);
hold on
for j=51:55
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

%%% 12.pen sync %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(4,3,12);
hold on
for j=56:60
    t1 = 1/length(GA_LeftHand_all{j}):1/length(GA_LeftHand_all{j}):1;
    plot(t1,GA_LeftHand_all{j},'color',[1,0.8,0.8]);
    t2 = 1/length(GA_RightHand_all{j}):1/length(GA_RightHand_all{j}):1;
    plot(t2,GA_RightHand_all{j},'color',[0.8,0.8,1]);
end
ylim(y_range);
title(Data_table.Object{j});

suptitle([subj,' Grip Aperture During Reaching Phase for ',mimicHand,' mimicking']);
