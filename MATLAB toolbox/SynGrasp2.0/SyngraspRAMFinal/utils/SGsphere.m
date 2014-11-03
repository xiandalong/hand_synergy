%function that calculates main data of a sphere used by 
%grasping-related applications.  
%H = homogeneous transformation
%rad = radius
%res = number of points on the external surface

function struct = SGsphere(Htr,rad,res)
struct.type = 'sph';
struct.res = res;
struct.Htr = Htr;
struct.center = Htr(1:3,4);
struct.radius = rad;
[X,Y,Z] = sphere(res); %creates a unit sphere mesh

struct.p = zeros(3,size(X,2),size(X,1));
for k=1:size(X,1)
    for j=1:size(X,2)
        p = (rad)*[X(k,j);Y(k,j);Z(k,j)];
        p = [p;1];
        v = Htr*p;
        struct.p(:,j,k) = v(1:3);
    end
end

for i=1:size(X,1)
    for j=1:size(X,2)
        struct.X(i,j) = struct.p(1,j,i);
        struct.Y(i,j) = struct.p(2,j,i);
        struct.Z(i,j) = struct.p(3,j,i);
    end
end
end