% Read and Plot Ocean Optics test data
files = dir(pwd);
% Read data from text files
for ij = 1:length(files)
   if isempty(regexp(files(ij).name,'.txt','once'));continue;end   
   textFile = importdata(files(ij).name);
   data(ij,:,:) = [textFile.data];   
   files(ij).name
   figure(1)
   h1 = plot(data(ij,:,1),smooth(data(ij,:,2)),'k');hold on
   xlabel('Wavelength [nm]');
   ylabel('Spectral Intensity [a.u.]');   
end

% Add the mean spectrum
wavelengths = data(end,:,1);
spectra = data(:,:,2);
meanSpec = mean(spectra,1);
figure(1);h2 = plot(wavelengths,smooth(meanSpec),'r--','LineWidth',2);grid on;
xlim([min(wavelengths),max(wavelengths)]);ylim([0,max(max(spectra))]);
set(gca,'FontSize',20,'FontName','Times','LineWidth',2)
legend([h1,h2],{'Single Shot','Average'})