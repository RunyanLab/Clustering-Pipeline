function []=inspect_intensity(outliers,cell_ids,intensities,centroids,pockels,flatindentities,titleaddon,identities)

% use this function to look at cells of interest or the spectra of outliers
% in general 

numpocks=length(pockels);


leg=cell(length(outliers),1);


for i = 1:length(outliers)
    leg{i}=['silhouette:',num2str(outliers(i)),' | cellid: ',num2str(cell_ids(outliers(i))),' | class:',num2str(identities(outliers(i)))]; % make cell array for the legend 
end


selected_intensities=intensities(outliers,:); %

selected_intensities=selected_intensities';
%selected_intensities=intensities';
centroids=centroids';

%%
figure()
title(titleaddon)
if mean(centroids(1:2,1)) > mean(centroids(1:2,2))
    
    plot(normc(centroids(:,1)),'LineWidth',3,'Color','r',"HandleVisibility",'off')
    hold on 
    plot(normc(centroids(:,2)),'LineWidth',3,'Color','g',"HandleVisibility",'off')
else
    plot(normc(centroids(:,1)),'LineWidth',3,'Color','g',"HandleVisibility",'off')
    hold on 
    plot(normc(centroids(:,2)),'LineWidth',3,'Color','r',"HandleVisibility",'off')
    
end


hold on 

%%

plot(normc(selected_intensities))


xticks(1:numpocks:size(intensities,2))
xticklabels(flatindentities(1:numpocks:end))
xline(1:numpocks:size(intensities,2),"HandleVisibility",'off')
legend(leg);


title(titleaddon)
