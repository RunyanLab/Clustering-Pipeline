function[]= detect_redcells(percent,img,img_thresholds,redcell_vect,cell_stat,shift)

%% MAKE VARIABLEs
xshift=shift(1); 
yshift=shift(2); 

longImage=img.long; 
shortImage=img.short; 
thirdImage=img.sum_proj; 


all_cellocs=nan(512,512,length(cell_stat));



%% GET MASKS
for i = 1 : length(cell_stat)
    
    mask=zeros(512,512);
    curstat=cell_stat{i};
    xpix=curstat.xpix(curstat.soma_crop==1);
    ypix=curstat.ypix(curstat.soma_crop==1);
    xpix=xpix+xshift;
    ypix=ypix+yshift;
      for k=1:length(xpix)
             curxpix=xpix(k);
             curypix=ypix(k);
             if curxpix>0 && curypix>0 && curxpix<512 && curypix<512 % make sure pixel of mask is within frame after re-registration  
                mask(curypix+1,curxpix+1)=1;%(curypix,curxpix) to get correct location; add +1 bc python to MATLAB
             end

             
      end
      
      all_cellocs(:,:,i)=mask;
       
end


%% GET POTENTIALLY RED CELLS
%uses check_green_long and check_green_short to find candidates at each
%wavelength 

cell_ids=1:size(all_cellocs,3);

intens=nan(1,size(all_cellocs,3));
for i =1:size(all_cellocs,3)
    intens(i)=mean(longImage(all_cellocs(:,:,i)==1));   
end


red_intens=intens(redcell_vect); % look at what the intensity is for confirmed red cells for comparison to potentially red cells classified as green 
green_intens=intens(redcell_vect==0);
green_ids=cell_ids(redcell_vect==0);
min_red=min(red_intens);
percentile=prctile(red_intens,percent);

check_green_long=green_ids(green_intens>percentile); % potential cells are defined as those having mean fluorescence in red channel above percentile of red cells 


intens=nan(1,size(all_cellocs,3));
for i =1:size(all_cellocs,3)
    intens(i)=mean(shortImage(all_cellocs(:,:,i)==1));   
end


red_intens=intens(redcell_vect);
green_intens=intens(redcell_vect==0);
green_ids=cell_ids(redcell_vect==0);
min_red=min(red_intens);
percentile=prctile(red_intens,percent); % get threshold value based on percent parameter 

check_green_short=green_ids(green_intens>percentile);
%% COMBINE VECTORS FROM SHORT AND LONG IMAGES 
check_green=union(check_green_short,check_green_long); % put together potential red cells from short and long wavelength images 


check_stat=cell_stat(check_green); % make a reduced stat list of all the masks for the candidates 

figure('Color','w')
%% LONG IMAGE 
subplot(1,3,1)
plot_mask_boundaries(longImage,img_thresholds(1),check_stat,check_green,'g',xshift,yshift)

title('Long Wavelength Image')

%% SHORT IMAGE

subplot(1,3,2)
plot_mask_boundaries(shortImage,img_thresholds(2),check_stat,check_green,'g',xshift,yshift)

title('Short Wavelength Image')

%% OTHER IMAGE
subplot(1,3,3)

plot_mask_boundaries(thirdImage,img_thresholds(3),check_stat,check_green,'g',xshift,yshift)

title('Summed Projection')


sgtitle('Candidate Red Cells Currently Classified as Pyramidal')