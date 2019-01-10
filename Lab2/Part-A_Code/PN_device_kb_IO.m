function lines= PN_device_kb_IO(act, t)

% Define 4x3-keyboard output line-values given actuation on the 3 columns
% and an (internal) time table of keys pressed
%
% Input:
%  act: 1x3 : column actuation values
%  t  : 1x1 : time
%
% Output:
%  lines: 1x4 : line outputs

% Nov2011, J. Gaspar

% Note: % Matlab/Simulink (sim) way of specifying control inputs:
%  t = (0:0.1:1)';
%  u = [sin(t), cos(t), 4*cos(t)];
%  tu= [t, u]; % in each line is time and 3 control values

if nargin<1 && nargout<1
    PN_device_kb_IO_demo;
    return
end

if length(act)<3, error('input arg "act" must be 1x3'); end
if prod(size(t))~=1, error('input arg "t" must be 1x1'); end

global keys_pressed
if isempty(keys_pressed)
    % first column = time in seconds
    % next 12 columns = keys pressed at time t
    %
    tu= [...
        0  mk_keys([]) ; ...
        1  mk_keys(1)  ; ...
        2  mk_keys([]) ; ...
        3  mk_keys(5)  ; ...
        4  mk_keys([]) ; ...
        5  mk_keys(9)  ; ...
        6  mk_keys([]) ; ...
        7  mk_keys([9 12]) ; ...
        8  mk_keys(12) ; ...
        9  mk_keys([]) ; ...
        ];
    keys_pressed= tu;
end

% pressed keys yes/no
ind= find(t>=keys_pressed(:,1));
if isempty(ind)
    lines= [0 0 0 0]; % default lines output for t < 0
    return
end
keys_t= keys_pressed(ind(end), :);

% if actuated column and key pressed match, than activate line
lines= sum( repmat(act>0, 4,1) & reshape(keys_t(2:end), 3,4)', 2);
lines= (lines > 0)';

return


function y= mk_keys(kid)
y= zeros(1,12);
for i=1:length(kid)
    y(kid(i))= 1;
end


function PN_device_kb_IO_demo
% display the table of keys pressed

col1= [1 4 7 10];
col2= [2 5 8 11];
col3= [3 6 9 12];

kSav= [];
for t= 0:.1:10
    keys= zeros(1,12);
    [~,~,v]= find( PN_device_kb_IO([1 0 0], t).*col1 ); keys(v)=1;
    [~,~,v]= find( PN_device_kb_IO([0 1 0], t).*col2 ); keys(v)=1;
    [~,~,v]= find( PN_device_kb_IO([0 0 1], t).*col3 ); keys(v)=1;
    kSav= [kSav; keys];
end

figure(200), clf;
mesh(kSav); xlabel('keys pressed'); ylabel('time'); view([43 54])
