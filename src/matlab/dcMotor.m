%% DC Motor Model Evaluation
close
clear
%% Simulink
k1 = 1
k2 = 2
k3 = 3
modelFileName = 'dcMotorSimulation';
% Run Simulation
sim(modelFileName);

% Export Model as PDF
pictureFileName = ['../../tex/img/',modelFileName,'.pdf']; % Generate name from model name
print(['-s',modelFileName],'-depsc',pictureFileName);      % Generate PDF

% Read Experiment Data (expData)
load('motorSimulation.mat');
v = expData.V.Data; % Input
u = expData.U.Data;
t = expData.U.Time;
w = expData.W1.Data; % Output
w2 = expData.W2.Data; % Output

%% Dead Zone Parameters Identification
isZero = ( u <= 0.1) & ( u >= -0.1) & ( v ~= 0 ); % Find Zeros
% Start DeadZone
deltaMinus = min(v(isZero))
% End DeadZone
deltaPlus = max(v(isZero))

%% First Order Model Parameters Identification
dW = w(2:end) - w(1:(end-1));  % dW = Wi - Wi-1
dT = t(2:end) - t(1:(end-1));  % dT = Ti - Ti-1

A = [u(2:end) (-w(2:end))];             % ignore first point
paramFist = (A'*A)\(A'*(dW./dT))        % pseudo inverse
errorParamFirst = paramFist - [k1;k2]   % evaluate error parameters

tfFirst = tf(paramFist(1),[1 paramFist(2)])
m1 = lsim(tfFirst,u,t);
errorFirst = norm(m1 - w)/norm(w)

%% Second Order Model Parameters Identification
dW = diff(w,1)./t(2:end);                     % dW = Wi - Wi-1
ddW = diff(dW,1)./t(3:end);                   % ddW = dWi - dWi-1
dT2 = t(3:end) - t(2:(end-1));      % dT = Ti - Ti-1

B = [ddW(1:end) dW(1:end-1) w(1:end-2)];  % ignore first point
paramSecond = (B'*B)\(B'*(u(3:end)))   % pseudo inverse

tfSecond = tf(9,[paramSecond(3) paramSecond(2) paramSecond(1)])
m2 = lsim(tfSecond,u,t);
errorSecond = norm(m2 - w)/norm(w)

%% Plot
mFigure = figure('PaperPositionMode', 'auto');
subplot(2,1,1)
plot(t,w,t,m1,t,m2)
mLegend = legend({'u(t)','$m_1(t)$','$m_2(t)$'},'Interpreter','latex');

subplot(2,1,2)
plot(t,m2)
mLegend = legend({'u(t)','$m_1(t)$','$m_2(t)$'},'Interpreter','latex');

% Export Plot as PDF
pictureFileName = ['../../tex/img/','modelEvaluation','.pdf']; % Generate name from model name
print(mFigure,'-depsc',pictureFileName);      % Generate PDF
