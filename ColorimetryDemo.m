clc, clear, close all

% based on a stripped down version of:
%https://github.com/da5nsy/PTBColorimetryDemo/tree/5070c25dac1fef3342fa26546be440ebb2977133

d = DGdisplaydefaults;
% set(groot,'defaultfigureposition',[100 100 500 400]);
% set(groot,'defaultLineLineWidth',2);
% set(groot,'defaultAxesFontName', 'Courier');
% set(groot,'defaultAxesFontSize',12);
% set(groot,'defaultFigureRenderer', 'painters') %renders pdfs as vectors
% set(groot,'defaultfigurecolor','white')

%%
load spd_D65     % SPD: CIE D-series illuminant D65
load sur_macbeth % SRF: macbeth colour checker
load T_xyz1931   % CMF: 1931 2deg 

%% Data

figure('Position',[100 100 500 700]) 
%figure

subplot(3,1,1)
plot(SToWls(S_D65),spd_D65)
xlim([380,730]),xticks([])

subplot(3,1,2)
plot(SToWls(S_macbeth),sur_macbeth)
xlim([380,730]),xticks([])
yticks(ylim)

subplot(3,1,3)
plot(SToWls(S_xyz1931),T_xyz1931)
xlim([380,730])
yticks(ylim)
xlabel('Wavelength (nm')

%save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\SPDetc.pdf')

%% Compute colour signals

colourSignal = sur_macbeth.*spd_D65;

%% CIE 1931 colorimetry

XYZ = T_xyz1931*colourSignal;
xy = [XYZ(1,:)./sum(XYZ);XYZ(2,:)./sum(XYZ)];

figure, hold on, 
drawChromaticity('1931')
scatter(xy(1,:),xy(2,:),'k')
axis equal, axis([0 1 0 1])
xticks([0 1]), yticks([0 1])
xlabel('x'), ylabel('y')

%save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\ColorimetryDemo1.pdf')

%% u'v'

upvp = xyTouv(xy); %upvp is short for u prime v prime, because there is another colourspace called uv which is subtly different *sigh*

figure, hold on, 
drawChromaticity('upvp')
axis equal
axis([0 1 0 1])
scatter(upvp(1,:),upvp(2,:),'k')
xticks([0 1]), yticks([0 1])
xlabel('u''') %to get an apostrophe you throw extra apostrophes at it until it behaves
ylabel('v''')

%save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\ColorimetryDemo3.pdf')

%% CIELUV

whiteXYZ = T_xyz1931*spd_D65;
Luv = XYZToLuv(XYZ,whiteXYZ);

figure, 
scatter3(Luv(2,:),Luv(3,:),Luv(1,:),'k') 
xlabel('u*')
ylabel('y*')
zlabel('L*')
xlim([-100 100])
ylim([-100 100])
zlim([0 100])
cleanTicks

%save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\ColorimetryDemo4.pdf')

%% MB

load T_cones_ss2.mat
load T_CIE_Y2.mat
%plot(SToWls(S_cones_ss2),T_cones_ss2)

T_c = SplineCmf(S_cones_ss2,T_cones_ss2,S_xyz1931); %resampling so that I can use the old sRGBs that I already calculated, and keep the appearance comparable accross diagrams
T_C = SplineCmf(S_CIE_Y2,T_CIE_Y2,S_xyz1931);

LMS = T_c*colourSignal;
ls = LMSToMacBoyn(LMS,T_c,T_C);

figure, hold on
drawChromaticity('MB2')
scatter(ls(1,:),ls(2,:),'k')
cleanTicks
xlabel('{\itl}_{MB}');
ylabel('{\its}_{MB}');

%save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\ColorimetryDemo5.pdf')

%% Illuminant dependence

% Granada daylight data
% Source: 
% http://colorimaginglab.ugr.es/pages/Data#__doku_granada_daylight_spectral_database
% Cite: 
% J. Hernández-Andrés, J. Romero& R.L. Lee, Jr., "Colorimetric and
% spectroradiometric characteristics of narrow-field-of-view
% clear skylight in Granada, Spain" (2001)

load('C:\Users\cege-user\Dropbox\UCL\Data\Reference Data\Granada Data\Granada_daylight_2600_161.mat');
T_SPD = final; clear final
T_SPD = T_SPD(17:97,1:20:end); %match sampling range and subsample across repeats
S_SPD = S_xyz1931;

for i=1:size(T_SPD,2)
    T_rad(:,:,i)  = sur_macbeth.*T_SPD(:,i);
    XYZ(:,:,i)    = T_xyz1931*T_rad(:,:,i);
end
XYZ = XYZ(:,:);
xy = [XYZ(1,:)./sum(XYZ);XYZ(2,:)./sum(XYZ)];

figure, hold on, 
drawChromaticity('1931')
scatter(xy(1,:),xy(2,:),'k','MarkerEdgeAlpha',0.2)
axis equal, axis([0 1 0 1])
xticks([0 1]), yticks([0 1])
xlabel('x'), ylabel('y')

%save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\ColorimetryDemo6.pdf')

%% SPDs normalised to same luminance

lum = T_xyz1931(2,:)*T_SPD;

figure,
plot(SToWls(S_SPD),T_SPD./lum)
axis tight

xlabel('Wavelength (nm)')
ylabel('Relative power')
ylim([0 0.14])
yticks(ylim)

%save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\ColorimetryDemo7.pdf')
