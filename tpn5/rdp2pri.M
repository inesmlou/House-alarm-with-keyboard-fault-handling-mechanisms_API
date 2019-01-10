function [Pre,Post,M0,TimeT,TypeT,PrioT] = rdp2pri(filename)
% [Pre,Post,M0,TimeT,TypeT,PrioT] = rdp2pri(filename)
% reads matrices Pre, Post and markings from "PM Editeur" format file
% This function must be also used when we want to read parameters of continuous Petri net, 
% where parameter PrioT is equivalent to V (vector maximal speed in CPN)
% Calls - getnum.m, getpnt.m
% PrioT - 0 indicates no priority (or lowest priority)
fid = fopen(filename,'r');
F = fread(fid);
s = setstr(F');
%********** find parameters **********
pla=findstr(s,'NB_PLACE');
pl=getnum(s,pla);
tra=findstr(s,'NB_TRANS');
tr=getnum(s,tra);
arc=findstr(s,'NB_ARC');
ar=getnum(s,arc);
%********** find marking **********
xpl=findstr(s,'[P');
mar=findstr(s,'MARKING');
if ((size(xpl,2)~=size(mar,2))|(size(xpl,2)~=pl))
  sprintf('Places red incorrectly')
end
for k=1:pl
  ma(k)=getnum(s,mar(k));  
end       
M0=ma';
%********** find Time **********
xtta=findstr(s,'[T');
tim=findstr(s,'DESCRIPTION');
if ((size(xtta,2)+pl)~=size(tim,2))
  sprintf('Time red incorrectly 1')
end
if (size(xtta,2)~=tr)
  sprintf('Time red incorrectly 2')
end
pri=findstr(s,'PRIORITY');
for k=1:tr
  [tti(k),ttp(k)]=getpnt(s,tim(k+pl));
  pr(k)=getnum(s,pri(k));    
end       
TimeT=tti';
TypeT=ttp';
PrioT=pr';
%********** find interconnections **********
xar=findstr(s,'[A');
p2t=findstr(s,'PLACE2TRANS');
sou=findstr(s,'SOURCE');
des=findstr(s,'DEST');
val=findstr(s,'VALUE');
%tem=findstr(s,'TEMPORISATION'); %there is temporisation of places and transitions as well
%arc_tem=tem([(pl+tr+1):size(tem,2)]);
Pre=zeros(pl,tr);
Post=zeros(pl,tr);
if ((size(xar,2)~=ar)|(size(p2t,2)~=ar)|(size(sou,2)~=ar)|(size(des,2)~=ar)|(size(val,2)~=ar))
  sprintf('Arcs red incorrectly')
end
for k=1:ar
  p2(k)=getnum(s,p2t(k));
  so(k)=getnum(s,sou(k))+1;  
  de(k)=getnum(s,des(k))+1;  
  va(k)=getnum(s,val(k)); 
  if p2(k)==1
    Pre(so(k),de(k))=va(k);
  else
    Post(de(k),so(k))=va(k);
  end
end   
fclose(fid);