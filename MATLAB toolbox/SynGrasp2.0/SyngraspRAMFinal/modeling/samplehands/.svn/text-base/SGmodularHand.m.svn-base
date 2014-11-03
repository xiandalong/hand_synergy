%    SGmodularHand
%
%    The function builds the Modular hand model
%
%    Usage: hand = SGmodularHand
%
%    Returns:
%    hand = the Modular hand model
%
%    References:
%    G.Gioioso,G.Salvietti,M.Malvezzi,andD.Prattichizzo,
%    "An object-based approach to map human hand synergies onto robotic
%    hands with dissimilar kinematics"
%    in Robotics: Science and Systems VIII. Sidney, Australia: The MIT Press, July 2012.
%
%    See also: SGParadigmatic, SG3Fingered, SGDLRHandII

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

function newHand = SGmodularHand(T)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    1 - M O D U L A R   H A N D    P A R A M E T E R S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Pre-allocation
DHpars{3} = [];
base{3} = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Thumb
DHpars{1}=[
   
   0 38 0 0;
   0 38 0 0;
   0 31 0 0;
];
base{1} = [
    1 0 0 48;
    0 0 1 0;
    0 -1 0 0;
    0 0 0 1;
];

% base{1} = [
%     1 0 0 48;
%     0 1 0 0;
%     0 0 1 0;
%     0 0 0 1;
% ];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Index
DHpars{2}=[
   
   0 38 0 0;
   0 38 0 0;
   0 31 0 0;
];
base{2} = [
    0 0 -1 0;
    1 0 0 52;
    0 -1 0 0;
    0 0 0 1;
];
  

% base{2} = [
%     0 0 -1 0;
%     0 1 0 0;
%     1 0 0 52;
%     0 0 0 1;
% ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Middle
DHpars{3}=[   
   0 38 0 0;
   0 38 0 0;
   0 31 0 0;
];
base{3} = [    
    -1 0 0 -48;
    0 0 -1 0;
    0 -1 0 0;
    0 0 0 1;
];

% base{3} = [    
%     -1 0 0 -48;
%     0 1 0 0;
%     0 0 -1 0;
%     0 0 0 1;
% ];


%%% Pre-allocation
F{3} = [];
 
for i = 1:length(DHpars)
    % number of joints for each finger
    joints = size(DHpars{i},1);
    % initialize joint variables
    q = zeros(joints,1);
    % make the finger
    if (nargin == 1)
        F{i} = SGmakeFinger(DHpars{i},T*base{i},q);
    else
        F{i} = SGmakeFinger(DHpars{i},base{i},q);
    end
end


newHand = SGmakeHand(F);
newHand.type = 'Modular';