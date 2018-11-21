close all;

%%
%%% Leitura do arquivo de dados
load dados3_Linear_01_11;

t = dados(1,:)';
v = dados(5,:)';
w = dados(2,:)';

% filtro=fir1(10,(20)*2/100000,'low');
filtro=fir1(481,(20)*2/200000,'low');
w=conv(w,filtro);

%% Calculando o vetor u
for i=1:size(v)
    if(v(i,1) >= MdeltaPlus)
        u(i,1) = v(i,1) - MdeltaPlus;
    elseif(v(i,1) > MdeltaMenus && v(i,1) < MdeltaPlus) 
        u(i,1) = 0;
    end
    if(v(i,1) <= MdeltaMenus)
        u(i,1) = v(i,1) - MdeltaMenus;
    end
end

%% Estimando as constantes da planta
i=size(t); i=i(1,1);
dT = t(2:end) - t(1:(end-1));   %%% Intervalo de amostragem
dw = (w(2:i) - w(1:(i-1)))./dT; %%% Aproximação da derivada
dw=conv(dw,filtro);

%%
A=[dw(1:i)    w(1:i)];
Parametros = ((A'*A)^-1)*A'*(u(1:end)); %%% Isolando P de ---> A(t)P=B(t)
Km=1/Parametros(2,1);
tau=Km*Parametros(1,1);

w_e=lsim(tf(Km,[tau 1]),u,t);
tf_first=tf(Km,[tau 1]);

%% Gráfico de entrada e saida sinal quadrático
figure;
d=size(v);
d1=max(dados(3,:));
plot(t(:,1),v(:,1),'b',t(:,1),dados(2,:)','r',t(:,1),w_e(:,1),'g--');
xlabel('t [s]'); ylabel('v [V], w [rad/s]');
legend({'Entrada (v)' 'Saída (w)' 'Saída Estimada (w)'});

%%
clear A Const dT dw i t u v w w_e d d1 dados Parametros filtro

tf_integrador=tf(1,[1 0]);
% sisotool(tf_first*tf_integrador);