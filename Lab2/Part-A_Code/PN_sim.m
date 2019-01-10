function [t, M, yout, qin]= PN_sim(Pre, Post, M0, ti_tf, options)

% Simulating a Petri net, using a SFC/Grafcet simulation methodology.
% See book "Automating Manufacturing Systems", by Hugh Jack, 2008
% (ch20. Sequential Function Charts)
%
% Petri net model:
%  M(k+1) = M(k) +(Post-Pre)*q(k)
%  Pre and Post are NxM matrices, meaning N places and M transitions
%
% Input:
%  Pre  : NxM : preconditions matrix
%  Post : NxM : postconditions matrix
%  M0   : Mx1 : intial marking
%  ti_tf: 1x2 : init and final time
%
% Output:
%  t   : NTx1 : time vector (steps of 5ms)
%  M   : NTxM : states of the PN along time
%  yout: NTxNO: output of the PN along time
%
% Requires the following auxiliary functions:
%  function act=  PN_s2act(MP)
%  function yout= PN_s2yout(MP)
%  function qk=   PN_tfire(MP, t)

% Nov2011, Nov2016 (output structure), J. Gaspar

if nargin<4
    kb_tst(2);
    return
end

% 0. Start PN at state M0
%
dt= 5e-3; if length(ti_tf)>=3, dt= ti_tf(3); end
PN= struct('MP',M0, 'trans',zeros(size(Pre,2),1), 'yout',[], ...
    'Pre',Pre, 'Post',Post, ...
    'ti',ti_tf(1), 'tf',ti_tf(2), 'tm',ti_tf(1), 'dt',dt );

tSav= (PN.ti:PN.dt:PN.tf)';
MPSav= zeros(length(tSav), length(PN.MP));
youtSav= zeros(length(tSav), length(PN_s2yout(PN.MP)));

h = waitbar(0,'Please wait...');
for i= 1:length(tSav)
    
    PN.tm= tSav(i);

    % 1. Check transitions and update state
    %    ik = PN outputs = system to control inputs
    %    qk = PN inputs  = system to control outputs
    ik=  PN_s2act(PN.MP);
    qk=  PN_tfire(ik, PN.tm);
    [PN.MP, qk2]= PN_state_step(PN.MP, Post, Pre, qk);
    
    % 2. Define results given the current PN state
    yout= PN_s2yout(PN.MP);
    
    % Log main data i.e. states, enabled firings, results
    MPSav(i,:)= PN.MP';
    qkSav(i,:)= qk'; %qk2';
    youtSav(i,:)= yout;

    waitbar((PN.tm-PN.ti)/(PN.tf-PN.ti), h);

end; % while
close(h);

% define the output arguments i.e. time t, states M, results yout
% (currently not returning inputs/outputs i.e. ik/qk)
%
if nargout==1
    % return data as a structure
    t= struct('t',tSav, 'qin',qkSav, 'M',MPSav, 'yout',youtSav);
else
    % return data separated by various output arguments
    t   = tSav;
    M   = MPSav;
    yout= youtSav;
    qin = qkSav;
end

return


function qk2= filter_possible_firings(M0, Pre, qk)
% verify Pre*q <= M
% try to fire all qk entries

M= M0;
mask= zeros(size(qk));
for i=1:length(qk)
    mask(i)= 1;
    if any(Pre*(mask.*qk) > M)
        % exceeds available markings
        mask(i)= 0;
        %else
        % % mask(i) is ok, apply the firing
        % % (consume some marking)
        % M= M - Pre(:,i)*qk(i);
    end
end
qk2= mask.*qk;


function [MP, qk2]= PN_state_step( MP, Post, Pre, qk )
% Petri net evolution given the desired firing vector qk and
% the incidence matrix D=Post-Pre
%
% MP  : Nx1 : current state, marked places
% Post: NxM : posconditions matrix, marking increment
% Pre : NxM : preconditions matrix, marking decrement (positive entries)
% qk  : Mx1 : desired firing vector
% qk2 : Mx1 : feasible firing vector

qk2= filter_possible_firings(MP, Pre, qk(:));
MP= MP +(Post-Pre)*qk2;
