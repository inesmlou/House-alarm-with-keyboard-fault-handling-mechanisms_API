function act= PN_s2act_C(MP)

% Create 4x3-keyboard column actuation
%
% MP:  1xN : marked places (integer values >= 0)
% act: 1x3 : column actuation values (0 or 1 per entry)

%error('function NOT implemented')

indice = find(MP);

if any(indice == 3) || any(indice == 6) || any(indice == 7) || any(indice == 8) || any(indice == 9)
    
    act = [1,0,0];
    
elseif any(indice == 4) || any(indice == 10) || any(indice == 11) || any(indice == 12) || any(indice == 13)
    
    act = [0,1,0];

elseif any(indice == 5) || any(indice == 14) || any(indice == 15) || any(indice == 16) || any(indice == 17)

    act = [0,0,1];

end

    