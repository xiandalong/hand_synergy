clear;clc

% PCA on all data for left hand mimicing

root_dir = 'S:\Xianda\Dropbox\Haptics research\hand_synergy\MyCode\LeftMimicRight';

data_list = {'Data_Subj1.mat','Data_Subj2.mat','Data_Subj3.mat','Data_Subj4.mat'};

Data_all = {};

frame_rate = 120; % in Hz
duration = 0.5; % in seconds

Left_JA_col_index = 6;
Right_JA_col_index = 7;

% load data from all subjects
for j=1:length(data_list)
    
    data_path = fullfile(root_dir,data_list{j});
    load(data_path);
    Data_all = [Data_all;Data_array];
    clear Data_array;
    
end

% Left Hand
num_trials = size(Data_all,1);
raw_data_Left = zeros(num_trials,20);
for j=1:size(Data_all,1)
    raw_data_Left(j,:)= ( mean(Data_all{j,Left_JA_col_index},2))';
end

% Right Hand
num_trials = size(Data_all,1);
raw_data_Right = zeros(num_trials,20);
for j=1:size(Data_all,1)
    raw_data_Right(j,:)= ( mean(Data_all{j,Right_JA_col_index},2))';
end

[coeff,score,latent,tsquared,explained,mu] = pca([raw_data_Left;raw_data_Right]);

% show two clusters from left and right hand
figure
scatter3(score(1:240,1),score(1:240,2),score(1:240,3));
hold on
scatter3(score(241:480,1),score(241:480,2),score(241:480,3),'red');
legend('Left Hand','Right Hand');

% show the detailed classification
figure
size = 50; 
% 1. cone
cone_async_index = [1:5,61:65,121:125,181:185];
scatter3(score(cone_async_index,1),score(cone_async_index,2),score(cone_async_index,3),size,[ 1 1 0 ],'o');%  async
hold on
cone_sync_index = [6:10,66:70,126:130,186:190];
scatter3(score(cone_sync_index,1),score(cone_sync_index,2),score(cone_sync_index,3),size,[ 1 1 0],'*');%  sync

% 2. cylinder 
cylinder_async_index = [11:15,71:75,131:135,191:195];
scatter3(score(cylinder_async_index,1),score(cylinder_async_index,2),score(cylinder_async_index,3),size,[  1 0 1],'o');% async
cylinder_sync_index = [16:20,76:80,136:140,196:200];
scatter3(score(cylinder_sync_index,1),score(cylinder_sync_index,2),score(cylinder_sync_index,3),size,[  1 0 1],'*');% sync

% 3. drum
drum_async_index = [21:25,81:85,141:145,201:205];
scatter3(score(drum_async_index,1),score(drum_async_index,2),score(drum_async_index,3),size,[ 0 1 1],'o');% async
drum_sync_index = [26:30,86:90,146:150,206:210];
scatter3(score(drum_sync_index,1),score(drum_sync_index,2),score(drum_sync_index,3),size,[ 0 1 1],'*');% sync

% 4. mouse
mouse_async_index = [31:35,91:95,151:155,211:215];
scatter3(score(mouse_async_index,1),score(mouse_async_index,2),score(mouse_async_index,3),size,[ 1 0 0],'o');% async
mouse_sync_index = [36:40,96:100,156:160,216:220];
scatter3(score(mouse_sync_index,1),score(mouse_sync_index,2),score(mouse_sync_index,3),size,[ 1 0 0],'*');% sync

% 5. papercup
paperpcup_async_index = [41:45,101:105,161:165,221:225];
scatter3(score(paperpcup_async_index,1),score(paperpcup_async_index,2),score(paperpcup_async_index,3),size,[ 0 1 0],'o');% async
papercup_sync_index = [46:50,106:110,166:170,226:230];
scatter3(score(papercup_sync_index,1),score(papercup_sync_index,2),score(papercup_sync_index,3),size,[ 0 1 0],'*');% sync

% 6. pen
pen_async_index = [51:55,111:115,171:175,231:235];
scatter3(score(pen_async_index,1),score(pen_async_index,2),score(pen_async_index,3),size,[ 0 0 1],'o');% async
pen_sync_index = [56:60,116:120,176:180,236:240];
scatter3(score(pen_sync_index,1),score(pen_sync_index,2),score(pen_sync_index,3),size,[ 0 0 1],'*');% sync

% right hand
right_index = [241:480];
scatter3(score(right_index,1),score(right_index,2),score(right_index,3),size,'s');
legend('cone async','cone sync','cylinder async','cylinder sync','drum async','drum sync',...
    'mouse async','mouse sync','papercup async','papercup sync','pen async','pen sync','RIGHT HAND');