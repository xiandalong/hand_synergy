% This function is used to calculate joint angles between the proximal
% phalanges and the palm (MCP joints) for all digits except for the thumb.

% Inputs:
%  marker_pos: a N*Frame 2-D matrix with each row represnts one marker
%  position,and the rows are in ascending order
%  proximal_maker_index: a 1*2 1-D vector containing two marker indices for markers on
%  the proximal phalange of this finger, it starts with the most distal marker.
% Outputs:
%  joint_angles: it's a 1*Frame 2-D matrix containing the two joint angles
% for each frame: the 1st row represents radial abduction
% angle for each frame, the 2nd row represents fexion angle for each frame

function joint_angles = calcMCPJoints(marker_pos,proximal_marker_index,b1_b2_index,palm_normal_vector)

num_frame = size(marker_pos,2);
% initialize output
joint_angles = zeros(2, num_frame);

% get the indices for markers on proximal phalange of this finger, and
% also for b1-b2
proximal_marker_index_XYZ = [proximal_marker_index*3-2;proximal_marker_index*3-1;proximal_marker_index*3];
proximal_marker_index_XYZ = proximal_marker_index_XYZ(:);

b1_b2_index_XYZ = [b1_b2_index*3-2;b1_b2_index*3-1;b1_b2_index*3];
b1_b2_index_XYZ = b1_b2_index_XYZ(:);

% get marker positions for the proximal phalange, and b1-b2
marker_pos_proximal_phalange = marker_pos(proximal_marker_index_XYZ,:);
marker_pos_b1_b2 = marker_pos(b1_b2_index_XYZ,:);

% get vectors representing proximal phalanges, and b1-b2
vectors_proximal_phalange = marker_pos_proximal_phalange(1:3,:)-marker_pos_proximal_phalange(4:6,:);
vector_b1_b2 = marker_pos_b1_b2(4:6,:)-marker_pos_b1_b2(1:3,:);




