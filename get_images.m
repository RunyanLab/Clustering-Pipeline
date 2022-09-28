function[wsRef,fRef,max_proj,sum_proj,shortImage,longImage,greenImage]=get_images(wsFall,Fall,red_wavelength_stack)

wsRef=wsFall.ops.meanImg; %w-series ref image (can make whatever you want)
fRef=Fall.ops.meanImg_chan2; % functionla ref image
[max_proj,sum_proj]=make_maxproj(red_wavelength_stack); % make a max_projection and sum_projection for different ways of making red cells show up 
shortImage=squeeze(mean(red_wavelength_stack(:,1:3,:,:),1)); % average of short wavelength images
shortImage=squeeze(mean(shortImage,1));
longImage=squeeze(mean(red_wavelength_stack(:,12:14,:,:),1)); % average of long wavelength images
longImage=squeeze(mean(longImage,1));
greenImage=Fall.ops.meanImg; % image of green channel for reference 

end
