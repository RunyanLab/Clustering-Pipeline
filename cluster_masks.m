function [ident,centroids,sumd,alldistances,silhouettes,used_intensities] = cluster_masks (mean_image,intensities,cellocs, nclust,t,flatindentities,normalized,wave_pock,cluster_pocks,cluster_waves,red_vect,combos)
numpocks=length(cluster_pocks);
numwaves=length(cluster_waves);

cell_idx=1:length(red_vect);

%% CHOOSE METHOD OF NORMALIZATION
red_idx=cell_idx(red_vect);
% intensities should be selected 
norm_intensities=nan(size(intensities,1),size(intensities,2));

if strcmp(normalized,'normr')  
   norm_intensities=normr(intensities);
   
elseif strcmp(normalized,'zscore')   
    norm_intensities(:,:)=zscore(intensities,0,2);

elseif strcmp(normalized,'no')
    norm_intensities=intensities;

elseif strcmp(normalized,'minmax')
    for i = 1:size(intensities,1)
        for j=1:size(intensities,2)
            norm_intensities(i,j)= (intensities(i,j)-min(intensities(i,:))/ (max(intensities(i,:)-min(intensities(i,:)))));
        end
   
    end
elseif strcmp(normalized,'euclidian')
    norm_intensities(:,:)=normalize(intensities,2,'norm');

end

%norm_intensities=weight_intensities(norm_intensities,combos);


[ident,centroids,sumd,alldistances]= kmeans(norm_intensities, nclust,'Replicates',100,'MaxIter',10000);
%% OUTPUT SILHOUETTE SCORES

silhouettes=get_silhouettes(alldistances,ident);

group1=norm_intensities(ident==1,:);

group2= norm_intensities(ident==2,:);


if mean(group1(:,1)) > mean(group2(:,1))
    g1_ident='mcherry';
    g2_ident='tdtomato';
else
    g1_ident='tdtomato';
    g2_ident='mcherry';

end
ident_order={g1_ident,g2_ident};

%%
figure()
imshow(mean_image);
caxis([0 mean(mean(mean_image))*4])
hold on 
shiftx=5;
shifty=5;
for i = 1: size(cellocs,3)
    [cury,curx]=find(cellocs(:,:,i));
    
        if ident(i)==1 && strcmp(g1_ident,'mcherry')
                hold on 
                plot(curx,cury,'.',"Color",'r')
                text(mean(curx)+shiftx,mean(cury)+shifty,num2str(red_idx(i)),'Color','r')
                hold off
                            
        elseif ident(i)==1 && strcmp(g1_ident,'tdtomato')
                hold on; 
                plot(curx,cury,'.',"Color",'g')
                text(mean(curx)+shiftx,mean(cury)+shifty,num2str(red_idx(i)),'Color','g')
                hold off
           
        elseif ident(i)==2 && strcmp(g2_ident,'mcherry')
                hold on 
                plot(curx,cury,'.',"Color",'r')
                text(mean(curx)+shiftx,mean(cury)+shifty,num2str(red_idx(i)),'Color','r')
                hold off 

        elseif ident(i)==2 && strcmp(g2_ident,'tdtomato')
                hold on
                plot(curx,cury,'.',"color",'g')
                text(mean(curx)+shiftx,mean(cury)+shifty,num2str(red_idx(i)),'Color','g')
                hold off 
        end
  
end


title(t);
subtitle('mcherry = red || tdtomato= green');

%% plot intensity graphs for each cell in each cluster 

figure();clf;
hold on
for clust = 1:nclust
    subplot(nclust,1,clust)

   
    group = norm_intensities(ident==clust,:)';
    plot(group);
    string=num2str(clust);
    title('cluster',string)
    if strcmp(wave_pock,'pockels')
        xticks(1:numpocks:size(norm_intensities,2))
        xticklabels(flatindentities(1:numpocks:end))
        xline(1:numpocks:size(norm_intensities,2))
    elseif strcmp(wave_pock,'wavelengths')
        xticks(1:numwaves:size(norm_intensities,2))
        xticklabels(flatindentities(1:numwaves:end))
        xline(1:numwaves:size(norm_intensities,2))
    end
    if clust==1
       title(g1_ident)
    else
       title(g2_ident)
    end


end
sgtitle(t)
hold off




%% change ident so that mcherry=1 

if strcmp(ident_order{1},'tdtomato')
    for id= 1:length(ident)
        
        if ident(id)==1
            ident(id)=2;
        elseif ident(id)==2
            ident(id)=1;
        end
    end
end


used_intensities=norm_intensities;
end



