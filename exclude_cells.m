function[final_red_vect,final_ident,final_intensities,final_silhouettes,excluded_cellids,final_iscell]=exclude_cells(red_ids_to_exclude,final_red_vect,final_ident,final_intensities,final_silhouettes,Fall)

iscell=Fall.iscell(:,1); 



%% function that will exclude cells from all variables used in procesing 

cellids_to_exclude=find(final_red_vect==1); % get list of red cells in iscell==1 coordinates

cellids_to_exclude=cellids_to_exclude(red_ids_to_exclude);%list of cells to be excluded 

final_red_vect(cellids_to_exclude,:)=[];
final_ident(red_ids_to_exclude,:)=[];
final_intensities(red_ids_to_exclude,:)=[];
final_silhouettes(red_ids_to_exclude,:)=[];


s2pidstoexclude=nan(length(red_ids_to_exclude),1);


for i = 1:length(cellids_to_exclude)
    s2pidstoexclude(i)=convert_coordinate(cellids_to_exclude(i),'c2s',Fall);
end



iscell(s2pidstoexclude)=0;

final_iscell=iscell;

excluded_cellids=cellids_to_exclude;
end
