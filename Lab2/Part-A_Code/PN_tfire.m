function qk= PN_tfire(act, t)

% Possible-to-fire transitions given PN outputs (act) and the time t
%
% act: 3x1 : PN outputs (PLC outputs) 
% t  : 1x1 : time
% qk : 1xM : possible firing vector (to be filtered later with enabled
%            transitions)

%error('function NOT implemented')

% -----------------------------
% Funcionamento random da Petri net
 qk= [round(rand(1,27))]; 

 if qk(4:7) == 0
    qk(1) = 1;
elseif qk(8:11) == 0
    qk(3) = 1;
 elseif qk(12:15) ==0
     qk(2) = 1;
 end
 
% -----------------------------
% Funcionamento da petri net com inputs predefinidos
%
% lines = PN_device_kb_IO(act, t);
% 
% qk = zeros(1, 27);
% 
% if act(1)
%     if lines(1)
%         qk(4)=1;
%     elseif lines(2)
%         qk(5)=1;
%     elseif lines(3)
%         qk(6)=1;
%     elseif lines(4)
%         qk(7)=1;
%     else
%         qk(1) =1;
%         qk(16)=1;
%         qk(17)=1;
%         qk(18)=1;
%         qk(19)=1;
%     end
% 
% elseif act(2)
%     if lines(1)
%         qk(8)=1;
%     elseif lines(2)
%         qk(9)=1;
%     elseif lines(3)
%         qk(10)=1;
%     elseif lines(4)
%         qk(11)=1;
%     else
%         qk(3) =1;
%         qk(20)=1;
%         qk(21)=1;
%         qk(22)=1;
%         qk(23)=1;
%     end    
%     
% elseif act(3)
%     if lines(1)
%         qk(12)=1;
%     elseif lines(2)
%         qk(13)=1;
%     elseif lines(3)
%         qk(14)=1;
%     elseif lines(4)
%         qk(15)=1;
%     else
%         qk(2) =1;
%         qk(24)=1;
%         qk(25)=1;
%         qk(26)=1;
%         qk(27)=1;
%     end
% end
