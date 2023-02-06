function [meanwave_intensities,medwave_intensities,wavelength_identities]=avg_acrosspocks(manual_intensities,info)
% function to average/ or take the median of all the powers at a given
% wavelength 

subset=info.subset_pockels; 
numpocks=length(info.pockels); 
numwaves=size(manual_intensities,2)/numpocks;

meanwave_intensities=nan(size(manual_intensities,1),numwaves);
medwave_intensities=nan(size(manual_intensities,1),numwaves);

%% MAKE LIST OF WAVELENGTHS USED (WITHOUT POWERS ATTACHED)
wavelength_identities=cell(numwaves,1);

for i = 1:length(wavelength_identities)
    combined_str=strcat(num2str(info.wavelengths(i)),' nm');
    wavelength_identities{i}=combined_str;
end

%% AVERAGE ACROSS POCKELS, TAKING A SUBSET IF NEEDED 

boundaries=1:numpocks:size(manual_intensities,2)+1;

for i = 1:numwaves
    curpocks=manual_intensities(:,(boundaries(i):boundaries(i+1)-1));
    meanwave_intensities(:,i)=mean(curpocks(:,subset),2);
    medwave_intensities(:,i)=median(curpocks(:,subset),2);

end

end 
