%% Plant Experiment Analisys

clc
clear
close all

%% Load all PID experiment data
filenames = cell(1,4);
filenames{1} = 'Dados dos Experimentos/pid/dadosControle1.mat';
filenames{2} = 'Dados dos Experimentos/pid/dadosControle2.mat';
filenames{3} = 'Dados dos Experimentos/pid/dadosControle3.mat';
filenames{4} = 'Dados dos Experimentos/pid/dadosControle4.mat';

for i = 1:4
    data = load(filenames{i}(1:end));
    % Split data
    time = data.ans(1,:);  % Time
    u = data.ans(end,:);   % Input
    y = data.ans(2,:);     % Output
    e = u-y;               % Error
   
    % Get Frequency 
    stepSize = max(u);		  % Pulse Size
    timeStep = time(max(u)==u);
    dt = timeStep(1);             % Pulse Time Length
    f = 1/dt;                     % Pulse Frequency
    
    % Plot
    figure;
    timeInterval = time < 20;
    plot(time(timeInterval),u(timeInterval),time(timeInterval),y(timeInterval))
    legend('Input','Output');
    title(['Resposta PID ( f = ',num2str(f),' Hz , a = ',num2str(stepSize),'^\circ )']);

    % Export to file
    print(['../../tex/img/quanserpid_s',num2str(stepSize),'num',num2str(dt)],'-dpng');
end

%% Load all SS experiment data
filenames = cell(1,8);
filenames{1} = 'Dados dos Experimentos/ss/dadosControleSS2.mat';
filenames{2} = 'Dados dos Experimentos/ss/dadosControleSS2.mat';
filenames{3} = 'Dados dos Experimentos/ss/dadosControleSS3.mat';
filenames{4} = 'Dados dos Experimentos/ss/dadosControleSS4.mat';
filenames{5} = 'Dados dos Experimentos/ss/dadosControleSS5.mat';
filenames{6} = 'Dados dos Experimentos/ss/dadosControleSS6.mat';
filenames{7} = 'Dados dos Experimentos/ss/dadosControleSS7.mat';
filenames{8} = 'Dados dos Experimentos/ss/dadosControleSS8.mat';

for i = 1:8
    data = load(filenames{i}(1:end));
    % Split data
    time = data.ans(1,:);  % Time
    u = data.ans(end,:);   % Input
    y = data.ans(2,:);     % Output
    e = u-y;               % Error
  i 
    % Get Frequency 
    stepSize = max(u);		  % Pulse Size
    timeStep = time(max(u)==u);
    dt = timeStep(1);             % Pulse Time Length
    f = 1/dt;                     % Pulse Frequency
    
    % Plot
    figure;
    timeInterval = time < 20;
    plot(time(timeInterval),u(timeInterval),time(timeInterval),y(timeInterval))
    legend('Input','Output');
    title(['Resposta SS ( f = ',num2str(f),' Hz , a = ',num2str(stepSize),'^\circ )']);

    % Export to file
    print(['../../tex/img/quanserss_s',num2str(stepSize),'num',num2str(dt)],'-dpng');
end
