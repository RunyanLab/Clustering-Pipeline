function [intensities,red_cellocs]= partialmask_intensities(threshold,cell_stat,red_wavelength_stack,final_redidx,max_proj,shift)
%% MKE VARIABLES

red_stat=cell_stat(final_redidx);
xshift=shift(1); 
yshift=shift(2); 

numred=length(red_stat);
red_cellocs=nan(512,512,numred);



%% GET FULL MASKS

for i = 1 : numred
    
    mask=zeros(512,512);
    curstat=red_stat{i};
    xpix=curstat.xpix(curstat.soma_crop==1); %include only the soma for calculating the intensity
    ypix=curstat.ypix(curstat.soma_crop==1);
    
    xpix=xpix+xshift;
    ypix=ypix+yshift;

      for k=1:length(xpix)
             curxpix=xpix(k);
             curypix=ypix(k);
             if curxpix <512 && curypix<512 && curxpix>0 && curypix>0 % if any pixels have been cutoff by re-registration, just dont include them 
                mask(curypix+1,curxpix+1)=1;%(curypix,curxpix) to get correct location; add +1 to convert from python to MATLAB
             end
             
      end
    red_cellocs(:,:,i)=mask;

end
%% TAKE CERTAIN PIXELS THAT ARE ABOVE THRESHOLD FROM THE MASK 

max_locs=nan(512,512,numred);

for i =1:size(red_cellocs,3)
    maxvals= max_proj(red_cellocs(:,:,i)==1);
    
    for x = 1:512
        for y =1:512
            max_locs(x,y,i)=max_proj(x,y);
        end
    end
    
    percentile=prctile(maxvals,threshold);

   for j = 1:512
      for k = 1:512
           if max_locs(j,k,i)<percentile
               red_cellocs(j,k,i)=0;
           end
      end

   end


end

%% make variables for intensities 
npocks=size(red_wavelength_stack,1);
nwaves=size(red_wavelength_stack,2);


intensities=zeros(length(red_stat),npocks*nwaves);% intensities is a  wavelength x pockel x idx matrix for avg brightness of each red cell


temp=zeros(npocks,nwaves);

for idx = 1:length(red_stat)

    cellarea=red_cellocs(:,:,idx);
    
    
    for p=1:npocks
        for w=1:nwaves
            curstack=squeeze(red_wavelength_stack(p,w,:,:));
            selectedvals=curstack(cellarea==1);
            temp(p,w)=mean(selectedvals);            
        end
    end
    flat=temp(:);
    
    intensities(idx,:) = flat; %organized by p x w
  
    
end

end


