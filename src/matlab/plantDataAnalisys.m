%% PLANTDATAANALISYS
close all
clear

%% Linear PLANT
% Read Linear Plant Experiment Data
expDataLinear = open('ExperimentalData_Linear.mat');
time = expDataLinear.dados(1,:);        % Seconds
inputSignal = expDataLinear.dados(4,:);
outputPos = expDataLinear.dados(2,:);
outputVel = expDataLinear.dados(3,:);

% Draw Plot
figure;
isInterval = time < 2;
plot(time(isInterval),inputSignal(isInterval))
hold on;
plot(time(isInterval),outputPos(isInterval))
plot(time(isInterval),outputVel(isInterval))
hold off;
legend('input','x(t)','v(t)');

expDataNotLinear = open('ExperimentalData_nLinear.mat');
time = expDataNotLinear.dados(1,:);        % micro Seconds
inputSignal = expDataNotLinear.dados(4,:);
outputPos = expDataNotLinear.dados(2,:);
outputVel = expDataNotLinear.dados(3,:);

% Draw Plot
figure;
isInterval = (time > 60) & (time < 70);
plot(time(isInterval),inputSignal(isInterval))
hold on;
plot(time(isInterval),outputPos(isInterval))
plot(time(isInterval),outputVel(isInterval))
hold off;
legend('input','x(t)','v(t)');
