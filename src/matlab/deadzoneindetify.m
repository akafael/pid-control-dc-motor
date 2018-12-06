function [ MdeltaMinus, MdeltaPlus] = deadzoneindetify( v,y )
%DEADZONEINDETIFY Dead Zone Parameters Identification

%% Pegando os valores de delta mais
w = y.*(y <= 0.03); % Zerando a parte negativa da saida

% Pega os valores de delta a cada periodo
j=1; k=0;
for i=1:size(v)-1
   if(w(i,1) == 0 && w(i+1,1) > 0 && v(i,1) > 0 && k == 0)
       deltaPlus(j,1)=v(i,1);
       j=j+1;
       k=1;
   end
   if(v(i,1) < 0)   % Contador de per�odo
      k=0; 
   end
end

%% Pegando os valores de delta menos
w = y.*(y >= - 0.03); % Zerando a parte positiva da saida

% Pega os valores de delta a cada periodo
j=1; k=0;
for i=1:size(v)-1
   if(w(i,1) == 0 && w(i+1,1) < 0 && v(i,1) < 0 && k == 0)
       deltaMinus(j,1)=v(i,1);
       j=j+1;
       k=1;
   end
   if(v(i,1) > 0)   % Contador de per�odo
      k=0; 
   end
end

%% Media de deltaPlus
MdeltaPlus = mean(deltaPlus);

%% Media de deltaMenus
MdeltaMinus = mean(deltaMinus);
end

