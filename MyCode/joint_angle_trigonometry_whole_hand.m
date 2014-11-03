%% 2. Get joint angles for all fingers
% getting joint angles for all fingers, including the joint angle between
% the palm and a each finger

clear all;clc;

% (1). read data from exported .csv file, "marker_pos" is the final output
filepath = 'S:\Xianda\hand_synergy\optiTrackData\Session 2014-10-28\Take 2014-10-28 12.39.08 AM.csv';
marker_set_name = 'LeftHand';
marker_pos = Read_data(filepath,marker_set_name);


% define the output as a 20*N matrix, N being the number of frames in the
% recording, and 20 is the total number of joints
joint_angles = zeros(20,size(marker_pos,2));

% The index of markers organized in groups 
palm_marker_index = [26 27 28 29 30]; % the order is [b1 b2 b3 cmc4, wrist]
finger_marker_index = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15; 16 17 18 19 20;...
    21 22 23 24 25];


% (2). get a palm plane by fitting all markers on palm into a plane

palm_normal_vector = calcPalmNormVector(marker_pos, palm_marker_index);

% (3). calculate ab-/adduction and MCP flexion angles(Type1)
% get the markers for the last two markers for each finger
proximal_marker_index = finger_marker_index(:,end-1:end);
b1_b2_index = [26 27]; %[ b1 b2 ]
b3_cmc4_index = [28 29]; % [ b3 cmc4 ]
% a. Thumb
joint_angles([1 2],:)= calcMCPJoints(marker_pos,proximal_marker_index(1,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);
% b. Index
joint_angles([5 6],:)= calcMCPJoints(marker_pos,proximal_marker_index(2,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);
% c. Middle
joint_angles([9 10],:)= calcMCPJoints(marker_pos,proximal_marker_index(3,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);
% d. Ring
joint_angles([13 14],:)= calcMCPJoints(marker_pos,proximal_marker_index(4,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);
% e. Pinky
joint_angles([17 18],:)= calcMCPJoints(marker_pos,proximal_marker_index(5,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);

% (4). calculate the flexion-only joints
% Notice the order of joints is always from distal end to proximal end of a
% finger
% a. Thumb
thumb_marker_index = finger_marker_index(1,:);
joint_angles([4 3],:) = calcJointAngle(marker_pos, thumb_marker_index);
% b. Index
index_marker_index = finger_marker_index(2,:);
joint_angles([8 7],:) = calcJointAngle(marker_pos, index_marker_index);
% c. Middle
middle_marker_index = finger_marker_index(3,:);
joint_angles([12 11],:) = calcJointAngle(marker_pos, middle_marker_index);
% d. Ring
ring_marker_index = finger_marker_index(4,:);
joint_angles([16 15],:) = calcJointAngle(marker_pos, ring_marker_index);
% e. Pinky
pinky_marker_index = finger_marker_index(5,:);
joint_angles([20 19],:) = calcJointAngle(marker_pos, pinky_marker_index);

