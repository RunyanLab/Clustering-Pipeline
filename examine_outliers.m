function []=examine_outliers(cell_stat,red_vect,chosen_combination,threshold,intensities,info,flatwave_identities,combination_results)

silhouettes=combination_results.all_silhouettes{chosen_combination}
outliers=find(silhouettes<threshold);% find outliers in isred coordinates 


centroids=combination_results.centroids{chosen_combination}; 
ident=combination_results.identities{chosen_combination}; 

flatwave_identities=flatwave_identities


inspect_intensity(outliers,find(red_vect==1),intensities,centroids,flatwave_identities,info,ident)


end
