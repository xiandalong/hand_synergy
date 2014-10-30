%% 1. Get joint angles for index and middle fingers

% This is a master script for getting joint angle information using
% trigonometry, the marker configuration is the same as Example 3 in
% Todorov's paper

% Overall: thumb-2 joints, index~pinky-3 joints each

% function "calcJointAngle" will be used to calculate joint angle for a
% specific finger. This function will be universal to all fingers as long
% as the markers has the following patterns: one marker on the most distal
% phalange and two markers with appropriate distance on all the other
% phalanges


clear all;
clc;

% (1). read data from exported .csv file, "marker_pos" is the final output
Read_data;

% (2). select one finger at a time and calculate joint angles

% index finger
index_marker_index = [1 2 3 4 5 11 12];
index_joint_angles = calcJointAngle(marker_pos, index_marker_index);

% middle finger
middle_marker_index = [6 7 8 9 10 13 14];
middle_joint_angles = calcJointAngle(marker_pos, middle_marker_index);

%% 2. Get joint angles for all fingers
% getting joint angles for all fingers, including the joint angle between
% the palm and a each finger

% define the output as a 20*N matrix, N being the number of frames in the
% recording, and 20 is the total number of joints
joint_angles = zeros(20,size(marker_pos,2));

% The index of markers organized in groups 
palm_marker_index = [26 27 28 29 30]; % the order is [b1 b2 b3 cmc4, wrist]
finger_marker_index = [1 2 3 4 5; 6 7 8 9 10; 11 12 13 14 15; 16 17 18 19 20;...
    21 22 23 24 25];


% (1). read data from exported .csv file, "marker_pos" is the final output
Read_data;

% (2). get a palm plane by fitting all markers on palm into a plane

palm_normal_vector = calcPalmNormVector(marker_pos, palm_marker_index);

% (3). calculate ab-/adduction and MCP flexion angles(Type1)
% get the markers for the last two markers for each finger
proximal_marker_index = finger_marker_index(:,end-1:end);
b1_b2_index = [26 27]; %[ b1 b2 ]
b3_cmc4_index = [28 29]; % [ b3 cmc4 ]
% a. Thumb
joint_angles(:,[1 2])= calcMCPJoints(marker_pos,proximal_marker_index(1,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);
% b. Index
joint_angles(:,[5 6])= calcMCPJoints(marker_pos,proximal_marker_index(2,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);
% c. Middle
joint_angles(:,[9 10])= calcMCPJoints(marker_pos,proximal_marker_index(3,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);
% d. Ring
joint_angles(:,[13 14])= calcMCPJoints(marker_pos,proximal_marker_index(4,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);
% e. Pinky
joint_angles(:,[17 18])= calcMCPJoints(marker_pos,proximal_marker_index(5,:),b1_b2_index,b3_cmc4_index, palm_normal_vector);

% (4). calculate the flexion-only joints
% a. Thumb
thumb_marker_index = finger_marker_index(1,:);
joint_angles(:,[3 4]) = calcJointAngle(marker_pos, thumb_marker_index);
% b. Index
index_marker_index = finger_marker_index(2,:);
joint_angles(:,[7 8]) = calcJointAngle(marker_pos, index_marker_index);
% c. Middle
middle_marker_index = finger_marker_index(3,:);
joint_angles(:,[11 12]) = calcJointAngle(marker_pos, middle_marker_index);
% d. Ring
ring_marker_index = finger_marker_index(4,:);
joint_angles(:,[15 16]) = calcJointAngle(marker_pos, ring_marker_index);
% e. Pinky
pinky_marker_index = finger_marker_index(5,:);
joint_angles(:,[19 20]) = calcJointAngle(marker_pos, pinky_marker_index);

