%    SGexampleWriting - SynGrasp demo concerning the anthropomorphic  hand
%    writing
%
%    Usage: SGexampleWriting
%
%    The demo includes
%    hand model, contact point definition, synergy and stiffness matrices, 
%    grasp analysis, evaluation and minimization of grasp quality cost
%    function,friction constraint analysis
% 
%    Copyright (c) 2012 M. Malvezzi, G. Gioioso, G. Salvietti, D.
%    Prattichizzo, A. Bicchi
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
%    SynGrasp is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    SynGrasp is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with SynGrasp. If not, see <http://www.gnu.org/licenses/>.

close all
clear all
clc
    
hand = SGparadigmatic;

[qm, S] = SGsantelloSynergies;
 
hand = SGdefineSynergies(hand,S,1:15); 


%%%% choose the writing configuration
hand = SGhumanWritingConf(hand);

  
%%%% contact points
% 
% thumb and index fingertip
hand = SGaddFtipContact(hand,1,1:2);
% DP joint of the middle finger
hand = SGaddContact(hand,1,3,3,1);

% define the pencil
[hand,object] = SGcontact_old('auto',hand); 

object.center(1) = object.center(1)+12;
object.center(3) = object.center(3)-30;
object.center(2) = object.center(2)+10;
% % 
%%%%% plot the hand, contact points and contact normals
figure(2)
view([-144 10]);

hold on
% plot the contact points and contact normals
plot3(object.center(1),object.center(2),object.center(3),'rd','LineWidth',3,'MarkerSize',8)
hold on
grid on
for i = 1:size(hand.cp,2)
    % assign the contact point to the respective finger
    plot3(hand.cp(1,i),hand.cp(2,i),hand.cp(3,i),'m*','Linewidth',2,'MarkerSize',8)
    quiver3(hand.cp(1,i),hand.cp(2,i),hand.cp(3,i),object.normals(1,i),object.normals(2,i),object.normals(3,i),10,'LineWidth',2)
end
axis('equal')
out = SGdefinePencil(object);
SGplotHand(hand)
 
% 
% re - define hand Jacobian and grasp matrix in the new configuration
hand.Jtilde = SGjacobianMatrix(hand);
H = SGselectionMatrix(object);
object.H = H;
hand.H = H;
hand.J = H*hand.Jtilde;
object.Gtilde = SGgraspMatrix(object);
object.G = object.Gtilde*hand.H';

[nl,nq]= size(hand.J);
[nd]= size(object.G,1);
% 
% choose the synergy indexes
 syn_index = 1:6;
% 
% 
% choose the corresponding columns
 S_rid = S(:,syn_index);
 hand.S = S_rid;
 nz = size(hand.S,2);

 
% define the stiffness matrices
% 
 Ks = eye(nl);
 Kq = eye(nq);
 Kz = eye(nz);
 
object = SGcontactStiffness(object,Ks);
hand = SGjointStiffness(hand,Kq);
hand = SGsynergyStiffness(hand,Kz);
  
% 
 %%%%% constant synergy matrix
 Ksz = zeros(nz,nz);
 Kjq = zeros(nq,nq);
 Kju = zeros(nq,nd);

% evaluate the homogeneous quasi static solution
Gamma = SGquasistaticHsolution(hand,object);

% define numerator and denominator terms, e.g. consider only rigid body
% object motions

Gamma_zc = Gamma.zrrb;
Gamma_uc = Gamma.urb;

% define the weight matrices 
  Wu = eye(nd);
  Wz = eye(nz);
% % 

% evaluate the kinematic manipulability ellipsoid
[ueig,zeig,kinellips] = SGkineManipul(Gamma_uc, Gamma_zc, Wu, Wz);

% translate the kinematic ellipsoid on the pen tip
% 
[r,c] = size(kinellips.u1);
for i = 1:r
    for j = 1:c

        u1t(i,j) = kinellips.u1(i,j)+object.center(1);
        u2t(i,j) = kinellips.u2(i,j)+object.center(2);
        u3t(i,j) = kinellips.u3(i,j)+object.center(3);
    end
end
% 
% draw the kinematic manipulability ellipsoid in the workspace
% 
 figure(2)
 hold on
 axis([-60 30 40 120 -100 50])
 mesh(u1t,u2t,u3t)
