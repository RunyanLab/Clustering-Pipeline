function [red_wavelength_stack,Fall,redcell_vect_init,wsFall] = load_reg_tif_wavelength_rev(info)
% Function that loads the Fall.mat files from functional data, redcell-only
% suite2p,and wavelength series suite2p. Also loads the reg_tif generated
% by suite2p for the wavelength series

%INPUTS: 
    % info: structure containing all dataset info

%OUTPUTS: 
    % red_wavelength_stack: stack of arrays organized as pockel x
    % wavelength x Xpix x Ypix  
    % 
    % Fall: .mat file for the functional imaging data
    %
    % redcell_vect_init: initial vector indicating which cells contain one
    % of the two red fluorophores 
    %
    % wsFall: .mat output for the wavelength series 


warning('off','all')

%% Unpack variables from info structure 
mouse=info.mouse; 
date=info.date; 
pockels=info.pockels; 
wavelengths=info.total_wavelengths; 
%xtrafolder=info.xtrafolder; 
servernum=info.servernum; 

% LOAD_REG_TIF_WAVELENGTH loads suite2p registered tifs saved inside
% '...mouse\date\W-series\suite2p\plane0\reg_tif\'
%all_image size is [npock*nwave, 512, 512]
%red_wavelength_stack is [npock, nwave, 512, 512]

%REV indicates that the red_wavelenghth_stack is organized taking all
%wavelengths at one pockel 

%% load Fall for functional data 
if ismac
    base_directory= strcat('/Volumes/Runyan2/Connie/RawData/',mouse,'/',date,'/suite2p/plane0/Fall.mat');
else
    try 
        base_directory =  strcat('Y:\Connie\RawData\',mouse,'\',date,'\suite2p\plane0\Fall.mat');
    catch
        base_directory =  strcat('X:\Connie\RawData\',mouse,'\',date,'\suite2p\plane0\Fall.mat');
    end

end 

Fall = load(base_directory);

%% Load load rcFall 

if ismac
    redcell_directory= strcat('/Volumes/Runyan2/Connie/RawData/',mouse,'/',date,'/suite2p-redcells/plane0/Fall.mat');
else
    try
        redcell_directory =  strcat('Y:\Connie\RawData\',mouse,'\',date,'\suite2p-redcells\plane0\Fall.mat');
    catch
        redcell_directory= strcat('X:\Connie\RawData\',mouse,'\',date,'\suite2p-redcells\plane0\Fall.mat');
    end

end 

rcFall=load(redcell_directory);
%%
redcells=rcFall.iscell(:,1); 
redcells(Fall.iscell(:,1)==0)= 0; 
redcell_vect_init=redcells==1; 



%% LOAD wsFall
if ismac
    wsbase_directory= strcat('/Volumes/Runyan2/Connie/RawData/',mouse,'/',date,'/W-series/suite2p/plane0/Fall.mat');
else
    try
        wsbase_directory =  strcat('Y:\Connie\RawData\',mouse,'\',date,'\W-series\suite2p\plane0\Fall.mat');
    catch
        wsbase_directory =  strcat('X:\Connie\RawData\',mouse,'\',date,'\W-series\suite2p\plane0\Fall.mat');
    end


end 


wsFall=load(wsbase_directory); 

%% LOAD reg_tif

if ismac
    try
        base_directory =  strcat('/Volumes/Runyan2'/Connie/RawData/',mouse,'/',date,'/W-series/suite2p/plane0/reg_tif');
    catch
        base_directory =  strcat('/Volumes/Runyan3'/Connie/RawData/',mouse,'/',date,'/W-series/suite2p/plane0/reg_tif');
    end

else
   if servernum==2
        base_directory= strcat('Y:\Connie\RawData\',mouse,'\',date,'\W-series\suite2p\plane0\reg_tif');
   elseif servernum==3
        base_directory=strcat('X:\Connie\RawData\',mouse,'\',date,'\W-series\suite2p\plane0\reg_tif');
    end

end

%% MAKE red_wavelength_stack
d = dir(base_directory);
num_files = length(d);
num_x_pixels = 512;
num_y_pixels = 512;

red_wavelength_stack = nan(length(pockels),length(wavelengths), num_x_pixels, num_y_pixels);
%green_wavelength_stack = nan(length(pockels),length(wavelengths), num_x_pixels, num_y_pixels);

total_780_1100_images= length(wavelengths)*length(pockels);

all_image = nan(total_780_1100_images,512,512);

count=0;
%reading each frame from the registered tif (including blank images for
%1020, 1040, 1060)
for f = [length(pockels)+1]:2:[total_780_1100_images*2+length(pockels)] 
   %I collect 2 frames for each p w so here I am collecting only one per p & w
   %starting with length(pockels)+1] bc I put all 1040 images in front of
   %780 to 1100 images during registration
    count = count+1;
    if ismac
        try 
            all_image(count,:,:) = imread([base_directory '/' 'file000_chan0.tif'],f);
        catch
            all_image(count,:,:) = imread([base_directory '/' 'file000_chan1.tif'],f);
        end
    elseif ispc
        try 
            all_image(count,:,:) = imread([base_directory '\' 'file000_chan0.tif'],f);
        catch
            all_image(count,:,:) = imread([base_directory '\' 'file000_chan1.tif'],f);
        end

    end

end
%getting the separatly taken single 1040nm images and putting them in the
%correct spot in the series
%if collecting 780:20:1100,the 14th one is 1040nm
for f = 1:length(pockels)
    if ismac
        try
            all_image(f*17-17+14,:,:) = imread([base_directory '/' 'file000_chan0.tif'],f);

        catch
            all_image(f*17-17+14,:,:) = imread([base_directory '/' 'file000_chan1.tif'],f);
        end

    elseif ispc
        try
            all_image(f*17-17+14,:,:) = imread([base_directory '\' 'file000_chan0.tif'],f); 
        catch
            all_image(f*17-17+14,:,:) = imread([base_directory '\' 'file000_chan1.tif'],f); 
        end
    end
end
%organizing data into the red_wavelength stack[p,w,512,512]
for p = 1:length(pockels)
    for w = 1:length(wavelengths)
        current_image = w+[length(wavelengths)*p-length(wavelengths)];
        red_wavelength_stack(p,w,:,:) = all_image(current_image,:,:);
    end
end

red_wavelength_stack(:,[13 15],:,:)=[]; % remove blank wavelengths 

% making plot of the mean of all wavelengths
summed_image = squeeze(sum(all_image));
summed_image = summed_image./max(summed_image(:));

shortwv_image=squeeze(sum(all_image(1:10,:,:),1));
shortwv_image=shortwv_image./max(shortwv_image(:));


% 
end
