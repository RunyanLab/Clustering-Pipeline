function plot_combination_cluster_performance(combination_results,combinations,full_ident,wave_identities,info) 

% function that takes combination of many silhouette distributions and
% plots them together in a 4x4 histogram 

% combinations: vector of the wavelengths used 
% wave_identities: list of strings that maps the coordinate from combinations to actual identity
% all_silhouettes: cell array of different silhouette distributions 
% full_ident: classified identities from the full dimensional cluster
% identities: classified identites from each of the combinations 


%% LOAD VARIABLES

all_silhouettes=combination_results.all_silhouettes;
identities=combination_results.identities; 
mouse=info.mouse; 
date=info.date;

%% MAKE FIGURE
figure('Color','w')


subplotnum=16;
for i = 1:subplotnum
    subplot(4,4,i)
    strcell=wave_identities(combinations{i});
    str=strcell{1};
    for j=2:length(strcell)
        str=[str,', ',strcell{j}];
    end
        
    params=fit_silhouettes(all_silhouettes{i});
    histg=histogram(all_silhouettes{i},length(all_silhouettes{i}));
    xlabel('Silhouette Score')
    ylabel('Frequency')
    pairwise_similarity=nan(subplotnum,1);
    for id= 1:subplotnum
        curmatrix=identities{i}-1;
        compmatrix=identities{id}-1;
        pairwise_similarity(id)=getJaccard(curmatrix,compmatrix); 
    end
    pairwise_similarity(i)=nan; %remove self from calculation
    pairwise_similarity=mean(pairwise_similarity,'omitnan');

    
    stdev= std(all_silhouettes{i});
    text(min(histg.BinEdges),max(histg.Values)*.9,['average score: ',num2str(round(params(4),2))],'Color','r')
    text(min(histg.BinEdges),max(histg.Values)*.8,['standard dev: ',num2str(round(stdev,2))],'Color','r')
   
    text(min(histg.BinEdges),max(histg.Values)*.4,['mean Jaccard similarity: ',num2str(round(pairwise_similarity,2))],'Color','r')
    text(min(histg.BinEdges),max(histg.Values)*.3,['Jaccard similarity to full: ',num2str(round(getJaccard(identities{i}-1,full_ident-1),2))],'Color','r')
    

    pairwise_similarity_full=nan(subplotnum,1);
            
    for id= 1:subplotnum
        curmatrix=identities{i}-1;
        compmatrix=full_ident-1;
        pairwise_similarity_full(id)=getJaccard(curmatrix,compmatrix);
    end

    

    xline(params(4),"LineWidth",2,'Color','r')
    
    xline(params(4)-stdev)
    
   
    title(str)
    sgtitle([mouse,' ',date,' mean jaccard similarity to full-D: ',num2str(mean(pairwise_similarity_full))])



end
%% UNUSED FIGURE THAT SHOWS SILHOUETTE SCORE IN BAR GRAPH BY CELL IF NEEDED 
% figure
% for i = 1:subplotnum
%     subplot(4,4,i)
%     barg=bar(all_silhouettes{i});
%     xlabel('Cell Number')
%     ylabel('Silhouette Score')
% 
%     strcell=wave_identities(combinations{i});
%     str=strcell{1};
%     for j=2:length(strcell)
%         str=[str,', ',strcell{j}];
%     end
%         
%     title(str)
% 
%     
% end
