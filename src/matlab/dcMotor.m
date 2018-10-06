%% DC Motor Model Evaluation
close all
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
tfFirst = firstordertf(u,w,t)
m1 = lsim(tfFirst,u,t);
errorFirst = norm(m1 - w)/norm(w)

%% Second Order Model Parameters Identification
tfSecond = secondordertf(u,w,t)
m2 = lsim(tfSecond,u,t);
errorSecond = norm(m2 - w)/norm(w)

%% Plot
mFigure = figure('PaperPositionMode', 'auto');
plot(t,v,t,w,t,m1,t,m2)
mLegend = legend({'$v(t)$','$w_1(t)$','$m_1(t)$','$m_2(t)$'},'Interpreter','latex');
% Export Plot as PDF
pictureFileName = ['../../tex/img/','model1Evaluation','.pdf']; % Generate name from model name
print(mFigure,'-dpdf',pictureFileName);      % Generate PDF

%% First Order Model Parameters Identification
tfFirst = firstordertf(u,w2,t)
m1 = lsim(tfFirst,u,t);
errorFirst = norm(m1 - w2)/norm(w2)

%% Second Order Model Parameters Identification
tfSecond = secondordertf(u,w,t)
m2 = lsim(tfSecond,u,t);
errorSecond = norm(m2 - w2)/norm(w2)

%% Plot
mFigure = figure('PaperPositionMode', 'auto');
plot(t,v,t,w2,t,m1,t,m2)
mLegend = legend({'$v(t)$','$w_2(t)$','$m_1(t)$','$m_2(t)$'},'Interpreter','latex');
% Export Plot as PDF
pictureFileName = ['../../tex/img/','model2Evaluation','.pdf']; % Generate name from model name
print(mFigure,'-dpdf',pictureFileName);      % Generate PDF
