curdataset=1;


%%
expdata(curdataset).tag=[mouse,':',date];
expdata(curdataset).identities=identities; 
expdata(curdataset).all_centroids=centroids;
expdata(curdataset).sumds=sumds;
expdata(curdataset).all_silhouettes=all_silhouettes;
expdata(curdataset).mean_silhouettes=mean_silhouettes;
expdata(curdataset).combinations=combinations; 

expdata(curdataset).full_identities=nr_allred_ident; 
expdata(curdataset).full_centroids=nr_centroids;
expdata(curdataset).full_sumd=nr_sumd;
expdata(curdataset).full_silhouettes=nr_silhouettes;

%%

