%% make identity matrix
function [identities, wave_ids,flatidentities] = p_w_identities(pockels,wavelengths,str)



nwaves = length(wavelengths);
npocks = length(pockels);
identities= cell(nwaves,npocks);
for i = 1:length(wavelengths)
    for t= 1:length(pockels)
        curwave=num2str(wavelengths(i));
        curpock=num2str(pockels(t));
        identities{i,t}= strcat(curwave,' nm ','@',curpock);
    end

end

identities=identities';% rearrage so that it is p x w 
% 
% if strcmp(str,'delete13/15')
% %     identities(:,[13 15])=[];
%      %wavelengths([13 15])=[];
% end

wave_ids = [];
for i = 1:length(pockels)
    for t= 1:length(wavelengths)
        wave_ids = [wave_ids, wavelengths(t)];
    end
end

flatidentities=identities(:);



end

