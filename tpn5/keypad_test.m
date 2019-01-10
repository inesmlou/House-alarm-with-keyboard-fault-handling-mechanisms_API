% Post, Post and M0 matrices
[Pre, Post, M0] = rdp('keypad.rdp')

% Incidence Matrix = D = D+ - D- = Post - Pre 
D = Post - Pre

[A, RM] = graphnet(Pre, Post, M0)

disp_gr(A)



