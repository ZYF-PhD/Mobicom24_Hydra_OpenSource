tic;
% Create codebook table
%% Parameter setting

B = 2;      % Number of biCreatts
L = 6;      % Sequence length
m = -1;     % -1 order
b1 = 1;     % +1 order
j = sqrt(-1);
num = 1;    % Table Index
%% Calculation
for g = 1:4
    for t = 1:4
        for z = 1:4
            for p = 1:4
                for q = 1:4
                    for x = 1:4
                        code = [g-1,t-1,z-1,p-1,q-1,x-1];
                        for i=1:L
                            pm=(1/L)*exp(j*code(i)*2*pi/(2^B))*sinc(m/L)*exp(-j*pi*m*(2*i-1)/L);
                            pb1=(1/L)*exp(j*code(i)*2*pi/(2^B))*sinc(b1/L)*exp(-j*pi*b1*(2*i-1)/L);

                            am(i) = pm;
                            ab1(i) = pb1;

                        end
                        sum_am = sum(am);
                        sum_ab1 = sum(ab1);
                        % Eliminate errors
                        sum_am = EliminateErrors(sum_am);
                        sum_ab1 = EliminateErrors(sum_ab1);

                        % Amplitude and Phase
                        A1=abs(sum_am);
                        P1=phase(sum_am);
                        A2 = abs(sum_ab1);
                        P2=phase(sum_ab1);

                        % Constraints can be changed based on specific task requirements.
                        if   (A1 > 0) && (A2 > 0)
                            % sequence of state transitions
                            context(num,:) = code;

                            % -1 harmonics
                            fi(num,1) = A1;
                            fi(num,2) = P1;

                            % +1 harmonics
                            fi(num,3) = A2;
                            fi(num,4) = P2;
                            num = num + 1;
                        end
                    end
                end
            end
        end
    end
end
toc;
%% Save results
save('context.mat', 'context');
save('fi.mat', 'fi');
