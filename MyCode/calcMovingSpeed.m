% this function is used to calculate the moving speed of one hand
% INPUTS:
%  marker_pos: marker position data read from the .csv files, a N*Frame 2-D matrix with each row represnts one marker
%      position,and the rows are in ascending order
%  wrist_marker_index: the index of marker on the wrist
% OUTPUT:
%  moving_speed: the resultant of speeds on x, y and z axis, the unit is
%  meters per second(m/s)
function moving_speed = calcMovingSpeed(marker_pos,wrist_marker_index,frame_rate)

% get the indices for XYZ coordinates for both marker 
wrist_marker_index_XYZ = [wrist_marker_index*3-2;wrist_marker_index*3-1;wrist_marker_index*3];

% get the marker coordinates for each marker
wrist_marker_pos = marker_pos(wrist_marker_index_XYZ,:);

% calculate the speed of wrist marker on x, y and z as the difference of 
% consecutive samples on each axis
correct_val = 0.3143; % because 70mm in virtual space represents 22mm in real space
moving_speed_XYZ = [[0;0;0],diff(wrist_marker_pos,1,2)]*frame_rate*correct_val;
moving_speed = sqrt(sum(moving_speed_XYZ.^2,1));

end