function yout= PN_s2yout(MP)

% Show the detected/undetected key(s) given the Petri state
%
% MP: 1xN : marked places (integer values >= 0)

%error('function NOT implemented')
yout= zeros(1,12);

indice = find(MP);

if indice == 4
    yout(1) = 1;
elseif indice == 5
    yout(4) = 1;
elseif indice == 6
    yout(7) = 1;
elseif indice == 7
    yout(10) = 1;
elseif indice == 8
    yout(2) = 1;  
elseif indice == 9
    yout(5) = 1;
elseif indice == 10
    yout(8) = 1;
elseif indice == 11
    yout(11) = 1;
elseif indice == 12
    yout(3) = 1;
elseif indice == 13
    yout(6) = 1;
elseif indice == 14
    yout(9) = 1;
elseif indice == 15
    yout(12) = 1;
end
yout= yout';
