function[]= check_shift(redcell_vect,cell_stat,img,shift,img_brightness)

% Function that plots masks over both the mean functional image and the
% mean from the wavelength stack to make sure that the registration 


%% MAKE VARIABLES
xshift=shift(1); 
yshift=shift(2); 

red_idx=1:length(cell_stat); 
red_idx=red_idx(redcell_vect); % get list of only red cells 


red_stat=cell_stat(redcell_vect); 

%% PLOT MASKS OVER MEAN OF WAVELENGTH SERIES 
figure('color','w')


subplot(1,2,2)

img_brightness=4;

plot_mask_boundaries(img.wsRef,img_brightness,red_stat,red_idx,'r',xshift,yshift,'imagesc')


title('Masks Plotted on reg-tif of W-Series')

%% PLOT MASKS OVER MEAN OF FUNCTIONAL IMAGES

subplot(1,2,1)

plot_mask_boundaries(img.fRef,img_brightness,red_stat,red_idx,'r',xshift,yshift,'imagesc')


title('Masks Plotted on Functional Imaging')
sgtitle('Check That Registration Differences Between Functional Imaging and Wavelength Series Are Accounted For')


