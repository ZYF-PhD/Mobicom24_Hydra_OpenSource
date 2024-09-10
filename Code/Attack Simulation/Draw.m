
FS = 20;
%% Data loading
% MaliciousSignals_1,2,3 represents the number of malicious signals
SIR = load("MaliciousSignals_2\SIR_MCS_7.mat").dd;
PER= load("MaliciousSignals_2\Per_MCS_7.mat").packetErrorRate;

%% Data processing
% Limit the x-axis range
if length(SIR(1,:))>100
    x = 100;
else
    x = length(SIR(1,:));
end
% Limited frequency offset range
y = 0:0.2:5;
% Data Extraction
for i = 1:1:length(y)
    for p = 1:1:x
        PER1(i,p ) = PER(i,p);
    end
end
% Get the x coordinate (approximately)
for i = 1:1:x
    SIR1(1,i) = SIR(1,i);
end
% Invert
PER1 = flip(PER1);
%% Drawing
figure(1)
imagesc(SIR1,y,PER1)
set(gca,'FontSize',FS);
shading interp;

% Color
c = colorbar();
colors = [53,11,61;141,26,40;175,51,37;169,107,40;205,204,202;] / 255;
colormap(GenColormap(colors))
% Drawing parameters
set(gca,'ColorScale','log')
% set(c,'Limits',[0.001,1]) ;
c.Ticks = [0.001,0.01,0.1,1];
c.FontSize = 25;
xlabel('SIR (dB)','FontSize',FS);
ylabel('Frequency (kHz)','FontSize',FS);
yticks(0:1:5);
yticklabels({'5','4','3','2','1','0'})
set(gca,'FontSize',FS)
% Graphics scale setting does not affect code implementation
% RFS([1.0 0.7])