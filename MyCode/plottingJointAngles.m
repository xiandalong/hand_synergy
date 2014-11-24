%% This code is used for plotting the joint angles
% adopted from the code in "example.m" in
% "\SynGrasp2.0\SyngraspRAMFinal\examples\Basic"
% 11/24/2014 update: wrap it inside a function

function plottingJointAngles(joint_angles,save_path, sma_factor)
% close all
% clear all
% clc

% joint_angles is a N by M matrix, where N is total number of joint angles
% and M is the total number of frames for a trial/recording

%%% initialize parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hand = SGparadigmatic;

%%% smoothing the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%
joint_angles_sm = zeros(size(joint_angles));
num_frame = size(joint_angles,2);

% sma_factor = 10;

weight = ones(1,sma_factor)/sma_factor;

for j=1:size(joint_angles,1)
    joint_angles_sm(j,:) = conv(joint_angles(j,:),weight, 'same');
end
%%% create video writer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writerObj = VideoWriter(save_path);
writerObj.FrameRate = 120;
writerObj.Quality = 100;
open(writerObj);

for j=1:num_frame
    
    q = joint_angles_sm(:,j);
    qm_my=q*pi/180';
    hand = SGmoveHand(hand,qm_my);
    SGplotHand(hand);
    grid on
    axis([-100 100 -180 0 -60 20 ]);
    
    frame = getframe;
    writeVideo(writerObj,frame);
    
end

close(writerObj);

%% This part is to plot joint angle time series
t = (1:num_frame)/writerObj.FrameRate;
plot(t, joint_angles');
axis tight;
xlabel('time/sec');
ylabel('joint angle/degree');
title('Joint Angle Time Series');

end