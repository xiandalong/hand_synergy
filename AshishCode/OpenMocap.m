function OpenMocap( NatNETdllPath )

    global Mocap;
    
    %declare global Mocap var in base
    evalin('base','global Mocap');
    
    %get NatNET dll path
    if nargin < 1
        NatNETdllPath = fullfile('C:\Users\USER\Downloads\NatNet_SDK_2.6\lib\x64\NatNetML.dll');
    end    
    
    %add NatNET
    NET.addAssembly(NatNETdllPath);
    
    %declare Mocap
    Mocap = NatNetML.NatNetClientML(0);
    
    %get loval IP
%     HostIP = char(java.net.InetAddress.getLocalHost.getHostAddress);
    HostIP = char('129.25.34.42');
    %connect
    Mocap.Initialize(HostIP, HostIP);
end