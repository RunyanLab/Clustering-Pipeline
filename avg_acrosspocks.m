function [meanwave_intensities,medwave_intensities,flatwave_identities]=avg_acrosspocks(manual_intensities,numpocks,wavelengths,subset)
% function to average/ or take the median of all the powers at a given
% wavelength 


numwaves=size(manual_intensities,2)/numpocks;

meanwave_intensities=nan(size(manual_intensities,1),numwaves);
medwave_intensities=nan(size(manual_intensities,1),numwaves);


flatwave_identities=cell(numwaves,1);

for i = 1:length(flatwave_identities)
    combined_str=strcat(num2str(wavelengths(i)),' nm');
    flatwave_identities{i}=combined_str;
end




boundaries=1:numpocks:size(manual_intensities,2)+1;


for i = 1:numwaves
    curpocks=manual_intensities(:,(boundaries(i):boundaries(i+1)-1));
    meanwave_intensities(:,i)=mean(curpocks(:,subset),2);
    medwave_intensities(:,i)=median(curpocks(:,subset),2);

end
