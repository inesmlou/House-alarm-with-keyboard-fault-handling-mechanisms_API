function [ D_final ] = Add_2_Petri_Net_Independent( D1,D2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

n_transicoes1 = length(D1(1,:));
n_transicoes2 = length(D2(1,:));
n_places1 = length(D1(:,1));
n_places2 = length(D2(:,1));

a = D1;

b = zeros( n_places1, n_transicoes2);

c = zeros( n_places2, n_transicoes1);

d = D2;

D_final  = [a b ; c d];

end

