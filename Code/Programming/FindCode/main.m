tic;
%% Metasurface size
NX = 16;
%% Data loading
% target_P1 -1 order  target_P2 +1 order
target_P1 = load("../CreateOrder/P.mat");
target_P1 = mod(target_P1.u1,2*pi);
target_P2 = load("../CreateOrder/Q.mat");
target_P2 = mod(target_P2.u2,2*pi);

context = load("../CreateTable/context.mat");
context = context.context;
fi = load("../CreateTable/fi.mat");
fi = fi.fi;
%% data processing
C = target_P1;
C(C>deg2rad(180)) = C(C>deg2rad(180)) - deg2rad(360);
D = target_P2;
D(D>deg2rad(180)) = D(D>deg2rad(180)) - deg2rad(360);

target_P1_list = C;
target_P2_list = D;

code_array = cell(NX, NX);
P2_all = zeros(NX, NX);
P1_all = zeros(NX, NX);
A2_all = zeros(NX, NX);
A1_all = zeros(NX, NX);
%% Data search
for i = 1:NX
    for j = 1:NX
        target_P1 = target_P1_list(i,j);
        target_P2 = target_P2_list(i,j);
        fprintf('---------------------------------------------\n');
        fprintf('Sequence number: %d \n',NX * (i - 1) + j);
        fprintf('Match target phase: %f %f(target_P1,target_P2)\n' ,target_P1,target_P2);
        [P2, P1, A2, A1,g_best] = MeijuDouble(context,fi,target_P1,target_P2);
        code_array{i, j} = g_best;
        A2_all(i,j) = A2;
        A1_all(i,j) = A1;
        P2_all(i,j) = P2;
        P1_all(i,j) = P1;
    end
end

%% Data storage
code1 = zeros(NX,NX);
code2 = zeros(NX,NX);
code3 = zeros(NX,NX);
code4 = zeros(NX,NX);
code5 = zeros(NX,NX);
code6 = zeros(NX,NX);

for i = 1:NX
    for p = 1:NX
        code = code_array{i, p};
        code1(i,p) = code(1,1);
        code2(i,p) = code(1,2);
        code3(i,p) = code(1,3);
        code4(i,p) = code(1,4);
        code5(i,p) = code(1,5);
        code6(i,p) = code(1,6);

    end
end
% the state transition sequence table
writematrix(code1,'code1.txt');
writematrix(code2,'code2.txt');
writematrix(code3,'code3.txt');
writematrix(code4,'code4.txt');
writematrix(code5,'code5.txt');
writematrix(code6,'code6.txt');
% the amplitude phase corresponding to the -1st and +1st order harmonics
writematrix(A1_all,'..\Draw\A1_all.txt');
writematrix(A2_all,'..\Draw\A2_all.txt');
writematrix(P1_all,'..\Draw\P1_all.txt');
writematrix(P2_all,'..\Draw\P2_all.txt');

toc;
