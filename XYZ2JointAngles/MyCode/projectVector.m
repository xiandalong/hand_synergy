% This function calculates the projected vector from the original vector P
% onto the plane specified by the normal vector N

% INPUT: 
%  P: a 3*frame matrix presents a vector in 3D space
%  N: a 3*frame matrix represents the normal vector of a plane

% Outputs:
%  Q: a 3*frame matrix represents the projected vector

function [ Q ] = projectVector( P, N )

Q = P-repmat(dot(N,P),3,1).*N;

end

