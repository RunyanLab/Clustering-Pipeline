function[combination_results]=try_combinations(combos,intensities)

%% CREATE VARIABLES

identities=cell(length(combos),1); 
all_centroids=cell(length(combos),1); 
sumds=cell(length(combos),1);
all_silhouettes=cell(length(combos),1);
mean_silhouettes=nan(length(combos),1);


centroids= cell(length(combos),1); 


%% RUN K-MEANS USING EACH 

for i = 1:length(combos)

    cur_intensities=intensities(:,combos{i});
    norm_cur_intensities=normr(cur_intensities);
    
    [ident,cur_centroids,sumd,alldistances]= kmeans(norm_cur_intensities, 2,'Replicates',100,'MaxIter',10000);
    cur_sils=get_silhouettes(alldistances,ident);
    all_silhouettes{i}=cur_sils;    
    mean_silhouettes(i)=mean(cur_sils);
    all_centroids{i}=cur_centroids; 
    
    if cur_centroids(2,1) > cur_centroids(1,1)
        for j=1:length(ident)
            if ident(j)==1
                ident(j)=2;
            elseif ident(j)==2
                ident(j)=1;
            end
        end
        
    end    
    identities{i}=ident;
    sumds{i}=sumd; 
    centroids{i}=cur_centroids;

end

combination_results.identities=identities; 
combination_results.sumds=sumds; 
combinations_info.centroids=centroids; 
combination_results.mean_silhouettes=mean_silhouettes; 
combination_results.all_silhouettes=all_silhouettes; 
combination_results.centroids=centroids; 
end
 



