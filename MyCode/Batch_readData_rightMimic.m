% This is for grasping with Right Hand

%% read all the data from the *.csv files and convert into joint angles
xls_path = 'S:\Xianda\Dropbox\Haptics research\Data and docs\recording_list.xlsx';

% % Subject 1: This subject doesn't have Left hand grasping
% table = readtable(xls_path,'sheet','Subj1_Xianda');
% data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-11-20'; %Subject 1: Xianda

% Subject 2
table = readtable(xls_path,'sheet','Subj2_Phil');
data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-12-10'; %Subject 2: Phil

% % Subject 3
% table = readtable(xls_path,'sheet','Subj3_Yitian');
% data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-12-11'; %Subject 3: Yitian

% % Subject 4
% table = readtable(xls_path,'sheet','Subj4_Darshan');
% data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-12-19'; %Subject 4: Darshan

frame_rate = 120; % in Hz
duration = 0.5; % in seconds

Data_array = table2cell(table);
Left_JA_col_index = 6;
Right_JA_col_index = 7;

for j=1:size(table,1)
    
    
    % get path for one file
    csv_path = fullfile(data_dir,table.filename{j});
    
    % get joint asngles for Left and Right hand separately
    % Left Hand
    marker_set_LeftHand = 'LeftHand';
    palm_marker_index_LeftHand = 26:33;
    finger_marker_index_LeftHand =reshape(1:25,5,5)';
    b1_b2_index_LeftHand =[32,28];
    b3_cmc4_index_LeftHand =[33,26];
    joint_angles_LeftHand = getJointAngles(csv_path,marker_set_LeftHand,...
        palm_marker_index_LeftHand,finger_marker_index_LeftHand,b1_b2_index_LeftHand,b3_cmc4_index_LeftHand);
    
    % Right Hand
    marker_set_RightHand = 'RightHand';
    palm_marker_index_RightHand = 26:33;
    finger_marker_index_RightHand =reshape(1:25,5,5)';
    b1_b2_index_RightHand =[32,28];
    b3_cmc4_index_RightHand =[33,26];
    joint_angles_RightHand = getJointAngles(csv_path,marker_set_RightHand,...
        palm_marker_index_RightHand,finger_marker_index_RightHand,b1_b2_index_RightHand,b3_cmc4_index_RightHand);
    
    % selected the the frames of interest
    joint_angles_LeftHand = joint_angles_LeftHand(:,table.left_start_frame(j):table.left_start_frame(j)+frame_rate*duration-1);
    joint_angles_RightHand = joint_angles_RightHand(:,table.left_start_frame(j):table.left_start_frame(j)+frame_rate*duration-1);
    
    % put the joint angles into "Data_array"
    Data_array{j,6} = joint_angles_LeftHand;
    Data_array{j,7} = joint_angles_RightHand;

    
end

%% PCA and E-distance calculation
% put all the data into a 2D matrix for PCA

% Left Hand
num_trials = size(Data_array,1);
raw_data_Left = zeros(num_trials,20);
for j=1:size(Data_array,1)
    raw_data_Left(j,:)= ( mean(Data_array{j,Left_JA_col_index},2))';
end

% Right Hand
num_trials = size(Data_array,1);
raw_data_Right = zeros(num_trials,20);
for j=1:size(Data_array,1)
    raw_data_Right(j,:)= ( mean(Data_array{j,Right_JA_col_index},2))';
end

[coeff,score,latent,tsquared,explained,mu] = pca([raw_data_Left;raw_data_Right]);

% show two clusters from left and right hand
figure(1)
scatter3(score(1:60,1),score(1:60,2),score(1:60,3));
hold on
scatter3(score(61:120,1),score(61:120,2),score(61:120,3),'red');
legend('Left Hand','Right Hand');

% show the detailed classification
figure(2)
size = 50; 
% left hand
scatter3(score(1:60,1),score(1:60,2),score(1:60,3),size,'s');
hold on

% right hand
% 1. cone
scatter3(score(61:65,1),score(61:65,2),score(61:65,3),size,[ 1 1 0 ],'o');%  async

scatter3(score(66:70,1),score(66:70,2),score(66:70,3),size,[ 1 1 0],'*');%  sync

% 2. cylinder 
scatter3(score(71:75,1),score(71:75,2),score(71:75,3),size,[  1 0 1],'o');% async
scatter3(score(76:80,1),score(76:80,2),score(76:80,3),size,[  1 0 1],'*');% sync

% 3. drum
scatter3(score(81:85,1),score(81:85,2),score(81:85,3),size,[ 0 1 1],'o');% async
scatter3(score(86:90,1),score(86:90,2),score(86:90,3),size,[ 0 1 1],'*');% sync

% 4. mouse
scatter3(score(91:95,1),score(91:95,2),score(91:95,3),size,[ 1 0 0],'o');% async
scatter3(score(96:100,1),score(96:100,2),score(96:100,3),size,[ 1 0 0],'*');% sync

% 5. papercup
scatter3(score(101:105,1),score(101:105,2),score(101:105,3),size,[ 0 1 0],'o');% async
scatter3(score(106:110,1),score(106:110,2),score(106:110,3),size,[ 0 1 0],'*');% sync

% 6. pen
scatter3(score(111:115,1),score(111:115,2),score(111:115,3),size,[ 0 0 1],'o');% async
scatter3(score(116:120,1),score(116:120,2),score(116:120,3),size,[ 0 0 1],'*');% sync


legend('LEFT HAND','cone async','cone sync','cylinder async','cylinder sync','drum async','drum sync',...
    'mouse async','mouse sync','papercup async','papercup sync','pen async','pen sync');