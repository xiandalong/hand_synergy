

% PCA on all data for left/right hand mimicing during holding phase

%% %%%%%%%%%%%%%%%%%%%%%%%%%% READING DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc

root_dir = 'C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode';
data_list = {'Data_Subject4.mat','Data_Subject3.mat','Data_Subject2.mat'};
% data_list = {'Data_Subject2.mat'};
num_subj = length(data_list);
% % Right hand mimicing left hand
% root_dir = 'S:\Xianda\Dropbox\Haptics research\hand_synergy\MyCode\RightMimicLeft';
% data_list = {'Data_Subj2.mat','Data_Subj3.mat','Data_Subj4.mat'};

Data_all = table();

frame_rate = 120; % in Hz
duration = 0.5; % in seconds
n_frames = frame_rate*duration;

% Left_JA_col_index = 6;
% Right_JA_col_index = 7;

% load data from all subjects
for j=1:length(data_list)
    
    data_path = fullfile(root_dir,data_list{j});
    load(data_path);
    Data_all = [Data_all;Data_table];
    clear Data_table;
    
end

%% %%%%%%% TWO versions of PCA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% 1. doing PCA on either on left mimicking or right mimicking %%%%%%%%%%%%
% raw_data_Left = zeros(num_trials,hand_DOF);
% raw_data_Right = zeros(num_trials,hand_DOF);
% for j=1:num_trials
%     % select which hand is the micmicing hand, to decide the time span of
%     % it's holding phase
%     if regexp(mimicHand,'left')
%         raw_data_Left(j,:)= ( mean(Data_table.joint_angles_LeftHand{j}(:,Data_table.leftMimic_start_frame(j):Data_table.leftMimic_start_frame(j)+frame_rate*duration-1),2))'; % Left Hand
%         raw_data_Right(j,:)= ( mean(Data_table.joint_angles_RightHand{j}(:,Data_table.leftMimic_start_frame(j):Data_table.leftMimic_start_frame(j)+frame_rate*duration-1),2))'; % Right Hand
%     elseif regexp(mimicHand,'right')
%         raw_data_Left(j,:)= ( mean(Data_table.joint_angles_LeftHand{j}(:,Data_table.rightMimic_start_frame(j):Data_table.rightMimic_start_frame(j)+frame_rate*duration-1),2))'; % Left Hand
%         raw_data_Right(j,:)= ( mean(Data_table.joint_angles_RightHand{j}(:,Data_table.rightMimic_start_frame(j):Data_table.rightMimic_start_frame(j)+frame_rate*duration-1),2))'; % Right Hand
%     end
% end
% [coeff,score,latent,tsquared,explained,mu] = pca([raw_data_Left;raw_data_Right]);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2. doing PCA on all the data including left and right mimicking %%%%%%

% in total, there are 4 types of gestures performed in one recording(trial)
n_samples = 10; % number of samples to use in each epoch
step_size = n_frames/n_samples;

for j = 1:size(Data_all,1)
    Data_all.joint_angle_LM_holding_mimic{j} = downsample((Data_all.joint_angles_LeftHand{j}(:,Data_all.leftMimic_start_frame(j):Data_all.leftMimic_start_frame(j)+frame_rate*duration-1))',step_size);
    Data_all.joint_angle_LM_holding_grasp{j}= downsample((Data_all.joint_angles_RightHand{j}(:,Data_all.leftMimic_start_frame(j):Data_all.leftMimic_start_frame(j)+frame_rate*duration-1))',step_size);
    Data_all.joint_angle_RM_holding_mimic{j} = downsample((Data_all.joint_angles_RightHand{j}(:,Data_all.rightMimic_start_frame(j):Data_all.rightMimic_start_frame(j)+frame_rate*duration-1))',step_size);
    Data_all.joint_angle_RM_holding_grasp{j}= downsample((Data_all.joint_angles_LeftHand{j}(:,Data_all.rightMimic_start_frame(j):Data_all.rightMimic_start_frame(j)+frame_rate*duration-1))',step_size);
end
mimic_all = [cell2mat(Data_all.joint_angle_LM_holding_mimic);cell2mat(Data_all.joint_angle_RM_holding_mimic)]; % congregating all mimicking hand postures
grasp_all = [cell2mat(Data_all.joint_angle_LM_holding_grasp);cell2mat(Data_all.joint_angle_RM_holding_grasp)]; % congregating all grasping hand postures

hand_postures_all = [mimic_all;grasp_all];

Object_labels = repmat(reshape(Data_all.Object,1,size(Data_all,1)),n_samples,1);% repeat for a certain amount of samples per trial
sync_labels = repmat(reshape(Data_all.synchronized_asynchronized,1,size(Data_all,1)),n_samples,1);

labels_for_all = repmat([Object_labels(:),sync_labels(:)],4,1); % repeat 4 times because it's essentially [Data_all.joint_angle_LM_holding_mimic;Data_all.joint_angle_RM_holding_mimic;Data_all.joint_angle_LM_holding_grasp;Data_all.joint_angle_RM_holding_grasp];


%%%%%%%%%%%%%%%%%%%%%%%%% DIMENSION REDUCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% 1. PCA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [coeff,score,latent,tsquared,explained,mu] = pca([mimic_all;grasp_all]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% 2. Multidimensional scaling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D = pdist(hand_postures_all); % calculate Euclidean distance matrix 
%%%% a. classical MDS
% score = cmdscale(D); % classic MDS yield exactly the same result as PCA is E-distance is used (look at http://stats.stackexchange.com/questions/14002/whats-the-difference-between-principal-components-analysis-and-multidimensional)
%%%% b. Nonclassical multidimensional scaling %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% p = 3; % p is the target number of dimensions
% score = mdscale(D,p);

%%%%%% 3. trying out all dimensionality reduction methods from this matlab
%%%%%% website(http://lvdmaaten.github.io/drtoolbox/#download)
% [score, mapping] = compute_mapping(hand_postures_all, 'tSNE',3); % t-SNE seems have good separation, look into individual subjects later.
% 
% [score, mapping] = compute_mapping(hand_postures_all, 'LPP',3); % this one seems have less variance within a cluster
[score, mapping] = compute_mapping(hand_postures_all, 'KernelPCA',3,'linear');
%%%%%%%%%%%%%%%%%%%%%%%%% VISUALIZING CLUSTERING QUALITY %%%%%%%%%%%%%%%%%%
% [s,h] = silhouette(score,repmat(Object_labels(:),4,1)); 


%% %%%%%%%%%%%%%%%%%%%%%% PLOTTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% 1. first version %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % show two clusters from left and right hand
% figure
% left_index = [1:180];
% scatter3(score(left_index,1),score(left_index,2),score(left_index,3));
% hold on
% right_index = [181:360];
% scatter3(score(right_index,1),score(right_index,2),score(right_index,3),'red');
% legend('Left Hand','Right Hand');
% 
% % show the detailed classification
% figure
% size = 50; 
% 
% % left hand
% scatter3(score(left_index,1),score(left_index,2),score(left_index,3),size,'s');
% hold on
% 
% % 1. cone
% cone_async_index = [1:5,61:65,121:125]+180;
% scatter3(score(cone_async_index,1),score(cone_async_index,2),score(cone_async_index,3),size,[ 1 1 0 ],'o');%  async
% cone_sync_index = [6:10,66:70,126:130]+180;
% scatter3(score(cone_sync_index,1),score(cone_sync_index,2),score(cone_sync_index,3),size,[ 1 1 0],'*');%  sync
% 
% % 2. cylinder 
% cylinder_async_index = [11:15,71:75,131:135]+180;
% scatter3(score(cylinder_async_index,1),score(cylinder_async_index,2),score(cylinder_async_index,3),size,[  1 0 1],'o');% async
% cylinder_sync_index = [16:20,76:80,136:140]+180;
% scatter3(score(cylinder_sync_index,1),score(cylinder_sync_index,2),score(cylinder_sync_index,3),size,[  1 0 1],'*');% sync
% 
% % 3. drum
% drum_async_index = [21:25,81:85,141:145]+180;
% scatter3(score(drum_async_index,1),score(drum_async_index,2),score(drum_async_index,3),size,[ 0 1 1],'o');% async
% drum_sync_index = [26:30,86:90,146:150]+180;
% scatter3(score(drum_sync_index,1),score(drum_sync_index,2),score(drum_sync_index,3),size,[ 0 1 1],'*');% sync
% 
% % 4. mouse
% mouse_async_index = [31:35,91:95,151:155]+180;
% scatter3(score(mouse_async_index,1),score(mouse_async_index,2),score(mouse_async_index,3),size,[ 1 0 0],'o');% async
% mouse_sync_index = [36:40,96:100,156:160]+180;
% scatter3(score(mouse_sync_index,1),score(mouse_sync_index,2),score(mouse_sync_index,3),size,[ 1 0 0],'*');% sync
% 
% % 5. papercup
% paperpcup_async_index = [41:45,101:105,161:165]+180;
% scatter3(score(paperpcup_async_index,1),score(paperpcup_async_index,2),score(paperpcup_async_index,3),size,[ 0 1 0],'o');% async
% papercup_sync_index = [46:50,106:110,166:170]+180;
% scatter3(score(papercup_sync_index,1),score(papercup_sync_index,2),score(papercup_sync_index,3),size,[ 0 1 0],'*');% sync
% 
% % 6. pen
% pen_async_index = [51:55,111:115,171:175]+180;
% scatter3(score(pen_async_index,1),score(pen_async_index,2),score(pen_async_index,3),size,[ 0 0 1],'o');% async
% pen_sync_index = [56:60,116:120,176:180]+180;
% scatter3(score(pen_sync_index,1),score(pen_sync_index,2),score(pen_sync_index,3),size,[ 0 0 1],'*');% sync
% 
% 
% legend('LEFT HAND','cone async','cone sync','cylinder async','cylinder sync','drum async','drum sync',...
%     'mouse async','mouse sync','papercup async','papercup sync','pen async','pen sync');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% second version %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. initialize containers for each case, there will be in total 6 obj *
% sync/async = 12 cases;
num_dim = 3;
cone_sync = zeros(0,num_dim); % only need the first 3 dimensions for plotting
cone_async = zeros(0,num_dim);
cylinder_sync = zeros(0,num_dim); % only need the first 3 dimensions for plotting
cylinder_async = zeros(0,num_dim);
drum_sync = zeros(0,num_dim); % only need the first 3 dimensions for plotting
drum_async = zeros(0,num_dim);
mouse_sync = zeros(0,num_dim); % only need the first 3 dimensions for plotting
mouse_async = zeros(0,num_dim);
papercup_sync = zeros(0,num_dim); % only need the first 3 dimensions for plotting
papercup_async = zeros(0,num_dim);
pen_sync = zeros(0,num_dim); % only need the first 3 dimensions for plotting
pen_async = zeros(0,num_dim);
point_size = 50;

% mimicking hand is 1:360; grasping hand is 361:720, which is not very
% interesting to look at
mimicking_range=1:size(mimic_all,1); % to control which subjects are included in plotting
for j=mimicking_range
    if strcmp(labels_for_all{j,1},'cone')
        if strcmp(labels_for_all{j,2},'Y')
            cone_sync = [cone_sync;score(j,1:num_dim)];
        elseif strcmp(labels_for_all{j,2},'N')
            cone_async = [cone_async;score(j,1:num_dim)];
        else error('The synchronicity should either be ''Y'' or ''N''.');
        end
    elseif strcmp(labels_for_all{j,1},'cylinder')
        if strcmp(labels_for_all{j,2},'Y')
            cylinder_sync = [cylinder_sync;score(j,1:num_dim)];
        elseif strcmp(labels_for_all{j,2},'N')
            cylinder_async = [cylinder_async;score(j,1:num_dim)];
        else error('The synchronicity should either be ''Y'' or ''N''.');
        end
    elseif strcmp(labels_for_all{j,1},'drum')
        if strcmp(labels_for_all{j,2},'Y')
            drum_sync = [drum_sync;score(j,1:num_dim)];
        elseif strcmp(labels_for_all{j,2},'N')
            drum_async = [drum_async;score(j,1:num_dim)];
        else error('The synchronicity should either be ''Y'' or ''N''.');
        end
    elseif strcmp(labels_for_all{j,1},'mouse')
        if strcmp(labels_for_all{j,2},'Y')
            mouse_sync = [mouse_sync;score(j,1:num_dim)];
        elseif strcmp(labels_for_all{j,2},'N')
            mouse_async = [mouse_async;score(j,1:num_dim)];
        else error('The synchronicity should either be ''Y'' or ''N''.');
        end
    elseif strcmp(labels_for_all{j,1},'papercup')
        if strcmp(labels_for_all{j,2},'Y')
            papercup_sync = [papercup_sync;score(j,1:num_dim)];
        elseif strcmp(labels_for_all{j,2},'N')
            papercup_async = [papercup_async;score(j,1:num_dim)];
        else error('The synchronicity should either be ''Y'' or ''N''.');
        end
    elseif strcmp(labels_for_all{j,1},'pen')
        if strcmp(labels_for_all{j,2},'Y')
            pen_sync = [pen_sync;score(j,1:num_dim)];
        elseif strcmp(labels_for_all{j,2},'N')
            pen_async = [pen_async;score(j,1:num_dim)];
        else error('The synchronicity should either be ''Y'' or ''N''.');
        end
    end
end
% check for exception
if size(cone_sync,1)~=10*n_samples*num_subj||size(cone_async,1)~=10*n_samples*num_subj||...
        size(cylinder_sync,1)~=10*n_samples*num_subj||size(cylinder_async,1)~=10*n_samples*num_subj||...
        size(drum_sync,1)~=10*n_samples*num_subj||size(drum_async,1)~=10*n_samples*num_subj||...
        size(mouse_sync,1)~=10*n_samples*num_subj||size(mouse_async,1)~=10*n_samples*num_subj||...
        size(papercup_sync,1)~=10*n_samples*num_subj||size(papercup_async,1)~=10*n_samples*num_subj||...
        size(pen_sync,1)~=10*n_samples*num_subj||size(pen_async,1)~=10*n_samples*num_subj
    error('Number of trials does not add up as expected.')
end


% plotting into 3D space
subject_range = 1:300;% 1:10 is for subject, 11:20 for subject 3, 21:30 for subject 4
 figure
% 1. cone
scatter3(cone_async(subject_range,1),cone_async(subject_range,2),cone_async(subject_range,3),point_size,[ 1 1 0],'o');%  async
hold on
scatter3(cone_sync(subject_range,1),cone_sync(subject_range,2),cone_sync(subject_range,3),point_size,[ 1 1 0],'*');%  sync
% 2. cylinder
scatter3(cylinder_async(subject_range,1),cylinder_async(subject_range,2),cylinder_async(subject_range,3),point_size,[  1 0 1],'o');%  async
scatter3(cylinder_sync(subject_range,1),cylinder_sync(subject_range,2),cylinder_sync(subject_range,3),point_size,[  1 0 1],'*');%  sync
% 3. drum
scatter3(drum_async(subject_range,1),drum_async(subject_range,2),drum_async(subject_range,3),point_size,[ 0 1 1],'o');%  async
scatter3(drum_sync(subject_range,1),drum_sync(subject_range,2),drum_sync(subject_range,3),point_size,[ 0 1 1],'*');%  sync
% 4. mouse
scatter3(mouse_async(subject_range,1),mouse_async(subject_range,2),mouse_async(subject_range,3),point_size,[ 1 0 0],'o');%  async
scatter3(mouse_sync(subject_range,1),mouse_sync(subject_range,2),mouse_sync(subject_range,3),point_size,[ 1 0 0],'*');%  sync
% 5. papercup
scatter3(papercup_async(subject_range,1),papercup_async(subject_range,2),papercup_async(subject_range,3),point_size,[ 0 1 0],'o');%  async
scatter3(papercup_sync(subject_range,1),papercup_sync(subject_range,2),papercup_sync(subject_range,3),point_size,[ 0 1 0],'*');%  sync
% 6. pen
scatter3(pen_async(subject_range,1),pen_async(subject_range,2),pen_async(subject_range,3),point_size,[ 0 0 1],'o');%  async
scatter3(pen_sync(subject_range,1),pen_sync(subject_range,2),pen_sync(subject_range,3),point_size,[ 0 0 1],'*');%  sync

% title('Subject 2');
legend('cone async','cone sync','cylinder async','cylinder sync','drum async','drum sync',...
     'mouse async','mouse sync','papercup async','papercup sync','pen async','pen sync');

 
avg_cone_async = mean(cone_async(subject_range,:),1);
avg_cone_sync = mean(cone_sync(subject_range,:),1);
avg_cylinder_async = mean(cylinder_async(subject_range,:),1);
avg_cylinder_sync = mean(cylinder_sync(subject_range,:),1);
avg_drum_async = mean(drum_async(subject_range,:),1);
avg_drum_sync = mean(drum_sync(subject_range,:),1);
avg_mouse_async = mean(mouse_async(subject_range,:),1);
avg_mouse_sync = mean(mouse_sync(subject_range,:),1);
avg_papercup_async = mean(papercup_async(subject_range,:),1);
avg_papercup_sync = mean(papercup_sync(subject_range,:),1);
avg_pen_async = mean(pen_async(subject_range,:),1);
avg_pen_sync = mean(pen_sync(subject_range,:),1);

% plot the average with lines linked between sync-async
figure
scatter3(avg_cone_async(:,1),avg_cone_async(:,2),avg_cone_async(:,3),point_size,[ 1 1 0],'o');%  async
hold on
scatter3(avg_cone_sync(:,1),avg_cone_sync(:,2),avg_cone_sync(:,3),point_size,[ 1 1 0],'*');%  sync
line([avg_cone_async(:,1) avg_cone_sync(:,1)],[avg_cone_async(:,2) avg_cone_sync(:,2)],[avg_cone_async(:,3) avg_cone_sync(:,3)],'color',[ 1 1 0]);

% 2. cylinder
scatter3(avg_cylinder_async(:,1),avg_cylinder_async(:,2),avg_cylinder_async(:,3),point_size,[  1 0 1],'o');%  async
scatter3(avg_cylinder_sync(:,1),avg_cylinder_sync(:,2),avg_cylinder_sync(:,3),point_size,[  1 0 1],'*');%  sync
line([avg_cylinder_async(:,1) avg_cylinder_sync(:,1)],[avg_cylinder_async(:,2) avg_cylinder_sync(:,2)],[avg_cylinder_async(:,3) avg_cylinder_sync(:,3)],'color',[  1 0 1]);

% 3. drum
scatter3(avg_drum_async(:,1),avg_drum_async(:,2),avg_drum_async(:,3),point_size,[ 0 1 1],'o');%  async
scatter3(avg_drum_sync(:,1),avg_drum_sync(:,2),avg_drum_sync(:,3),point_size,[ 0 1 1],'*');%  sync
line([avg_drum_async(:,1) avg_drum_sync(:,1)],[avg_drum_async(:,2) avg_drum_sync(:,2)],[avg_drum_async(:,3) avg_drum_sync(:,3)],'color',[ 0 1 1]);

% 4. mouse
scatter3(avg_mouse_async(:,1),avg_mouse_async(:,2),avg_mouse_async(:,3),point_size,[ 1 0 0],'o');%  async
scatter3(avg_mouse_sync(:,1),avg_mouse_sync(:,2),avg_mouse_sync(:,3),point_size,[ 1 0 0],'*');%  sync
line([avg_mouse_async(:,1) avg_mouse_sync(:,1)],[avg_mouse_async(:,2) avg_mouse_sync(:,2)],[avg_mouse_async(:,3) avg_mouse_sync(:,3)],'color',[ 1 0 0]);

% 5. papercup
scatter3(avg_papercup_async(:,1),avg_papercup_async(:,2),avg_papercup_async(:,3),point_size,[ 0 1 0],'o');%  async
scatter3(avg_papercup_sync(:,1),avg_papercup_sync(:,2),avg_papercup_sync(:,3),point_size,[ 0 1 0],'*');%  sync
line([avg_papercup_async(:,1) avg_papercup_sync(:,1)],[avg_papercup_async(:,2) avg_papercup_sync(:,2)],[avg_papercup_async(:,3) avg_papercup_sync(:,3)],'color',[ 0 1 0]);

% 6. pen
scatter3(avg_pen_async(:,1),avg_pen_async(:,2),avg_pen_async(:,3),point_size,[ 0 0 1],'o');%  async
scatter3(avg_pen_sync(:,1),avg_pen_sync(:,2),avg_pen_sync(:,3),point_size,[ 0 0 1],'*');%  sync
line([avg_pen_async(:,1) avg_pen_sync(:,1)],[avg_pen_async(:,2) avg_pen_sync(:,2)],[avg_pen_async(:,3) avg_pen_sync(:,3)],'color',[ 0 0 1]);
