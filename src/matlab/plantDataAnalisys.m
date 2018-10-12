%% PLANTDATAANALISYS
close all
clear

%% Dead Zone

% Get Data
expDataNotLinear = open('ExperimentalData_nLinear.mat');
time = expDataNotLinear.dados(1,2:end);        % micro Seconds
inputSignal = expDataNotLinear.dados(4,2:end);
outputPos = expDataNotLinear.dados(2,2:end);
outputVel = expDataNotLinear.dados(3,2:end);

% Draw Plot
figure;
isInterval = (time > 60) & (time < 70);
plot(time(isInterval),inputSignal(isInterval))
hold on;
plot(time(isInterval),outputPos(isInterval))
plot(time(isInterval),outputVel(isInterval))
hold off;
legend('input','x(t)','v(t)');

% Find Dead Zone
thresholdZero = max(outputPos)*1e-2 % 0.1%
isZero = ( outputPos <= thresholdZero) & ( outputPos >= -thresholdZero) & ( inputSignal ~= 0 ); % Find Zeros
% Start DeadZone
deltaMinus = min(outputPos(isZero))
% End DeadZone
deltaPlus = max(outputPos(isZero))


%% Linear Plant Identification
% Read Linear Plant Experiment Data
expDataLinear = open('ExperimentalData_Linear.mat');
time = expDataLinear.dados(1,:);        % Seconds
inputSignal = expDataLinear.dados(4,:);
% Apply Dead Zone
inputSignal = inputSignal.*( (inputSignal>deltaPlus)|(inputSignal<deltaPlus) );
outputPos = expDataLinear.dados(2,:);
outputVel = expDataLinear.dados(3,:);

% Draw Plot
figure;
isInterval = (time > 0);
plot(time(isInterval),inputSignal(isInterval))
hold on;
plot(time(isInterval),outputPos(isInterval))
plot(time(isInterval),outputVel(isInterval))
hold off;
legend('input','x(t)','v(t)');

% Identification
tfFirstVel = firstordertf(inputSignal(isInterval)',outputVel(isInterval)',time(isInterval)')
tfFirstPos = firstordertf(inputSignal(isInterval)',outputPos(isInterval)',time(isInterval)')
tfSecondVel = secondordertf(inputSignal(isInterval)',outputVel(isInterval)',time(isInterval)')
tfSecondPos = secondordertf(inputSignal(isInterval)',outputPos(isInterval)',time(isInterval)')

% Evaluation
outputTFFirstPos = lsim(tfFirstPos,inputSignal,time);
errorTFFirstPos = norm(outputTFFirstPos' - outputPos)/norm(outputPos)

outputTFSecondPos = lsim(tfSecondPos,inputSignal,time);
errorTFSecondPos = norm(outputTFSecondPos' - outputPos)/norm(outputPos)

outputTFFirstVel = lsim(tfFirstVel,inputSignal,time);
errorTFFirstVel = norm(outputTFFirstVel' - outputVel)/norm(outputVel)

outputTFSecondVel = lsim(tfSecondVel,inputSignal,time);
errorTFSecondVel = norm(outputTFSecondVel' - outputVel)/norm(outputVel)