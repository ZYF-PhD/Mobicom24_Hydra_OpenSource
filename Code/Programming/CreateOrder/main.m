% Beamforming target phase
clc;close all;clear all
global d Nx Ny NA NE R in_theta
f0 = 5.25e9; % Array element transmit signal frequency
f1=  5.2499925e9;    % -1 order
f2 = 5.2500075e9;    % +1 order

c = 3*1e8;           % Speed ​​of Light
lambda0 = c/f0;      % Incident signal wavelength
lambda1 = c/f1;      % -1 order harmonic wavelength
lambda2 = c/f2;      % +1 order harmonic wavelength

d = 0.0195; % Array element spacing (i.e. array element size), unit is m
Nx = 16;    % Number of array elements on the x-axis
Ny = 16;    % Number of array elements on the y-axis
NA =181;    % Sampling Rate
NE =181;
A=1;        % Amplitude

%% Sender Parameters

% The vertical distance between Tx and MTS, in meters
R = 1;

% Angle of incidence
in_theta = deg2rad(0);

%% Receiver Parameters

theta1 = deg2rad(30); % Target beam azimuth
phi1 = deg2rad(0);    % Target beam elevation angle

%% Calculation Compensation Phase

% -1,+1 order to obtain the ideal compensation coding matrix
[P1,u1] = Idealphase(lambda0,lambda1,theta1,phi1); 
[P2,u2] = Idealphase(lambda0,lambda2,theta1,phi1);

% -1,+1 order actual compensation pattern
Idealpattern(lambda0,lambda1,A,P1); 
Idealpattern(lambda0,lambda2,A,P2); 
%% Save results

% Save the -1 order and +1 order 
% beamforming target compensation phase as P,Q
save('P.mat', 'u1');
save('Q.mat', 'u2');


