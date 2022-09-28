function [s2p_median ,s2p_centroids,Fall] = s2p_masks(mouse,date,servernum)
% This code is adapted to only return the centroids
% 
% FINDINTENSITIES_ALL_S2P_MASK uses suite2p mask outputs. Returns intensities for each red selected cell
% across pockels and wavelenths; also returns the locations of the red; red
% cell ids, and median values for all suite2p masks
% selected cells
%mouse='DX4-1L';date='2021-10-22';
%base_directory =  strcat('Y:\Caroline\2P\SOM_VIP\',mouse,'\',date,'\suite2p\plane0\Fall.mat');


stat = Fall.stat; %all info including each cells and non cell location
iscell = Fall.iscell; 


 %which are red from all cells
s2p_cells = find(iscell(:,1) == 1); 
cellocs=zeros(512,512,length(s2p_cells)); % 3D array of pixel locations (for only selected cells)
count_cell = 0;
s2p_median = zeros(length(s2p_cells),2);
s2p_centroids = zeros(length(s2p_cells),2);
for i = 1:length(stat)
     if iscell(i,1)==1
     count_cell = count_cell +1;
     mask=zeros(512,512);
     curstat= stat{1,i};
     median = curstat.med;
     xpix=curstat.xpix(curstat.soma_crop==1);
     ypix=curstat.ypix(curstat.soma_crop==1);
         for k=1:length(xpix)
             curxpix=xpix(k);
             curypix=ypix(k);
             mask(curypix+1,curxpix+1)=1;%(curypix,curxpix) to get correct location; add +1 bc python to MATLAB
             %mask=imrotate(mask,90);
             %mask=flip(mask,1);
         end
      cellocs(:,:,count_cell)=mask;
      s2p_median(count_cell,1) = median(2)+1;
      s2p_median(count_cell,2) = median(1)+1;
      stats = regionprops(cellocs(:,:,count_cell));
      centroid = stats.Centroid;
      s2p_centroids(count_cell,1) = round(centroid(1)) + 1;
      s2p_centroids(count_cell,2) = round(centroid(2)) + 1;
        
     end
 %another way to get correct location keeping (curxpix,curypix) 
%  mask=imrotate(mask,90);
%  mask=flip(mask,1);
end