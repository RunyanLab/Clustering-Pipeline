function[]= check_redcells(redcell_vect,cell_stat,img,thresholds,shift)

xshift=shift(1);
yshift=shift(2); 



cellstat_ids=1:length(cell_stat);


%%
figure


subplot(1,2,1)
%redcells on short image 

imshow(img.short)
caxis([0 max(max(img.short))/thresholds(1)])
hold on 

red_stat=cell_stat(redcell_vect); 
red_ids=cellstat_ids(redcell_vect);



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
    text(mean(xpix)+5,mean(ypix)+5,num2str(red_ids(i)),'Color','r')
 
end



%%
%PLOT GREEN CELLS 

green_stat=cell_stat(redcell_vect==0); 

green_ids=cellstat_ids(redcell_vect==0);


for i = 1:length(green_stat)
    curstat=green_stat{i};
    xpix=double(curstat.xpix(curstat.soma_crop==1));
    ypix=double(curstat.ypix(curstat.soma_crop==1));
    
    xpix=xpix+xshift;
    ypix=ypix+yshift;

    xcoords=nan(2*range(ypix)+1,1);
    ycoords=nan(2*range(ypix)+1,1);
    ycl=unique(ypix);% y coords list 
    [ycl,~]=sort(ycl);
    if length(ycl)<range(xpix)
        for j=1:length(ycl)
        
            curx=xpix(ypix==ycl(j));
            xcoords(j)=min(curx);
            xcoords((end-1)-(j-1))=max(curx);
            ycoords(j)=ycl(j);
            ycoords((end-1)-(j-1))=ycl(j);    
        end
    else
        for j=1:range(ypix)
        
            curx=xpix(ypix==ycl(j));
            xcoords(j)=min(curx);
            xcoords((end-1)-(j-1))=max(curx);
            ycoords(j)=ycl(j);
            ycoords((end-1)-(j-1))=ycl(j);    
        end
    end
    ycoords(end)=ycoords(1);
    xcoords(end)=xcoords(1);

    plot(double(xcoords),double(ycoords),'g','LineWidth',2)
    text(mean(xpix)+5,mean(ypix)+5,num2str(green_ids(i)),'Color','g')
 
end


title('Short Wavelength Image')
%%
%LONG IMAGE REDCELLS




subplot(1,2,2)
%redcells on short image 

imshow(img.long)
caxis([0 max(max(img.long))/thresholds(2)])


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
    text(mean(xpix)+5,mean(ypix)+5,num2str(red_ids(i)),'Color','r')
 
end



%%
%LONGIMAGE GREEN CELLS 

green_stat=cell_stat(redcell_vect==0); 
green_ids=cellstat_ids(redcell_vect==0);



for i = 1:length(green_stat)
    curstat=green_stat{i};
    xpix=double(curstat.xpix(curstat.soma_crop==1));
    ypix=double(curstat.ypix(curstat.soma_crop==1));
    
    xpix=xpix+xshift;
    ypix=ypix+yshift;

    xcoords=nan(2*range(ypix)+1,1);
    ycoords=nan(2*range(ypix)+1,1);
    ycl=unique(ypix);% y coords list 
    [ycl,~]=sort(ycl);
    if length(ycl)<range(xpix)
        for j=1:length(ycl)
        
            curx=xpix(ypix==ycl(j));
            xcoords(j)=min(curx);
            xcoords((end-1)-(j-1))=max(curx);
            ycoords(j)=ycl(j);
            ycoords((end-1)-(j-1))=ycl(j);    
        end
    else
        for j=1:range(ypix)
        
            curx=xpix(ypix==ycl(j));
            xcoords(j)=min(curx);
            xcoords((end-1)-(j-1))=max(curx);
            ycoords(j)=ycl(j);
            ycoords((end-1)-(j-1))=ycl(j);    
        end
    end
    ycoords(end)=ycoords(1);
    xcoords(end)=xcoords(1);

    plot(double(xcoords),double(ycoords),'g','LineWidth',2)
    text(mean(xpix)+5,mean(ypix)+5,num2str(green_ids(i)),'Color','g')
 
end


title('Long Wavelength Image')









