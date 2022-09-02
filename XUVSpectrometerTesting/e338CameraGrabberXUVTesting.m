campvs = {'CAMR:LI20:211'};
opts = struct('usemethod',2,'back',1);%Asymmetric Gaussian
Nshots = 50;
ij = 1;
tic   
  while 1
       data = profmon_grab(campvs{1});
       img = data.img;% If u want to use unprocessed image for centroid finding
       data.back = importdata('FirstOrderImages_09012022_2/bkgFirstOrder09012022_2.mat');
       [img,~,~,~,~]=beamAnalysis_imgProc(data,opts);% If you want to use the processed Image
        % Calculate beam statistics
       beamParams = beamAnalysis_beamParams(img, 1:size(img,2), 1:size(img,1),0,opts);
        stats = beamParams.stats;

        centroidx(1,ij) = stats(1);
        centroidy(1,ij) = stats(2);
        timestamp(ij) = data.ts;        
        sumCounts(ij) = sum(sum(img))*1e-6;
        horzProj = sum(img,2);
        vertProj = smooth(sum(img,1));
        
%         fname = ['FirstOrderImages_09012022_2/img0order_',datestr(now,'mm.DD.HH.MM.FFF'),'.mat'];
%         if ij==1;    ij = ij+1;continue;end
%         if timestamp(ij)~=timestamp(ij-1)           
%         save(fname,'img');
%         ij = ij+1;
%         disp(ij)
%         
%         end
        
        
        figure(1)
        subplot(2,2,1)
        imagesc(img);
        title(sprintf(['Sum Cts = ',num2str(sumCounts(ij))]));
        
        subplot(2,2,2);
        plot(horzProj);%view([90,0])
        
        ymin = mean(vertProj(1:30));
        subplot(2,2,3);
        plot(vertProj-ymin);ylim([0,2.5e3]);xlim([1,length(vertProj)])
         title(sprintf(['Max = ',num2str(max(vertProj))]));
       drawnow
       
       if ij>Nshots;return;end
    end

toc

%%
campvs = {'CAMR:LI20:211'};
opts = struct('usemethod',2,'back',1);%Asymmetric Gaussian
Nshots = 500;
ij = 1;
tic   
  while 1
       data = profmon_grab(campvs{1});
       img = data.img;% If u want to use unprocessed image for centroid finding
       data.back = importdata('bkgZerothOrder09012022.mat');
       [img,~,~,~,~]=beamAnalysis_imgProc(data,opts);% If you want to use the processed Image
        % Calculate beam statistics
       beamParams = beamAnalysis_beamParams(img, 1:size(img,2), 1:size(img,1),0,opts);
        stats = beamParams.stats;

        centroidx(1,ij) = stats(1);
        centroidy(1,ij) = stats(2);
        timestamp(ij) = data.ts;

 
        figure(1)
        subplot(2,1,1)
        imagesc(data.img-data.back);
        subplot(2,1,2)
        imagesc(img);
        
        
        fname = ['ZerothOrderImages_09012022/img0order_',datestr(now,'mm.DD.HH.MM.FFF'),'.mat']
        save(fname,'img');
        

        
        ij = ij+1;
       
       if ij>100;return;end
    end
