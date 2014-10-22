function [MocapData]= GetMocap()   
    global Mocap;
    data = Mocap.GetLastFrameOfData();    
    
    Markers={};
    RigidBodies={};
    if(data.nRigidBodies > 0)
        for ii=1:data.nRigidBodies 
            rb = data.RigidBodies(ii);
            for jj=1:rb.nMarkers               
                mm = rb.Markers(jj);                
                RigidBodies{ii,1}= struct('name',char(data.MarkerSets(ii).MarkerSetName),'x',newScale(mm.x),'y',-newScale(mm.z),'z', newScale(mm.y));
            end            
        end   
    end
    if (data.nOtherMarkers > 0)
        for jj=1:data.nOtherMarkers
            mm = data.OtherMarkers(jj);
            Markers{jj,1}=struct('x',newScale(mm.x),'y',-newScale(mm.z),'z', newScale(mm.y));
        end    
    end
    MocapData=struct('RigidBodies',{RigidBodies},'nRigidBodies',{size(RigidBodies,1)},'Markers',{Markers},'nMarkers',{size(Markers,1)});
end


function newVal = newScale(value)
    %precision to mm
    dVal = double(value);
    dVal = dVal*10000;
    dVal = round(dVal);
    dVal = dVal/10000;
    %scale
    newVal = m2cm(dVal);  
    
end

function [cm] = m2cm(m)   
    cm=m*100;
end
