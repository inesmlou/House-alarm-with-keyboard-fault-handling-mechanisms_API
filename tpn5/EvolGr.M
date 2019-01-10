function [B,VV,D] = evolgr(Pre,Post,M0,V)


% [B,VV,D] = evolgr(Pre,Post,M0,V) function evolgr finds an evolution graph 
% of constant speed continuous Petri Net [David&Alla- Performance Evaluation 33 1998]
% V - 	column vector of maximal firing speeds associated to the transitions
% B - 	matrix of IB states (invariant behaviour - instantaneous firing speeds remain constant during delta period)
%	j-th column of B corresponds to j-th IB state (representing the marking at the begining of delta period)
% VV -  j-th column of matrix VV corresponds to instantaneous firing speeds during j-th IB state
% D -	row vector of delta periods (j-th entry of D corresponds to the j-th IB state)

%CCPN with weights and arcs equal to 0 or 1
M=M0;
B=M;
VV=[];
D=[];
[nofp,noft]=size(Pre);

run=1;

while run	%main loop

%calculate the set of enabled transitions
XA=zeros(1,nofp);
XE=zeros(1,noft);
go=1;
while go
	XAnew=sign(M')|sign((Post*XE')');    %place is marked or supplied (some of input transitions is enabled)
	XEnew=zeros(1,noft);
	for j = 1:noft
		if sign(Pre(:,j))==sign(Pre(:,j).*XAnew')
			XEnew(1,j)=1;
	  	end
	end
	XEnew=~any(Pre)|XEnew;		%transition is source transition or all its places are marked or supplied 
	if (all(XEnew==XE)&all(XAnew==XA))
		go=0;
	else
		go=1;
	end
	XA=XAnew;
	XE=XEnew;
end

for k=1:noft
    	XS(k)=all(M >= Pre(:,k));  % strongly enabled transition
end

%calculation of instantaneous firing speed
fXE=find(XE);
v=zeros(1,noft);
go=1;
while go
	vnew=zeros(1,noft);
	for j = 1:noft
	       if XE(j) ~= 0		%enabled transition
  	       	 if XS(j) ==1		%strongly
  	           vnew(j)=V(j);
  	       	 else			%weakly
		   fi=find(Pre(:,j));		%input places
		   fj=find(fXE==j);		%my position
  	           for i=1:size(fi,1)
			mv(i)=0;		
			for k=1:fj-1
			    mv(i)=mv(i)+(Post(fi(i),fXE(k))-Pre(fi(i),fXE(k)))*vnew(fXE(k));
			end
			for k=fj+1:size(fXE,2)
		    	    mv(i)=mv(i)+(Post(fi(i),fXE(k))-Pre(fi(i),fXE(k)))*v(fXE(k));
			end
		   end
		   vnew(j)=min([V(j),mv]);
		 end
  	       end
	end
	
	if (sum(abs(vnew-v))<=0.00001)
		go=0;
	else
		go=1;
	end
	v=vnew;
end
VV=[VV,v'];

%calculate synchronous balance 
bal=(Post-Pre)*v';

%calculate time interval
fb=find(bal<0);		%negative balance
ratio=zeros(size(fb,1),1);
for i=1:size(fb,1)
	ratio(i)=M(fb(i))/(-bal(fb(i)));
end
delta=min(ratio);
D=[D,delta];

%end test
if isempty(fb)
	run=0;
else
	M=M+bal*delta;		%new marking
	B=[B,M];
end

end	%main loop end