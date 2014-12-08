%%% Get joint angles for all fingers on both hands %%%%%%%%%%%%%%%%%%%%%%%%
% getting joint angles for all fingers, including the joint angle between
% the palm and a each finger

% clear all;
% close all;
% clc;

%% (1). read marker position data and get joint angles

% Left Hand
csv_path = 'S:\Xianda\Dropbox\Haptics research\Data and docs\optiTrackData\Session 2014-11-20\cylinder_a1.csv';
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

%% (2). plotting and making animation for both hands
save_path='C:\Users\USER\Desktop\LeftHand.avi';
sma_factor=1;
plottingJointAngles(joint_angles_LeftHand,save_path, sma_factor);

save_path='C:\Users\USER\Desktop\RightHand.avi';
sma_factor=1;
plottingJointAngles(joint_angles_RightHand,save_path, sma_factor);