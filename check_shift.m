function[]= check_shift(redcell_vect,cell_stat,img,shift)

% Function that plots masks over both the mean functional image and the
% mean from the wavelength stack to make sure that the registration 

xshift=shift(1); 
yshift=shift(2); 

%% PLOT MASKS OVER MEAN OF WAVELENGTH SERIES 
figure

subplot(1,2,2)
imagesc(img.wsRef)
caxis([0 max(max(img.wsRef))/.2])
hold on 

red_stat=cell_stat(redcell_vect); 


for i = 1:length(red_stat)
    curstat=red_stat{i};
    xpix=double(curstat.xpix(curstat.soma_crop==1));
    ypix=double(curstat.ypix(curstat.soma_crop==1));
    
    xpix=xpix+xshift;
    ypix=ypix+yshift;

    xcoords=nan(2*range(ypix)+1,1);
    ycoords=nan(2*range(ypix)+1,1);
    ycl=unique(ypix);% y coords list 
    [ycl,~]=sort(ycl);

    for j=1:range(ypix)
        
        curx=xpix(ypix==ycl(j));
        xcoords(j)=min(curx);
        xcoords((end-1)-(j-1))=max(curx);
        ycoords(j)=ycl(j);
        ycoords((end-1)-(j-1))=ycl(j);

    end
    ycoords(end)=ycoords(1);
    xcoords(end)=xcoords(1);

    plot(double(xcoords),double(ycoords),'r','LineWidth',2)
    text(mean(xpix)+5,mean(ypix)+5,num2str(i),'Color','r')
 
end


title('masks plotted on reg-tif of W-Series')


%% PLOT MASKS OVER MEAN OF FUNCTIONAL IMAGES

subplot(1,2,1)

imagesc(img.fRef)
caxis([0 max(max(img.fRef))/2])

hold on 

red_stat=cell_stat(redcell_vect); 

for i = 1:length(red_stat)
    curstat=red_stat{i};
    xpix=double(curstat.xpix(curstat.soma_crop==1));
    ypix=double(curstat.ypix(curstat.soma_crop==1));
    
    xcoords=nan(2*range(ypix)+1,1);
    ycoords=nan(2*range(ypix)+1,1);
    ycl=unique(ypix);% y coords list 
    [ycl,~]=sort(ycl);

    for j=1:range(ypix)
        
        curx=xpix(ypix==ycl(j));
        xcoords(j)=min(curx);
        xcoords((end-1)-(j-1))=max(curx);
        ycoords(j)=ycl(j);
        ycoords((end-1)-(j-1))=ycl(j);
  
        
        
    end
    ycoords(end)=ycoords(1);
    xcoords(end)=xcoords(1);

    plot(double(xcoords),double(ycoords),'r','LineWidth',2)
    text(mean(xpix)+5,mean(ypix)+5,num2str(i),'Color','r')
 
end


title('masks plotted on functional imaging')
sgtitle('Check that registration differences are accounted for')


