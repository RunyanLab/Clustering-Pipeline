function[edge_excluded]= detect_redcells(longImage,shortImage,thirdImage,img_thresholds,redcell_vect,cell_stat,xshift,yshift,percent)

% this function takes 3 images and plots cells that are currently
% classified as green 
all_cellocs=nan(512,512,length(cell_stat));

edge_excluded=zeros(length(cell_stat),1); 

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
             mask(curypix+1,curxpix+1)=1;%(curypix,curxpix) to get correct location; add +1 bc python to MATLAB
             
      end
      if size(mask,1)>512 || size(mask,2)>512
          all_cellocs(:,:,i)=nan(512,512); 
          edge_excluded(i)=1; 
      else
          all_cellocs(:,:,i)=mask;
      end

    
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

figure
%% LONG IMAGE 
subplot(1,3,1)
plot_mask_boundaries(longImage,img_thresholds(1),check_stat,check_green,'g',xshift,yshift)

title('long wavelength image')

%% SHORT IMAGE

subplot(1,3,2)
plot_mask_boundaries(longImage,img_thresholds(2),check_stat,check_green,'g',xshift,yshift)

title('short wavelength image')

%% OTHER IMAGE
subplot(1,3,3)

plot_mask_boundaries(longImage,img_thresholds(3),check_stat,check_green,'g',xshift,yshift)

title('third image')


sgtitle('Green Masks to Check')