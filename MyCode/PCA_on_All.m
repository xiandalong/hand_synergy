clear;clc

% PCA on all data for left/right hand mimicing during holding phase

% select case
root_dir = 'S:\Xianda\Dropbox\Haptics research\hand_synergy\MyCode\LeftMimicRight';
data_list = {'Data_Subj1.mat','Data_Subj2.mat','Data_Subj3.mat','Data_Subj4.mat'};

% % Right hand mimicing left hand
% root_dir = 'S:\Xianda\Dropbox\Haptics research\hand_synergy\MyCode\RightMimicLeft';
% data_list = {'Data_Subj2.mat','Data_Subj3.mat','Data_Subj4.mat'};

Data_all = table();

frame_rate = 120; % in Hz
duration = 0.5; % in seconds

% Left_JA_col_index = 6;
% Right_JA_col_index = 7;

% load data from all subjects
for j=1:length(data_list)
    
    data_path = fullfile(root_dir,data_list{j});
    load(data_path);
    Data_all = [Data_all;Data_table];
    clear Data_table;
    
end

raw_data_Left = zeros(num_trials,hand_DOF);
raw_data_Right = zeros(num_trials,hand_DOF);
for j=1:num_trials
    % select which hand is the micmicing hand, to decide the time span of
    % it's holding phase
    if regexp(mimicHand,'left')
        raw_data_Left(j,:)= ( mean(Data_table.joint_angles_LeftHand{j}(:,Data_table.leftMimic_start_frame(j):Data_table.leftMimic_start_frame(j)+frame_rate*duration-1),2))'; % Left Hand
        raw_data_Right(j,:)= ( mean(Data_table.joint_angles_RightHand{j}(:,Data_table.leftMimic_start_frame(j):Data_table.leftMimic_start_frame(j)+frame_rate*duration-1),2))'; % Right Hand
    elseif regexp(mimicHand,'right')
        raw_data_Left(j,:)= ( mean(Data_table.joint_angles_LeftHand{j}(:,Data_table.rightMimic_start_frame(j):Data_table.rightMimic_start_frame(j)+frame_rate*duration-1),2))'; % Left Hand
        raw_data_Right(j,:)= ( mean(Data_table.joint_angles_RightHand{j}(:,Data_table.rightMimic_start_frame(j):Data_table.rightMimic_start_frame(j)+frame_rate*duration-1),2))'; % Right Hand
    end
end

[coeff,score,latent,tsquared,explained,mu] = pca([raw_data_Left;raw_data_Right]);

% show two clusters from left and right hand
figure
left_index = [1:180];
scatter3(score(left_index,1),score(left_index,2),score(left_index,3));
hold on
right_index = [181:360];
scatter3(score(right_index,1),score(right_index,2),score(right_index,3),'red');
legend('Left Hand','Right Hand');

% show the detailed classification
figure
size = 50; 

% left hand
scatter3(score(left_index,1),score(left_index,2),score(left_index,3),size,'s');
hold on

% 1. cone
cone_async_index = [1:5,61:65,121:125]+180;
scatter3(score(cone_async_index,1),score(cone_async_index,2),score(cone_async_index,3),size,[ 1 1 0 ],'o');%  async
cone_sync_index = [6:10,66:70,126:130]+180;
scatter3(score(cone_sync_index,1),score(cone_sync_index,2),score(cone_sync_index,3),size,[ 1 1 0],'*');%  sync

% 2. cylinder 
cylinder_async_index = [11:15,71:75,131:135]+180;
scatter3(score(cylinder_async_index,1),score(cylinder_async_index,2),score(cylinder_async_index,3),size,[  1 0 1],'o');% async
cylinder_sync_index = [16:20,76:80,136:140]+180;
scatter3(score(cylinder_sync_index,1),score(cylinder_sync_index,2),score(cylinder_sync_index,3),size,[  1 0 1],'*');% sync

% 3. drum
drum_async_index = [21:25,81:85,141:145]+180;
scatter3(score(drum_async_index,1),score(drum_async_index,2),score(drum_async_index,3),size,[ 0 1 1],'o');% async
drum_sync_index = [26:30,86:90,146:150]+180;
scatter3(score(drum_sync_index,1),score(drum_sync_index,2),score(drum_sync_index,3),size,[ 0 1 1],'*');% sync

% 4. mouse
mouse_async_index = [31:35,91:95,151:155]+180;
scatter3(score(mouse_async_index,1),score(mouse_async_index,2),score(mouse_async_index,3),size,[ 1 0 0],'o');% async
mouse_sync_index = [36:40,96:100,156:160]+180;
scatter3(score(mouse_sync_index,1),score(mouse_sync_index,2),score(mouse_sync_index,3),size,[ 1 0 0],'*');% sync

% 5. papercup
paperpcup_async_index = [41:45,101:105,161:165]+180;
scatter3(score(paperpcup_async_index,1),score(paperpcup_async_index,2),score(paperpcup_async_index,3),size,[ 0 1 0],'o');% async
papercup_sync_index = [46:50,106:110,166:170]+180;
scatter3(score(papercup_sync_index,1),score(papercup_sync_index,2),score(papercup_sync_index,3),size,[ 0 1 0],'*');% sync

% 6. pen
pen_async_index = [51:55,111:115,171:175]+180;
scatter3(score(pen_async_index,1),score(pen_async_index,2),score(pen_async_index,3),size,[ 0 0 1],'o');% async
pen_sync_index = [56:60,116:120,176:180]+180;
scatter3(score(pen_sync_index,1),score(pen_sync_index,2),score(pen_sync_index,3),size,[ 0 0 1],'*');% sync


legend('LEFT HAND','cone async','cone sync','cylinder async','cylinder sync','drum async','drum sync',...
    'mouse async','mouse sync','papercup async','papercup sync','pen async','pen sync');