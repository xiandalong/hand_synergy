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

% (1). get a palm plane by fitting all markers on palm into a plane
palm_marker_index = [11 12 13 14];
palm_normal_vector = calcPalmNormVector(marker_pos, palm_marker_index);

% (2). calculate joint angle between plam and each finger