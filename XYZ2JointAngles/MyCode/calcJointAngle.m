% This function is used to calculate joint angle for a
% specific finger. This function will be universal to all fingers as long
% as the markers has the following patterns: one marker on the most distal
% phalange and two markers with appropriate distance on all the other
% phalanges

% Inputs:
%  marker_pos: a N*Frame 2-D matrix with each row represnts one marker
%  position,and the rows are in ascending order
%  finger_maker_index: a 1*M 1-D vector containing all marker indices for markers on
%  this finger, it starts with the most distal marker.
% Outputs:
%  joint_angles: it's a (M+1)/2 * Frame 2-D matrix containing all joint angles
%  on this finger for each frame

function joint_angles = calcJointAngle(marker_pos, finger_marker_index)

num_marker = length(finger_marker_index);
num_joints = (num_marker-1)/2;
num_frame = size(marker_pos,2);
% initialize output
joint_angles = zeros(num_joints, num_frame);

% get the indices for all markers on this finger
finger_marker_index_XYZ = [finger_marker_index*3-2;finger_marker_index*3-1;finger_marker_index*3];
finger_marker_index_XYZ = finger_marker_index_XYZ(:);

% get marker positions for this finger
marker_pos_finger = marker_pos(finger_marker_index_XYZ,:);

% 1. Take care of the first joint (most distal one), the more distal
% phalange is considered as phalange1, and the one closer to palm is called
% phalange2. This convention also applies to the other fingers
markers_pos_joint1 = marker_pos_finger(1*3-2:3*3,:);

% convert marker positions into vectors
phalange1 = markers_pos_joint1(4:6,:)-markers_pos_joint1(1:3,:);
phalange2 = markers_pos_joint1(7:9,:)-markers_pos_joint1(4:6,:);

% calculate joint angle
theta = acosd(sum(phalange1.*phalange2,1)./((sqrt(sum(phalange1.^2,1)).*(sqrt(sum(phalange2.^2,1))))));

joint_angles(1,:) = theta;

% 2. Calculate joint angles for the rest of joints
for joint_index = 2:num_joints % go from the 2nd joint
    % get marker positions for one joint
    markers_pos_jointX = marker_pos_finger(joint_index*2*3-8:joint_index*2*3+3,:);
    
    % convert marker positions into vectors
    phalange1 = markers_pos_jointX(4:6,:)-markers_pos_jointX(1:3,:);
    phalange2 = markers_pos_jointX(10:12,:)-markers_pos_jointX(7:9,:);
    % calculate joint angle
    theta = acosd(sum(phalange1.*phalange2,1)./((sqrt(sum(phalange1.^2,1)).*(sqrt(sum(phalange2.^2,1))))));
    joint_angles(joint_index,:) = theta;
    
end

end