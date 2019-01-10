addpath(genpath('D:\Tecnico\5º Ano\API\Trabalho 2\Parte C\spnbox'));
addpath(genpath('D:\Tecnico\5º Ano\API\Trabalho 2\Parte C\tpn5'));
addpath(genpath('C:\Users\Catarina\Documents\IST\API\spnbox'));
addpath(genpath('C:\Users\Catarina\Documents\IST\API\tpn5\tpn5'));

% Pode-se fazer das duas maneiras:
% 1 - Directamente pelo petri  net conjunto
    %[Pre, Post, M0] = rdp('FINAL.RDP');

% 2 - Apartir das duas petri nets separadamente:
    [Pre_KB, Post_KB, M0_KB] = rdp('KB_READ.RDP');
    [Pre_Err, Post_Err, M0_Err] = rdp('SUPERVISOR.RDP');

    Pre = Add_2_Petri_Net_Independent(Pre_Err,Pre_KB);
    Post = Add_2_Petri_Net_Independent(Post_Err,Post_KB);
    M0 = [M0_Err' M0_KB']';

    
% Projectar o Supervisor controlador:
b = ones(3,1);

L = [0 1 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0;
    0 1 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0;
    0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1];
 
 [Dfm, Dfp, ms0] = linenf(Pre, Post, L, b, M0);
 
 Df = Dfp - Dfm;
 