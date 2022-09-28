function [ red_wavelength_stack,summed_image] = load_reg_tif_wavelength_old(mouse,date,pock_start,pock_end,wavelengths)
% LOAD_REG_TIF_WAVELENGTH loads suite2p registered tifs saved inside
% '...mouse\date\W-series\suite2p\plane0\reg_tif\'
%all_image size is [npock*nwave, 512, 512]
%red_wavelength_stack is [npock, nwave, 512, 512]


pockels = pock_start:100:pock_end;
%base_directory =  strcat('\\136.142.49.216\runyan2\Connie\2p_results\',mouse,'\',date,'\suite2p\plane0\reg_tif\');
%base_directory =  strcat('\\136.142.49.216\runyan2\Connie\2p_results\',mouse,'\',date,'\run2\suite2p\plane0\reg_tif\');
base_directory =  strcat('Y:\Caroline\2P\SOM_VIP\',mouse,'\',date,'\Wavelength Series\suite2p\plane0\reg_tif\');

d = dir(base_directory);
num_files = length(d);
num_x_pixels = 512;
num_y_pixels = 512;

red_wavelength_stack = nan(length(pockels),length(wavelengths), num_x_pixels, num_y_pixels);
%green_wavelength_stack = nan(length(pockels),length(wavelengths), num_x_pixels, num_y_pixels);

total_images= length(wavelengths)*length(pockels);

all_image = nan(total_images,512,512);

count=0;
%reading each frame from the registered tif (including blank images for
%1020, 1040, 1060)
for f = 1:total_images 
   %changed this so that it just runs from first frame till end (instead of
   %having different loading for 1040 nm)
    count = count+1;
    all_image(count,:,:) = imread([base_directory '/' 'file000_chan0.tif'],f);
end


%organizing data into the red_wavelength stack[p,w,512,512]
for w = 1:length(wavelengths)
    for p = 1:length(pockels)
        current_image = w+[length(wavelengths)*p-length(wavelengths)];
        red_wavelength_stack(p,w,:,:) = all_image(current_image,:,:);
    end
end
% making plot of the mean of all wavelengths
summed_image = squeeze(mean(all_image,1));
summed_image = summed_image./max(summed_image(:));
figure(99)
clf
imagesc(summed_image)
title('mean image (all wavelengths)')
%axis image
%colormap gray
caxis([0 max(summed_image(:))/1.25])
%set(99,'position',[1011 141 1401 1048])
colorbar
% set(colorbar,'visible','off')
% set(gca,'xticklabel',{[]})
% set(gca,'yticklabel',{[]})
% set(gca,'LooseInset',get(gca,'TightInset'));
end
