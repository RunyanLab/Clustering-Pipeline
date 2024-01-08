%% 1. ENTER DATASET INFORMATION
addpath(genpath('C:\Code\Github\Clustering-Pipeline'))
info.mouse = 'HA1-00';
info.date = '2023-06-29';
info.servernum='V:';
info.pockels=300:100:500; 
info.subset_pockels=1:length(info.pockels); % vector of pockels to actually include in clustering 
info.savepathstr = '/Connie/ProcessedData/';

info.wavelengths= 780:20:1100;info.wavelengths([13,15])=[]; % wavelengths 
info.total_wavelengths=780:20:1100; 

[info] = p_w_identities(info); % add reference matrix to intro for order of pockels and wavelengths


load('wave_identities.mat')
load('combos.mat')
%% 2. LOAD RED_WAVELENGTH_STACK, FALL.MAT, MANUAL RED CELL SELECTION

[red_wavelength_stack,Fall,redcell_vect_init,wsFall] = load_reg_tif_wavelength_rev(info);

%% 3. GET ISCELL COORDINATES/ GET IMAGES
% Remove Fall.iscell==0 from coordinates 

[cell_stat,redcell_vect,Fall]= convert_to_isCell(Fall,redcell_vect_init);
[img]=get_images(wsFall,Fall,red_wavelength_stack); 

%% 4. CORRECT AND CONFIRM REGISTRATION
% registration is different between w-series s2p file and functional s2p
% file, so need to correct for where masks are located 
[shift]=shift_wseries(img);

img_brightness=4; 
check_shift(redcell_vect,cell_stat,img,shift) % make sure that re-registration is effective

%% 5. CHECK MANUALLY LABELED RED CELLS 
% * this is a to check that you haven't left out any red cells in your s2p red_cells file 
% * plots all of the green masks that have over a certain mean threshold 

img_brightness=[7 7 7]; % change this if you want to change brightness of either of 3 images (higher number = brighter(lower threshold))
percent=10; % "percent" is the percentile of the mean intentsity of red cells. candidate red cells currently classified as greedn above that value will be shown  

detect_redcells(percent,img,img_brightness,redcell_vect,cell_stat,shift);

%% 6. CHOOSE CELLS TO ADD AND SUBTRACT FROM THE RED LIST, THEN ADD/ SUBTRACT RED CELLS FROM LIST AND VIEW FINAL RESULT 
add= [6,123,31,10];
subtract=[];
uncertain=[]; % delete cells if it is unclear or not that they are red (should not be in red_vect) 

[final_red_vect]=add_redcells(redcell_vect,add);
[final_red_vect]=sub_redcells(final_red_vect,subtract);

thresholds=[8 8]; % increase to make images brighter 
check_redcells(final_red_vect,cell_stat,img,thresholds,shift)

%% 7. RESTRICT MASKS, GET INTENSITIES, AND AVERAGE ACROSS POWERS

pixel_exclusion_prctile= 30; %usually set to 30

[intensities,red_cellocs]= partialmask_intensities(pixel_exclusion_prctile,cell_stat,red_wavelength_stack,final_red_vect,img.max_proj,shift);
[meanwave_intensities,medwave_intensities,flatwave_identities]=avg_acrosspocks(intensities,info); 



%% 8. DO CLUSTERING ON FULL DATA AND ON COMBINATIONS OF DATA 


[combination_results]=try_combinations(combos,meanwave_intensities);
[fullD_results] = cluster_masks(meanwave_intensities,final_red_vect,flatwave_identities,info,img,red_cellocs);
plot_combination_cluster_performance(combination_results,combos,fullD_results.ident,flatwave_identities,info) 
plot_cluster_performance (fullD_results.silhouettes,info)

%% 9. EXAMINE OUTLIERS WITH SILHOUETTE SCORES BELOW THRESHOLD 
chosen_combination=14; % you can choose from the 16 combinations to see which you want to plot 

thresh=.7; 
sub_intensities=meanwave_intensities(:,combos{chosen_combination}); 
examine_outliers(cell_stat,final_red_vect,chosen_combination,thresh,sub_intensities,info,flatwave_identities(combos{chosen_combination}),combination_results)

%% 10. EXCLUDE CELLS, GET FINAL VECTORS TO PUT IN STRUCTURE 

exclude_redids=[]; %make sure it is in red index

[final_red_vect_ex,final_ident,final_intensities,final_silhouettes,excluded_cellids,final_iscell]=exclude_cells(exclude_redids,uncertain,final_red_vect,combination_results.identities{chosen_combination},meanwave_intensities,combination_results.all_silhouettes{chosen_combination},Fall); 
[cellids]=make_final_ids(final_red_vect_ex,final_ident); 
Fall.redcell_vect=final_red_vect_ex;

%% 11. MAKE STRUCTURE TO SAVE INFORMATION
clustering_info.mouseID=[info.mouse,' ',info.date];
clustering_info.cellids=cellids;
clustering_info.redvect=final_red_vect_ex;
clustering_info.excluded=excluded_cellids;
clustering_info.used_silhouettes=final_silhouettes;

clustering_info.combinations=combos;
clustering_info.Fall=Fall;
clustering_info.chosen_combination=chosen_combination; 
clustering_info.iscell=final_iscell; 
clustering_info.intensities=final_intensities;
clustering_info.all_identities=info.identities; 
clustering_info.uncertain=uncertain; 
clustering_info.added=add; 
clustering_info.subtracted=subtract; 
clustering_info.img=img; 

%need to add intensities and identities to track the final used cells 
%% 12. FINAL CHECK 
check_redcells(final_red_vect_ex,cell_stat,img,thresholds,shift)

%% 13. SAVE STRUCTURE 
mkdir([info.servernum,info.savepathstr,info.mouse,'/',info.date,'/dual_red/'])
cd([info.servernum,info.savepathstr,info.mouse,'/',info.date,'/dual_red/'])
save('clustering_info','clustering_info')


%% SAVE TDTOM, MCHERRY, PYR
tdtom_cells = find( clustering_info.cellids == 2); 
mcherry_cells = find( clustering_info.cellids == 1);
pyr_cells = find( clustering_info.cellids == 0)'; 
mkdir(strcat(info.servernum,info.savepathstr,info.mouse,'/',info.date,'/red_variables/'));
cd(strcat(info.servernum,info.savepathstr,info.mouse,'/',info.date,'/red_variables/'));
    save('tdtom_cells','tdtom_cells');
    save('mcherry_cells','mcherry_cells');
    save('pyr_cells','pyr_cells'); 

length(mcherry_cells)
length(tdtom_cells)