% function Search the codebook table to match the target phase
function [P2, P1, A2, A1,g_best] = MeijuDouble( context,fi,target_P1,target_P2)
% Input parameters:
%   context -  All state transition sequences
%   fi      -  The amplitude and phase of the corresponding state sequence
%   target_P1  - Target phase of -1 order harmonic approximation
%   target_P2  - Target phase of +1 order harmonic approximation
%
% Output parameters:
%   g_best  -  Optimal state transition sequence
%   A1,P1   -  -1 order harmonic amplitude and phase corresponding to the optimal state transition sequence
%   A2,P2   -  +1 order harmonic amplitude and phase corresponding to the optimal state transition sequence
%----------------------------------------------------------------------------------------------------------
fitness_history = 1000;
index0 = 0;
cha_x = 0;
cha_y = 0;
w1 = 1; % Amplitude weight
w2 = 2; % Phase weight
[m,n] = size(fi);
for i = 1 :1: m
    P1 = fi(i,2);
    P2 = fi(i,4);
    A1 = fi(i,1);
    A2 = fi(i,3);
    cha_x = abs(P1 - target_P1);
    if cha_x > pi
        cha_x = 2*pi - cha_x;
    end
    cha_y = abs(P2 - target_P2);
    if cha_y > pi
        cha_y = 2*pi - cha_y;
    end
    % The phase difference should be as small as possible and the amplitude should be as large as possible
    % Adjustable ratio
    fitness = w1 * (cha_y + cha_x) + w2 *((1 - A1) + (1-A2));
    if(fitness < fitness_history)
        fitness_history = fitness;
        index0 = i;
        x = cha_x;
        y = cha_y;
    end
end
g_best = context(index0,:);
A1 = fi(index0,1);
P1 = fi(index0,2);
A2 = fi(index0,3);
P2 = fi(index0,4);
% Output
disp('Optimal solution：');
disp(g_best);
fprintf('  %f  |   %f   |   %f  |   %f(A1,P1,A2,P2)\n',A1,P1,A2,P2);
fprintf('---------------------------------------------\n');
end