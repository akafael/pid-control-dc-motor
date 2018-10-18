%% PLANTDATAANALISYS
close all
clear

%% Dead Zone
% Get Data
expDataNotLinear = open('ExperimentalData_nLinear.mat');
time = expDataNotLinear.dados(1,2:end);        % micro Seconds
inputSignal = expDataNotLinear.dados(4,2:end);
outputVel = expDataNotLinear.dados(2,2:end);
outputAcc = expDataNotLinear.dados(3,2:end);

% Draw Plot
figure;
isInterval = (time > 60) & (time < 70);
plot(time(isInterval),inputSignal(isInterval))
hold on;
plot(time(isInterval),outputVel(isInterval))
plot(time(isInterval),outputAcc(isInterval))
hold off;
legend('input','x(t)','v(t)');

% Find Dead Zone
thresholdZero = max(outputVel)*1e-2 % 0.1%
isZero = ( outputVel <= thresholdZero) & ( outputVel >= -thresholdZero) & ( inputSignal ~= 0 ); % Find Zeros
% Start DeadZone
deltaMinus = min(outputVel(isZero))
% End DeadZone
deltaPlus = max(outputVel(isZero))


%% Linear Plant Identification
% Read Linear Plant Experiment Data
expDataLinear = open('ExperimentalData_nLinear.mat');
time = expDataLinear.dados(1,:);        % Seconds
inputSignal = expDataLinear.dados(4,:);
% Apply Dead Zone
inputSignal = inputSignal.*(( (inputSignal>deltaPlus)|(inputSignal<deltaMinus) ));
outputVel = expDataLinear.dados(2,:);
outputAcc = expDataLinear.dados(3,:);

% Draw Plot
figure;
isInterval = (time > 0);
plot(time(isInterval),inputSignal(isInterval))
hold on;
plot(time(isInterval),outputVel(isInterval))
plot(time(isInterval),outputAcc(isInterval))
hold off;
legend('input','x(t)','v(t)');

% Filter BandStop 60Hz
noiseFilt = designfilt('bandstopfir','FilterOrder',20, ...
         'CutoffFrequency1',50,'CutoffFrequency2',70, ...
        'SampleRate', 1/min(diff(time)))
inputSignal = filter(noiseFilt,inputSignal);

% Identification
isInterval = (time > 0);
tfFirstVel = firstordertf(inputSignal(isInterval)',outputVel(isInterval)',time(isInterval)')
tfSecondVel = secondordertf(inputSignal(isInterval)',outputVel(isInterval)',time(isInterval)')

% Evaluation
outputTFFirstVel = lsim(tfFirstVel,inputSignal,time);
errorTFFirstVel = norm(outputTFFirstVel' - outputVel)/norm(outputVel)

outputTFSecondVel = lsim(tfSecondVel,inputSignal,time);
errorTFSecondVel = norm(outputTFSecondVel' - outputVel)/norm(outputVel)

figure;
isInterval = (time > 0);
plot(time(isInterval),inputSignal(isInterval))
hold on;
plot(time(isInterval),outputVel(isInterval))
plot(time(isInterval),outputTFFirstVel(isInterval))
plot(time(isInterval),outputTFSecondVel(isInterval))
hold off;
legend('input','x(t)','X_{m1}(t)','X_{m2}(t)');

%% PID Control Evaluation
Kp1 = 1000
Ki1 = 0
Kd1 = 0
Kp2 = 5
Ki2 = 5
Kd2 = 0
modelFileName = 'dcMotorControl';
% Run Simulation
sim(modelFileName);
% Export Model as PDF
pictureFileName = ['../../tex/img/',modelFileName,'.pdf']; % Generate name from model name
print(['-s',modelFileName],'-depsc',pictureFileName);      % Generate PDF

% Load Data
load('simPIDControl.mat','simData');

% Plot
plot(simData.input);
hold on;
plot(simData.m1);
plot(simData.m2);
hold off;
legend('input','m_1(t)','m_2(t)');