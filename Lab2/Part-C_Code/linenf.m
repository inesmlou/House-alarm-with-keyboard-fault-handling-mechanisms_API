function [Dfm, Dfp, ms0, how, dhow, Lf, Cf, bf] = linenf(Dm, Dp, L, b, m0, F, C, Tuc, Tuo)

% LINENF - Linear Inequality Enforcement
%
% This function creates the supervisor enforcing 
%
%              L*m + F*q + C*v <= b                                 (1)
%
% where m is the Petri net marking, v is the firing vector and q is a  
% vector of the size of the firing vector. The meaning of the inequali-
% ties is as follows. Let tj be an enabled transition at the marking m,
% m[tj>m', v' the firing vector after firing tj, and q be such that all
% its elements are 0 except for q(j) = 1. The transition tj may fire if
% the two conditions below are met:
%  1) L*m' + C*v' <= b
%  2) (1) holds true
%
% The function returns the structure that corresponds to the supervised
% Petri net, and the initial marking of the supervised Petri net (ms0),
% (the argument m0 specifies the initial marking of the plant Petri net.)
% The initial firing vector v0 is assumed to be 0. The syntax is:
%
% [Df^-, Df^+, ms0] = linenf(pn, L, b, F, C)
%
% The last four arguments of the function are optional. This means that if
% an argument is not of interest, it may be set to [] and that the following
% forms can also be used:
%
% [Df^-, Df^+, ms0] = linenf(pn, L, b)
% [Df^-, Df^+, ms0] = linenf(pn, L, b, F)
% [Df^-, Df^+, ms0] = linenf(pn, L, b, F, C)
%
% Alternative formats are:
%
% [Df^-, Df^+, ms0] = linenf(D^-, D^+, L, b, m0, F, C)
% [Df^-, Df^+, ms0] = linenf(D^-, D^+, L, b, m0, F, C, Tuc, Tuo)
%
% where D^- and  D^+ specify the incidence matrices and Tuc and Tuo the
% uncontrollable and unobservable transitions. For instance, Tuc = [3 4] 
% means that t3 and t4 (where the indices correspond to the incidence matrix)
% are uncontrollable. 
%
% When presented with uncontrollable and/or unobservable transitions, 
% additional outputs are of interest:
%
% [Df^-, Df^+, ms0, how, dhow] = linenf(...)
% 
% The function first transforms the constraints such that they are admissible, 
% and then enforces them; if the transformation succeeded, how = 'ok', else 
% how = 'not solved'. dhow{i} stores the status of constraint i: 'ok' or 
% 'not solved'. 
% 
% When the initial marking m0 is not given (that is m0 = []/pn.m0 = []), the 
% following output format is of interest
%
% [Df^-, Df^+, ms0, how, dhow, Lf, Cf, bf] = linenf(...)
%
% The additional outputs allow to compute the initial marking ms0 of the
% supervised system as a function of the marking m0 of the plant:
%
% ms0 = bf - Lf*m0 - Cf*v0

% Written by Marian V. Iordache, miordach@nd.edu

if strcmp(class(Dm),'struct')
    mpn = Dm;
    % Dm, Dp, L, b, m0, F, C, Tuc, Tuo
    % pn,  L, b, F,  C
    if nargin > 4, C = m0; end
    if nargin > 3, F = b; end
    if nargin > 1, b = L; L = Dp; end
    if nargin < 5, C = []; end
    if nargin < 4, F = []; end
    if nargin < 2, L = []; b = []; end
    Dm = mpn.Dm; Dp = mpn.Dp; m0 = mpn.m0; Tuc = mpn.Tuc; Tuo = mpn.Tuo;
else
    if nargin < 9, Tuo = []; end
    if nargin < 8, Tuc = []; end
    if nargin < 7, C = []; end
    if nargin < 6, F = []; end
    if nargin < 5, m0 = []; end
    if nargin < 4, b = []; end
end

chk_data(Dm,Dp); D = Dp - Dm;
[m,n] = size(D); m0 = m0(:);

% Eliminate multiple entries in Tuc & Tuo (e.g. Tuc = [3, 3] --> Tuc = [3])
tu = zeros(n,1); to = zeros(n,1); tu(Tuc) = 1; to(Tuo) = 1;
Tuc = find(tu); Tuo = find(to); 

fco_case = isempty(Tuc) & isempty(Tuo); 

if isempty(F), F = []; end
if isempty(L), L = []; end
if isempty(C), C = []; end

[k,m2] = size(L);
[p,n2] = size(F);
[r,n3] = size(C);
[u, v] = size(b);

xx = max([k, p, r]);
how = 'ok'; for i = 1:xx, dhow{i} = 'ok'; end

if isempty(F) & isempty(L) & isempty(C)
   Dfm = Dm; Dfp = Dp; ms0 = m0; return
end

if isempty(F), p = max(k,r); F = zeros(p,n); n2 = n; end
if isempty(L), k = max(p,r); L = zeros(k,m); m2 = m; end
if isempty(C), r = max(p,k); C = zeros(r,n); n3 = n; end
if isempty(b), b = zeros(k,0); end
if isempty(m0), m0 = zeros(m,0); end

[e,t] = size(m0);

if m ~= m2 | n ~= n2 | n3 ~= n | e ~= m 
error('Dimensions of incidence matrices, constraints and/or marking disagree')
end

if p ~= k | r ~= k | ((v ~= 1 | u ~= k) & ~isempty(b))
   error('Dimensions of constraints do not agree')
end

if isempty(b) & ~isempty(m0)
   error('the b parameter must be nonempty when an initial marking is given!')
end

if fco_case
   LD = L*D;

   LDp = max(0, -LD-C);
   LDm = max(0,  LD+C);

   Dfp = [Dp; LDp+max(0,F-LDm)];
   Dfm = [Dm; max(LDm,F)];

   if isempty(m0), ms0 = zeros(m+k,0);
   else ms0 = [m0; b-L*m0]; end

   Lf = L; bf = b; Cf = C;

   return
end

% Check admissibility: sufficient conditions for admissibility are tested 

Duc = D(:,Tuc); Duo = D(:,Tuo);%inadm: to store the "inadmissible" constraints
inadm = find(sum((L*Duc+C(:,Tuc))>0,2)); 
inadm = [inadm; find(sum((L*Duo+C(:,Tuo))~=0,2))];
inadm = [inadm; find(sum(F(:,Tuc)>0,2))]; 
% The line above assumes that it is possible to have controllable
% unobservable transitions. If this is not the case, set Tuc to 
% contain also the transitions in Tuo. 

xinadm = zeros(k,1); xinadm(inadm) = 1; % delete repeated occurrences in inadm
inadm = find(xinadm); adm = find(~xinadm); % and generate adm, the complement
Lx = L(inadm,:); Fx = F(inadm,:); Cx = C(inadm,:); ni = length(inadm);
if ~isempty(b), bx = b(inadm); else, bx = zeros(ni,0); end
Dxm = Dm; Dxp = Dp; Ifm = zeros(0,n); Ifp = Ifm;
xx = 0; yy = 0;
Fx(:,Tuc) = 0; % Fx contains only the admissible constraints

for i = 1:ni
   j = inadm(i);

   % Transformation of the constraints of C in marking constraints

   Dxm = Dm; Dxp = Dp;
   Tc = find(C(j,:)); mc = length(Tc);
   Dxm = [Dxm; zeros(mc,n)];
   Dxp = [Dxp; zeros(mc,n)];
   Dxp(m+1:m+mc,Tc) = eye(mc);
   lx = [L(j,:), C(j,Tc)]; % transformed marking constraint
   mx = m + mc; 

   % Transformation of the constraints of F in marking constraints

   Tf = find(sum(F(j,:)>0,1) & tu'); mf = length(Tf); 
   lx = [lx, F(j,Tf).*(F(j,Tf)>0)+lx*Dxm(:,Tf)]; % new marking constraints
   Dxm = [Dxm zeros(mx,mf); zeros(mf, n) eye(mf)];
   Dxp = [Dxp zeros(mx,mf); zeros(mf, n+mf)];
   Dxp(:,n+1:n+mf) = Dxp(:,Tf);
   Dxp(:,Tf) = 0;
   Dxp(mx+1:mx+mf,Tf) = eye(mf);
   mx = mx + mf; nx = n + mf;

   if isempty(m0), m0x = zeros(mx,0);
   else m0x = [m0(:); zeros(mx-m,1)]; end

   Txuc = [Tuc(:); (n+1:n+mf)']; Txuo = Tuo(:); Dx = Dxp - Dxm;

   % Transformation to admissible constraints

   la = lx;
   [la, ba, R1, R2, xhow, xdhow] = mro_adm(lx,b(j,:),Dx, Txuc, Txuo, m0x, 0);

   if ~strcmp('ok',xdhow) % in case of failure, try ilp_adm
     [la,bb,r1,r2,xdhow] = ilp_adm(lx,b(j,:),Dx,Txuc,Txuo,m0x,0);
     if ~isempty(b), ba = bb; end
   end
   if strcmp('ok',xdhow)
      lx = la; if ~isempty(b), bx(i) = ba; end
   else
      lx = zeros(1,mx); if ~isempty(b), bx(i) = 0; end
      dhow{j} = xdhow;
   end
   xx = xx | strcmp('not solved',xdhow);
   yy = yy | strcmp('impossible',xdhow);

   % Enforce the transformed constraint

   fx = [Fx(i,:), zeros(1,mf)];
   [Dfim, Dfip, mIx] = linenf(Dxm, Dxp, lx, bx(i,:), m0x, fx);
   if ~isempty(m0), mI(i) = mIx(mx+1); end

   % Collapse structure by removing transformation places

   Ifmx = Dfim(mx+1,:); Ifpx = Dfip(mx+1,:);
   Ifmx(:,Tf) = Ifmx(:,Tf) + Ifmx(:,n+1:n+mf); % ':,' added to deal with Tf = []
   Ifpx(:,Tf) = Ifpx(:,Tf) + Ifpx(:,n+1:n+mf);
   Ifm(i,:) = Ifmx(1:n); Ifp(i,:) = Ifpx(1:n);

   Cx(i,Tc) = lx(m+1:m+mc);
   Lx(i,:) = lx(1:m);
end

if xx, how = 'not solved'; end
if yy, how = 'impossible'; end

% Enforce admissible constraints into the transformed PN

[Dfam, Dfap, mA] = linenf(Dm, Dp, L(adm,:), b(adm), m0, F(adm,:), C(adm,:));

Afm = Dfam(m+1:m+k-ni,:); Afp = Dfap(m+1:m+k-ni,:);

% Final result

if ~isempty(m0)
   %mI = mI(mx+1:mx+ni); 
   mA = mA(m+1:m+k-ni); ms0 = zeros(m+k,1);
   ms0(1:m) = m0; ms0(m+adm) = mA; ms0(m+inadm) = mI;
else
   ms0 = zeros(m+k,0);
end
Dfp = [Dp; zeros(k,n)]; Dfm = [Dm; zeros(k,n)]; 
if ~isempty(adm), Dfp(m+adm,:) = Afp; Dfm(m+adm,:) = Afm; 
   Lf(adm,:) = L(adm,:); bf(adm,:) = b(adm,:); Cf(adm,:) = C(adm,:); end
if ~isempty(inadm), Dfp(m+inadm,:) = Ifp; Dfm(m+inadm,:) = Ifm; 
   Lf(inadm,:) = Lx(:,:); bf(inadm,:) = bx(:,:); Cf(inadm,:) = Cx(:,:); end

