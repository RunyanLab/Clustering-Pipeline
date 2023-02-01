function [info] = p_w_identities(info)
pockels=info.pockels;
wavelengths=info.wavelengths; 


% Function that takes vector of integers for each pockels value used as
% well as each wavelenth that was used 

% OUTPUTS:
% identities =  p x w matrix with strings of wavelength @ pockel  

%% POPULATE "IDENTITIES" 

nwaves = length(wavelengths);
npocks = length(pockels);
identities= cell(npocks,nwaves);

for i = 1:npocks
    for t= 1:nwaves
        curwave=num2str(wavelengths(t));
        curpock=num2str(pockels(i));
        identities{i,t}= strcat(curwave,' nm ','@',curpock);
    end

end

info.identities=identities; 

end

