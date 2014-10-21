% testing obtaining joint angles from hand mo-cap data ====================
% James R. Peters === Drexel University === 8/12/2014 =====================
% =========================================================================
% =========================================================================
clear all
close all
clc

% load data
load('alldata')

t=alldata(:,2); % time vector

numc=(length(alldata(1,:))-2)/3; % number of markers

LMP=cell(numc,1); % set up cells for landmark points

for i=1:numc
    LMP{i,1}=alldata(:,(3*i):(3*i)+2);
end

% assign points to fingers tip=1 ==> mcp=4
PKY=[LMP{1},LMP{2},LMP{18},LMP{19}]; % pinky
RNG=[LMP{3},LMP{17},LMP{8},LMP{10}]; % ring
MID=[LMP{15},LMP{16},LMP{4},LMP{20}]; % middle
IDX=[LMP{13},LMP{14},LMP{9},LMP{5}]; % index
TMB=[LMP{7},LMP{6},LMP{11},LMP{12}]; % thumb
W=LMP{21}; % wrist

% force finger points to be co-planar =====================================


% visualize whole data set
numf=length(t); % number of frames

figure('Renderer','zbuffer')
set(gca,'NextPlot','replaceChildren')
for i=1:numf
    clf;
    hold on,grid on,axis equal
    xlabel('X'),ylabel('Y'),zlabel('Z')
    view(-180,0)
    for j=1:numc
        pt=LMP{j};
        plot3(pt(i,1),pt(i,2),pt(i,3),'.k','markersize',30)
    end
    getframe;
    hold off
end
close

% =========================================================================
% measuring flexion of distal joints
% =========================================================================
% pinky
p1=PKY(:,1:3);p2=PKY(:,4:6);p3=PKY(:,7:9);p4=PKY(:,10:12); % individual markers
v1=p1-p2;v2=p2-p3;v3=p3-p4; % vectors between landmarks
ax1=zeros(numf,3);ang1=zeros(numf,1);
ax2=ax1;ang2=ang1;
for i=1:numf
    ax1(i,:)=cross(-v1(i,:),v2(i,:));
    ang1(i)=pi-acos(dot(-v1(i,:),v2(i,:))/(norm(-v1(i,:))*norm(v2(i,:))));
    ax2(i,:)=cross(-v2(i,:),v3(i,:));
    ang2(i)=pi-acos(dot(-v2(i,:),v3(i,:))/(norm(-v2(i,:))*norm(v3(i,:))));
end
ang1=ang1*180/pi;
ang2=ang2*180/pi;

% display finger flexion
n=[0,0,-1];
figure('Renderer','zbuffer')
for i=1:5:numf
    rotax=cross(n,-v3(i,:));
    rotang=acos(dot(n,-v3(i,:))/(norm(n)*norm(-v3(i,:))));
    H=makehgtform('axisrotate',rotax,rotang);
    H=H(1:3,1:3);
    
    p1n=(p1(i,:)-p4(i,:))*H;
    p2n=(p2(i,:)-p4(i,:))*H;
    p3n=(p3(i,:)-p4(i,:))*H;
    
    plot3([p1n(1);p2n(1);p3n(1);0],[p1n(2);p2n(2);p3n(2);0],...
        [p1n(3);p2n(3);p3n(3);0],'k','linewidth',3)
    hold on,grid on,axis equal,title('FINGER ANGLES OVER TIME')
    plot3(p2n(1),p2n(2),p2n(3),'.b','markersize',20)
    plot3(p3n(1),p3n(2),p3n(3),'.r','markersize',20)
    legend('PINKY',sprintf('THETA1 = %5.2f degrees',ang1(i)),...
        sprintf('THETA2 = %5.4f degrees',ang2(i)))
    getframe;
    hold off
    
end

% ring
p1=RNG(:,1:3);p2=RNG(:,4:6);p3=RNG(:,7:9);p4=RNG(:,10:12); % individual markers
v1=p1-p2;v2=p2-p3;v3=p3-p4; % vectors between landmarks
ax1=zeros(numf,3);ang1=zeros(numf,1);
ax2=ax1;ang2=ang1;
for i=1:numf
    ax1(i,:)=cross(-v1(i,:),v2(i,:));
    ang1(i)=pi-acos(dot(-v1(i,:),v2(i,:))/(norm(-v1(i,:))*norm(v2(i,:))));
    ax2(i,:)=cross(-v2(i,:),v3(i,:));
    ang2(i)=pi-acos(dot(-v2(i,:),v3(i,:))/(norm(-v2(i,:))*norm(v3(i,:))));
end
ang1=ang1*180/pi;
ang2=ang2*180/pi;

% display finger flexion
n=[0,0,-1];
figure('Renderer','zbuffer')
for i=1:5:numf
    rotax=cross(n,-v3(i,:));
    rotang=acos(dot(n,-v3(i,:))/(norm(n)*norm(-v3(i,:))));
    H=makehgtform('axisrotate',rotax,rotang);
    H=H(1:3,1:3);
    
    p1n=(p1(i,:)-p4(i,:))*H;
    p2n=(p2(i,:)-p4(i,:))*H;
    p3n=(p3(i,:)-p4(i,:))*H;
    
    plot3([p1n(1);p2n(1);p3n(1);0],[p1n(2);p2n(2);p3n(2);0],...
        [p1n(3);p2n(3);p3n(3);0],'k','linewidth',3)
    hold on,grid on,axis equal,title('FINGER ANGLES OVER TIME')
    plot3(p2n(1),p2n(2),p2n(3),'.b','markersize',20)
    plot3(p3n(1),p3n(2),p3n(3),'.r','markersize',20)
    legend('RING',sprintf('THETA1 = %5.2f degrees',ang1(i)),...
        sprintf('THETA2 = %5.2f degrees',ang2(i)))
    getframe;
    hold off
    
end

% middle
p1=MID(:,1:3);p2=MID(:,4:6);p3=MID(:,7:9);p4=MID(:,10:12); % individual markers
v1=p1-p2;v2=p2-p3;v3=p3-p4; % vectors between landmarks
ax1=zeros(numf,3);ang1=zeros(numf,1);
ax2=ax1;ang2=ang1;
for i=1:numf
    ax1(i,:)=cross(-v1(i,:),v2(i,:));
    ang1(i)=pi-acos(dot(-v1(i,:),v2(i,:))/(norm(-v1(i,:))*norm(v2(i,:))));
    ax2(i,:)=cross(-v2(i,:),v3(i,:));
    ang2(i)=pi-acos(dot(-v2(i,:),v3(i,:))/(norm(-v2(i,:))*norm(v3(i,:))));
end
ang1=ang1*180/pi;
ang2=ang2*180/pi;

% display finger flexion
n=[0,0,-1];
figure('Renderer','zbuffer')
for i=1:5:numf
    rotax=cross(n,-v3(i,:));
    rotang=acos(dot(n,-v3(i,:))/(norm(n)*norm(-v3(i,:))));
    H=makehgtform('axisrotate',rotax,rotang);
    H=H(1:3,1:3);
    
    p1n=(p1(i,:)-p4(i,:))*H;
    p2n=(p2(i,:)-p4(i,:))*H;
    p3n=(p3(i,:)-p4(i,:))*H;
    
    plot3([p1n(1);p2n(1);p3n(1);0],[p1n(2);p2n(2);p3n(2);0],...
        [p1n(3);p2n(3);p3n(3);0],'k','linewidth',3)
    hold on,grid on,axis equal,title('FINGER ANGLES OVER TIME')
    plot3(p2n(1),p2n(2),p2n(3),'.b','markersize',20)
    plot3(p3n(1),p3n(2),p3n(3),'.r','markersize',20)
    legend('MIDDLE',sprintf('THETA1 = %5.2f degrees',ang1(i)),...
        sprintf('THETA2 = %5.4f degrees',ang2(i)))
    getframe;
    hold off
    
end

% index
p1=IDX(:,1:3);p2=IDX(:,4:6);p3=IDX(:,7:9);p4=IDX(:,10:12); % individual markers
v1=p1-p2;v2=p2-p3;v3=p3-p4; % vectors between landmarks
ax1=zeros(numf,3);ang1=zeros(numf,1);
ax2=ax1;ang2=ang1;
for i=1:numf
    ax1(i,:)=cross(-v1(i,:),v2(i,:));
    ang1(i)=pi-acos(dot(-v1(i,:),v2(i,:))/(norm(-v1(i,:))*norm(v2(i,:))));
    ax2(i,:)=cross(-v2(i,:),v3(i,:));
    ang2(i)=pi-acos(dot(-v2(i,:),v3(i,:))/(norm(-v2(i,:))*norm(v3(i,:))));
end
ang1=ang1*180/pi;
ang2=ang2*180/pi;

% display finger flexion
n=[0,0,-1];
figure('Renderer','zbuffer')
for i=1:5:numf
    rotax=cross(n,-v3(i,:));
    rotang=acos(dot(n,-v3(i,:))/(norm(n)*norm(-v3(i,:))));
    H=makehgtform('axisrotate',rotax,rotang);
    H=H(1:3,1:3);
    
    p1n=(p1(i,:)-p4(i,:))*H;
    p2n=(p2(i,:)-p4(i,:))*H;
    p3n=(p3(i,:)-p4(i,:))*H;
    
    plot3([p1n(1);p2n(1);p3n(1);0],[p1n(2);p2n(2);p3n(2);0],...
        [p1n(3);p2n(3);p3n(3);0],'k','linewidth',3)
    hold on,grid on,axis equal,title('FINGER ANGLES OVER TIME')
    plot3(p2n(1),p2n(2),p2n(3),'.b','markersize',20)
    plot3(p3n(1),p3n(2),p3n(3),'.r','markersize',20)
    legend('INDEX',sprintf('THETA1 = %5.2f degrees',ang1(i)),...
        sprintf('THETA2 = %5.4f degrees',ang2(i)))
    getframe;
    hold off
    
end

% thumb
p1=TMB(:,1:3);p2=TMB(:,4:6);p3=TMB(:,7:9);p4=TMB(:,10:12); % individual markers
v1=p1-p2;v2=p2-p3;v3=p3-p4; % vectors between landmarks
ax1=zeros(numf,3);ang1=zeros(numf,1);
ax2=ax1;ang2=ang1;
for i=1:numf
    ax1(i,:)=cross(-v1(i,:),v2(i,:));
    ang1(i)=pi-acos(dot(-v1(i,:),v2(i,:))/(norm(-v1(i,:))*norm(v2(i,:))));
    ax2(i,:)=cross(-v2(i,:),v3(i,:));
    ang2(i)=pi-acos(dot(-v2(i,:),v3(i,:))/(norm(-v2(i,:))*norm(v3(i,:))));
end
ang1=ang1*180/pi;
ang2=ang2*180/pi;

% display finger flexion
n=[0,0,-1];
figure('Renderer','zbuffer')
for i=1:5:numf
    rotax=cross(n,-v3(i,:));
    rotang=acos(dot(n,-v3(i,:))/(norm(n)*norm(-v3(i,:))));
    H=makehgtform('axisrotate',rotax,rotang);
    H=H(1:3,1:3);
    
    p1n=(p1(i,:)-p4(i,:))*H;
    p2n=(p2(i,:)-p4(i,:))*H;
    p3n=(p3(i,:)-p4(i,:))*H;
    
    plot3([p1n(1);p2n(1);p3n(1);0],[p1n(2);p2n(2);p3n(2);0],...
        [p1n(3);p2n(3);p3n(3);0],'k','linewidth',3)
    hold on,grid on,axis equal,title('FINGER ANGLES OVER TIME')
    plot3(p2n(1),p2n(2),p2n(3),'.b','markersize',20)
    plot3(p3n(1),p3n(2),p3n(3),'.r','markersize',20)
    legend('THUMB',sprintf('THETA1 = %5.2f degrees',ang1(i)),...
        sprintf('THETA2 = %5.4f degrees',ang2(i)))
    getframe;
    hold off
    
end