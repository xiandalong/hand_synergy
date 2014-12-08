tic

%% read all the data from the *.csv files and convert into joint angles
xls_path = 'S:\Xianda\Dropbox\Haptics research\Data and docs\recording_list.xlsx';
table = readtable(xls_path);

data_dir = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-11-20';

frame_rate = 120; % in Hz
duration = 0.5; % in seconds

Data_array = table2cell(table);
Left_JA_col_index = 6;
Right_JA_col_index = 7;

for j=1:size(table,1)
    
    tic
    
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
    joint_angles_LeftHand = joint_angles_LeftHand(:,table.start_frame(j):table.start_frame(j)+frame_rate*duration-1);
    joint_angles_RightHand = joint_angles_RightHand(:,table.start_frame(j):table.start_frame(j)+frame_rate*duration-1);
    
    % put the joint angles into "Data_array"
    Data_array{j,6} = joint_angles_LeftHand;
    Data_array{j,7} = joint_angles_RightHand;

    toc
end




toc
