% This function is used for calculating the normal vector of the palm for
% all the frames during the recording

% INPUT: 
%  marker_pos:a N*Frame 2-D matrix with each row represnts one marker
%  position,and the rows are in ascending order
%  palm_maker_index: a 1*M 1-D vector containing all marker indices for markers on
%  the palm, the order does not matter.

% Outputs:
%  palm_norm_vector: it's a 3* Frame 2-D matrix containing normal vector of
%  the palm plane for each frame

function palm_norm_vector = calcPalmNormVector(marker_pos, palm_marker_index)


num_frame = size(marker_pos,2);
% 1. get the indices for XYZ for all markers
palm_marker_index_XYZ = [palm_marker_index*3-2;palm_marker_index*3-1;palm_marker_index*3];
palm_marker_index_XYZ = palm_marker_index_XYZ(:);

% 2. get the markers on the palm
palm_marker_pos = marker_pos(palm_marker_index_XYZ,:);

% 3. for each frame, fit the palm markers to a plane with least square
% error and get its normal vector
palm_norm_vector = zeros(3, num_frame);

for frame_index = 1:num_frame
    
    % get palm marker position for a frame
    palm_marker_pos_snap = palm_marker_pos(:,frame_index);
    % make it in a format of [X1,Y1,Z1;Z2,Y2,Z2;...]
    palm_marker_pos_snap = (reshape( palm_marker_pos_snap,[3,length(palm_marker_pos_snap)/3] ) )';
    
    palm_norm_vector(:,frame_index)= affine_fit(palm_marker_pos_snap);
    
end

end