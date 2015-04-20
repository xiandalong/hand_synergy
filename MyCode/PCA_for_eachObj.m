%% 1. reading data
readDataFromAllSubjects;

%% 2. organize the data into sub-datasets: mimic-async, mimic-sync and grasp FOR EACH OBJECT
n_samples = 10; % number of samples to use in each epoch
step_size = n_frames/n_samples;
% objectName = 'cone';
% objectName = 'cylinder';
% objectName = 'drum';
% objectName = 'mouse';
% objectName = 'papercup';
objectName = 'pen';

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
    if Data_all.synchronized_asynchronized{j}=='Y' && strcmpi(Data_all.Object{j},objectName)
        grasp_sync = [grasp_sync; Data_all.joint_angle_LM_holding_grasp{j};Data_all.joint_angle_RM_holding_grasp{j}];
        mimic_sync = [mimic_sync; Data_all.joint_angle_LM_holding_mimic{j};Data_all.joint_angle_RM_holding_mimic{j}];
    elseif Data_all.synchronized_asynchronized{j}=='N'&& strcmpi(Data_all.Object{j},objectName)
        grasp_async = [grasp_async; Data_all.joint_angle_LM_holding_grasp{j};Data_all.joint_angle_RM_holding_grasp{j}];
        mimic_async = [mimic_async; Data_all.joint_angle_LM_holding_mimic{j};Data_all.joint_angle_RM_holding_mimic{j}];
    end
end

%% 3. PCA on all four cases
%%%% 3.1. PCA on four cases separately
[coeff_grasp,score_grasp,latent_grasp,tsquared_grasp,explained_grasp,mu_grasp] = pca([grasp_sync;grasp_async]);
% [coeff_grasp_sync,score_grasp_sync,latent_grasp_sync,tsquared_grasp_sync,explained_grasp_sync,mu_grasp_sync] = pca(grasp_sync);
[coeff_mimic_sync,score_mimic_sync,latent_mimic_sync,tsquared_mimic_sync,explained_mimic_sync,mu_mimic_sync] = pca(mimic_sync);
% [coeff_grasp_async,score_grasp_async,latent_grasp_async,tsquared_grasp_async,explained_grasp_async,mu_grasp_async] = pca(grasp_async);
[coeff_mimic_async,score_mimic_async,latent_mimic_async,tsquared_mimic_async,explained_mimic_async,mu_mimic_async] = pca(mimic_async);

%% 4. plotting cumsum for explained variances
cumsum_explained_grasp = cumsum(explained_grasp);
cumsum_explained_mimic_sync = cumsum(explained_mimic_sync);
cumsum_explained_mimic_async = cumsum(explained_mimic_async);

figure
subplot(1,2,1)
plot(1:20,cumsum_explained_grasp,'b');
hold on
plot(1:20,cumsum_explained_mimic_sync,'--r');
plot(1:20,cumsum_explained_mimic_async,'--g');
legend('grasping','mimicking sync','mimicking async');
xlim([1 10]);
xlabel('Number of Principle Component');
ylabel('Cumulative Explained Variance(%)');



% try plotting Area under the curve (AUC)
grasp_AUC = trapz(1:20,cumsum_explained_grasp );
mimic_sync_AUC = trapz(1:20,cumsum_explained_mimic_sync );
mimic_async_AUC = trapz(1:20,cumsum_explained_mimic_async );
subplot(1,2,2)
bar([grasp_AUC,mimic_async_AUC,mimic_sync_AUC],'k');
set(gca,'XTickLabel',{'Grasp','Mimic Async','Mimic Sync'});
ylim([1700,1850])
ylabel('Area Under Curve')
suptitle(objectName);
set(gcf,'PaperPosition', [0 0 12 4])

% saving the figure
savePath = ['C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode\mimic_all_figures\PCA_for_eachObj\',objectName];
saveas(gcf,savePath,'fig');
saveas(gcf,savePath,'jpg');