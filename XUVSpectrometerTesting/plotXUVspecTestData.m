%Load and plot data from XUV spectrometer tests
path = [pwd,'/FirstOrderImages_09012022_2/'];
files = dir(path);
n=1;
% Load images and background
for ij=1:length(files)
    isbkg(ij) = ~isempty(regexp(files(ij).name,'bkg\w','once'));
    isimg(ij) = ~isempty(regexp(files(ij).name,'img\w','once'));
    
    if isimg(ij)
    images(n,:,:) = importdata([path,files(ij).name]);    
    vertProj(n,:) = smooth(sum(images(n,:,:),2));    
    
    
    figure(1)
    subplot(2,1,2)
    h1=plot(vertProj(n,:),'color',[0 0 0 0.2]);hold on;
    n=n+1;
    end
end
bkground = importdata([path,files(find(isbkg)).name]);

%% Plot a few random shots and look at the single shot vs average
meanVertProj = mean(vertProj,1);
ymin = mean(meanVertProj(1:30));
randomImage = squeeze(images(randi(size(images,1),1),:,:));        
        
figure(1)
subplot(2,1,1)
    imagesc(randomImage);
    set(gca,'FontSize',20,'FontName','Times','LineWidth',2)
    ylabel('Pixels');xlabel('Pixels')
    %title(sprintf(['Sum Cts = ',num2str(sum(sum(randomImage)))]));              
     title('First Order Diffraction from Thorlabs 250nm UV LED')
     
subplot(2,1,2);
    h2=plot(meanVertProj-ymin,'LineWidth',2);
    ylim([0,max(meanVertProj)*1.25]);
    grid on
    set(gca,'FontSize',20,'FontName','Times','LineWidth',2)
    xlim([1,length(meanVertProj)])
    xlabel('Pixels');ylabel('Spectral Intensity [a.u.]')
   % title(sprintf(['Max = ',num2str(max(meanVertProj))]));
    drawnow
    legend([h1,h2],{'Single Shot','Average'})
