%% This code is used for plotting the joint angles
% adopted from the code in "example.m" in
% "\SynGrasp2.0\SyngraspRAMFinal\examples\Basic"

% close all
% clear all
% clc

%%% initialize parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hand = SGparadigmatic;

%%% smoothing the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%
joint_angles_sm = zeros(size(joint_angles));
num_frame = size(joint_angles,2);

sma_factor = 10;

weight = ones(1,sma_factor)/sma_factor;

for j=1:size(joint_angles,1)
    joint_angles_sm(j,:) = conv(joint_angles(j,:),weight, 'same');
end
%%% create video writer %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writerObj = VideoWriter('joint_angle_movement_10SMA.avi');
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