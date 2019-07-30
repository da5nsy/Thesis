load spd_D65     % SPD: CIE D-series illuminant D65
load sur_macbeth % SRF: macbeth colour checker dataset
load T_xyz1931   % CMF: 1931 2deg 

colourSignal = sur_macbeth.*spd_D65; %11 is 'lime green'
XYZ = T_xyz1931*colourSignal;
xy = [XYZ(1,:)./sum(XYZ);XYZ(2,:)./sum(XYZ)];

