%    example - SynGrasp demo concerning the anthropomorphic  hand
%
%    Usage: example
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
 
hand = SGdefineSynergies(hand,S(:,1:4),qm); 
 
figure(1)
SGplotHand(hand);
hand = SGmoveHand(hand,qm);
 
figure(2)
SGplotHand(hand);
hold on
 
hand = SGaddFtipContact(hand,1,1:5);
 
[hand,object] = SGmakeObject(hand); 
 
SGplotObject(object);

delta_zr = [0 1 0 0]';
variation = SGquasistatic(hand,object,delta_zr);

linMap = SGquasistaticMaps(hand,object);

% object rigid body motions
rbmotion = SGrbMotions(hand,object);


% find the optimal set of contact forces that minimizes SGVcost
E = ima(linMap.P);

ncont = size(E,2);

% contact properties
mu = 0.8;
alpha = 1/sqrt(1+mu^2);
%
fmin = 1;
%
fmax = 30;
%
k = 0.01;
% 
w = zeros(6,1);
% 
pG = pinv(object.G);

y0 = rand(ncont,1);

% options.Display = 'iter';
option.TolX = 1e-3;
option.TolFun = 1e-3;
option.MaxIter = 5000;
option.MaxFunEvals =500;

[yopt,cost_val] = fminsearch(@(y) SGVcost(w,y,pG,E,object.normals,mu, fmin,fmax,k),y0,option);

lambdaopt = E*yopt;

c = SGcheckFriction(w,yopt,pG,E,object.normals,alpha,k);

% solve the quasi static problem in the homogeneous form

Gamma = SGquasistaticHsolution(hand, object);