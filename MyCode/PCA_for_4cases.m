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
% separate into grasp/mimic and sync/async
% a. grasp sync
grasp_sync = [];
mimic_sync = [];
grasp_async = [];
mimic_async = [];

for j = 1:size(Data_all,1)
    if Data_all.synchronized_asynchronized{j}=='Y'
        grasp_sync = [grasp_sync; Data_all.joint_angle_LM_holding_grasp{j};Data_all.joint_angle_RM_holding_grasp{j}];
        mimic_sync = [mimic_sync; Data_all.joint_angle_LM_holding_mimic{j};Data_all.joint_angle_RM_holding_mimic{j}];
    elseif Data_all.synchronized_asynchronized{j}=='N'
        grasp_async = [grasp_async; Data_all.joint_angle_LM_holding_grasp{j};Data_all.joint_angle_RM_holding_grasp{j}];
        mimic_async = [mimic_async; Data_all.joint_angle_LM_holding_mimic{j};Data_all.joint_angle_RM_holding_mimic{j}];
    end
end


%% 3. PCA on all four cases
%%%% 3.1. PCA on four cases separately
[coeff_grasp,score_grasp,latent_grasp,tsquared_grasp,explained_grasp,mu_grasp] = pca([grasp_sync;grasp_async]);
[coeff_grasp_sync,score_grasp_sync,latent_grasp_sync,tsquared_grasp_sync,explained_grasp_sync,mu_grasp_sync] = pca(grasp_sync);
[coeff_mimic_sync,score_mimic_sync,latent_mimic_sync,tsquared_mimic_sync,explained_mimic_sync,mu_mimic_sync] = pca(mimic_sync);
[coeff_grasp_async,score_grasp_async,latent_grasp_async,tsquared_grasp_async,explained_grasp_async,mu_grasp_async] = pca(grasp_async);
[coeff_mimic_async,score_mimic_async,latent_mimic_async,tsquared_mimic_async,explained_mimic_async,mu_mimic_async] = pca(mimic_async);
%%%% 3.2. PCA on difference of each case(sync/async), namely
%%%% "mimic_sync-grasp_sync" and "mimic_async-grasp_async"
% [coeff_diff_sync,score_diff_sync,latent_diff_sync,tsquared_diff_sync,explained_diff_sync,mu_diff_sync] = pca(mimic_sync-grasp_sync);
% [coeff_diff_async,score_diff_async,latent_diff_async,tsquared_diff_async,explained_diff_async,mu_diff_async] = pca(mimic_async-grasp_async);

%% 4. plotting cumsum for explained variances
% a. synchronous case
cumsum_explained_grasp_sync = cumsum(explained_grasp_sync);
cumsum_explained_mimic_sync = cumsum(explained_mimic_sync);
subplot(1,2,1)
plot(1:20,cumsum_explained_grasp_sync,'b');
hold on
plot(1:20,cumsum_explained_mimic_sync,'r');
legend('grasping hand','mimicking hand');
% b. asynchronous case
cumsum_explained_grasp_async = cumsum(explained_grasp_async);
cumsum_explained_mimic_async = cumsum(explained_mimic_async);
subplot(1,2,2)
plot(1:20,cumsum_explained_grasp_async,'b');
hold on
plot(1:20,cumsum_explained_mimic_async,'r');
legend('grasping hand','mimicking hand');

% c. all 4 cases
cumsum_explained_grasp = cumsum(explained_grasp);
figure
plot(1:20,cumsum_explained_grasp,'--b');
% plot(1:20,cumsum_explained_grasp_sync,'--b');
hold on
% plot(1:20,cumsum_explained_grasp_async,'b');
plot(1:20,cumsum_explained_mimic_sync,'--r');
plot(1:20,cumsum_explained_mimic_async,'r');
legend('grasping sync','grasping async','mimicking sync','mimicking async');
xlim([1 10]);
xlabel('Number of Principle Component');
ylabel('Cumulative Explained Variance(%)');

% try plotting Area under the curve (AUC)
grasp_AUC = trapz(1:20,cumsum_explained_grasp );
mimic_sync_AUC = trapz(1:20,cumsum_explained_mimic_sync );
mimic_async_AUC = trapz(1:20,cumsum_explained_mimic_async );
figure;
bar([grasp_AUC,mimic_async_AUC,mimic_sync_AUC]);
set(gca,'XTickLabel',{'Grasp','Mimic Async','Mimic Sync'});
ylim([1400,1800])
ylabel('Area Under Curve')


%% 5. plot the difference of EV
EVdiff_sync = cumsum_explained_mimic_sync - cumsum_explained_grasp_sync;
EVdiff_async = cumsum_explained_mimic_async - cumsum_explained_grasp_async;
figure
plot(1:20,EVdiff_sync,'--g');
hold on
plot(1:20,EVdiff_async,'g');
legend('EV diff sync','EV diff async');
xlabel('Number of Principle Component');
ylabel('Cumulative Explained Variance(%)');
xlim([1 10]);

% %% 6. plotting PCA EV for difference of hand shape for sync/async case
% cumsum_explained_diff_sync = cumsum(explained_diff_sync);
% cumsum_explained_diff_async = cumsum(explained_diff_async);
% plot(1:20,cumsum_explained_diff_sync,'r');
% hold on
% plot(1:20,cumsum_explained_diff_async,'y');
% legend('diff sync','diff async');
% xlabel('# of PC');
% ylabel('Percentage of EV(%)');
% xlim([1 20]);