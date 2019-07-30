clc, clear, close all

% based on a stripped down version of:
%https://github.com/da5nsy/PTBColorimetryDemo/tree/5070c25dac1fef3342fa26546be440ebb2977133

%%
load spd_D65     % SPD: CIE D-series illuminant D65
load sur_macbeth % SRF: macbeth colour checker
load T_xyz1931   % CMF: 1931 2deg 

colourSignal = sur_macbeth.*spd_D65;
XYZ = T_xyz1931*colourSignal;
xy = [XYZ(1,:)./sum(XYZ);XYZ(2,:)./sum(XYZ)];

%%
spectralLocus = [T_xyz1931(1,:)./sum(T_xyz1931);T_xyz1931(2,:)./sum(T_xyz1931)];
sRGBSpectralLocus = XYZToSRGBPrimary(T_xyz1931); %These values go considerably out of gamut, but we only want rough values to orient ourselves

figure, hold on, 
scatter(spectralLocus(1,1:70),spectralLocus(2,1:70),[],sRGBSpectralLocus(:,1:70)','filled')
scatter(xy(1,:),xy(2,:),'k')
axis equal, axis([0 1 0 1])
xticks([0 1]), yticks([0 1])
xlabel('x'), ylabel('y')

%%
save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\ColorimetryDemo1.pdf')

%%

figure('Position',[100 100 500 700]) 

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

save2pdf('C:\Users\cege-user\Dropbox\UCL\Ongoing Work\Thesis\figs\LitRev\SPDetc.pdf')

