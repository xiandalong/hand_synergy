%%%%%% Measuring the error term for joint angle differences between %%%%%%
%%%%%% grasping and mimicking hand %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. reading data
clear;clc
readDataFromAllSubjects;

%% 2. organize the data into sub-datasets: mimic-
n_samples = 10; % number of samples to use in each epoch
step_size = n_frames/n_samples;

for j = 1:size(Data_all,1)
    Data_all.joint_angle_LM_holding_mimic{j} = downsample((Data_all.joint_angles_LeftHand{j}(:,Data_all.leftMimic_start_frame(j):Data_all.leftMimic_start_frame(j)+frame_rate*duration-1))',step_size);
    Data_all.joint_angle_LM_holding_grasp{j}= downsample((Data_all.joint_angles_RightHand{j}(:,Data_all.leftMimic_start_frame(j):Data_all.leftMimic_start_frame(j)+frame_rate*duration-1))',step_size);
    Data_all.joint_angle_RM_holding_mimic{j} = downsample((Data_all.joint_angles_RightHand{j}(:,Data_all.rightMimic_start_frame(j):Data_all.rightMimic_start_frame(j)+frame_rate*duration-1))',step_size);
    Data_all.joint_angle_RM_holding_grasp{j}= downsample((Data_all.joint_angles_LeftHand{j}(:,Data_all.rightMimic_start_frame(j):Data_all.rightMimic_start_frame(j)+frame_rate*duration-1))',step_size);
end
% take the difference of mimicking hand shape and grasping hand shape for
% each case (sync/sync)

diff_sync = [];
diff_async = [];
% objectName = 'cone';
% objectName = 'cylinder';
% objectName = 'drum';
% objectName = 'mouse';
% objectName = 'papercup';
objectName = 'pen';

% if need to plot for all objects, comment out " &&
% strcmpi(Data_all.Object{j},objectName)" in each of the following "if"
% clause
for j = 1:size(Data_all,1)
    if Data_all.synchronized_asynchronized{j}=='Y' && strcmpi(Data_all.Object{j},objectName)
        diff_sync = [diff_sync; Data_all.joint_angle_LM_holding_mimic{j}-Data_all.joint_angle_LM_holding_grasp{j};Data_all.joint_angle_RM_holding_mimic{j}-Data_all.joint_angle_RM_holding_grasp{j}];
    elseif Data_all.synchronized_asynchronized{j}=='N'&& strcmpi(Data_all.Object{j},objectName)
        diff_async = [diff_async; Data_all.joint_angle_LM_holding_mimic{j}-Data_all.joint_angle_LM_holding_grasp{j};Data_all.joint_angle_RM_holding_mimic{j}-Data_all.joint_angle_RM_holding_grasp{j}];
    end
end

%% 3. calculate the sum of squared difference for each hand shape
% a. overall
Square_diff_sync = sqrt(sum(diff_sync.^2,2)/20);
Square_diff_async = sqrt(sum(diff_async.^2,2)/20);

figure;
subplot(1,2,1)
boxplot([Square_diff_sync,Square_diff_async],'notch','on','labels',{'Sync','Async'});
p1 = ranksum(Square_diff_sync,Square_diff_async);
p = anova1([Square_diff_sync,Square_diff_async]);
ylabel('sum of squared error (degree^2)');
% title(objectName);
% boxPlotPath = ['C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\mimic_all_figures\PCA_for_eachObj\',objectName,'_boxplot'];
% saveas(gcf,boxPlotPath,'fig');
% saveas(gcf,boxPlotPath,'jpg');

subplot(1,2,2)
hist([Square_diff_sync,Square_diff_async],30);
% hist([Square_diff_sync,randn(size(Square_diff_sync,1),1)],30);
h = findobj(gca,'Type','patch');
h1= h(1);h2 = h(2); % h1 is for async and h2 is for sync
h1.FaceColor = 'k'; % async is black
h2.FaceColor = [.5 .5 .5]; % sync is grey
legend({'sync','async'});
xlabel('MSE(degree)');
ylabel('Frequency');
suptitle(objectName);
set(gcf,'PaperPosition', [0 0 12 4])
savePath = ['C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\mimic_all_figures\PCA_for_eachObj\',objectName];
saveas(gcf,savePath,'fig');
saveas(gcf,savePath,'jpg');
% save('C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\Square_error.mat','Square_diff_sync','Square_diff_async','-v6');

% figure; % raw data point plot
% plot(zeros(length(Square_diff_sync),1),Square_diff_sync,'o');
% hold on
% plot(ones(length(Square_diff_async),1),Square_diff_async,'o');
% xlim([-1 2]);

% figure; % look at distribution
% bins = 0:0.1:5;
% hist(Square_diff_sync,50);
% ylim([0 1400]);

