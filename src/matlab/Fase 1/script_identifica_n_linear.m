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

%% Determinando a defasagem entre a entrada e a saida
% 
% i=1;
% while(v(i,1) < 0 || v(i,1) > v(i+1,1))
%     i=i+1;
% end
% while(v(i,1) >= 0 && v(i,1) <= v(i+1,1))
%     k1=v(i,1);
%     i=i+1;
% end
% 
% i=1;
% while(w1(i,1) < 0 || w1(i,1) > w1(i+1,1))
%     i=i+1;
% end
% while(w1(i,1) >= 0 && w1(i,1) <= w1(i+1,1))
%     k2=w1(i,1);
%     i=i+1;
% end
% 
% i=1;
% while(v(i,1) ~= k1)
%     i=i+1;
% end
% k1=i-1;i=1;
% 
% while(w1(i,1) ~= k2)
%     i=i+1;
% end
% k2=i-1;
% 
% difere = k2-k1;                             %Número de posições de defasagem

%%
% w1=w;
for i=1:size(w)
   if(w(i,1) <= 0.03)
       w(i,1) = 0;
   end
end

j=1; k=0;
for i=1:size(v)-1
   if(w(i,1) == 0 && w(i+1,1) > 0 && v(i,1) > 0 && k == 0)
       deltaPlus(j,1)=v(i,1);
       j=j+1;
       k=1;
   end
   if(v(i,1) < 0)
      k=0; 
   end
end

%%
w=dados(2,:)';
for i=1:size(w)
   if(w(i,1) >= -0.03)
       w(i,1) = 0;
   end
end

j=1; k=0;
for i=1:size(v)-1
   if(w(i,1) == 0 && w(i+1,1) < 0 && v(i,1) < 0 && k == 0)
       deltaMenus(j,1)=v(i,1);
       j=j+1;
       k=1;
   end
   if(v(i,1) > 0)
      k=0; 
   end
end
% w=w1;

%% Média de deltaPlus
j=size(deltaPlus);
MdeltaPlus = sum(deltaPlus)/j(1,1);

%% Média de deltaMenus
j=size(deltaMenus);
MdeltaMenus = sum(deltaMenus)/j(1,1);

%% Grpafico de entrada e saída sinal triangular
figure;
d = max(v);
d1 = max(w1);
plot(dados(1,:),dados(5,:)/d,'b',dados(1,:),dados(2,:)/d1,'r--');
xlabel('t [s]'); ylabel('v [V], w [rad/s]');
legend({'Entrada (v) - Escalonada' 'Saída (w) - Escalonada'});

clear d d1 i j k k1 k2 w w1 v filtro dados difere deltaMenus deltaPlus;