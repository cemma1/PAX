% Calibrate Ocean Optics and XUV spectrometer
oceanOpticsSpec = importdata([pwd,...
    '/oceanOpticsTestData08232022/meanSpectrumOceanOptics.mat']);
wavelengths = importdata([pwd,...
    '/oceanOpticsTestData08232022/wavelengths.mat']);
XUVSpec = fliplr(importdata([pwd,...
    '/XUVSpectrometerTesting/meanXUVSpectrum.mat']));% I confirm that the fliplr is because the camera image is flipped in profmon GUI

% Crop UV vis spec to the desired wavelength range
idx = wavelengths > 180 & wavelengths < 320;
oceanOpticsSpec = smooth(oceanOpticsSpec(idx));
wavelengths = wavelengths(idx);

% Center the peaks of the two spectra
[~,idx] = max(oceanOpticsSpec);
[~,idx2] = max(XUVSpec);
XUVSpec = circshift(XUVSpec,idx-idx2);

% Normalize the spectra
oceanOpticsSpecNorm = oceanOpticsSpec./max(oceanOpticsSpec);
XUVSpecNorm = XUVSpec./max(XUVSpec);

figure;plot(oceanOpticsSpecNorm);hold on;
plot(XUVSpecNorm);

% Calculate the calibration factor (ratio of FWHMs)
calFactor = fwhm(1:length(XUVSpecNorm),XUVSpecNorm)/...
    fwhm(1:length(oceanOpticsSpecNorm),oceanOpticsSpecNorm);

deltaLambdaXUV = mean(diff(wavelengths))/calFactor;
[~,idx3] = max(XUVSpec);

wavelengthsXUV = [1:length(XUVSpecNorm)]*deltaLambdaXUV+min(wavelengths)+17;

figure;plot(wavelengths,oceanOpticsSpecNorm,'LineWidth',2);hold on;
plot(wavelengthsXUV,XUVSpecNorm,'LineWidth',2)
grid on
xlim([min(wavelengths),max(wavelengths)])
legend('Ocean Insight','XUV spectrometer')
    set(gca,'FontSize',20,'FontName','Times','LineWidth',2)
    ylabel('Spectral Intensity [a.u.]');xlabel('Wavelength [nm]')

