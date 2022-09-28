function []=examine_outliers(cell_stat,red_vect,intensities,silhouettes,threshold,centroids,title,flatwave_identities,ident)

idvect=1:length(cell_stat); % 

outliers=find(silhouettes<threshold);% find outliers in isred coordinates 

inspect_intensity(outliers,find(red_vect==1),intensities,centroids,1,flatwave_identities,title,ident)


end
