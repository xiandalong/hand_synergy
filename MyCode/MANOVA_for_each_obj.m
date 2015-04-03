% MANOVA for each object

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
results = {};

%%%%%%%%%%%%%%%%%%%%%% those above are subject to change %%%%%%%%%%%%%%%%%


for j = 1:length(object_list)
    object = object_list{j};
    async_range = async_ranges(j,:);
    sync_range = sync_ranges(j,:);
    
    mimic_async=[];
    grasp_async=[];
    mimic_sync=[];
    grasp_sync=[];
    
    for k = 1:length(subject_list)
        data_path = fullfile(root_dir,data_list{k});
        load(data_path);
        subject = subject_list{k};
        
        for l = 1:size(Data_table,1)
            Data_table.joint_angle_LM_holding_mimic{l} = downsample((Data_table.joint_angles_LeftHand{l}(:,Data_table.leftMimic_start_frame(l):Data_table.leftMimic_start_frame(l)+frame_rate*duration-1))',step_size);
            Data_table.joint_angle_LM_holding_grasp{l}= downsample((Data_table.joint_angles_RightHand{l}(:,Data_table.leftMimic_start_frame(l):Data_table.leftMimic_start_frame(l)+frame_rate*duration-1))',step_size);
            Data_table.joint_angle_RM_holding_mimic{l} = downsample((Data_table.joint_angles_RightHand{l}(:,Data_table.rightMimic_start_frame(l):Data_table.rightMimic_start_frame(l)+frame_rate*duration-1))',step_size);
            Data_table.joint_angle_RM_holding_grasp{l}= downsample((Data_table.joint_angles_LeftHand{l}(:,Data_table.rightMimic_start_frame(l):Data_table.rightMimic_start_frame(l)+frame_rate*duration-1))',step_size);
        end
        
        for async_index = async_range
            mimic_async = [mimic_async;Data_table.joint_angle_LM_holding_mimic{async_index};Data_table.joint_angle_RM_holding_mimic{async_index}];
            grasp_async = [grasp_async;Data_table.joint_angle_LM_holding_grasp{async_index};Data_table.joint_angle_RM_holding_grasp{async_index}];
        end
        for sync_index = sync_range
            mimic_sync = [mimic_sync;Data_table.joint_angle_LM_holding_mimic{sync_index};Data_table.joint_angle_RM_holding_mimic{sync_index}];
            grasp_sync = [grasp_sync;Data_table.joint_angle_LM_holding_grasp{sync_index};Data_table.joint_angle_RM_holding_grasp{sync_index}];
        end
        
    end
    % 1. MANOVA for mimic hand
    sync_async = [repmat({'async'},length(subject_list)*length(async_range)*n_samples*2,1);repmat({'sync'},length(subject_list)*length(sync_range)*n_samples*2,1)];
    data_mimic = [mimic_async;mimic_sync];
    t_mimic = table(sync_async,data_mimic(:,1),data_mimic(:,2),data_mimic(:,3),data_mimic(:,4),data_mimic(:,5),...
        data_mimic(:,6),data_mimic(:,7),data_mimic(:,8),data_mimic(:,9),data_mimic(:,10),...
        data_mimic(:,11),data_mimic(:,12),data_mimic(:,13),data_mimic(:,14),data_mimic(:,15),...
        data_mimic(:,16),data_mimic(:,17),data_mimic(:,18),data_mimic(:,19),data_mimic(:,20),...
        'VariableNames',{'sync_async','JA1','JA2','JA3','JA4','JA5','JA6','JA7','JA8','JA9','JA10',...
        'JA11','JA12','JA13','JA14','JA15','JA16','JA17','JA18','JA19','JA20'});
    JA = table([1:20]','VariableNames',{'JA'});
    
    rm_mimic = fitrm(t_mimic,'JA1-JA20~sync_async','WithinDesign',JA);

    manovatbl_mimic = manova(rm_mimic);
    
     % 2. MANOVA for grasp hand
    sync_async = [repmat({'async'},length(subject_list)*length(async_range)*n_samples*2,1);repmat({'sync'},length(subject_list)*length(sync_range)*n_samples*2,1)];
    data_grasp = [grasp_async;grasp_sync];
    t_grasp = table(sync_async,data_grasp(:,1),data_grasp(:,2),data_grasp(:,3),data_grasp(:,4),data_grasp(:,5),...
        data_grasp(:,6),data_grasp(:,7),data_grasp(:,8),data_grasp(:,9),data_mimic(:,10),...
        data_grasp(:,11),data_grasp(:,12),data_grasp(:,13),data_grasp(:,14),data_grasp(:,15),...
        data_grasp(:,16),data_grasp(:,17),data_grasp(:,18),data_grasp(:,19),data_grasp(:,20),...
        'VariableNames',{'sync_async','JA1','JA2','JA3','JA4','JA5','JA6','JA7','JA8','JA9','JA10',...
        'JA11','JA12','JA13','JA14','JA15','JA16','JA17','JA18','JA19','JA20'});
    JA = table([1:20]','VariableNames',{'JA'});
    
    rm_grasp = fitrm(t_grasp,'JA1-JA20~sync_async','WithinDesign',JA);

    manovatbl_grasp = manova(rm_grasp);
    
    results = [results;{object,sync_async,t_mimic,t_grasp,JA,manovatbl_mimic,manovatbl_grasp}];
end
    
    