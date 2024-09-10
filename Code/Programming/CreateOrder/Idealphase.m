% function Calculate the phase difference between the feed source transmission beam and the target beam
function[P,u] =Idealphase(lambda0,lambda1,theta1,phi1)
% Input parameters:
%   lambda0 - Incident signal wavelength
%   lambda1 - Reflection wavelength
%   theta1  - Target beam azimuth
%   phi1    - Target beam elevation angle
%
% Output parameters:
%   P - Ideal target phase
%   u - Ideal compensation phase   
%---------------------------------------------
global d  R  Nx Ny in_theta
% d:Array element spacing (i.e. array element size), unit is m
% R:The distance between the feed source and the plane array, unit is m
% Nx:Number of array elements on the x-axis
% Ny:Number of array elements on the y-axis
% in_theta:Angle of incidence

%% Calculate the actual distance between each array element and the feed
position_x = Nx*d/2 + R*tan(in_theta);
position_y=Ny*d/2; % Feed location
D0=zeros(Ny,Nx);
for i=1:Ny
    for j=1:Nx
        dy=d/2+(i-1)*d-position_y;
        dx=d/2+(j-1)*d-position_x;
        D0(i,j)=sqrt(dy^2+dx^2+R^2);

    end
end
D=2*pi/lambda0*D0;% The actual phase of the transmitted beam

%% Find the phase difference between the ideal phase and the actual phase
aa=d/2:d:(Ny-1)*d+d/2;
DD1=repmat(aa',1,Nx);
bb=d/2:d:(Nx-1)*d+d/2;
DD2=repmat(bb,Ny,1);
DD=DD1+sqrt(-1).*DD2;

P1=sin(phi1)*sin(theta1)*real(DD)+sin(theta1)*cos(phi1)*imag(DD);

P=2*pi/lambda1*P1; % Target beam phase

comphi=P-D;
u=mod(comphi,2*pi);
P=mod(P,2*pi);

