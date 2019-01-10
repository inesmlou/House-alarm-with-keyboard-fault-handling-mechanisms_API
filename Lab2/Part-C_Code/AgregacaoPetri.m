%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                       Agregação de Petri Nets                          %         
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(genpath('D:\Tecnico\5º Ano\API\Trabalho 2\Parte C\spnbox'));
addpath(genpath('D:\Tecnico\5º Ano\API\Trabalho 2\Parte C\tpn5'));
addpath(genpath('C:\Users\Catarina\Documents\IST\API\spnbox'));
addpath(genpath('C:\Users\Catarina\Documents\IST\API\tpn5\tpn5'));

[Pre_KB, Post_KB, M0_KB] = rdp('KB_READ.RDP'); % Petri Net Parte A)
[Pre_Err, Post_Err, M0_Err] = rdp('SUPERVISOR.RDP'); % Petri Net Parte C)

%Matrizes de incidência de ambas as Petri nets
Dp = Post_KB - Pre_KB;
Dd = Post_Err - Pre_Err;

[Pre_Agreg, Post_Agreg, M0_Agreg] = rdp('FINAL.RDP'); %Petri Net Agregada

%Matriz de incidência da Petri net agregada
D_Agreg = Post_Agreg - Pre_Agreg;

%Estado inicial da Petri net agregada
M0_Agreg;


