% This is for grasping with Left/Right Hand specified by variable
% "mimicHand".
% updated with serveral change to fully use table data type, now we can add
% more columns in the Excel spreadsheet without worrying about the order
% of the columns but only the names of them.

% 1/27/2015 update: add maximum grip aperture(MGA)

clear; clc; close all
%% read all the data from the *.csv files and convert into joint angles
xls_path = 'S:\Xianda\Dropbox\Haptics research\Data and docs\recording_list.xlsx';

% Subject 1
Data_table = readtable(xls_path,'sheet','Subj1_Xianda');
data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-11-20'; %Subject 1: Xianda

% % Subject 2
% Data_table = readtable(xls_path,'sheet','Subj2_Phil');
% data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-12-10'; %Subject 2: Phil

% % Subject 3
% Data_table = readtable(xls_path,'sheet','Subj3_Yitian');
% data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-12-11'; %Subject 3: Yitian

% % Subject 4
% Data_table = readtable(xls_path,'sheet','Subj4_Darshan');
% data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-12-19'; %Subject 4: Darshan

frame_rate = 120; % in Hz
duration = 0.5; % in seconds

% % For old version:
% Data_array = table2cell(Data_table);
% Left_JA_col_index = 6;
% Right_JA_col_index = 7;
% %

mimicHand = 'left';
num_trials = size(Data_table,1);
hand_DOF = 20; % using 20-DOF hand model
% Grasping_Phase = 'reaching';

palm_marker_index = 26:33;
finger_marker_index =reshape(1:25,5,5)';
b1_b2_index =[32,28];
b3_cmc4_index =[33,26];

% those below are the marker index on the tip of each finger, for
% calculating MGA
thumb_marker_index = 1;
index_marker_index = 6;

for j=1:num_trials
    
    
    % get path for one file
    csv_path = fullfile(data_dir,Data_table.filename{j});
    
    % get joint asngles for Left and Right hand separately
    % Left Hand
    marker_set_LeftHand = 'LeftHand';
    marker_pos_LeftHand = Read_data(csv_path,marker_set_LeftHand);
    GA_LeftHand = calcEdist(marker_pos_LeftHand,thumb_marker_index,index_marker_index);
    joint_angles_LeftHand = getJointAngles(marker_pos_LeftHand,...
        palm_marker_index,finger_marker_index,b1_b2_index,b3_cmc4_index);
    
    % Right Hand
    marker_set_RightHand = 'RightHand';
    marker_pos_RightHand = Read_data(csv_path,marker_set_RightHand);
    GA_RightHand = calcEdist(marker_pos_RightHand,thumb_marker_index,index_marker_index);
    joint_angles_RightHand = getJointAngles(marker_pos_RightHand,...
        palm_marker_index,finger_marker_index,b1_b2_index,b3_cmc4_index);
    
    
    % put the joint angles into "Data_array"
%     % early version
%     Data_array{j,6} = joint_angles_LeftHand;
%     Data_array{j,7} = joint_angles_RightHand;
%     %
    Data_table.joint_angles_LeftHand{j} = joint_angles_LeftHand;
    Data_table.joint_angles_RightHand{j} = joint_angles_RightHand;
    
    Data_table.GA_LeftHand{j} = GA_LeftHand;
    Data_table.GA_RightHand{j} = GA_RightHand;
end

%%%%%%% Data extracted from the above script are saved in folders
%%%%%%% "LeftMimicRight" and "RightMimicLeft" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PCA and E-distance calculation
% put all the data into a 2D matrix for PCA

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
scatter3(score(1:60,1),score(1:60,2),score(1:60,3));
hold on
scatter3(score(61:120,1),score(61:120,2),score(61:120,3),'red');
legend('Left Hand','Right Hand');

% show the detailed classification
figure
size = 50; 
% 1. cone
scatter3(score(1:5,1),score(1:5,2),score(1:5,3),size,[ 1 1 0 ],'o');%  async
hold on
scatter3(score(6:10,1),score(6:10,2),score(6:10,3),size,[ 1 1 0],'*');%  sync

% 2. cylinder 
scatter3(score(11:15,1),score(11:15,2),score(11:15,3),size,[  1 0 1],'o');% async
scatter3(score(16:20,1),score(16:20,2),score(16:20,3),size,[  1 0 1],'*');% sync

% 3. drum
scatter3(score(21:25,1),score(21:25,2),score(21:25,3),size,[ 0 1 1],'o');% async
scatter3(score(26:30,1),score(26:30,2),score(26:30,3),size,[ 0 1 1],'*');% sync

% 4. mouse
scatter3(score(31:35,1),score(31:35,2),score(31:35,3),size,[ 1 0 0],'o');% async
scatter3(score(36:40,1),score(36:40,2),score(36:40,3),size,[ 1 0 0],'*');% sync

% 5. papercup
scatter3(score(41:45,1),score(41:45,2),score(41:45,3),size,[ 0 1 0],'o');% async
scatter3(score(46:50,1),score(46:50,2),score(46:50,3),size,[ 0 1 0],'*');% sync

% 6. pen
scatter3(score(51:55,1),score(51:55,2),score(51:55,3),size,[ 0 0 1],'o');% async
scatter3(score(56:60,1),score(56:60,2),score(56:60,3),size,[ 0 0 1],'*');% sync

% right hand
scatter3(score(61:120,1),score(61:120,2),score(61:120,3),size,'s');
legend('cone async','cone sync','cylinder async','cylinder sync','drum async','drum sync',...
    'mouse async','mouse sync','papercup async','papercup sync','pen async','pen sync','RIGHT HAND');