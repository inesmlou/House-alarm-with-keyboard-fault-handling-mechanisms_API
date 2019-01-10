function demo(tstId)
if nargin<1
    tstId=1;
end
switch tstId
    case 1
        fname= 'demo_net.rdp';
    case 2
        fname= '../pmedit/didac/ex_03.rdp';
    case 3
        fname= '../pmedit/examples/net.rdp';
end


% 1. load the Petri Net
[Pre, Post, M0]= RDP(fname)

% 2. convert representation
[A, RM]= graph(Pre, Post, M0)

% 3. draw the graph of reachable markings (reachability tree)
disp_gr(A) %, RM) % RM is NOT used in disp_gr.m


if tstId==1
    % some more testing for a Stochastic Timed Petri Net
    %
    TimeT=[0 0 3 4]';
    TypeT=[0 0 1 1]';
    ticks=100;
    [Seq, M] = playSTPN(Pre, Post, M0, TimeT, TypeT, ticks);
    Seq'
end
