%function that calculates cube data organized as a structure.
%                                  3
%faces as cube opened, top view: 4 5 2 6
%                                  1
function struct = SGcube(Htr,a,b,c)

if nargin < 3
    b = a;
    c = a;
end
if nargin >3 && nargin < 4
    c = b; %arbitrariamente imposto c=b se non specificato
end
struct.type = 'cube';
struct.center = Htr(1:3,4);

%vertices:
Hv1=Htr*SGtransl([a/2,-b/2,-c/2]) ;
v1=Hv1(1:3,4); %vertex 1
Hv2=Htr*SGtransl([a/2,b/2,-c/2]) ;
v2=Hv2(1:3,4); %vertex 2
Hv3=Htr*SGtransl([-a/2,b/2,-c/2]);
v3=Hv3(1:3,4); %vertex 3
Hv4=Htr*SGtransl([-a/2,-b/2,-c/2]);
v4=Hv4(1:3,4); %vertex 4
Hv5=Htr*SGtransl([-a/2,-b/2,c/2]);
v5=Hv5(1:3,4); %vertex 5
Hv6=Htr*SGtransl([a/2,-b/2,c/2]);
v6=Hv6(1:3,4); %vertex 6
Hv7=Htr*SGtransl([a/2,b/2,c/2]);
v7=Hv7(1:3,4); %vertex 7
Hv8=Htr*SGtransl([-a/2,b/2,c/2]);
v8=Hv8(1:3,4); %vertex 8

%faces

struct.Htr = Htr;
struct.dim = [a,b,c];
struct.faces.f1=[v1,v2,v7,v6];
struct.faces.f2=[v2,v3,v8,v7];
struct.faces.f3=[v3,v4,v5,v8];
struct.faces.f4=[v4,v1,v6,v5];
struct.faces.f5=[v1,v4,v3,v2];
struct.faces.f6=[v7,v8,v5,v6];

end