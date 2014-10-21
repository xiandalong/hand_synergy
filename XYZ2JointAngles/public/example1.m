% simple example
clear all;

% kinematic model
%  parent joint sensor axis category
segment = [...
   0 0 0 0 0;  %1 root
   1 3 0 3 1;  %2 body
   2 1 2 1 1;  %3 pos
   3 3 4 2 2;  %4 quat
];

% noise and dynamics model (compressed)
%  TO INCREASE THE AMOUNT OF SMOOTHING (ALONG WITH THE TIMELAG),
%  REDUCE THE SECOND ELEMENT OF datR
dt = 1/20;                              % time step
datS = [3,20];                          % [w,p] position init. stdev
datR = [0,5];                           % [w,p] position drift stdev
datV = 1;                               % position sensor noise stdev
ratio = 10;                             % position/angle stdev ratio

x_w = [10];                             % constant state components
nD = 500;                               % length of data sequence


% prepare information structures
[map, info, S, R, V] = prepare(segment, 1, dt,datS,datR,datV,ratio);

% generate smooth state sequence
pos = randn(map.nX,nD+40)*20;
[b,a] = butter(4,2*dt);
pos = filtfilt(b,a,pos')';
pos = pos(:,21:nD+20);
pos(info.spatial==2,:) = pos(info.spatial==2,:)/ratio;

xTrue = zeros(map.nX,nD);
xTrue(info.type==1,:) = pos(info.type==1,:);
if map.nW,
   xTrue(info.type==2,:) = repmat(x_w,[1,nD]);
end

% generate zero-noise observation sequence
Y0 = zeros(map.nY,nD);
for d=1:nD
   [dummy, Y0(:,d)] = residual(Y0(:,d),xTrue(:,d),segment,map);
end

% add noise to observations, re-normalize quaternions
Y = Y0;
iii = {[],[]};
for n=1:size(segment,1)
   if segment(n,3),                    % select sensor segments
      if segment(n,3)<3,               % translation sensor
         ii = (map.aY(n):map.aY(n)+2);
         Y(ii,:) = Y(ii,:) + datV*randn(3,nD);
         iii{1} = [iii{1}; ii];
      else                             % rotation sensor
         ii = (map.aY(n):map.aY(n)+3);
         Y(ii,:) = Y(ii,:) + datV/ratio*randn(4,nD);
         Y(ii,:) = Y(ii,:) ./ (ones(4,1)*sqrt(sum(Y(ii,:).^2)));
         iii{2} = [iii{2}; ii];
      end
   end
end

% run estimator
%X = estimate_ekf(Y, xTrue(:,1), S, segment, map, info, R, V);
X = estimate(Y, xTrue(:,1), S, segment, map, info, R, V);

% plot time-varying states
labels = {'position','angle'};
figure(1);
clf;
for tp=[2 1]
   subplot(2,1,tp);
   select = (info.type==1 & info.spatial==tp);  % select pos/quat
   h1 = plot(xTrue(select,:)','k');
   hold on;
   h2 = plot(X(select,:)','r');
   ylabel(labels{tp});
end
legend([h1(1) h2(1)],'correct state','estimated state');
title('states');

% plot measurements
labels = {'position sensor','quaternion sensor'};
figure(2);
clf;
for tp=[2 1]
   subplot(2,1,tp);
   h1 = plot(Y0(iii{tp},:)','k');
   hold on;
   h2 = plot(Y(iii{tp},:)','g');
   ylabel(labels{tp});
end
legend([h1(1) h2(1)],'ideal measurement','actual measurement');
title('measurements');
