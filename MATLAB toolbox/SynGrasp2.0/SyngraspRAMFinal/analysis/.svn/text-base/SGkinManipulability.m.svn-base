%    SGkinManipulability - Evaluate the kinematic manipulability principal
%    directions
%
%    Usage: SGkinManipulability(Gamma,in_col,Wu,Wz)
%
%    Arguments:
%    Gamma = matrix of the homogeneous solution of grasp problem obtained
%    with the function SGquasistaticHsolution
%    in_col = the index indicating the columns of Gamma to consider in the
%    evaluation
%    Wu,Wz: weights matrices for the object displacement and the synergy
%    inputs, respectively 
%
%    Returns: 
%    kinmanipulability.V principal directions in the x space
%    kinmanipulability.D eigenvalues of the manipulability problem
%    kinmanipulability.ueig principal directions in the u space
%    kinmanipulability.zeig principal directions in the z space
%
%    References
%    D. Prattichizzo, M. Malvezzi, M. Gabiccini, A. Bicchi. On the 
%    Manipulability Ellipsoids of Underactuated Robotic Hands with 
%    Compliance. Robotics and Autonomous Systems, Elsevier, 2012.
%    http://sirslab.dii.unisi.it/papers/2012/PrattichizzoRAS2012Grasping.pdf
%
%    See also: SGquasistaticHsolution, SGforceManipulability
%
%    This file is part of SynGrasp (Synergy Grasping Toolbox).
%
%  Copyright (c) 2013, M. Malvezzi, G. Gioioso, G. Salvietti, D.
%     Prattichizzo,
%  All rights reserved.
% 
%  Redistribution and use with or without
%  modification, are permitted provided that the following conditions are met:
%      * Redistributions of source code must retain the above copyright
%        notice, this list of conditions and the following disclaimer.
%      * Redistributions in binary form must reproduce the above copyright
%        notice, this list of conditions and the following disclaimer in the
%        documentation and/or other materials provided with the distribution.
%      * Neither the name of the <organization> nor the
%        names of its contributors may be used to endorse or promote products
%        derived from this software without specific prior written permission.
% 
%  THIS SOFTWARE IS PROVIDED BY M. Malvezzi, G. Gioioso, G. Salvietti, D.
%  Prattichizzo, ``AS IS'' AND ANY
%  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
%  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%  DISCLAIMED. IN NO EVENT SHALL M. Malvezzi, G. Gioioso, G. Salvietti, D.
%  Prattichizzo BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
%  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
%  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
%  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
%  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
%  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function kinmanipulability = SGkinManipulability(Gamma,in_col,Wu,Wz)

Gamma_z = [Gamma.zrco Gamma.zrh Gamma.zrrb];
Gamma_u = [Gamma.uco Gamma.uh Gamma.urb];

nd = size(Gamma.wco,1);
nz = size(Gamma.zco,1);

switch nargin
    case 1
        in_col = [1:size(Gamma_z,2)];
        Wu = eye(nd);
        Wz = eye(nz);
    case 2
        Wu = eye(nd);
        Wz = eye(nz);
end
        
Gamma_zm = Gamma_z(:,in_col);
Gamma_um = Gamma_u(:,in_col);

A = Gamma_um'*Wu*Gamma_um;
B = Gamma_zm'*Wz*Gamma_zm;

[V,D] = eig(A,B);

ueig = Gamma_um*V;
zeig = Gamma_zm*V;

kinmanipulability.V = V;
kinmanipulability.D = D;
kinmanipulability.ueig = ueig;
kinmanipulability.zeig = zeig;


