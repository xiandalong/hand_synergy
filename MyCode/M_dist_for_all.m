% calculate M-dist for all objects(3 subjects for each object) and plot


% 1. create a cell array to store the index range for each subject and
% object
%   make the rows represent each subject and the columns represents each
% object
clear;clc

root_dir = 'C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode';
data_list = {'Data_Subject4.mat','Data_Subject3.mat','Data_Subject2.mat'};

num_obj = 6;
frame_rate = 120; % in Hz
duration = 0.5; % in seconds
n_frames = frame_rate*duration;
n_samples = 10; % number of samples to use in each epoch
step_size = n_frames/n_samples;

% initialize variables to contain results
subject_list = cellfun(@(x) x(6:13),data_list,'UniformOutput', false);
object_list = {'Cone','Cylinder','Drum','Mouse','Papercup','Pen'};
async_ranges = [1:5;11:15;21:25;31:35;41:45;51:55];
sync_ranges = async_ranges+5;
Mdist_results = {};
%%%%%%%%%%%%%%%%%%%%%% those above are subject to change %%%%%%%%%%%%%%%%%


for j = 1:length(data_list)
    
    data_path = fullfile(root_dir,data_list{j});
    load(data_path);
    subject = subject_list{j};
    % after Data_table is loaded, calculate M-distance for each sync/async
    % pair
    
    for l = 1:size(Data_table,1)
        Data_table.joint_angle_LM_holding_mimic{l} = downsample((Data_table.joint_angles_LeftHand{l}(:,Data_table.leftMimic_start_frame(l):Data_table.leftMimic_start_frame(l)+frame_rate*duration-1))',step_size);
        Data_table.joint_angle_LM_holding_grasp{l}= downsample((Data_table.joint_angles_RightHand{l}(:,Data_table.leftMimic_start_frame(l):Data_table.leftMimic_start_frame(l)+frame_rate*duration-1))',step_size);
        Data_table.joint_angle_RM_holding_mimic{l} = downsample((Data_table.joint_angles_RightHand{l}(:,Data_table.rightMimic_start_frame(l):Data_table.rightMimic_start_frame(l)+frame_rate*duration-1))',step_size);
        Data_table.joint_angle_RM_holding_grasp{l}= downsample((Data_table.joint_angles_LeftHand{l}(:,Data_table.rightMimic_start_frame(l):Data_table.rightMimic_start_frame(l)+frame_rate*duration-1))',step_size);
    end
    for k = 1:length(object_list)
        object = object_list{k};
        async_range = async_ranges(k,:);
        sync_range = sync_ranges(k,:);
        
        mimic_async = [];
        mimic_sync = [];
        grasp_async = [];
        grasp_sync = [];
        
        for async_index = async_range
            mimic_async = [mimic_async;Data_table.joint_angle_LM_holding_mimic{async_index};Data_table.joint_angle_RM_holding_mimic{async_index}];
            grasp_async = [grasp_async;Data_table.joint_angle_LM_holding_grasp{async_index};Data_table.joint_angle_RM_holding_grasp{async_index}];
        end
        for sync_index = sync_range
            mimic_sync = [mimic_sync;Data_table.joint_angle_LM_holding_mimic{sync_index};Data_table.joint_angle_RM_holding_mimic{sync_index}];
            grasp_sync = [grasp_sync;Data_table.joint_angle_LM_holding_grasp{sync_index};Data_table.joint_angle_RM_holding_grasp{sync_index}];
        end
        mimic_Mdist = calcMdist(mimic_async,mimic_sync);
        grasp_Mdist = calcMdist(grasp_async,grasp_sync);
        Mdist_results = [Mdist_results;{subject,object,mimic_Mdist, grasp_Mdist}];
        
    end
    
end

%% plotting m_dist bwteen sync&async for mimic hand
index_range = 1:6; % for subject 4
figure(1)
bar(index_range,cell2mat(Mdist_results(index_range,3)));
set(gca,'xtickLabel',Mdist_results(index_range,2));
ylim([0 70]);
ylabel('Mahalanobis distance');
title('Subject3');

index_range = 7:12; % for subject 3
figure(2)
bar(index_range,cell2mat(Mdist_results(index_range,3)));
set(gca,'xtickLabel',Mdist_results(index_range,2));
ylim([0 70]);
ylabel('Mahalanobis distance');
title('Subject2');

index_range = 13:18; % for subject 2
figure(3)
bar(index_range,cell2mat(Mdist_results(index_range,3)));
set(gca,'xtickLabel',Mdist_results(index_range,2));
ylim([0 70]);
ylabel('Mahalanobis distance');
title('Subject1');