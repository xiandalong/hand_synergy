% This function is used to calculate joint angles between the proximal
% phalanges and the palm (MCP joints) for all digits except for the thumb.

% vector b1-b2 and b3-cmc4 will be calculated and use their cross product
% (we call this reference vector) to set the ventral direction of palm, and
% then by calculating their dot product, if it's positive, we know the
% normal vector is going towards the ventral side, otherwise it's going
% towards the dorsal side, which means it needs to be multiplied by -1 to
% switch to the other side.

% Inputs:

%  marker_pos: a N*Frame 2-D matrix with each row represnts one marker
%   position,and the rows are in ascending order

%  proximal_maker_index: a 1*2 1-D vector containing two marker indices for markers on
%   the proximal phalange of this finger, it starts with the most distal marker.

%  b1_b2_index: a 1*2 1-D vector containing two marker indices for markers on
%   b1 and b2 on the palm.

%  b3_cmc4_index: a 1*2 1-D vector containing two marker indices for markers on
%   b3 and cmc4 on the palm.

%  palm_normal_vector: it's a 3* Frame 2-D matrix containing normal vector of
%   the palm plane for each frame

% Outputs:

%  joint_angles: it's a 1*Frame 2-D matrix containing the two joint angles
% for each frame: the 1st row represents radial abduction
% angle for each frame, the 2nd row represents fexion angle for each frame

% 11/13/2014 v1.1 update: 
% Algorithm simplified by removing unnecessary steps:
% removed the norm vector correction part, compare 
% the cross product of b1-b2 and b3-cmc4 (reference vector) with the cross 
% product of b1-b2 and projected proximal phalange directly, in order to
% get the direction/sign(+/-) of radial joint angle. The output was
% confirmed to be the same.

function joint_angles = calcMCPJoints(marker_pos,proximal_marker_index,b1_b2_index,b3_cmc4_index, palm_normal_vector)

num_frame = size(marker_pos,2); 
% initialize output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
joint_angles = zeros(2, num_frame);

% get the indices for markers on proximal phalange of this finger, and
% also for b1-b2, b3-cmc4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
proximal_marker_index_XYZ = [proximal_marker_index*3-2;proximal_marker_index*3-1;proximal_marker_index*3];
proximal_marker_index_XYZ = proximal_marker_index_XYZ(:);

b1_b2_index_XYZ = [b1_b2_index*3-2;b1_b2_index*3-1;b1_b2_index*3];
b1_b2_index_XYZ = b1_b2_index_XYZ(:);

b3_cmc4_index_XYZ = [b3_cmc4_index*3-2;b3_cmc4_index*3-1;b3_cmc4_index*3];
b3_cmc4_index_XYZ = b3_cmc4_index_XYZ(:);

% get marker positions for the proximal phalange, and b1-b2 %%%%%%%%%%%%%%
marker_pos_proximal_phalange = marker_pos(proximal_marker_index_XYZ,:);
marker_pos_b1_b2 = marker_pos(b1_b2_index_XYZ,:);
marker_pos_b3_cmc4 = marker_pos(b3_cmc4_index_XYZ,:);

% get vectors representing proximal phalanges, and b1-b2, b3-cmc4 %%%%%%%%
vector_proximal_phalange = marker_pos_proximal_phalange(1:3,:)-marker_pos_proximal_phalange(4:6,:);
vector_b1_b2 = marker_pos_b1_b2(4:6,:)-marker_pos_b1_b2(1:3,:);
vector_b3_cmc4 = marker_pos_b3_cmc4(4:6,:)-marker_pos_b3_cmc4(1:3,:);

% get reference vector for each frame %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vector_ref = zeros(3,num_frame);
% for j = 1:num_frame
%     vector_ref(:,j) = cross(vector_b1_b2(:,j),vector_b3_cmc4(:,j));
% end

% OR WE CAN USE:
vector_ref = cross(vector_b1_b2,vector_b3_cmc4,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % calculate the dot product and correct the direction of normal vector for
% % each frame %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dotProduct_matrix = dot(vector_ref, palm_normal_vector,1);
% correction_matrix = sign(dotProduct_matrix);
% correction_matrix = repmat(correction_matrix,3,1);
% 
% palm_normal_vector_corrected = correction_matrix.*palm_normal_vector; % now all the normal vectors in "palm_normal_vector_corrected" are pointing to the ventral side.
% 
% % NOTICE: even though the corrected norm vector can be useful, it's not
% % necessary

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% project vectors representing proximal phalanges and b1-b2 onto the palm
% plane %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
proj_vector_proximal_phalange = projectVector( vector_proximal_phalange, palm_normal_vector );
proj_vector_b1_b2 = projectVector( vector_b1_b2, palm_normal_vector);

% calculate the ab-/adduction angle %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. decide which direction is this angle (radial side +, ulnar side -)
sign_multiplier = sign(dot(vector_ref,cross(proj_vector_proximal_phalange,proj_vector_b1_b2,1),1));
% 2. calculte the angle between the projected vectors
joint_angles(1,:) = sign_multiplier.* acosd(dot(proj_vector_proximal_phalange,proj_vector_b1_b2,1)./...
    (sqrt(sum(proj_vector_proximal_phalange.^2,1)).*(sqrt(sum(proj_vector_b1_b2.^2,1)))));

% calculate the fexion angle %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
joint_angles(2,:) = acosd(dot(proj_vector_proximal_phalange,vector_proximal_phalange,1)./...
    (sqrt(sum(proj_vector_proximal_phalange.^2,1)).*(sqrt(sum(vector_proximal_phalange.^2,1)))));

end
