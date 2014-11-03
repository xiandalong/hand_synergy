%% This code is used for plotting the joint angles
% adopted from the code in "example.m" in
% "\SynGrasp2.0\SyngraspRAMFinal\examples\Basic"

% close all
% clear all
% clc

hand = SGparadigmatic;

% [qm, S] = SGsantelloSynergies;
 
% hand = SGdefineSynergies(hand,S(:,1:4),qm); 
 
figure(1)
SGplotHand(hand);
q = zeros(1,20);
hand = SGmoveHand(hand,q);
SGplotHand(hand);
axis([-100 100 -180 180 -80 20 ]);


for j=1:size(joint_angles,2)
    
    q = joint_angles(:,j);
    qm_my=q*pi/180';
    hand = SGmoveHand(hand,qm_my);
    SGplotHand(hand);
    axis([-100 100 0 180 -80 20 ]);
    
end

