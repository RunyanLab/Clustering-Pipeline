function [intensities,intensities2, red_locs, s2p_median, red_cell_ids,s2p_centroids,red_ids] = findintensities_all_s2p_mask(red_wavelength_stack,Fall,redcells)
% FINDINTENSITIES_ALL_S2P_MASK uses suite2p mask outputs. Returns intensities for each red selected cell
% across pockels and wavelenths; also returns the locations of the red; red
% cell ids, and median values for all suite2p masks
% selected cells
%mouse='DX4-1L';date='2021-10-22';

stat = Fall.stat; %all info including each cells and non cell location
iscell = Fall.iscell; 
redcell = Fall.redcell;

pic=zeros(512,512);
isred=redcells; %which are red from all cells
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
     xpix=curstat.xpix;
     ypix=curstat.ypix;
         for k=1:length(xpix)
             curxpix=xpix(k);
             curypix=ypix(k);
             mask(curypix+1,curxpix+1)=1; %(curypix,curxpix) to get correct location; add +1 bc python to MATLAB
         end
      cellocs(:,:,count_cell)=mask;
      s2p_median(count_cell,1) = median(2)+1;
      s2p_median(count_cell,2) = median(1)+1;
      stats = regionprops(cellocs(:,:,count_cell));
      centroid = stats.Centroid;
      s2p_centroids(count_cell,1) = round(centroid(1))+ 1;
      s2p_centroids(count_cell,2) = round(centroid(2))+ 1;
     end
 %another way to get correct location keeping (curxpix,curypix) 
%  mask=imrotate(mask,90);
%  mask=flip(mask,1);
end
% % for i = 1:length(s2p_cells)
% % 
% %    s2p_centroids(i,round(centroid(2)),round(centroid(1))) = 1;
% % end
all_locs = cellocs;
%redlocs= cellocs(:,:,isred==1); % is this doing the right thing???
%redidx=find(isred==1);
 
%finding index of red selected cells
red_ids=[]; 
for c=1:length(stat)
    if iscell(c,1)==1 && isred(c,1)==1
        red_ids = [red_ids,c]; 
    end
end
%cells=cellocs(:,:,iscell(:,1)==1); %to get red and green selected ROIS
cell_id = iscell(:,1);
count = 0; 
for c = 1:length(cell_id) 
    if cell_id(c,1) == 1; 
        count=count+1; 
        cell_id(c,2) = count; 
    end
end
cell_id(red_ids,3) = 1;
red_cell_ids = cell_id(cell_id(:,3) == 1,2);
red_locs=cellocs(:,:,red_cell_ids);
%to plot: 
figure(100);clf; imagesc(squeeze(sum(shiftdim(all_locs,2))));

nwaves=size(red_wavelength_stack,2);
npocks=size(red_wavelength_stack,1);
% intensities is a p, w, idx matrix for avg brightness of each red cell
% using all_image array
intensities=zeros(size(red_locs,3),npocks*nwaves);
intensities2=zeros(size(red_locs,3),npocks*nwaves);
count=1;
temp=zeros(npocks,nwaves);
for idx = 1:size(red_locs,3)
    cellarea=red_locs(:,:,idx);
    for p=1:npocks
        for w=1:nwaves
            curstack=squeeze(red_wavelength_stack(p,w,:,:));
            selectvals=curstack(cellarea==1);
            temp(p,w)=mean(selectvals);
            flat=temp(:);
            intensities2(idx,:)=flat;  %organized by p x w
            
            temp2 = mean(selectvals);
            intensities(idx,count)=temp2; %organized by w x p
            count = count+1;
        end
    end
    count=1;            
end
figure(11); clf;
%norm_intensities = normr(intensities);
for i = [4 93]%[1    18    35    52    69    86; 14    31    48    65    82    99]
hold on;
plot(intensities(:,i)); 
hold off; 
end
ylabel('Pixel Intensity');
xlabel('Cells');
title('cells vs intensity (using s2p masks)')
legend('800','1040')

%figure(12);hold on; for p = 1:size(intensities,1); plot(wavelengths,intensities(p,:));end; hold off
end