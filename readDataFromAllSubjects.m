clear;clc

root_dir = 'C:\Users\kelvi_000\OneDrive\Haptics research\hand_synergy\MyCode';
data_list = {'Data_Subject4.mat','Data_Subject3.mat','Data_Subject2.mat'};
% data_list = {'Data_Subject2.mat'};
num_subj = length(data_list);
% % Right hand mimicing left hand
% root_dir = 'S:\Xianda\Dropbox\Haptics research\hand_synergy\MyCode\RightMimicLeft';
% data_list = {'Data_Subj2.mat','Data_Subj3.mat','Data_Subj4.mat'};

Data_all = table();

frame_rate = 120; % in Hz
duration = 0.5; % in seconds
n_frames = frame_rate*duration;

% Left_JA_col_index = 6;
% Right_JA_col_index = 7;

% load data from all subjects
for j=1:length(data_list)
    
    data_path = fullfile(root_dir,data_list{j});
    load(data_path);
    Data_all = [Data_all;Data_table];
    clear Data_table;
    
end