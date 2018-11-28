clear all;
close all;

%%
%%% Leitura do arquivo de dados
load dados1_nLinear_01_11;

v = dados(5,:)';
w = dados(2,:)';

%% Filtro

filtro=fir1(1000,(20)*2/20000,'low');
w1=conv(w,filtro);

%% Pegando os valores de delta mais no tempo de execu��o
for i=1:size(w)
   if(w(i,1) <= 0.03)   % Zerando a parte negativa da sa�da
       w(i,1) = 0;
   end
end

j=1; k=0;
for i=1:size(v)-1
   if(w(i,1) == 0 && w(i+1,1) > 0 && v(i,1) > 0 && k == 0)  % Pegando valor de delta mais a cada per�odo
       deltaPlus(j,1)=v(i,1);
       j=j+1;
       k=1;
   end
   if(v(i,1) < 0)   % Contador de per�odo
      k=0; 
   end
end

%% Pegando os valores de delta menos no tempo de execu��o
w=dados(2,:)';
for i=1:size(w)
   if(w(i,1) >= -0.03)  % Zerando a parte positiva da sa�da
       w(i,1) = 0;
   end
end

j=1; k=0;
for i=1:size(v)-1
   if(w(i,1) == 0 && w(i+1,1) < 0 && v(i,1) < 0 && k == 0)  % Pegando valor de delta menos a cada per�odo
       deltaMenus(j,1)=v(i,1);
       j=j+1;
       k=1;
   end
   if(v(i,1) > 0)   % Contador de per�odo
      k=0; 
   end
end

%% M�dia de deltaPlus
j=size(deltaPlus);
MdeltaPlus = sum(deltaPlus)/j(1,1);

%% M�dia de deltaMenus
j=size(deltaMenus);
MdeltaMenus = sum(deltaMenus)/j(1,1);

%% Grpafico de entrada e sa�da sinal triangular
figure;
d = max(v);
d1 = max(w1);
plot(dados(1,:),dados(5,:)/d,'b',dados(1,:),dados(2,:)/d1,'r--');
xlabel('t [s]'); ylabel('v [V], w [rad/s]');
legend({'Entrada (v) - Escalonada' 'Sa�da (w) - Escalonada'});

clear d d1 i j k k1 k2 w w1 v filtro dados difere deltaMenus deltaPlus;