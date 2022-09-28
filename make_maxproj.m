function[max_proj,sum_proj]=make_maxproj(red_wavelength_stack)

maxpocks=squeeze(max(red_wavelength_stack,[],1));


max_proj=squeeze(max(maxpocks,[],1));

min_proj=nan(512,512);




sumpocks=squeeze(sum(red_wavelength_stack,1));

sum_proj=squeeze(sum(sumpocks,1));





end

