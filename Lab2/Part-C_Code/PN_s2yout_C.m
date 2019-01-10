function yout= PN_s2yout_C(MP)

% Show the detected/undetected key(s) given the Petri state
%
% MP: 1xN : marked places (integer values >= 0)

%error('function NOT implemented')
yout= zeros(1,13);

indice = find(MP);

%alterei os indices agora (sumei-lhes +2):
if any(indice == 6)
    yout(1) = 1;
elseif any(indice == 7)
    yout(4) = 1;
elseif any(indice == 8)
    yout(7) = 1;
elseif any(indice == 9)
    yout(10) = 1;
elseif any(indice == 10)
    yout(2) = 1;  
elseif any(indice == 11)
    yout(5) = 1;
elseif any(indice == 12)
    yout(8) = 1;
elseif any(indice == 13)
    yout(11) = 1;
elseif any(indice == 14)
    yout(3) = 1;
elseif any(indice == 15)
    yout(6) = 1;
elseif any(indice == 16)
    yout(9) = 1;
elseif any(indice == 17)
    yout(12) = 1;
end

if any(indice==2)
    yout(13)=1;
end
yout= yout';
