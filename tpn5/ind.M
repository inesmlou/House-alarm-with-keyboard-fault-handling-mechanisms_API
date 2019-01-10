function [indexed_f]= ind(x)
% adds row/column indexes
f=x;
indexed_f=[[1:size(f,1)]',f,[1:size(f,1)]'];
f=f';			
disp('Matrix with indexes added:');
indexed_f=indexed_f';
indexed_f=[[0:size(f,1),0]',indexed_f,[0:size(f,1),0]']';
