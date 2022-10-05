function[identities,centroids,sumds,all_silhouettes,mean_silhouettes,combos]=try_combinations(ranked_combinations,intensities)

combos=cell(length(ranked_combinations)/6,1); 
identities=cell(length(ranked_combinations)/6,1); 
all_centroids=cell(length(ranked_combinations)/6,1); 
sumds=cell(length(ranked_combinations)/6,1);
all_silhouettes=cell(length(ranked_combinations)/6,1);
mean_silhouettes=nan(length(ranked_combinations)/6,1);
alpha=nan(length(ranked_combinations)/6,1);
beta=nan(length(ranked_combinations)/6,1);
mu=nan(length(ranked_combinations)/6,1);

centroids= cell(length(ranked_combinations)/6,1); 

for i = 1:length(combos)
    combos{i}=ranked_combinations(1+(i-1)*6).index; 
end

%%


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

    %pd= fitdist(cur_sils,'Beta');

    %alpha(i)=pd.a;
    %beta(i)=pd.b;

    pde=fitdist(1-cur_sils,'Exponential');

    mu(i)=pde.mu;
    
    identities{i}=ident;
    sumds{i}=sumd;
    centroids{i}=cur_centroids;

  


end

