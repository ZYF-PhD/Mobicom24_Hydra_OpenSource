clc;close all;clear all;
global d Nx Ny R in_theta
%% Parameter settings
f0 = 5.25e9;        % Array element transmit signal frequency
f1=  5.2499925e9;   % -1 order
f2 = 5.2500075e9;   % +1 order
c = 3*1e8;          % Speed of Light
lambda0 = c/f0;     %  Incident signal wavelength
lambda1 = c/f1;     % -1 order harmonic wavelength
lambda2 = c/f2;     % +1 order harmonic wavelength
d = 0.0195;     % Array element spacing (i.e. array element size), unit is m
Nx = 16;        % Number of array elements on the x-axis
Ny = 16;        % Number of array elements on the y-axis


%% Sender Parameters

% The vertical distance between Tx and MTS, in meters
R = 1;

% Angle of incidence
in_theta = deg2rad(0);


%% Data load
a1=load('A1_all.txt');
a2=load('A2_all.txt');

b1=load('P1_all.txt');
b2=load('P2_all.txt');
%% Draw harmonic patterns
Harmonicpattern(lambda0,lambda1,a1,b1);
Harmonicpattern(lambda0,lambda2,a2,b2);




