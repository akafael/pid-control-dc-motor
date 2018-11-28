% Programa para Seguidor de Referêcia do tipo Degrau

clear all;
close all;

%% Converte a função de transferência em espaço de estados 

[A, B, C, D] = tf2ss(28.22,[0.1 1 0]);

%% Define Polos Desejados

Polos = [complex(-8,-0),complex(-9,0),complex(-10,0)];

%% Calculo do ganho K para controlador em malha fechada 

Aa = [A zeros(2,1);-C 0];               %Matriz A do sistema estendido
Ba = [B;0];                             %Matriz B do sistema estendido
K1 = sym('K_1');
K2 = sym('K_2');
K3 = sym('K_3');
KK = [K1 K2 K3];

%% Acha Polinomio Característico Controlador para K simbólico

Ac = Aa-Ba*KK;
I = eye(size(Ac));
x = sym('s')*I-Ac;
PolControle = wrev(coeffs(det(x),'s'));

%% Resolve as equações para determinar os ganhos

PolDesejado = poly(Polos);
PolK = (PolControle - PolDesejado);
k1 = solve(PolK(2),K1);
k2 = solve(PolK(3),K2);
k3 = solve(PolK(4),K3);

%% Gera Matriz Ac com valores numéricos

KK = [double(k1) double(k2) double(k3)];
K = KK(1:2);                            % Matriz de ganho do estado observado
Ki = -KK(1,3);                           % Ganho integral
Ac = Aa-Ba*KK;                          % Matriz A do sistema estendido para K e Ki definidos
Bc = [zeros(size(B));1];                % Matriz B na forma canônica estendida
Cc=[C 0];                               % Matriz C estendida
Dc = D;
Ke = acker(A',C',Polos(1:2))';          % Matriz de ganho do observador
 
 t = 0:0.01:10;                         % Tempo da simulaçao
for i=2:size(t')                        % Sinal de entrada (degrau)
   u(1,i)= 1;
end

%% Resposta do seguidor de referência para condições iniciais dadas sem observador

x0c=[0 0 0]';                           %Condições iniciais
[Y] = lsim(Ac,Bc,Cc,Dc,u,t,x0c); 
figure; plot(t,Y,'b',t,u,'r');
title('Saída do Sistema com Seguidor de Referência'); axis([0 max(t) 0 1.2])

clear k1 K1 k2 K2 k3 K3 KK PolControle PolDesejado PolK Polos x x0 x0c t u X Y I i Aa Ac Ba Bc Cc Dc;