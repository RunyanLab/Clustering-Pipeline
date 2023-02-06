function[img]=get_images(wsFall,Fall,red_wavelength_stack)


wsRef=wsFall.ops.meanImg;
 %w-series ref image (can make whatever you want)

fRef=Fall.ops.meanImg_chan2; % functionla ref image
fRef_red=Fall.ops.meanImgE;
[max_proj,sum_proj]=make_maxproj(red_wavelength_stack); % make a max_projection and sum_projection for different ways of making red cells show up 
greenImage=Fall.ops.meanImg; % image of green channel for reference 

%% Create short and long wavelength images here (adjust as necessary given your wavelength series)

shortImage=squeeze(mean(red_wavelength_stack(:,1:3,:,:),1)); % average of short wavelength images
shortImage=squeeze(mean(shortImage,1));

longImage=squeeze(mean(red_wavelength_stack(:,12:14,:,:),1)); % average of long wavelength images
longImage=squeeze(mean(longImage,1));

%% MAKE img STRUCTURE 


img.wsRef=wsRef;
img.fRef=fRef; 
img.fRef_red=fRef_red;
img.short=shortImage; 
img.long=longImage; 
img.green=greenImage; 
img.max_proj=max_proj; 
img.sum_proj=sum_proj; 



end
