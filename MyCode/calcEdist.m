% this function is used to calculate the Euclidean distance from one marker to another,
%  can be used to calculte maximum grip aperture which is the E-distance from tip of
%  thumb to the tip of index finger.
% INPUTS:
%  marker_pos: marker position data read from the .csv files, a N*Frame 2-D matrix with each row represnts one marker
%      position,and the rows are in ascending order
%  marker1_index: the index of marker on the thumb tip
%  marker2_index: the index of marker on the index finger tip
% OUTPUT:
%  Edist: the Euclidean distance for each frame returned as a 1-D array
function Edist = calcEdist(marker_pos,marker1_index,marker2_index)

% get the indices for XYZ coordinates for both marker 
marker1_index_XYZ = [marker1_index*3-2;marker1_index*3-1;marker1_index*3];
marker2_index_XYZ = [marker2_index*3-2;marker2_index*3-1;marker2_index*3];

% get the marker coordinates for each marker
marker1_pos = marker_pos(marker1_index_XYZ,:);
marker2_pos = marker_pos(marker2_index_XYZ,:);

% calculate the E-distance
Edist = sqrt(sum((marker1_pos-marker2_pos).^2,1));

end