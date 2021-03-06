addpath(genpath('D:\Tecnico\5� Ano\API\Trabalho 2\Parte C\tpn5'));
addpath(genpath('C:\Users\Catarina\Documents\IST\API\tpn5\tpn5'));

% How to simulate a Petri net:

        global keys_pressed; keys_pressed= []; % select default simulation

        %[Pre, Post, M0] = rdp('KB_READ.RDP');
        Controller_Supervisor;
        [t, M, yout]= PN_sim_C(Dfm, Dfp, ms0, [0 10]);

        figure(201), clf;
        subplot(121); plot_z_C(t,M); ylabel('place number'); xlabel('time [sec]');
        subplot(122); plot_z_C(t,yout); ylabel('key number'); xlabel('time [sec]'); 
        % o erro esta na "tecla" 13.
        % mostrar o erro a ir a cima num gr�fico diferente :
            %subplot(133); plot_z_C(t,yout(:,13)); ylabel('Erro'); xlabel('time [sec]');


% RDP.m requires a Petri net file, e.g.:
%  KB_READ.RDP

% PN_sim.m requires the following auxiliary functions:
%  function act=  PN_s2act(MP)
%  function yout= PN_s2yout(MP)
%  function qk=   PN_tfire(MP, t)

% PN_tfire.m requires the following auxiliary function:
%  function lines= PN_device_kb_IO(act, t)


% -- Note: functions
% 	PN_s2act.m
% 	PN_s2yout.m
% 	PN_tfire.m
% are NOT implemented.

