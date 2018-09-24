%% DC Motor Model Evaluation
clear
%% Simulink
k1 = 1
k2 = 55
k3 = 23
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

%% Dead Zone Parameters Identification
isZero = ( u <= 0.1) & ( u >= -0.1) & ( v ~= 0 ); % Find Zeros
% Start DeadZone
deltaMinus = min(v(isZero))
% End DeadZone
deltaPlus = max(v(isZero))

%% First Order Model Parameters Identification
dW = w(2:end) - w(1:(end-1));  % dW = Wi - Wi-1
dT = t(2:end) - t(1:(end-1));  % dT = Ti - Ti-1

A = [u(2:end) (-w(2:end))];    % ignore first point
paramFist = (A'*A)\(A'*(dW./dT))   % pseudo inverse
errorParam = paramFist - [k1;k2]   % evaluate error
tfFirst = tf(paramFist(1),[1 paramFist(2)])

%% Second Order Model Parameters Identification
dW = w(2:end) - w(1:(end-1));     % dW = Wi - Wi-1
ddW = dW(2:end) - dW(1:(end-1));  % ddW = dWi - dWi-1
dT2 = t(3:end) - t(2:(end-1));     % dT = Ti - Ti-1

B = [u(3:end) (-w(3:end)) (-dW(2:end))];    % ignore first point
paramSecond = (B'*B)\(B'*(ddW./dT2))   % pseudo inverse
tfSecond = tf(paramSecond(1),[1 paramSecond(2) paramSecond(3)])