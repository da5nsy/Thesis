clear, clc, close all

% figure defaults
set(groot,'defaultfigureposition',[100 100 500 400]);
set(groot,'defaultLineLineWidth',2);
set(groot,'defaultAxesFontName', 'Courier');
set(groot,'defaultAxesFontSize',12);
set(groot,'defaultFigureRenderer', 'painters') %renders pdfs as vectors
set(groot,'defaultfigurecolor','white')

figure, hold on, axis tight
S = WlsToS([380:10:750]');

% %% Load sunlight
% 
% sunlight = xlsread('C:\Users\cege-user\Dropbox\UCL\Data\Reference Data\ASTMG173.xls');
% sunlight = sunlight([1:2:241,242:671],:);
% S_sunlight = WlsToS(sunlight(:,1));
% 
% plot(SToWls(S_sunlight),sunlight(:,2:4))
% axis tight

%% Load daylight

% load spd_D65.mat
% plot(SToWls(S_D65),spd_D65)

load('C:\Users\cege-user\Dropbox\UCL\Data\Reference Data\Granada Data\Granada_daylight_2600_161.mat');
T_SPD = final; clear final
S_SPD = [300,5,161];

T_SPDs = SplineSpd(S_SPD,T_SPD,S)';
Tnorm = T_SPDs(100,:)./max(T_SPDs(100,:));

plot(380:10:750,Tnorm,'k','DisplayName','Daylight')

xlabel('Wavelength (nm)')
ylabel('SPD (normalised)')
ylim([0 1])
yticks(ylim)

%% Load reflectances

banana_SRF = xlsread('C:\Users\cege-user\Dropbox\UCL\Data\Reference Data\UCDavis_Banana_Peel_ReflectanceData.xlsx','Sheet1','C2:AG11');
S_SRF = WlsToS([450:10:750]');
banana_SRF = banana_SRF/100;

banana_SRFs = SplineSrf(S_SRF,banana_SRF',S,1)';

%figure, plot(SToWls(S_SRF),banana_SRF)

plot(380:10:750,banana_SRFs(1,:).*Tnorm,'k:','DisplayName','Green banana')
plot(380:10:750,banana_SRFs(end,:).*Tnorm,'k--','DisplayName','Yellow banana')

%%
l = legend('Location',[0.2818,0.6124,0.328,0.14]);
save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\daylightAndBananas.pdf')

