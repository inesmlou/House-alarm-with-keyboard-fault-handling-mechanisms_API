function [P]= silva(C)
% SILVA - algoritm Alfa2 /Martinez&Silva - LNCS 52/
%	P = SILVA(C) is a nonegative matrix such that:
%		1) each positive p-invariant could be done as a lambda 
%		   combination of the rows of P
%		2) no row of P could be done as a lambda 
%		   combination of other rows of P 
% 	Remarque: the lambda is a vector of nonnegative rational numbers Q+ 
%disp('             hanzalek@rtime.felk.cvut.cz')
%phase 1 - initialize P
[n,m]=size(C);
P = eye(size(C,1));
CC=C;
Csav=C;
for j=1:m %eliminate all transitions
%phase 2.1 - generate new places resulting as a non-negative linear combination 
%of one input and one output place to the transition j (new places are neither 
%input nor output places tio the transition j)
  POZ=find(CC(:,j)>0);
  NEG=find(CC(:,j)<0);
  for po=1:size(POZ,1)
     ii=POZ(po);
     for ne=1:size(NEG,1)
        jj=NEG(ne);
          al=abs(CC(ii,j))/gcd(CC(ii,j),CC(jj,j));
          be=abs(CC(jj,j))/gcd(CC(ii,j),CC(jj,j));         
          CC=[CC;al*CC(jj,:)+be*CC(ii,:)];  
          P=[P;al*P(jj,:)+be*P(ii,:)];           
     end 
  end
%phase 2.2 - eliminate input and output places to the transition j
  NZE=flipud(sort([POZ;NEG])); %sort in descending order
  for nze=1:size(NZE,1)
    ii=NZE(nze);
    CC=CC([1:(ii-1),(ii+1):size(CC,1)],:); % delete row ii
    P=P([1:(ii-1),(ii+1):size(P,1)],:); % delete row ii
  end
%phase 2.3 - eliminate the non minimal invariants
%put non-minimal invariants to DEL
  DEL=[];
  for ii=1:size(P,1)
   if CC(ii,:)==zeros(1,m) %look just for completed invariants - this should have the same efect as usual condition for P-invariant P(ii,:)'*Csave=0
    arr=find(P(ii,:)~=0);
    q=size(arr,2);
    if (q~=rank(Csav(arr,:))+1)
       DEL=[DEL,ii];
    end    
   end
  end
%delete non-minimal invariants
  DEL=fliplr(sort(DEL));
  for del=1:size(DEL,2)
    ii=DEL(del);
%    sprintf('non-minimal support invariant deleted')
%    P(ii,:)
    CC=CC([1:(ii-1),(ii+1):size(CC,1)],:); % delete row ii
    P=P([1:(ii-1),(ii+1):size(P,1)],:); % delete row ii
  end
end
CC;
