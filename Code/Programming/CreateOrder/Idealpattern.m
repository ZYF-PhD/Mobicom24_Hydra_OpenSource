% function Target beam pattern under ideal conditions
function Idealpattern(lambda0,lambda1,A,P)
% Input parameters:
%   lambda0 - Incident signal wavelength
%   lambda1 - Reflection wavelength
%   A       - Reflection Amplitude
%   P       - Reflection Phase
%---------------------------------------------
global d Nx Ny NA NE
% d:Array element spacing (i.e. array element size), unit is m
% R:The distance between the feed source and the plane array, unit is m
% Nx:Number of array elements on the x-axis
% Ny:Number of array elements on the y-axis
% NA:Sampling Rate
% NE:Sampling Rate
%% Calculate Direction Pattern
phi = linspace(-pi/2,pi/2,NA);
theta = linspace(-pi/2,pi/2,NE);
aa = d/2:d:(Ny-1)*d+d/2;
DD1 = repmat(aa',1,Nx);
bb = d/2:d:(Nx-1)*d+d/2;
DD2 = repmat(bb,Ny,1);
DD = DD1+sqrt(-1).*DD2;

for jj = 1:length(phi)
    for ii = 1:length(theta)
        pattern0 = A.*exp(sqrt(-1) *(2*pi/lambda1*(sin(theta(ii))*sin(phi(jj))*real(DD)+sin(theta(ii))*cos(phi(jj))*imag(DD))...
            -P));
        pattern(jj,ii) = sum(sum(pattern0));
    end
end

%% Drawing Pattern
max_p=max(max(abs(pattern) ) ) ;
pattern_dbw=20*log10(abs(pattern)/max_p + eps );
number=find(pattern_dbw<-50);
g_temp=-50+unifrnd(-1,1,1,length(number) );
for ii=1:length(number)
pattern_dbw(number(ii) ) =g_temp(ii) ;
end
%% Determine the current calculated harmonic order、
order = '0 order';
if lambda1 > lambda0
    order = '-1 order';
elseif lambda1 < lambda0
    order = '+1 order';
end

% 3D Direction Map
figure();
mesh(theta*180/pi,phi*180/pi,pattern_dbw);
xlabel('Azimuth');
ylabel('Pitch angle');
title(['Ideal target beam pattern  ' order]);
% view([0,90]);

figure();
for n=1:length(theta)
    for m=1:length(phi)
        if n==91
            temp1(m)=pattern_dbw(n,m);
        end
    end
end
plot(theta*180/pi,temp1);
xlabel('Azimuth');
ylabel('dB');
title(['Ideal target beam pattern(Pitch angle = 0)  ' order]);

