function [n,m] = getpnt(str,i)
% gets a number ans transition type from a string containing '='
% function [n,m] = getpnt(str,i)

%skip over the text
m=0;
while strcmp(str(i),'=')==0
 i=i+1;
end
i=i+1; 

if ((str(i) == 'S') | (str(i) == 's')) 
 m=2;
 i=i+1;
end

if ((str(i) == 'T') | (str(i) == 't')) 
 m=1;
 i=i+1;
end

j=i;	%number start position
while abs(str(i))~=13
 i=i+1;
end
n=str2num(str(j:i));
if isempty(n)
  n=0;
end