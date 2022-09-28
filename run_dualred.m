%% 1. ENTER DATASET INFORMATION
mouse = 'FU1-00';
date = '2022-03-17';
servernum=2;
xtrafolder='no';
pockels=300:100:700; 
subset_pockels=1:length(pockels); % vector of pockels to actually include in clustering 

wavelengths= 780:20:1100;wavelengths([13,15])=[];

[~, wave_ids,flatidentities] = p_w_identities(pockels,wavelengths,'delete13/15');
load('wave_identities.mat')
load("ranked_combinations.mat")
load('combos.mat')
%% 2. LOAD RED_WAVELENGTH_STACK, FALL.MAT, MANUAL RED CELL SELECTION
[red_wavelength_stack,Fall,redcell_vect_init,wsImage,wsFall] = load_reg_tif_wavelength_rev(mouse,date,pockels,780:20:1100,xtrafolder,servernum);

%% 3. GET ISCELL COORDINATES/ GET IMAGES
%the coordinates for cells are in reference to just those classified as
%iscell == 1 in the functional imaging 
%sometime the coordinates can also be just in terms of red_cells
%you can use convert_coordinate to convert between the two 
[cell_stat,redcell_vect]= convert_to_isCell(Fall,redcell_vect_init);
Fall.red_cell_vect=redcell_vect; 
[wsRef,fRef,max_proj,sum_proj,shortImage,longImage,greenImage]=get_images(wsFall,Fall,red_wavelength_stack); 

%% 4. CORRECT AND CONFIRM REGISTRATION
% registration is different between w-series s2p file and functional s2p
% file, so need to correct for where masks are located 

[xshift,yshift]=shift_wseries(wsRef,fRef);
check_shift(redcell_vect,cell_stat,wsFall.ops.meanImg,Fall.ops.meanImg_chan2,xshift,yshift) % make sure that re-registration is effective

%% 5. CHECK MANUALLY LABELED RED CELLS 
% * this is a to check that you haven't left out any red cells in your s2p red_cells file 
% * plots all of the green masks that have over a certain mean threshold 

img_thresholds=[3,4,5]; % change this if you want to change brightness of either of 3 images (higher number = brighter(lower threshold))
detect_redcells(longImage,shortImage,sum_proj,img_thresholds,redcell_vect,cell_stat,xshift,yshift,25)% Threshold is end argument and is a percentage 

%% 6. CHOOSE CELLS TO ADD AND SUBTRACT FROM THE RED LIST, THEN ADD/ SUBTRACT RED CELLS FROM LIST AND VIEW FINAL RESULT 
toadd= [270 21 265 360 304 325 187];
uncertain=[];
tosubtract=[];


[final_red_vect]=add_redcells(redcell_vect,toadd);
[final_red_vect]=sub_redcells(final_red_vect,tosubtract);

thresholds=[2 3]; %change for 
check_redcells(final_red_vect,cell_stat,shortImage,longImage,thresholds,xshift,yshift)

%% 7. RESTRICT MASKS, GET INTENSITIES, AND AVERAGE ACROSS POWERS
subset=1:length(pockels); % subset is an argument to take only certain pockels if there are any  

[intensities,red_cellocs]= partialmask_intensities(66,cell_stat,red_wavelength_stack,final_red_vect,max_proj,xshift,yshift);
[meanwave_intensities,medwave_intensities,flatwave_identities]=avg_acrosspocks(intensities,length(pockels),wavelengths,subset); 

%% 8. DO CLUSTERING ON FULL DATA AND ON COMBINATIONS OF DATA 

[identities,centroids,sumds,all_silhouettes,mean_silhouettes,combos]=try_combinations(ranked_combinations,meanwave_intensities);
[full_ident,centroids,sumd,alldistances,silhouettes,used_intensities] = cluster_masks (wsRef,meanwave_intensities,red_cellocs, 2,[mouse,' ',date,'  all wavelengths'],flatwave_identities,'normr','wavelength',pockels,wavelengths,final_red_vect,combos);
plot_combination_cluster_performance(all_silhouettes,combos,identities,full_ident,wave_identities,mouse,date) 
plot_cluster_performance (silhouettes,mouse,date,'no','normr')

%% 9. EXAMINE OUTLIERS WITH SILHOUETTE SCORES BELOW THRESHOLD 
chosen_combination=10; % you can choose from the 16 combinations to see which you want to plot 

examine_outliers(cell_stat,final_red_vect,meanwave_intensities,all_silhouettes{chosen_combination},.7,centroids,['outliers:',mouse,date],flatwave_identities,identities{chosen_combination})

%% 10. EXCLUDE CELLS, GET FINAL VECTORS TO PUT IN STRUCTURE 

exclude_redids=[74];

[final_red_vect_ex,final_ident,final_intensities,final_silhouettes,excluded_cellids,final_iscell]=exclude_cells(exclude_redids,final_red_vect,full_ident,meanwave_intensities,silhouettes,Fall.iscell(:,1)); 
[final_ids]=make_final_ids(final_red_vect_ex,final_ident); 
Fall.red_cell_vect=final_red_vect_ex;

%% 11. MAKE STRUCTURE
clustering_info.mouseID=[mouse,' ',date];
clustering_info.cellids=final_ids;
clustering_info.redvect=final_red_vect_ex;
clustering_info.excluded=excluded_cellids;
clustering_info.used_silhouettes=final_silhouettes;
clustering_info.all_silhouettes=all_silhouettes;
clustering_info.combinations=combos;
clustering_info.Fall=Fall;
clustering_info.iscell=final_iscell; 
%% 12. FINAL CHECK 
check_redcells(final_red_vect,cell_stat,shortImage,sum_proj,xshift,yshift)

%% 13. SAVE STRUCTURE 
save(['Y:\Christian\Processed Data\dual_red\',mouse,'_',date],'clustering_info')

