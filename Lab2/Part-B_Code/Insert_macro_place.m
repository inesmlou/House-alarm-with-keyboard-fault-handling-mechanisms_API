function [ D ] = Insert_macro_place( Pre , Post , Place , Pre2 , Post2 )

%INSERT_MACRO_PLACE
%   Descrição:  Esta função serve para substituir, numa petri net original,
%               um place por uma outra petri net no seu lugar(macro-place).
%
%   Inputs:     Pre   - Matriz Pre da petri net original;    
%               Post  - Matriz Post da petri net original; 
%               Place - Nº do place pelo qual se quer substiruir por uma
%                       macro-place;
%               Pre2  - Matriz Pre da petri net a acrescentar;    
%               Post2 - Matriz Post da petri net a acrescentar;   



% Número de transiçoes existentes na petri net original:
N_trans1 = length(Pre(1,:)); 

% Número de places existentes na petri net original:
N_places1 = length(Pre(:,1));

% Número de transiçoes que se terão de acrescentar, ou seja, as existentes na petri net a acrescentar à original
N_trans2 = length(Pre2(1,:));  
        
% Número de places que se terão de acrescentar, ou seja os existentes na petri net a acrescentar à original
N_places2 = length(Pre2(:,1));  

% Cálculo da Matriz de incidência original:
D1 = Post - Pre; 

% Retira-se da matriz de incidência original a linha corresponde ao place
% onde se vai acrescentar (macro-place), a:
a = [ D1( 1:(Place-1), : ); D1( (Place+1):N_places1 , :)]; 

% Construção de uma matriz de zeros para englubar as relações entres os
% outros places da petri net origianla com as novas transições que serão 
% acrescentadas, b:
b = zeros(N_places1 -1 , N_trans2); 

% Contrução da matriz que faz a ligação da petri net original com a outra 
% net a acrescentar (no place correspondente), c:

% primeira linha linha é dada por:
line1_C = Post( Place, : ); 

% a última linha é dada por:
last_line_C = - Pre ( Place, :);

% as restantes linhas desta matriz são zero, pelo que a matriz é dada por:
c = [ line1_C ; zeros(N_places2 - 2 , N_trans1) ; last_line_C ]; 

% Matriz incidência da petri net a acrescentar, d:
d = Post2 - Pre2; 

% Matriz Incidência Final:
D = [ a b ; c d ];  

end

