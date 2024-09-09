clc;close all;clear all;
% a principle simulation of frequency offset signals
FS = 20;
%% Incident signal
% Define signal parameters
f0 = 5.25e9; % Signal frequency is 5.25 GHz
T = 1e-6;    % Reflection coefficient signal period
fs = 50e9;   % Sampling Rate
t = 0:1/fs:4*T; % Time vector from 0 to 5*T with a step size of 1/fs
j = sqrt(-1);   % Define imaginary unit
x = exp(j*2*pi*f0*t); % Generate a complex exponential signal with frequency f0
X = fft(x);           % Perform FFT on the signal x
N = length(X);        % Length of the FFT result
fx = (-N/2:(N-1)/2)*(fs/N); % Compute the corresponding frequency vector
Xshift = fftshift(X/N);     % Normalize the FFT result and shift zero frequency component to center

% Plot the frequency spectrum
figure(1);
plot(fx/1e9,abs(Xshift) ,'DisplayName','Incident signal','Linewidth', 2, 'MarkerSize', 8,Color=[45, 48, 138]/255);
set(gca,'Fontsize',FS)
xlim([5.24, 5.26]);
ylim([0, 1.2]);
xticks(5.24:0.01:5.26);
yticks(0:0.2:1);
xlabel('Frequency (GHz)');
ylabel('Magnitude') ;
legend('show', 'Box', 'off');


%% State transition sequence
% Define the parameters
num=4;              % Number of steps in the step function
t_step = T/num;     % The duration of each step
values = [0,pi/2, pi,3*pi/2,0];  % The values of the step function
z = zeros(size(t)); % Initialize the step function
% Create the step function
for i = 1:num
    z = z + values(i) * (heaviside(mod(t, T) - (i-1)*t_step) - heaviside(mod(t, T) - i*t_step));
end
% Plotting State transition sequence
figure(2);
plot(t,rad2deg(z),'w', 'Linewidth', 2, 'MarkerSize', 8,Color=[53, 85, 137]/255);
set(gca,'Fontsize',FS)
xlabel('Time (us)','FontSize',FS);
ylim([0,330]);
yticks([0, 90, 180, 270]);
yticklabels({'0', '\pi/2', '\pi', '3\pi/2', '2\pi'});
ylabel('State ','FontSize',FS);
grid off;

%% Emerging signal
z=exp(j*z);     % generate reflection coefficient function
y=x.*z;         % Time domain multiplication
Y = fft(y);     % Perform FFT on the signal y
N_Y = length(Y);      % Length of the FFT result
fy = (-N_Y/2:(N_Y-1)/2)*(fs/N_Y);   % Compute the corresponding frequency vector
Yshift = fftshift(Y/N_Y);           % Normalize the FFT result and shift zero frequency component to center

% Plotting incident signal and emerging signal
figure(3);
xlabel('Frequency (GHz)','FontSize',FS);
ylabel('Magnitude','FontSize',FS) ;
plot(fx/1e9,abs(Xshift) ,'DisplayName','Incident signal','Linewidth', 2, 'MarkerSize', 8,Color=[45, 48, 138]/255);
hold on;
plot(fy/1e9,abs(Yshift),'DisplayName','Emerging signal', 'Linewidth', 2, 'MarkerSize', 8,Color=[237, 28, 36]/255);
xlim([5.24, 5.26]);
ylim([0, 1.2])
xticks(5.24:0.01:5.26);
yticks(0:0.2:1);
xlabel('Frequency (GHz)','FontSize',FS);
ylabel('Magnitude','FontSize',FS) ;
tt = legend('show', 'Box', 'off');
tt.NumColumns=1;
set(gca,'FontSize',FS);

