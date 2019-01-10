function plot_z_C(t, z, options)
% Show various time signals, collected as columns z(:,i)
%
% t : Nx1 : time range
% z : Nxm : signals to show
%
% cstr: string : (facultative) plot modifier

% Nov2013, Nov2015 (columns), JG

if nargin<3
    options= [];
end
if ischar(options)
    cstr= options;
elseif isfield(options, 'cstr')
    cstr= options.cstr;
else
    cstr= '.-';
end

if isempty(t)
    x= (1:size(z,2))';
else
    x= t(:);
end
if ~isfield(options, 'plot3')
    dy= 0.5*z/max(max(abs(z))); % used for plot2
end

washold= ishold;
hold on
for i=1:size(z,2)
    y= i+x*0;
    if isfield(options, 'plot3')
        plot3(x, y, z(:,i), cstr)
    else
        plot(x, y+dy(:,i), cstr);
    end
end
if ~washold
    hold off
end
