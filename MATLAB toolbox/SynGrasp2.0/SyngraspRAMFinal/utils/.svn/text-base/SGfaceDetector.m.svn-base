function face = SGfaceDetector(CP,obj)

CP_tilde=inv(obj.Htr)*[CP;1];
CP = CP_tilde(1:3);
CP=CP';
V=[obj.faces.f1,obj.faces.f2,obj.faces.f3,obj.faces.f4,obj.faces.f5,obj.faces.f6];

Inv = inv(obj.Htr);
V_tilde = zeros(size(Inv,1),24);
for cont=1:24
    V_tilde(:,cont) = Inv * [V(:,cont);1];
end

for i=1:4:24
    if (distancePointPlane(CP,[V_tilde(1:3,i)',V_tilde(1:3,i+1)',V_tilde(1:3,i+2)']) <= 0.0001)
        face = SGindexReduction(i);
    end
end
end