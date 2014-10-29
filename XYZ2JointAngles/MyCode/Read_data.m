% read content from the .csv file exported from Motive
filepath = 'S:\Xianda\hand_synergy\optiTrackData\Session 2014-10-13\Take 2014-10-13 02.41.46 PM_example_layout_retrajectorized.csv';
marker_set_name = 'example_layout';

[~,~,raw_marker_pos] = xlsread( filepath);

% shift by two columns because the first two columns in the raw sheet is "NAN"
selected_col = find(~cellfun(@isempty,regexp(raw_marker_pos(4,3:end),marker_set_name))) +2; 

% take out all the columns corresponds to the 14 markers
marker_pos_temp = raw_marker_pos(4:end,selected_col); 

% extract the marker index for each column
num_index = size(marker_pos_temp,2);
marker_index = zeros(1, num_index);
for j=1:num_index
    marker_index(j) = str2double(cell2mat(regexp(marker_pos_temp{1,j},'\d+','match')));
end

% rearrange the matrix so the columns are ordered by the marker index
% e.g. X,Y,Z of "example_layout-1" corresponds to columns 1-3, X,Y,Z of
% "example_layout-2" corresponds to columns 4-6 etc.
[C,ia,ic] = unique(marker_index); % ia will be the re-ordered marker index of X to achieve order of "example_layout_1,2,3..."
new_order = [ia,ia+1,ia+2]';
new_order = new_order(:);
new_order_checklist = (marker_pos_temp([1 4],new_order))'; % !!! CHECK "new_order_checklist" to make sure the output is correctly re-ordered

% marker_pos contains a matrix with each column represents one frame and each row represents coordinates for X/Y/Z
marker_pos = (cell2mat(marker_pos_temp(5:end, new_order)))';