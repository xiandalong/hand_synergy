%%%%%% Measuring the error term for joint angle differences between %%%%%%
%%%%%% grasping and mimicking hand %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. reading data
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

for j = 1:size(Data_all,1)
    if Data_all.synchronized_asynchronized{j}=='Y'
        diff_sync = [diff_sync; Data_all.joint_angle_LM_holding_mimic{j}-Data_all.joint_angle_LM_holding_grasp{j};Data_all.joint_angle_RM_holding_mimic{j}-Data_all.joint_angle_RM_holding_grasp{j}];
    elseif Data_all.synchronized_asynchronized{j}=='N'
        diff_async = [diff_async; Data_all.joint_angle_LM_holding_mimic{j}-Data_all.joint_angle_LM_holding_grasp{j};Data_all.joint_angle_RM_holding_mimic{j}-Data_all.joint_angle_RM_holding_grasp{j}];
    end
end

%% 3. calculate the sum of squared difference for each hand shape
% a. overall
Square_diff_sync = sqrt(sum(diff_sync.^2,2)/20);
Square_diff_async = sqrt(sum(diff_async.^2,2)/20);

figure;
boxplot([Square_diff_sync,Square_diff_async],'notch','on','labels',{'Sync','Async'});
ylabel('sum of squared error (degree^2)');

figure; % raw data point plot
plot(zeros(length(Square_diff_sync),1),Square_diff_sync,'o');
hold on
plot(ones(length(Square_diff_async),1),Square_diff_async,'o');
xlim([-1 2]);

figure; % look at distribution
bins = 0:0.1:5;
hist(Square_diff_sync,50);
ylim([0 1400]);

figure;
hist([Square_diff_sync,Square_diff_async],30);
h = findobj(gca,'Type','patch');
xlabel('MSE(degree)');
ylabel('Frequency');
% save('C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\Square_error.mat','Square_diff_sync','Square_diff_async','-v6');

% b. for each object
% define index range for each object

