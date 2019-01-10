function [A,RM] = graphpri(Pre,Post,M0,PrioT)
% [A,RM] = graphpri(Pre,Post,M0,PrioT)
% function graphpri finds a graph of reachable markings to given marked bounded Priority Petri Net
% A - 	Adjacency matrix (A(i,j) means oriented arc from vertex i to vertex j)
%	value of A(i,j) means index of fired transition
% RM - 	Matrix of reachable states (each column represents marking of one state)

RM=M0
A=[0]
[nofp,noft]=size(Pre);

C=Post-Pre

i=0
while i < size(RM,2)	%main loop - while (number of alredy inspected states)<(number of existing states)
	i=i+1;
	sprintf('--------inspecting state %i',i)
	%generation of vector of  enabled transitions
	for k=1:noft
	    	x(k)=all(RM(:,i) >= Pre(:,k));  			% x - enabled transition
	end
	fx=find(x)						%fx - list of enabled transitions

	%start priority%  priority effective conflict
	Pr_Ef_Conf=zeros(size(Pre));
	for k=1:nofp
        	Pr_Ef_Conf(k,:) = PrioT'.*x.*sign(Pre(k,:));  
	end
	%%column of maximal elements in each row
Pr_Ef_Conf
	Maxim=max(Pr_Ef_Conf')'
	%% from the list of enabled transitions eliminate the ones that lost
	ffx=[];
	for k=1:size(fx,2)
		if (Pre(:,fx(k)).*Maxim==Pr_Ef_Conf(:,fx(k)))
			ffx=[ffx,fx(k)];
		end
	end
ffx
	fx=ffx;							%%fx - list of priority enabled transitions
	%end priority%

	for k=1:size(fx,2)
            	bb = RM(:,i)+C(:,fx(k));
		mat_bb=[];
		for j=1:size(RM,2)
			mat_bb=[mat_bb,bb];
		end;
		v=all(mat_bb == RM);
		j=find(v);
		if size(j,2)>1
                    sprintf('!!!!!!!!!! State is duplicated')
		end
		if any(v)					%state already exists
			A(i,j)=	fx(k);
		else						%state does not exist
			RM=[RM,bb];
			A(size(A,1)+1,size(A,2)+1)=0;
			A(i,size(A,2))=fx(k);
		end;
	end;

RM;
A;

end	%main loop