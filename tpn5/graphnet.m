function [A,RM] = graphnet(Pre,Post,M0)

%function [A,RM] = graph(Pre,Post,M0)
% function graph finds a graph of reachable markings to given marked bounded Petri Net
% A - 	Adjacency matrix (A(i,j) means oriented arc from vertex i to vertex j)
%	value of A(i,j) means index of fired transition
% RM - 	Matrix of reachable states (each column represents marking of one state)

RM=M0;
A=[0];
[nofp,noft]=size(Pre);

C=Post-Pre;

i=0;
while i < size(RM,2)	%main loop - while (number of alredy inspected states)<(number of existing states)
	i=i+1;
	sprintf('--------inspecting state %i',i)
	%generation of vector of  enabled transitions
	for k=1:noft
	    	x(k)=all(RM(:,i) >= Pre(:,k));  			% x - enabled transition
	end
	fx=find(x);
	
	for k=1:size(fx,2)
		bb = RM(:,i)+C(:,fx(k));
		mat_bb=[];
		for j=1:size(RM,2)
			mat_bb=[mat_bb,bb];
		end;
		v=all(mat_bb == RM);
		j=find(v);
		if size(j,2)>1
                    sprintf('!!!!!!!!!!11State is duplicated')
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
return; % end of main function
