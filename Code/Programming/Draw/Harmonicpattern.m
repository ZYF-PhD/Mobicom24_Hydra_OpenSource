% function Target harmonic pattern
function Harmonicpattern(lambda0,lambda1,A,P)
% Input parameters:
%   lambda0 - Incident signal wavelength
%   lambda1 - Reflection wavelength
%   A       - Harmonic Amplitude
%   P       - Harmonic compensation phase
%---------------------------------------------
global d Nx Ny R in_theta
% d:Array element spacing (i.e. array element size), unit is m
% R:The distance between the feed source and the plane array, unit is m
% Nx:Number of array elements on the x-axis
% Ny:Number of array elements on the y-axis
% in_theta:Angle of incidence
NA = 181;
NE = 181;
order = '0 order';
%% Calculate the actual distance between each array element and the feed
position_x = Nx*d/2 + R*tan(in_theta);
position_y=Ny*d/2;  % Feed location
D0=zeros(Ny,Nx); 
for i=1:Ny
    for j=1:Nx
        dy=d/2+(i-1)*d-position_y;
        dx=d/2+(j-1)*d-position_x;
        D0(i,j)=sqrt(dy^2+dx^2+R^2);   
    end
end
D=2*pi/lambda0*D0;% The actual phase of the transmitted beam

%% Calculating Harmonic Phase
harmonicpattern=zeros(Ny,Nx);
for i=1:Ny
    for j=1:Nx
        harmonicpattern(i,j)=P(i,j)+D(i,j);
    end
end
harmonicpattern=mod(harmonicpattern,2*pi);
harmonicpattern=harmonicpattern*lambda1/(2*pi);

%% Calculate Harmonic Direction Pattern

phi = linspace(-pi/2,pi/2,NA);
theta = linspace(-pi/2,pi/2,NE);
pattern=zeros(length(phi),length(theta)); 
aa = d/2:d:(Ny-1)*d+d/2;
DD1 = repmat(aa',1,Nx);
bb = d/2:d:(Nx-1)*d+d/2;
DD2 = repmat(bb,Ny,1);
DD = DD1+sqrt(-1).*DD2;

 for jj = 1:length(phi) 
    for ii = 1:length(theta)    
        pattern0 = A.*exp(sqrt(-1) *2*pi/lambda1*(sin(theta(ii))*sin(phi(jj))*real(DD)+sin(theta(ii))*cos(phi(jj))*imag(DD)...
              -harmonicpattern));
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
title(['Target harmonic pattern    ' order]);
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
title(['Target harmonic pattern(Pitch angle = 0)   ' order]);