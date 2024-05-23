# Clustering Pipeline
 
Original code used in "Simultaneous interneuron labeling reveals cell-type-specific population-level interactions in cortex" to classify mCherry and TdTomato fluorophores. The approach could be used to distinguish any two fluorophores with differing excitation spectra.

### Before starting - collect necessary data
1) Collect wavelenth series using wavelenths that best separate fluorophores across multiple powers. Averaging across frames is recommended.
2) Process functional data using suite2p with 2 Channels green and red (so that we can use the registered version of the red channel and functional masks)
3) Separate folder that has the Fall.mat file for only selected red cells. To do this copy the functional suite2p folder and save it with a different name, then using the suite2p GUI move all cells that are not red into the not cell category using the red channel images.

### Getting started 
NOTE: This code has been tested in MATLAB 2022b and later. Older versions may be compatible but have not been tested.

The main code: run_dualred.mat has all the functions used in the order described below:

1) Input information about the dataset including name, date, pockels, and wavelenths used. This will also load in the wavelenth combos (combos.mat) to be used and the wavelenth identities (wave_identities.mat). Examples of these files are in the repository.
2) Load wavelength stacks, functional suite2p masks, and red cell suite2p masks (from Fall.mat). The code currently assumes there are two copies of each wavelenth image and takes the first. It also puts the images taken with the separate 1045 laser in the right place (assumes they are at the start of the stack)
3) Get coordinates from suite2p masks and mean images (of short and long wavelenths) for plotting purposes. The numbers for short and long wavelenths are hard coded. 
4) Correct and confirm registration between wavelength stack and functional suite2p images
5) Check manually labeled red cells that may have been missed during suite2p red cell selection
6) Add and/or subtract any red cells as necessary
7) Restrict masks using a pixel exclusion threshold, get intensities of masks across all wavelenths and powers
8) Perform k-means clustering on data using all wavelenths and top 25 combinations of wavelenths. This will group clusters into 1 (mcherry) and 2 (tdtom) based on the cluster with largest mean intensity for the first wavelenth (in our case 780nm)
9) Examine outliers with silhouette scores below threshold (0.7) and choose combination used for clustering
10) Determine if you want to exclude any cells (like outliers) from the final vector structure
11) Use clustering_info structure to save all relevant information including the classified identities of the red cells.
12) Perform a final check using the mean images to make we were missing no red cells
13) Save the clustering_info structure in a specific folder
