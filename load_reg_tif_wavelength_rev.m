function [red_wavelength_stack,Fall,redcell_idx,wsImage,wsFall,rcFall,mcherry_coords,tdtom_coords,mcherry_spectra,tdtom_spectra] = load_reg_tif_wavelength_rev(mouse,date,pockels,wavelengths,xtrafolder,servernum)
warning('off','all')

% LOAD_REG_TIF_WAVELENGTH loads suite2p registered tifs saved inside
% '...mouse\date\W-series\suite2p\plane0\reg_tif\'
%all_image size is [npock*nwave, 512, 512]
%red_wavelength_stack is [npock, nwave, 512, 512]

%REV indicates that the red_wavelenghth_stack is organized taking all
%wavelengths at one pockel 
%% first handle loading spectra, giving coordinates
if ismac
    mcherry_spectra=readtable('/Volumes/Runyan2/Christian/Code/PC_control data/mcherry_spectra.csv');
    tdtom_spectra=readtable('/Volumes/Runyan2/Christian/Code/PC_control data/tdtomato_spectra.csv');
else
    mcherry_spectra=readtable('Y:\Christian\Code\PC_control data\mcherry_spectra.csv');
    tdtom_spectra=readtable('Y:\Christian\Code\PC_control data\tdtomato_spectra.csv');
end


tdtom_coords=nan(2,length(wavelengths));
mcherry_coords=nan(2,length(wavelengths));

for i=1:length(wavelengths)
    tdtom_coords(1,i)=find(tdtom_spectra.wavelength==wavelengths(i));
    mcherry_coords(1,i)=find(tdtom_spectra.wavelength==wavelengths(i));
    tdtom_coords(2,i)=tdtom_spectra.tdTomato2p(tdtom_coords(1,i));
    mcherry_coords(2,i)=mcherry_spectra.mCherry2p(mcherry_coords(1,i));
end



%% load Fall for functional data 
if ismac
    base_directory= strcat('/Volumes/Runyan',num2str(servernum),'/Connie/RawData/',mouse,'/',date,'/suite2p/plane0/Fall.mat');
else
    if servernum==2
        base_directory =  strcat('Y:\Connie\RawData\',mouse,'\',date,'\suite2p\plane0\Fall.mat');
    elseif servernum==3
        base_directory =  strcat('X:\Connie\RawData\',mouse,'\',date,'\suite2p\plane0\Fall.mat');
    end

end 



Fall = load(base_directory);%('Y:\Connie\2p_results\EC1-1R\2021-10-27\suite2p\plane0\Fall.mat');
%% Load load rcFall 
if ismac
    redcell_directory= strcat('/Volumes/Runyan',num2str(servernum),'/Connie/RawData/',mouse,'/',date,'/suite2p-redcells/plane0/Fall.mat');
else
    if servernum==2
        redcell_directory =  strcat('Y:\Connie\RawData\',mouse,'\',date,'\suite2p-redcells\plane0\Fall.mat');
    elseif servernum==3
        redcell_directory= strcat('X:\Connie\RawData\',mouse,'\',date,'\suite2p-redcells\plane0\Fall.mat');
    end

end 

rcFall=load(redcell_directory);
%%
redcells=rcFall.iscell(:,1); 
redcells(Fall.iscell(:,1)==0)= 0; 
redcell_idx=redcells==1; 


%% load wsFall 
if ismac
    wsbase_directory= strcat('/Volumes/Runyan',num2str(servernum),'/Connie/RawData/',mouse,'/',date,'/W-series/suite2p/plane0/Fall.mat');
else
    if servernum==2
        wsbase_directory =  strcat('Y:\Connie\RawData\',mouse,'\',date,'\W-series\suite2p\plane0\Fall.mat');
    elseif servernum==3
        wsbase_directory =  strcat('X:\Connie\RawData\',mouse,'\',date,'\W-series\suite2p\plane0\Fall.mat');
    end


end 


wsFall=load(wsbase_directory); 


try
    wsImage=wsFall.ops.meanImg_chan2;
catch
    wsImage=wsFall.ops.meanImgE;
end


%% next load reg_tif

if ismac
    if servernum==3
        base_directory =  strcat('/Volumes/Runyan',num2str(servernum),'/Connie/RawData/',mouse,'/',date,'/W-series/suite2p/plane0/reg_tif');
    elseif servernum==2
        base_directory =  strcat('/Volumes/Runyan',num2str(servernum),'/Connie/RawData/',mouse,'/',date,'/W-series/suite2p/plane0/reg_tif');
    end

else
   if servernum==2
        base_directory= strcat('Y:\Connie\RawData\',mouse,'\',date,'\W-series\suite2p\plane0\reg_tif');
   elseif servernum==3
        base_directory=strcat('X:\Connie\RawData\',mouse,'\',date,'\W-series\suite2p\plane0\reg_tif');
    end

end


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
    else
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

    else
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

red_wavelength_stack(:,[13 15],:,:)=[];

% making plot of the mean of all wavelengths
summed_image = squeeze(sum(all_image));
summed_image = summed_image./max(summed_image(:));

shortwv_image=squeeze(sum(all_image(1:10,:,:),1));
shortwv_image=shortwv_image./max(shortwv_image(:));
% 

end
