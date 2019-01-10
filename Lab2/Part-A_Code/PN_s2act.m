function act= PN_s2act(MP)

% Create 4x3-keyboard column actuation
%
% MP:  1xN : marked places (integer values >= 0)
% act: 1x3 : column actuation values (0 or 1 per entry)

%error('function NOT implemented')

indice = find(MP);

if indice == 1 || indice == 4 || indice == 5 || indice ==6 || indice == 7
    
    act = [1,0,0];
    
elseif indice == 2 || indice == 8 || indice == 9 || indice == 10 || indice == 11
    
    act = [0,1,0];

elseif indice == 3 || indice == 12 || indice == 13 || indice == 14 || indice == 15

    act = [0,0,1];

end

    