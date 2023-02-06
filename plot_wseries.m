function plot_wseries(wavelength_stack,info)
clims = [0 250];
colormap gray
imagesc(squeeze(wavelength_stack(length(info.pockels),length(info.wavelengths),:,:)),clims);

set(gca, 'box', 'off','XTick',[],'YTick',[],'fontsize', 14)

title(info.identities)

%%title ([num2str(info.identities{length(info.pockels),length(info.wavelengths)}(1:4)) ' nm']);


end
