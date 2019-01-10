%API LAB 2 A Petri Nets
%Group A1
clc; clear all; close all;

[Pre, Post, M0] = rdp('demo_net.rdp');
[A, RM] = graphnet(Pre, Post, M0);
disp_gr(A)