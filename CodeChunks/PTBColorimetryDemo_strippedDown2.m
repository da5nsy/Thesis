spectralLocus = [T_xyz1931(1,:)./sum(T_xyz1931);T_xyz1931(2,:)./sum(T_xyz1931)];
sRGBSpectralLocus = XYZToSRGBPrimary(T_xyz1931); %These values go considerably out of gamut, but we only want rough values to orient ourselves

figure, hold on, 
scatter(spectralLocus(1,1:70),spectralLocus(2,1:70),[],sRGBSpectralLocus(:,1:70)','filled')
scatter(xy(1,:),xy(2,:),'k')
axis equal, axis([0 1 0 1])
xticks([0 1]), yticks([0 1])
xlabel('x'), ylabel('y')