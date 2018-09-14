%% DC Motor Model Evaluation

%% Simulink
modelFileName = 'dcMotorSimulation';
% Run Simulation
sim(modelFileName);

% Export Model as PDF
pictureFileName = ['../../tex/img/',modelFileName,'.pdf']; % Generate name from model name
print(['-s',modelFileName],'-depsc',pictureFileName);      % Generate PDF

% Read Experiment Data (expData)
load('motorSimulation.mat');
v = expData.V.Data;
u = expData.U.Data;

%% Dead Zone Parameters Identification
isZero = ( u <= 0.1) & ( u >= -0.1) & ( v ~= 0 ); % Find Zeros
% Start DeadZone
deltaMinus = min(v(isZero))
% End DeadZone
deltaPlus = max(v(isZero))

%% First Order Model Parameters Identification