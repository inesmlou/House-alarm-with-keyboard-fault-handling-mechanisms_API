function [ D ] = Insert_macro_place( Pre , Post , Place , Pre2 , Post2 )

%INSERT_MACRO_PLACE
%   Descri��o:  Esta fun��o serve para substituir, numa petri net original,
%               um place por uma outra petri net no seu lugar(macro-place).
%
%   Inputs:     Pre   - Matriz Pre da petri net original;    
%               Post  - Matriz Post da petri net original; 
%               Place - N� do place pelo qual se quer substiruir por uma
%                       macro-place;
%               Pre2  - Matriz Pre da petri net a acrescentar;    
%               Post2 - Matriz Post da petri net a acrescentar;   



% N�mero de transi�oes existentes na petri net original:
N_trans1 = length(Pre(1,:)); 

% N�mero de places existentes na petri net original:
N_places1 = length(Pre(:,1));

% N�mero de transi�oes que se ter�o de acrescentar, ou seja, as existentes na petri net a acrescentar � original
N_trans2 = length(Pre2(1,:));  
        
% N�mero de places que se ter�o de acrescentar, ou seja os existentes na petri net a acrescentar � original
N_places2 = length(Pre2(:,1));  

% C�lculo da Matriz de incid�ncia original:
D1 = Post - Pre; 

% Retira-se da matriz de incid�ncia original a linha corresponde ao place
% onde se vai acrescentar (macro-place), a:
a = [ D1( 1:(Place-1), : ); D1( (Place+1):N_places1 , :)]; 

% Constru��o de uma matriz de zeros para englubar as rela��es entres os
% outros places da petri net origianla com as novas transi��es que ser�o 
% acrescentadas, b:
b = zeros(N_places1 -1 , N_trans2); 

% Contru��o da matriz que faz a liga��o da petri net original com a outra 
% net a acrescentar (no place correspondente), c:

% primeira linha linha � dada por:
line1_C = Post( Place, : ); 

% a �ltima linha � dada por:
last_line_C = - Pre ( Place, :);

% as restantes linhas desta matriz s�o zero, pelo que a matriz � dada por:
c = [ line1_C ; zeros(N_places2 - 2 , N_trans1) ; last_line_C ]; 

% Matriz incid�ncia da petri net a acrescentar, d:
d = Post2 - Pre2; 

% Matriz Incid�ncia Final:
D = [ a b ; c d ];  

end

