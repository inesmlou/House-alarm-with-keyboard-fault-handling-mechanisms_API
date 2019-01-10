function [n] = getnum(str,i)
%gets a number form a string containing '='

%skip over the text
while strcmp(str(i),'=')==0
 i=i+1;
end
i=i+1; 
j=i;	%number start position
while abs(str(i))~=13
 i=i+1;
end
n=str2num(str(j:i));
if isempty(n)
  n=0;
end