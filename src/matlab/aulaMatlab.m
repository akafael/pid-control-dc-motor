%% DUMMIECONTROL Arquivo de Estudo para Matlab
%clc
clear all;
close all;

%% TEST First Steps Comparing Implementations
% Cost tictoc
tic;
toc;

% Cost Dynamic Allocation with loop
tic;
N = 10000;
for i = 1:N,
    x(i,1) = i;
end
toc;

% Cost Preview Allocation with loop
tic;
N = 10000;
x = zeros(N,1);
for i = 1:N,
    x(i,1) = i;
end
toc;

% Cost Matrix Operation without loop
tic;
N = 10000;
x = (1:N)';
toc;


%% CONTROL
% List all Control Toolbox: help control

% Create Model
K = 2;
tal = 0.1;
P = tf([K],[tal 1])

[num,dem] = tfdata(P);  % Get parts as Cells
whos num dem            % Check type
% Cell Operation
cell2mat(num) % Convert from cell to mat
num{1} % Get Inner Content

% Control Plant Analysis
pole(P)
zero(P)      % Get Zeros
dcgain(P)    %  DC Gain

% Controler
C = tf([10],[1 0])

Zopen = C*P
Zclose = C*P/(1+C*P)
Zfeedback = feedback(C*P,1)

% Plot Poles
subplot(1,2,1);
pzmap(P)
hold on;
pzmap(Zfeedback)
hold off;

% Step Responce
subplot(2,2,2);
step(P);
subplot(2,2,4);
step(Zfeedback);

% Signal Responce to Input Signal
figure;
T = 4;
t = linspace(0,5*T,1000);
u = sin(2*pi*(1/T)*t);
uSquare = 2*(u>0)-1;
y = lsim(Zfeedback,uSquare,t);

plot(t,y,t,uSquare)
% Procurar sobre Sinal PRBS

% Frequency Responce
bode(Zfeedback);
nyquist(Zfeedback);
margim(Zfeedback);

% LGR : Feedback Gain
rlocus(Zfeedback);
